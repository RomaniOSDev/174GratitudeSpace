import SwiftUI

struct FlowerGridCell: View {
    let flower: GardenFlower

    var body: some View {
        VStack(spacing: 10) {
            ZStack {
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [flowerColor.opacity(0.28), flowerColor.opacity(0.04)],
                            center: .center,
                            startRadius: 2,
                            endRadius: 38
                        )
                    )
                    .frame(width: 76, height: 76)

                Circle()
                    .stroke(
                        LinearGradient(
                            colors: [flowerColor.opacity(0.5), flowerColor.opacity(0.2)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 2
                    )
                    .frame(width: 76, height: 76)

                Image(systemName: "leaf.circle.fill")
                    .font(.system(size: 34, weight: .medium))
                    .foregroundStyle(flowerColor)

                if !flower.isWilted {
                    Text(flower.moodLevel.emoji)
                        .font(.system(size: 16))
                        .padding(5)
                        .background(Circle().fill(Color.white))
                        .overlay(Circle().stroke(flowerColor.opacity(0.25), lineWidth: 1))
                        .offset(x: 26, y: -26)
                }
            }

            VStack(spacing: 2) {
                Text(flower.title)
                    .font(.caption.weight(.semibold))
                    .foregroundColor(flower.isWilted ? .gray : .gardenBloom)
                    .lineLimit(1)
                Text(DateFormatting.formattedShortDate(flower.bloomDate))
                    .font(.caption2)
                    .foregroundColor(.gray)
            }
            .frame(width: 88)
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 4)
        .gardenTile(accent: flowerColor)
    }

    private var flowerColor: Color {
        flower.isWilted ? .gray : flower.moodLevel.flowerColor
    }
}

struct EmptyFlowerGridCell: View {
    var body: some View {
        VStack(spacing: 10) {
            ZStack {
                Circle()
                    .fill(Color.gardenNew.opacity(0.06))
                    .frame(width: 76, height: 76)
                Circle()
                    .strokeBorder(style: StrokeStyle(lineWidth: 2, dash: [6, 4]))
                    .foregroundColor(Color.gardenNew.opacity(0.35))
                    .frame(width: 76, height: 76)
                Image(systemName: "plus")
                    .font(.title2.weight(.semibold))
                    .foregroundColor(.gardenNew.opacity(0.75))
            }
            Text("Plant")
                .font(.caption.weight(.medium))
                .foregroundColor(.gardenNew.opacity(0.8))
        }
        .padding(.vertical, 8)
        .gardenTile()
    }
}

typealias FlowerView = FlowerGridCell
typealias EmptyFlowerView = EmptyFlowerGridCell
