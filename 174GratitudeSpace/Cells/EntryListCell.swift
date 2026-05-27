import SwiftUI

struct EntryListCell: View {
    let entry: GratitudeEntry
    var showChevron: Bool = true

    var body: some View {
        HStack(spacing: 14) {
            ZStack(alignment: .bottomTrailing) {
                if entry.imageName != nil {
                    EntryThumbnail(fileName: entry.imageName, height: 56)
                        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                } else {
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(
                            LinearGradient(
                                colors: [Color.gardenNew.opacity(0.15), Color.gardenBloom.opacity(0.08)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 56, height: 56)
                        .overlay {
                            Text(entry.category.emoji)
                                .font(.title2)
                        }
                }
                Text(entry.moodLevel.emoji)
                    .font(.caption2)
                    .padding(3)
                    .background(Circle().fill(Color.white))
                    .offset(x: 4, y: 4)
            }

            VStack(alignment: .leading, spacing: 6) {
                Text(entry.title)
                    .font(.headline)
                    .foregroundColor(.gardenBloom)
                    .lineLimit(1)

                Text(entry.preview)
                    .font(.caption)
                    .foregroundColor(.gray)
                    .lineLimit(2)

                HStack(spacing: 8) {
                    Label(entry.formattedTime, systemImage: "clock")
                    if entry.isFavorite {
                        Image(systemName: "star.fill")
                            .foregroundColor(.gardenNew)
                    }
                }
                .font(.caption2)
                .foregroundColor(.gray)
            }

            Spacer(minLength: 0)

            if showChevron {
                Image(systemName: "chevron.right")
                    .font(.caption.weight(.semibold))
                    .foregroundColor(.gardenNew.opacity(0.6))
            }
        }
        .gardenCard(padding: 14)
    }
}

typealias MiniEntryCard = EntryListCell
