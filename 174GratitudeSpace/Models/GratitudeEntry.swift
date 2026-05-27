import Foundation

struct GratitudeEntry: Identifiable, Codable, Equatable, Hashable {
    let id: UUID
    let date: Date
    var title: String
    var description: String
    var category: GratitudeCategory
    var tags: [String]
    var people: [String]?
    var location: String?
    var imageName: String?
    var isFavorite: Bool
    var mood: Int
    let createdAt: Date

    var moodLevel: GratitudeMood {
        GratitudeMood.from(raw: mood)
    }

    var formattedDate: String {
        DateFormatting.formattedDate(date)
    }

    var formattedTime: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        formatter.locale = Locale(identifier: "en_US")
        return formatter.string(from: date)
    }

    var preview: String {
        if description.count > 100 {
            return String(description.prefix(100)) + "..."
        }
        return description
    }

    enum CodingKeys: String, CodingKey {
        case id, date, title, description, category, tags, people, location
        case imageName, isFavorite, mood, createdAt
    }

    init(
        id: UUID,
        date: Date,
        title: String,
        description: String,
        category: GratitudeCategory,
        tags: [String],
        people: [String]?,
        location: String?,
        imageName: String?,
        isFavorite: Bool,
        mood: Int = 3,
        createdAt: Date
    ) {
        self.id = id
        self.date = date
        self.title = title
        self.description = description
        self.category = category
        self.tags = tags
        self.people = people
        self.location = location
        self.imageName = imageName
        self.isFavorite = isFavorite
        self.mood = min(5, max(1, mood))
        self.createdAt = createdAt
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        date = try container.decode(Date.self, forKey: .date)
        title = try container.decode(String.self, forKey: .title)
        description = try container.decode(String.self, forKey: .description)
        category = try container.decode(GratitudeCategory.self, forKey: .category)
        tags = try container.decodeIfPresent([String].self, forKey: .tags) ?? []
        people = try container.decodeIfPresent([String].self, forKey: .people)
        location = try container.decodeIfPresent(String.self, forKey: .location)
        imageName = try container.decodeIfPresent(String.self, forKey: .imageName)
        isFavorite = try container.decodeIfPresent(Bool.self, forKey: .isFavorite) ?? false
        mood = try container.decodeIfPresent(Int.self, forKey: .mood) ?? 3
        createdAt = try container.decode(Date.self, forKey: .createdAt)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(date, forKey: .date)
        try container.encode(title, forKey: .title)
        try container.encode(description, forKey: .description)
        try container.encode(category, forKey: .category)
        try container.encode(tags, forKey: .tags)
        try container.encode(people, forKey: .people)
        try container.encode(location, forKey: .location)
        try container.encode(imageName, forKey: .imageName)
        try container.encode(isFavorite, forKey: .isFavorite)
        try container.encode(mood, forKey: .mood)
        try container.encode(createdAt, forKey: .createdAt)
    }
}
