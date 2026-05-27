import Foundation

struct GardenFlower: Identifiable, Codable, Equatable, Hashable {
    let id: UUID
    let entryId: UUID
    var title: String
    var bloomDate: Date
    var color: String
    var isWilted: Bool
    var mood: Int

    var moodLevel: GratitudeMood {
        GratitudeMood.from(raw: mood)
    }

    enum CodingKeys: String, CodingKey {
        case id, entryId, title, bloomDate, color, isWilted, mood
    }

    init(
        id: UUID,
        entryId: UUID,
        title: String,
        bloomDate: Date,
        color: String,
        isWilted: Bool,
        mood: Int = 3
    ) {
        self.id = id
        self.entryId = entryId
        self.title = title
        self.bloomDate = bloomDate
        self.color = color
        self.isWilted = isWilted
        self.mood = min(5, max(1, mood))
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        entryId = try container.decode(UUID.self, forKey: .entryId)
        title = try container.decode(String.self, forKey: .title)
        bloomDate = try container.decode(Date.self, forKey: .bloomDate)
        color = try container.decode(String.self, forKey: .color)
        isWilted = try container.decode(Bool.self, forKey: .isWilted)
        mood = try container.decodeIfPresent(Int.self, forKey: .mood) ?? 3
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(entryId, forKey: .entryId)
        try container.encode(title, forKey: .title)
        try container.encode(bloomDate, forKey: .bloomDate)
        try container.encode(color, forKey: .color)
        try container.encode(isWilted, forKey: .isWilted)
        try container.encode(mood, forKey: .mood)
    }
}
