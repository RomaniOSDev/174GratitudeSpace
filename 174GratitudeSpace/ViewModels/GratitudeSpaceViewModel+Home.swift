import Foundation
import UIKit

extension GratitudeSpaceViewModel {
    var recentEntries: [GratitudeEntry] {
        entries.sorted { $0.createdAt > $1.createdAt }.prefix(8).map { $0 }
    }

    var todayEntries: [GratitudeEntry] {
        entries
            .filter { Calendar.current.isDateInToday($0.date) }
            .sorted { $0.createdAt > $1.createdAt }
    }

    var entriesWithPhotos: [GratitudeEntry] {
        entries
            .filter { ($0.imageName ?? "").isEmpty == false }
            .sorted { $0.date > $1.date }
    }

    var photoGalleryEntries: [GratitudeEntry] {
        let withPhotos = entriesWithPhotos
        if withPhotos.count >= 4 { return Array(withPhotos.prefix(12)) }
        return recentEntries
    }

    var activeChallenge: GratitudeChallenge? {
        challenges.first { $0.isActive }
    }

    var todayProgress: (current: Int, goal: Int) {
        let today = todayEntries.count
        let goal = activeChallenge?.requiredEntriesPerDay ?? 1
        return (today, max(goal, 1))
    }

    var unlockedBadgesCount: Int {
        badges.filter(\.isUnlocked).count
    }

    func entryImage(_ entry: GratitudeEntry) -> UIImage? {
        ImageStorage.load(fileName: entry.imageName)
    }
}
