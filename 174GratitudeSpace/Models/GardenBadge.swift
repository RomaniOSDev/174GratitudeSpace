import Foundation

struct GardenBadge: Identifiable, Codable, Equatable {
    let id: String
    let title: String
    let description: String
    let icon: String
    var isUnlocked: Bool
    var unlockedAt: Date?

    static let catalog: [GardenBadge] = [
        GardenBadge(
            id: "streak_7",
            title: "Week Warrior",
            description: "7-day gratitude streak",
            icon: "flame.fill",
            isUnlocked: false,
            unlockedAt: nil
        ),
        GardenBadge(
            id: "flowers_50",
            title: "Garden Keeper",
            description: "50 flowers planted",
            icon: "leaf.fill",
            isUnlocked: false,
            unlockedAt: nil
        ),
        GardenBadge(
            id: "entries_30",
            title: "Consistent Heart",
            description: "30 gratitude entries",
            icon: "heart.fill",
            isUnlocked: false,
            unlockedAt: nil
        ),
        GardenBadge(
            id: "challenge_complete",
            title: "Challenge Finisher",
            description: "Complete a gratitude challenge",
            icon: "trophy.fill",
            isUnlocked: false,
            unlockedAt: nil
        )
    ]
}
