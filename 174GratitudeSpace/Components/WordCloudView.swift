import SwiftUI

struct WordCloudView: View {
    let items: [WordCloudItem]

    var body: some View {
        if items.isEmpty {
            HStack {
                Spacer()
                VStack(spacing: 8) {
                    Image(systemName: "text.word.spacing")
                        .font(.largeTitle)
                        .foregroundColor(.gardenNew.opacity(0.4))
                    Text("Write more entries to grow your word cloud")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                }
                Spacer()
            }
            .padding(.vertical, 24)
        } else {
            FlowLayout(spacing: 10) {
                ForEach(items) { item in
                    Text(item.word)
                        .font(.system(size: fontSize(for: item.count), weight: .medium, design: .rounded))
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(
                            Capsule()
                                .fill(
                                    LinearGradient(
                                        colors: [
                                            Color.gardenNew.opacity(opacity(for: item.count)),
                                            Color.gardenBloom.opacity(opacity(for: item.count) * 0.7)
                                        ],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                        )
                        .foregroundColor(.gardenBloom)
                }
            }
        }
    }

    private func fontSize(for count: Int) -> CGFloat {
        CGFloat(13 + min(count, 8) * 2)
    }

    private func opacity(for count: Int) -> Double {
        0.12 + Double(min(count, 10)) * 0.035
    }
}
