import Foundation

struct GratitudeChallenge: Identifiable, Codable, Equatable, Hashable {
    let id: UUID
    var name: String
    var description: String
    var days: Int
    var currentDay: Int
    var startDate: Date
    var isActive: Bool
    var entries: [UUID]
    var requiredEntriesPerDay: Int
    var completedDayKeys: [String]

    enum CodingKeys: String, CodingKey {
        case id, name, description, days, currentDay, startDate, isActive, entries
        case requiredEntriesPerDay, completedDayKeys
    }

    init(
        id: UUID,
        name: String,
        description: String,
        days: Int,
        currentDay: Int,
        startDate: Date,
        isActive: Bool,
        entries: [UUID],
        requiredEntriesPerDay: Int = 1,
        completedDayKeys: [String] = []
    ) {
        self.id = id
        self.name = name
        self.description = description
        self.days = days
        self.currentDay = currentDay
        self.startDate = startDate
        self.isActive = isActive
        self.entries = entries
        self.requiredEntriesPerDay = max(1, requiredEntriesPerDay)
        self.completedDayKeys = completedDayKeys
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        description = try container.decode(String.self, forKey: .description)
        days = try container.decode(Int.self, forKey: .days)
        currentDay = try container.decode(Int.self, forKey: .currentDay)
        startDate = try container.decode(Date.self, forKey: .startDate)
        isActive = try container.decode(Bool.self, forKey: .isActive)
        entries = try container.decodeIfPresent([UUID].self, forKey: .entries) ?? []
        requiredEntriesPerDay = try container.decodeIfPresent(Int.self, forKey: .requiredEntriesPerDay) ?? 1
        completedDayKeys = try container.decodeIfPresent([String].self, forKey: .completedDayKeys) ?? []
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(description, forKey: .description)
        try container.encode(days, forKey: .days)
        try container.encode(currentDay, forKey: .currentDay)
        try container.encode(startDate, forKey: .startDate)
        try container.encode(isActive, forKey: .isActive)
        try container.encode(entries, forKey: .entries)
        try container.encode(requiredEntriesPerDay, forKey: .requiredEntriesPerDay)
        try container.encode(completedDayKeys, forKey: .completedDayKeys)
    }
}
