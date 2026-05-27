import SwiftUI

struct MoodPickerView: View {
    @Binding var mood: Int

    var body: some View {
        HStack(spacing: 6) {
            ForEach(GratitudeMood.allCases, id: \.rawValue) { level in
                Button {
                    withAnimation(.spring(response: 0.3)) {
                        mood = level.rawValue
                    }
                } label: {
                    VStack(spacing: 6) {
                        Text(level.emoji)
                            .font(.title2)
                            .scaleEffect(mood == level.rawValue ? 1.15 : 1)
                        Text(level.label)
                            .font(.caption2.weight(mood == level.rawValue ? .semibold : .regular))
                            .foregroundColor(mood == level.rawValue ? .gardenNew : .gray)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                    .background {
                        if mood == level.rawValue {
                            RoundedRectangle(cornerRadius: 12, style: .continuous)
                                .fill(
                                    LinearGradient(
                                        colors: [level.flowerColor.opacity(0.2), level.flowerColor.opacity(0.06)],
                                        startPoint: .top,
                                        endPoint: .bottom
                                    )
                                )
                        }
                    }
                    .overlay(
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .stroke(mood == level.rawValue ? level.flowerColor.opacity(0.5) : Color.clear, lineWidth: 1.5)
                    )
                }
                .buttonStyle(.plain)
            }
        }
    }
}
