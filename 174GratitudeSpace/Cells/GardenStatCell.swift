import SwiftUI

struct GardenStatCell: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    var compact: Bool = true

    var body: some View {
        HStack(spacing: 12) {
            GardenIconCircle(systemName: icon, color: color, size: compact ? 40 : 44)

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.caption)
                    .foregroundColor(.gray)
                Text(value)
                    .font(compact ? .title3.weight(.bold) : .title2.weight(.bold))
                    .foregroundColor(.gardenBloom)
            }
            if !compact { Spacer() }
        }
        .frame(width: compact ? 168 : nil, alignment: .leading)
        .gardenCard(padding: 14, radius: GardenDesign.radiusM)
    }
}

typealias StatCard = GardenStatCell
