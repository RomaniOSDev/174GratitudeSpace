import SwiftUI
import PhotosUI

struct EntryFormFields: View {
    @Binding var title: String
    @Binding var description: String
    @Binding var category: GratitudeCategory
    @Binding var location: String
    @Binding var people: [String]
    @Binding var tagsString: String
    @Binding var isFavorite: Bool
    @Binding var mood: Int
    @Binding var selectedPhotoItem: PhotosPickerItem?
    var previewImage: UIImage?
    var onRemovePhoto: () -> Void

    var body: some View {
        VStack(spacing: 14) {
            formSection(title: "Mood", subtitle: "How does this moment feel?") {
                MoodPickerView(mood: $mood)
            }

            formSection(title: "Photo", subtitle: "Optional memory") {
                EntryPhotoPickerSection(
                    selectedItem: $selectedPhotoItem,
                    previewImage: previewImage,
                    onRemove: onRemovePhoto
                )
            }

            formSection(title: "Story", subtitle: "Title and reflection") {
                VStack(spacing: 12) {
                    gardenTextField("Title", text: $title)
                    gardenTextEditor("Description", text: $description, height: 120)
                }
            }

            formSection(title: "Details", subtitle: nil) {
                VStack(spacing: 12) {
                    categoryPicker
                    gardenTextField("Place", text: $location)
                }
            }

            formSection(title: "People", subtitle: nil) {
                VStack(spacing: 10) {
                    ForEach(people.indices, id: \.self) { index in
                        HStack(spacing: 8) {
                            gardenTextField("Name", text: $people[index])
                            Button { people.remove(at: index) } label: {
                                Image(systemName: "minus.circle.fill")
                                    .foregroundColor(.gardenNew.opacity(0.8))
                            }
                        }
                    }
                    Button {
                        people.append("")
                    } label: {
                        Label("Add person", systemImage: "person.badge.plus")
                            .font(.subheadline.weight(.medium))
                            .foregroundColor(.gardenNew)
                    }
                }
            }

            formSection(title: "Tags", subtitle: "Comma separated") {
                gardenTextField("family, joy, health", text: $tagsString)
            }

            formSection(title: nil, subtitle: nil) {
                Toggle(isOn: $isFavorite) {
                    Text("Add to favorites")
                        .foregroundColor(.gardenBloom)
                }
                .tint(.gardenNew)
            }
        }
        .padding(.horizontal, GardenDesign.padding)
    }

    private var categoryPicker: some View {
        Menu {
            ForEach(GratitudeCategory.allCases, id: \.self) { cat in
                Button {
                    category = cat
                } label: {
                    Text("\(cat.emoji) \(cat.displayName)")
                }
            }
        } label: {
            HStack {
                Text(category.emoji)
                Text(category.displayName)
                    .foregroundColor(.gardenBloom)
                Spacer()
                Image(systemName: "chevron.down")
                    .font(.caption)
                    .foregroundColor(.gardenNew)
            }
            .padding(12)
            .background(fieldBackground)
        }
    }

    private func formSection<Content: View>(title: String?, subtitle: String?, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            if let title {
                GardenSectionHeader(title: title, subtitle: subtitle)
            }
            content()
        }
        .gardenCard(padding: 14)
    }

    private func gardenTextField(_ placeholder: String, text: Binding<String>) -> some View {
        TextField(placeholder, text: text)
            .padding(12)
            .foregroundColor(.gardenBloom)
            .background(fieldBackground)
    }

    private func gardenTextEditor(_ placeholder: String, text: Binding<String>, height: CGFloat) -> some View {
        ZStack(alignment: .topLeading) {
            if text.wrappedValue.isEmpty {
                Text(placeholder)
                    .foregroundColor(.gray.opacity(0.5))
                    .padding(.horizontal, 16)
                    .padding(.vertical, 14)
            }
            TextEditor(text: text)
                .frame(height: height)
                .padding(8)
                .foregroundColor(.gardenBloom)
                .scrollContentBackground(.hidden)
        }
        .background(fieldBackground)
    }

    private var fieldBackground: some View {
        RoundedRectangle(cornerRadius: 12, style: .continuous)
            .fill(Color.gardenNew.opacity(0.04))
            .overlay(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .stroke(Color.gardenNew.opacity(0.15), lineWidth: 1)
            )
    }
}
