import Foundation

enum GratitudeCategory: String, CaseIterable, Codable, Hashable {
    case people
    case health
    case work
    case nature
    case family
    case friendship
    case achievement
    case simpleJoy
    case self_
    case other

    var displayName: String {
        switch self {
        case .people: return "People"
        case .health: return "Health"
        case .work: return "Work & Study"
        case .nature: return "Nature"
        case .family: return "Family"
        case .friendship: return "Friendship"
        case .achievement: return "Achievements"
        case .simpleJoy: return "Simple Joys"
        case .self_: return "Self"
        case .other: return "Other"
        }
    }

    var icon: String {
        switch self {
        case .people: return "person.2.fill"
        case .health: return "heart.fill"
        case .work: return "briefcase.fill"
        case .nature: return "leaf.fill"
        case .family: return "house.fill"
        case .friendship: return "hand.raised.fill"
        case .achievement: return "star.fill"
        case .simpleJoy: return "sun.max.fill"
        case .self_: return "person.fill"
        case .other: return "circle.fill"
        }
    }

    var emoji: String {
        switch self {
        case .people: return "👥"
        case .health: return "❤️"
        case .work: return "💼"
        case .nature: return "🌿"
        case .family: return "🏠"
        case .friendship: return "🤝"
        case .achievement: return "🏆"
        case .simpleJoy: return "☀️"
        case .self_: return "🧘"
        case .other: return "✨"
        }
    }
}
