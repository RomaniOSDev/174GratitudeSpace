import Foundation

enum EntryTemplate: String, CaseIterable, Identifiable {
    case blank
    case threeGratitudes
    case delightedAndThankful

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .blank: return "Free form"
        case .threeGratitudes: return "3 gratitudes today"
        case .delightedAndThankful: return "Delighted & thankful"
        }
    }

    var subtitle: String {
        switch self {
        case .blank: return "Write anything you feel grateful for"
        case .threeGratitudes: return "Three short gratitude notes for today"
        case .delightedAndThankful: return "What delighted you and who deserves thanks"
        }
    }

    var isMultiEntry: Bool {
        self == .threeGratitudes
    }
}

struct GratitudeDraft: Identifiable {
    let id: UUID
    var title: String
    var description: String
    var category: GratitudeCategory

    init(
        id: UUID = UUID(),
        title: String,
        description: String,
        category: GratitudeCategory
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.category = category
    }
}
