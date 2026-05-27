import SwiftUI

struct HomeWidgetContainer<Content: View>: View {
    let title: String
    var subtitle: String? = nil
    var actionTitle: String? = nil
    var action: (() -> Void)? = nil
    var elevation: GardenElevation = .raised
    @ViewBuilder var content: () -> Content

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            GardenSectionHeader(
                title: title,
                subtitle: subtitle,
                actionTitle: actionTitle,
                action: action
            )
            content()
        }
        .gardenCard(elevation: elevation)
    }
}

struct HomeMiniStatTile: View {
    let icon: String
    let value: String
    let label: String
    let color: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundStyle(color)
            Text(value)
                .font(.title2.weight(.bold))
                .foregroundColor(.gardenBloom)
            Text(label)
                .font(.caption)
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(14)
        .gardenInsetPanel()
        .overlay(
            RoundedRectangle(cornerRadius: GardenDesign.radiusS, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [color.opacity(0.12), color.opacity(0.02)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .allowsHitTesting(false)
        )
    }
}

struct HomePhotoTile: View {
    let image: UIImage?
    let emoji: String
    var height: CGFloat = 120

    var body: some View {
        Group {
            if let image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
            } else {
                ZStack {
                    GardenDesign.gradientSoft
                    Text(emoji)
                        .font(.system(size: height * 0.35))
                }
            }
        }
        .frame(width: height * 0.85, height: height)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(
                    LinearGradient(
                        colors: [Color.white.opacity(0.7), Color.gardenNew.opacity(0.25)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 2
                )
        )
    }
}
