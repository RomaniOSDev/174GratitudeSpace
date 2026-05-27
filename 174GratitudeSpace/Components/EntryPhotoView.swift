import SwiftUI
import PhotosUI

struct EntryPhotoPickerSection: View {
    @Binding var selectedItem: PhotosPickerItem?
    let previewImage: UIImage?
    var onRemove: () -> Void

    var body: some View {
        VStack(spacing: 12) {
            if let previewImage {
                Image(uiImage: previewImage)
                    .resizable()
                    .scaledToFill()
                    .frame(height: 180)
                    .frame(maxWidth: .infinity)
                    .clipped()
                    .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                    .overlay(
                        RoundedRectangle(cornerRadius: 14, style: .continuous)
                            .stroke(Color.gardenNew.opacity(0.2), lineWidth: 1)
                    )

                Button("Remove photo", role: .destructive, action: onRemove)
                    .font(.caption.weight(.medium))
                    .foregroundColor(.gardenNew)
            }

            PhotosPicker(selection: $selectedItem, matching: .images) {
                HStack {
                    Image(systemName: "photo.on.rectangle.angled")
                    Text(previewImage == nil ? "Add photo" : "Change photo")
                        .fontWeight(.medium)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .foregroundColor(.gardenNew)
                .background(
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(Color.gardenNew.opacity(0.08))
                )
            }
        }
    }
}

struct EntryThumbnail: View {
    let fileName: String?
    var height: CGFloat = 44

    var body: some View {
        Group {
            if let image = ImageStorage.load(fileName: fileName) {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
            } else {
                Image(systemName: "photo")
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.gardenNew.opacity(0.08))
            }
        }
        .frame(width: height, height: height)
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}
