import SwiftUI

struct CalendarDayCell: View {
    let date: Date
    let hasEntry: Bool
    let entryCount: Int
    let heatLevel: Double
    var isSelected: Bool = false
    var isToday: Bool = false

    private var calendar: Calendar { Calendar.current }

    var body: some View {
        VStack(spacing: 4) {
            Text("\(calendar.component(.day, from: date))")
                .font(.system(size: 14, weight: isToday ? .bold : .medium))
                .foregroundColor(textColor)

            if hasEntry {
                HStack(spacing: 2) {
                    ForEach(0..<min(entryCount, 3), id: \.self) { _ in
                        Circle()
                            .fill(Color.gardenNew)
                            .frame(width: 4, height: 4)
                    }
                }
            } else {
                Circle()
                    .fill(Color.clear)
                    .frame(width: 4, height: 4)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 8)
        .background {
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(dayGradient)
        }
        .overlay(
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .stroke(borderColor, lineWidth: isSelected || isToday ? 2 : 0)
        )
    }

    private var textColor: Color {
        if isSelected || isToday { return .gardenNew }
        return hasEntry ? .gardenBloom : .gardenBloom.opacity(0.7)
    }

    private var dayGradient: LinearGradient {
        if isSelected {
            return LinearGradient(
                colors: [Color.gardenNew.opacity(0.28), Color.gardenNew.opacity(0.12)],
                startPoint: .top,
                endPoint: .bottom
            )
        }
        let top = Color.gardenNew.opacity(heatLevel * 0.45 + (hasEntry ? 0.1 : 0.02))
        let bottom = Color.gardenNew.opacity(heatLevel * 0.2 + (hasEntry ? 0.04 : 0))
        return LinearGradient(colors: [top, bottom], startPoint: .top, endPoint: .bottom)
    }

    private var borderColor: Color {
        if isSelected { return .gardenNew }
        if isToday { return .gardenBloom }
        return .clear
    }
}
