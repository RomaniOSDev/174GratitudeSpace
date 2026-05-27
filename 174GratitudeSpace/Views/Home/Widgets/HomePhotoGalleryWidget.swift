import SwiftUI

struct HomePhotoGalleryWidget: View {
    @ObservedObject var viewModel: GratitudeSpaceViewModel
    var onSelect: (GratitudeEntry) -> Void

    private var items: [GratitudeEntry] {
        let photos = viewModel.photoGalleryEntries
        return photos.isEmpty ? viewModel.recentEntries : photos
    }

    var body: some View {
        HomeWidgetContainer(
            title: "Memory gallery",
            subtitle: "\(viewModel.entriesWithPhotos.count) photos in your journal"
        ) {
            if items.isEmpty {
                emptyGallery
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 14) {
                        ForEach(items) { entry in
                            Button {
                                onSelect(entry)
                            } label: {
                                galleryCard(entry)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
            }
        }
    }

    private func galleryCard(_ entry: GratitudeEntry) -> some View {
        ZStack(alignment: .bottomLeading) {
            Group {
                if let image = viewModel.entryImage(entry) {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                } else {
                    LinearGradient(
                        colors: [Color.gardenNew.opacity(0.4), Color.gardenBloom.opacity(0.5)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    Text(entry.category.emoji)
                        .font(.system(size: 48))
                }
            }
            .frame(width: 150, height: 190)
            .clipped()

            LinearGradient(colors: [.clear, .black.opacity(0.55)], startPoint: .center, endPoint: .bottom)

            VStack(alignment: .leading, spacing: 4) {
                Text(entry.title)
                    .font(.caption.weight(.bold))
                    .foregroundColor(.white)
                    .lineLimit(2)
                Text(entry.moodLevel.emoji)
            }
            .padding(10)
        }
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .stroke(Color.white.opacity(0.35), lineWidth: 1.5)
        )
    }

    private var emptyGallery: some View {
        VStack(spacing: 12) {
            HStack(spacing: 12) {
                HomePhotoTile(image: nil, emoji: "🌿", height: 100)
                HomePhotoTile(image: nil, emoji: "☀️", height: 120)
                HomePhotoTile(image: nil, emoji: "🤝", height: 100)
            }
            Text("Add photos to your entries — they will appear here")
                .font(.caption)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 8)
    }
}
