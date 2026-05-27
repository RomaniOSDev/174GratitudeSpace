import SwiftUI

enum GratitudeMood: Int, CaseIterable, Codable, Hashable {
    case veryLow = 1
    case low = 2
    case neutral = 3
    case good = 4
    case great = 5

    var emoji: String {
        switch self {
        case .veryLow: return "😔"
        case .low: return "😐"
        case .neutral: return "🙂"
        case .good: return "😊"
        case .great: return "🤩"
        }
    }

    var label: String {
        switch self {
        case .veryLow: return "Low"
        case .low: return "Mild"
        case .neutral: return "Calm"
        case .good: return "Good"
        case .great: return "Joyful"
        }
    }

    static func from(raw: Int) -> GratitudeMood {
        GratitudeMood(rawValue: min(5, max(1, raw))) ?? .neutral
    }

    var flowerColor: Color {
        switch self {
        case .veryLow: return Color.gray
        case .low: return Color.gardenBloom.opacity(0.7)
        case .neutral: return Color.gardenBloom
        case .good: return Color.gardenNew.opacity(0.85)
        case .great: return Color.gardenNew
        }
    }
}
