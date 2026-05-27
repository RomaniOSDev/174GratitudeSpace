import SwiftUI

struct QuoteHighlightCell: View {
    let text: String
    let author: String

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                GardenIconCircle(systemName: "quote.opening", color: .gardenNew, size: 36)
                Text("Quote of the day")
                    .font(.subheadline.weight(.semibold))
                    .foregroundColor(.gardenBloom)
            }

            Text(text)
                .font(.body)
                .foregroundColor(.gardenBloom)
                .italic()
                .fixedSize(horizontal: false, vertical: true)

            Text("— \(author)")
                .font(.caption)
                .foregroundColor(.gray)
        }
        .gardenCard()
        .overlay(
            RoundedRectangle(cornerRadius: GardenDesign.radiusM, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [Color.gardenNew.opacity(0.08), Color.clear],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .allowsHitTesting(false)
        )
    }
}

struct PromptBannerCell: View {
    let prompt: String

    var body: some View {
        HStack(spacing: 12) {
            GardenIconCircle(systemName: "lightbulb.fill", color: .gardenNew, size: 40)
            VStack(alignment: .leading, spacing: 4) {
                Text("Today's prompt")
                    .font(.caption.weight(.semibold))
                    .foregroundColor(.gardenNew)
                Text(prompt)
                    .font(.subheadline)
                    .foregroundColor(.gardenBloom)
                    .lineLimit(2)
            }
        }
        .gardenCard(padding: 14)
    }
}

struct GardenHeroHeader: View {
    let title: String
    let subtitle: String
    var trailingIcon: String? = nil
    var trailingLabel: String? = nil

    var body: some View {
        HStack(alignment: .center, spacing: 14) {
            VStack(alignment: .leading, spacing: 6) {
                Text(title)
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                    .foregroundColor(.gardenBloom)
                Text(subtitle)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            Spacer()
            if let trailingIcon, let trailingLabel {
                VStack(spacing: 4) {
                    Image(systemName: trailingIcon)
                        .font(.title3)
                        .foregroundColor(.gardenNew)
                    Text(trailingLabel)
                        .font(.caption2.weight(.medium))
                        .foregroundColor(.gardenNew)
                }
                .padding(10)
                .background(
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(Color.gardenNew.opacity(0.1))
                )
            }
        }
        .padding(.horizontal, GardenDesign.padding)
    }
}
