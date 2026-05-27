import SwiftUI

struct DetailMetricCell: View {
    let title: String
    let value: String
    let icon: String
    let color: Color

    var body: some View {
        VStack(spacing: 10) {
            GardenIconCircle(systemName: icon, color: color, size: 40)
            Text(value)
                .font(.subheadline.weight(.semibold))
                .foregroundColor(.gardenBloom)
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .minimumScaleFactor(0.8)
            Text(title)
                .font(.caption2)
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity)
        .gardenCard(padding: 12, radius: GardenDesign.radiusS)
    }
}

typealias DetailBox = DetailMetricCell

struct CategoryStatRow: View {
    let emoji: String
    let name: String
    let count: Int
    let maxCount: Int

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text(emoji)
                Text(name)
                    .foregroundColor(.gardenBloom)
                Spacer()
                Text("\(count)")
                    .font(.subheadline.weight(.bold))
                    .foregroundColor(.gardenNew)
            }
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Capsule().fill(Color.gardenNew.opacity(0.1))
                    Capsule()
                        .fill(Color.gardenNew)
                        .frame(width: geo.size.width * barProgress)
                }
            }
            .frame(height: 6)
        }
    }

    private var barProgress: CGFloat {
        guard maxCount > 0 else { return 0 }
        return CGFloat(count) / CGFloat(maxCount)
    }
}
