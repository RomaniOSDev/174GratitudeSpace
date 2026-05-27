import SwiftUI
import PhotosUI

struct EditEntryView: View {
    @ObservedObject var viewModel: GratitudeSpaceViewModel
    let entry: GratitudeEntry
    @Environment(\.dismiss) private var dismiss

    @State private var title: String
    @State private var description: String
    @State private var category: GratitudeCategory
    @State private var location: String
    @State private var people: [String]
    @State private var tagsString: String
    @State private var isFavorite: Bool
    @State private var mood: Int
    @State private var selectedPhotoItem: PhotosPickerItem?
    @State private var previewImage: UIImage?
    @State private var imageFileName: String?

    init(viewModel: GratitudeSpaceViewModel, entry: GratitudeEntry) {
        self.viewModel = viewModel
        self.entry = entry
        _title = State(initialValue: entry.title)
        _description = State(initialValue: entry.description)
        _category = State(initialValue: entry.category)
        _location = State(initialValue: entry.location ?? "")
        _people = State(initialValue: entry.people ?? [])
        _tagsString = State(initialValue: entry.tags.joined(separator: ", "))
        _isFavorite = State(initialValue: entry.isFavorite)
        _mood = State(initialValue: entry.mood)
        _imageFileName = State(initialValue: entry.imageName)
        _previewImage = State(initialValue: ImageStorage.load(fileName: entry.imageName))
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
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

                VStack(spacing: 10) {
                    GardenPrimaryButton(title: "Save changes", icon: "checkmark", action: saveChanges, isEnabled: canSave)
                    GardenSecondaryButton(title: "Cancel", action: { dismiss() })
                }
                .padding(GardenDesign.padding)
                .gardenStickyFooter()
            }
            .gardenScreenBackground()
            .navigationTitle("Edit entry")
            .navigationBarTitleDisplayMode(.inline)
            .onChange(of: selectedPhotoItem) { newItem in
                loadPhoto(from: newItem)
            }
        }
    }

    private var canSave: Bool {
        !title.trimmingCharacters(in: .whitespaces).isEmpty &&
        !description.trimmingCharacters(in: .whitespaces).isEmpty
    }

    private func saveChanges() {
        let tags = tagsString
            .split(separator: ",")
            .map { $0.trimmingCharacters(in: .whitespaces) }
            .filter { !$0.isEmpty }
        let filteredPeople = people
            .map { $0.trimmingCharacters(in: .whitespaces) }
            .filter { !$0.isEmpty }

        var fileName = imageFileName
        if previewImage == nil {
            ImageStorage.delete(fileName: imageFileName)
            fileName = nil
        } else if let previewImage, let saved = viewModel.savePhoto(previewImage, for: entry.id) {
            if fileName != saved { ImageStorage.delete(fileName: imageFileName) }
            fileName = saved
        }

        var updated = entry
        updated.title = title.trimmingCharacters(in: .whitespaces)
        updated.description = description.trimmingCharacters(in: .whitespaces)
        updated.category = category
        updated.tags = tags
        updated.people = filteredPeople.isEmpty ? nil : filteredPeople
        updated.location = location.trimmingCharacters(in: .whitespaces).isEmpty ? nil : location
        updated.isFavorite = isFavorite
        updated.mood = mood
        updated.imageName = fileName

        viewModel.updateEntry(updated)
        dismiss()
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
        imageFileName = nil
    }
}
