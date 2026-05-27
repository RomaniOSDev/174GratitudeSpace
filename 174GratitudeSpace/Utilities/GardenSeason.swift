import SwiftUI

enum GardenSeason: CaseIterable {
    case spring, summer, autumn, winter

    static var current: GardenSeason {
        switch Calendar.current.component(.month, from: Date()) {
        case 3...5: return .spring
        case 6...8: return .summer
        case 9...11: return .autumn
        default: return .winter
        }
    }

    var title: String {
        switch self {
        case .spring: return "Spring bloom"
        case .summer: return "Summer light"
        case .autumn: return "Autumn glow"
        case .winter: return "Winter calm"
        }
    }

    var decorSymbol: String {
        switch self {
        case .spring: return "leaf.fill"
        case .summer: return "sun.max.fill"
        case .autumn: return "wind"
        case .winter: return "snowflake"
        }
    }
}

/// Lightweight seasonal layer — fixed corners, no GeometryReader loop.
struct GardenSeasonBackground: ViewModifier {
    let flowerCount: Int

    func body(content: Content) -> some View {
        let season = GardenSeason.current
        let accent = seasonAccent(season)

        ZStack {
            GardenDesign.gradientScreen
                .ignoresSafeArea()

            seasonDecor(symbol: season.decorSymbol, color: accent)
                .allowsHitTesting(false)

            content
        }
    }

    private func seasonAccent(_ season: GardenSeason) -> Color {
        let boost = min(0.08, Double(flowerCount) / 300.0)
        switch season {
        case .spring, .summer: return Color.gardenNew.opacity(0.1 + boost)
        case .autumn, .winter: return Color.gardenBloom.opacity(0.08 + boost)
        }
    }

    private func seasonDecor(symbol: String, color: Color) -> some View {
        VStack {
            HStack {
                decorIcon(symbol, color, size: 22)
                Spacer()
                decorIcon(symbol, color, size: 18)
            }
            Spacer()
            HStack {
                decorIcon(symbol, color, size: 16)
                Spacer()
                decorIcon(symbol, color, size: 20)
            }
        }
        .padding(24)
        .opacity(0.45)
    }

    private func decorIcon(_ symbol: String, _ color: Color, size: CGFloat) -> some View {
        Image(systemName: symbol)
            .font(.system(size: size))
            .foregroundStyle(color)
    }
}

extension View {
    func gardenSeasonBackground(flowerCount: Int) -> some View {
        modifier(GardenSeasonBackground(flowerCount: flowerCount))
    }
}
