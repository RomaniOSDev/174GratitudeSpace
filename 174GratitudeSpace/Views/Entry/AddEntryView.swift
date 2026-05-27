import SwiftUI
import PhotosUI

struct AddEntryView: View {
    @ObservedObject var viewModel: GratitudeSpaceViewModel
    @Environment(\.dismiss) private var dismiss

    var dailyPrompt: String?
    var initialTemplate: EntryTemplate = .blank

    @State private var template: EntryTemplate = .blank
    @State private var title = ""
    @State private var description = ""
    @State private var category: GratitudeCategory = .simpleJoy
    @State private var location = ""
    @State private var people: [String] = []
    @State private var tagsString = ""
    @State private var isFavorite = false
    @State private var mood = 3
    @State private var selectedPhotoItem: PhotosPickerItem?
    @State private var previewImage: UIImage?
    @State private var multiDrafts: [GratitudeDraft] = []
    @State private var delightedText = ""
    @State private var thankfulPerson = ""

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        if let dailyPrompt {
                            promptBanner(dailyPrompt)
                        }

                        templatePicker
                        templateActions

                        if template == .threeGratitudes {
                            threeGratitudesForm
                        } else if template == .delightedAndThankful {
                            delightedForm
                        } else {
                            EntryFormFields(
                                title: $title,
                                description: $description,
                                category: $category,
                                location: $location,
                                people: $people,
                                tagsString: $tagsString,
                                isFavorite: $isFavorite,
                                mood: $mood,
                                selectedPhotoItem: $selectedPhotoItem,
                                previewImage: previewImage,
                                onRemovePhoto: clearPhoto
                            )
                            .frame(minHeight: 420)
                        }
                    }
                }

                saveButtons
            }
            .gardenScreenBackground()
            .navigationTitle("New flower")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                template = initialTemplate
                if template == .threeGratitudes {
                    multiDrafts = defaultThreeDrafts()
                }
            }
            .onChange(of: selectedPhotoItem) { newItem in
                loadPhoto(from: newItem)
            }
            .onChange(of: template) { newTemplate in
                applyTemplate(newTemplate)
            }
        }
    }

    private func promptBanner(_ text: String) -> some View {
        PromptBannerCell(prompt: text)
            .padding(.horizontal, GardenDesign.padding)
    }

    private var templatePicker: some View {
        VStack(alignment: .leading, spacing: 10) {
            GardenSectionHeader(title: "Template", subtitle: template.subtitle)
                .padding(.horizontal, GardenDesign.padding)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(EntryTemplate.allCases) { item in
                        GardenChip(
                            title: item.displayName,
                            isSelected: template == item
                        ) {
                            template = item
                        }
                    }
                }
                .padding(.horizontal, GardenDesign.padding)
            }
        }
    }

    private var templateActions: some View {
        Button {
            multiDrafts = viewModel.draftsFromYesterday()
            template = .threeGratitudes
        } label: {
            Label("Repeat yesterday's structure", systemImage: "arrow.counterclockwise")
                .font(.subheadline.weight(.medium))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .foregroundColor(.gardenNew)
                .background(
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .stroke(Color.gardenNew.opacity(0.35), lineWidth: 1)
                )
        }
        .padding(.horizontal, GardenDesign.padding)
    }

    private var threeGratitudesForm: some View {
        VStack(spacing: 14) {
            MoodPickerView(mood: $mood)
                .gardenCard(padding: 14)
                .padding(.horizontal, GardenDesign.padding)

            ForEach(multiDrafts.indices, id: \.self) { index in
                VStack(alignment: .leading, spacing: 10) {
                    Text("Gratitude \(index + 1)")
                        .font(.caption.weight(.bold))
                        .foregroundColor(.gardenNew)
                    TextField("Title", text: $multiDrafts[index].title)
                        .padding(10)
                        .background(RoundedRectangle(cornerRadius: 10).fill(Color.gardenBackground))
                    TextEditor(text: $multiDrafts[index].description)
                        .frame(height: 72)
                        .padding(8)
                        .scrollContentBackground(.hidden)
                        .background(RoundedRectangle(cornerRadius: 10).fill(Color.gardenBackground))
                }
                .gardenCard(padding: 14)
                .padding(.horizontal, GardenDesign.padding)
            }
        }
    }

    private var delightedForm: some View {
        Form {
            Section(header: Text("Mood").foregroundColor(.gray)) {
                MoodPickerView(mood: $mood)
            }
            Section(header: Text("What delighted you?").foregroundColor(.gray)) {
                TextEditor(text: $delightedText)
                    .frame(height: 90)
            }
            Section(header: Text("Who do you thank?").foregroundColor(.gray)) {
                TextField("Name", text: $thankfulPerson)
                TextEditor(text: $description)
                    .frame(height: 70)
            }
            Section {
                Picker("Category", selection: $category) {
                    ForEach(GratitudeCategory.allCases, id: \.self) { cat in
                        Text(cat.displayName).tag(cat)
                    }
                }
            }
        }
        .scrollContentBackground(.hidden)
        .frame(minHeight: 360)
    }

    private var saveButtons: some View {
        VStack(spacing: 10) {
            GardenPrimaryButton(
                title: template == .threeGratitudes ? "Plant 3 flowers" : "Plant flower",
                icon: "leaf.fill",
                action: save,
                isEnabled: canSave
            )
            GardenSecondaryButton(title: "Cancel", action: { dismiss() })
        }
        .padding(GardenDesign.padding)
        .gardenStickyFooter()
    }

    private var canSave: Bool {
        switch template {
        case .threeGratitudes:
            return multiDrafts.contains { !$0.title.trimmingCharacters(in: .whitespaces).isEmpty && !$0.description.trimmingCharacters(in: .whitespaces).isEmpty }
        case .delightedAndThankful:
            return !delightedText.trimmingCharacters(in: .whitespaces).isEmpty
        case .blank:
            return !title.trimmingCharacters(in: .whitespaces).isEmpty && !description.trimmingCharacters(in: .whitespaces).isEmpty
        }
    }

    private func defaultThreeDrafts() -> [GratitudeDraft] {
        [
            GratitudeDraft(title: "Gratitude 1", description: "", category: .simpleJoy),
            GratitudeDraft(title: "Gratitude 2", description: "", category: .people),
            GratitudeDraft(title: "Gratitude 3", description: "", category: .achievement)
        ]
    }

    private func applyTemplate(_ newTemplate: EntryTemplate) {
        switch newTemplate {
        case .blank:
            break
        case .threeGratitudes:
            if multiDrafts.isEmpty { multiDrafts = defaultThreeDrafts() }
        case .delightedAndThankful:
            title = "Today's delight"
            description = ""
            category = .people
        }
    }

    private func save() {
        switch template {
        case .threeGratitudes:
            let entries = multiDrafts.compactMap { draft -> GratitudeEntry? in
                let t = draft.title.trimmingCharacters(in: .whitespaces)
                let d = draft.description.trimmingCharacters(in: .whitespaces)
                guard !t.isEmpty, !d.isEmpty else { return nil }
                return makeEntry(title: t, description: d, category: draft.category, imageName: nil)
            }
            viewModel.addEntries(entries)
        case .delightedAndThankful:
            let person = thankfulPerson.trimmingCharacters(in: .whitespaces)
            let desc = """
            Delighted: \(delightedText.trimmingCharacters(in: .whitespaces))
            Thankful: \(description.trimmingCharacters(in: .whitespaces))
            """
            var entry = makeEntry(
                title: "Delighted & thankful",
                description: desc,
                category: category,
                imageName: nil,
                people: person.isEmpty ? nil : [person]
            )
            if let image = previewImage, let name = viewModel.savePhoto(image, for: entry.id) {
                entry.imageName = name
            }
            viewModel.addEntry(entry)
        case .blank:
            var entry = makeEntry(
                title: title.trimmingCharacters(in: .whitespaces),
                description: description.trimmingCharacters(in: .whitespaces),
                category: category,
                imageName: nil
            )
            if let image = previewImage, let name = viewModel.savePhoto(image, for: entry.id) {
                entry.imageName = name
            }
            viewModel.addEntry(entry)
        }
        dismiss()
    }

    private func makeEntry(
        title: String,
        description: String,
        category: GratitudeCategory,
        imageName: String?,
        people: [String]? = nil
    ) -> GratitudeEntry {
        let tags = tagsString
            .split(separator: ",")
            .map { $0.trimmingCharacters(in: .whitespaces) }
            .filter { !$0.isEmpty }
        let filteredPeople = (people ?? self.people)
            .map { $0.trimmingCharacters(in: .whitespaces) }
            .filter { !$0.isEmpty }

        return GratitudeEntry(
            id: UUID(),
            date: Date(),
            title: title,
            description: description,
            category: category,
            tags: tags,
            people: filteredPeople.isEmpty ? nil : filteredPeople,
            location: location.trimmingCharacters(in: .whitespaces).isEmpty ? nil : location,
            imageName: imageName,
            isFavorite: isFavorite,
            mood: mood,
            createdAt: Date()
        )
    }

    private func loadPhoto(from item: PhotosPickerItem?) {
        guard let item else { return }
        Task {
            if let data = try? await item.loadTransferable(type: Data.self),
               let image = UIImage(data: data) {
                await MainActor.run { previewImage = image }
            }
        }
    }

    private func clearPhoto() {
        selectedPhotoItem = nil
        previewImage = nil
    }
}
