import Foundation
import Combine
import UIKit

final class GratitudeSpaceViewModel: ObservableObject {
    @Published var entries: [GratitudeEntry] = []
    @Published var quotes: [GratitudeQuote] = []
    @Published var challenges: [GratitudeChallenge] = []
    @Published var flowers: [GardenFlower] = []
    @Published var badges: [GardenBadge] = GardenBadge.catalog

    var todayPrompt: String { DailyPromptProvider.todayPrompt }

    var totalFlowers: Int { flowers.count }
    var bloomingFlowers: Int { flowers.filter { !$0.isWilted }.count }

    var currentStreak: Int {
        let calendar = Calendar.current
        var streak = 0
        var date = calendar.startOfDay(for: Date())
        while true {
            let hasEntry = entries.contains { calendar.isDate($0.date, inSameDayAs: date) }
            if hasEntry {
                streak += 1
                guard let previous = calendar.date(byAdding: .day, value: -1, to: date) else { break }
                date = previous
            } else {
                break
            }
        }
        return streak
    }

    var monthlyCount: Int { entryCount(inMonth: Date()) }

    var averageWords: Int {
        guard !entries.isEmpty else { return 0 }
        let totalWords = entries.reduce(0) { $0 + $1.description.split(separator: " ").count }
        return totalWords / entries.count
    }

    var averageEntriesPerWeek: Double {
        guard !entries.isEmpty else { return 0 }
        let oldestEntry = entries.min { $0.date < $1.date }?.date ?? Date()
        let weeks = max(1, Calendar.current.dateComponents([.weekOfYear], from: oldestEntry, to: Date()).weekOfYear ?? 1)
        return Double(entries.count) / Double(weeks)
    }

    var todayQuote: GratitudeQuote? {
        let dayOfYear = Calendar.current.ordinality(of: .day, in: .year, for: Date()) ?? 1
        guard !quotes.isEmpty else { return nil }
        return quotes[dayOfYear % quotes.count]
    }

    var topCategories: [(GratitudeCategory, Int)] {
        Dictionary(grouping: entries, by: { $0.category })
            .map { ($0.key, $0.value.count) }
            .sorted { $0.1 > $1.1 }
            .prefix(5)
            .map { $0 }
    }

    struct WeeklyActivity: Identifiable {
        let id = UUID()
        let day: String
        let count: Int
    }

    var weeklyActivity: [WeeklyActivity] {
        let calendar = Calendar.current
        let today = Date()
        return (0..<7).compactMap { calendar.date(byAdding: .day, value: -$0, to: today) }.reversed().map { date in
            let count = entries.filter { calendar.isDate($0.date, inSameDayAs: date) }.count
            let formatter = DateFormatter()
            formatter.dateFormat = "E"
            formatter.locale = Locale(identifier: "en_US")
            return WeeklyActivity(day: formatter.string(from: date), count: count)
        }
    }

    struct CategorySlice: Identifiable {
        let id = UUID()
        let category: GratitudeCategory
        let count: Int
    }

    var categoryChartData: [CategorySlice] {
        Dictionary(grouping: entries, by: { $0.category })
            .map { CategorySlice(category: $0.key, count: $0.value.count) }
            .sorted { $0.count > $1.count }
    }

    var wordCloudItems: [WordCloudItem] {
        WordCloudHelper.topWords(from: entries)
    }

    struct MonthSummary: Identifiable {
        let id = UUID()
        let month: Date
        let label: String
        let entryCount: Int
    }

    var recentMonthSummaries: [MonthSummary] {
        let calendar = Calendar.current
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        formatter.locale = Locale(identifier: "en_US")

        return (0..<6).compactMap { offset -> MonthSummary? in
            guard let month = calendar.date(byAdding: .month, value: -offset, to: Date()) else { return nil }
            return MonthSummary(
                month: month,
                label: formatter.string(from: month),
                entryCount: entryCount(inMonth: month)
            )
        }
    }

    var monthComparison: (current: MonthSummary, previous: MonthSummary)? {
        let summaries = recentMonthSummaries
        guard summaries.count >= 2 else { return nil }
        return (summaries[0], summaries[1])
    }

    func entry(for flower: GardenFlower) -> GratitudeEntry? {
        entries.first { $0.id == flower.entryId }
    }

    func hasEntry(on date: Date) -> Bool {
        entryCount(on: date) > 0
    }

    func entryCount(on date: Date) -> Int {
        entries.filter { Calendar.current.isDate($0.date, inSameDayAs: date) }.count
    }

    func heatLevel(for date: Date) -> Double {
        let count = entryCount(on: date)
        if count == 0 { return 0 }
        return min(1.0, Double(count) / 3.0)
    }

    func entriesOnDate(_ date: Date) -> [GratitudeEntry] {
        entries.filter { Calendar.current.isDate($0.date, inSameDayAs: date) }
            .sorted { $0.createdAt > $1.createdAt }
    }

    func yesterdayEntries() -> [GratitudeEntry] {
        guard let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: Date()) else { return [] }
        return entriesOnDate(yesterday)
    }

    func draftsFromYesterday() -> [GratitudeDraft] {
        let yesterday = yesterdayEntries()
        if yesterday.isEmpty {
            return [
                GratitudeDraft(title: "", description: "", category: .simpleJoy),
                GratitudeDraft(title: "", description: "", category: .people),
                GratitudeDraft(title: "", description: "", category: .simpleJoy)
            ]
        }
        return yesterday.map {
            GratitudeDraft(title: $0.title, description: "", category: $0.category)
        }
    }

    func addEntry(_ entry: GratitudeEntry, linkToChallenges: Bool = true) {
        entries.append(entry)
        flowers.append(
            GardenFlower(
                id: UUID(),
                entryId: entry.id,
                title: entry.title,
                bloomDate: entry.date,
                color: "blue",
                isWilted: false,
                mood: entry.mood
            )
        )
        if linkToChallenges {
            linkEntryToActiveChallenges(entry.id)
        }
        updateChallenges()
        refreshBadges()
        saveToUserDefaults()
    }

    func addEntries(_ newEntries: [GratitudeEntry]) {
        for entry in newEntries {
            addEntry(entry, linkToChallenges: true)
        }
    }

    func updateEntry(_ entry: GratitudeEntry) {
        guard let index = entries.firstIndex(where: { $0.id == entry.id }) else { return }
        entries[index] = entry
        if let flowerIndex = flowers.firstIndex(where: { $0.entryId == entry.id }) {
            flowers[flowerIndex].title = entry.title
            flowers[flowerIndex].bloomDate = entry.date
            flowers[flowerIndex].mood = entry.mood
        }
        refreshBadges()
        saveToUserDefaults()
    }

    func deleteEntry(_ entry: GratitudeEntry) {
        entries.removeAll { $0.id == entry.id }
        if let index = flowers.firstIndex(where: { $0.entryId == entry.id }) {
            flowers[index].isWilted = true
        }
        for index in challenges.indices {
            challenges[index].entries.removeAll { $0 == entry.id }
        }
        ImageStorage.delete(fileName: entry.imageName)
        refreshBadges()
        saveToUserDefaults()
    }

    func savePhoto(_ image: UIImage, for entryId: UUID) -> String? {
        ImageStorage.saveJPEG(image, entryId: entryId)
    }

    func addChallenge(_ challenge: GratitudeChallenge) {
        challenges.append(challenge)
        saveToUserDefaults()
    }

    func deleteChallenge(_ challenge: GratitudeChallenge) {
        challenges.removeAll { $0.id == challenge.id }
        saveToUserDefaults()
    }

    func startChallenge(_ challenge: GratitudeChallenge) {
        guard let index = challenges.firstIndex(where: { $0.id == challenge.id }) else { return }
        challenges[index].isActive = true
        challenges[index].startDate = Date()
        challenges[index].currentDay = 1
        saveToUserDefaults()
    }

    func entriesLinked(to challenge: GratitudeChallenge) -> [GratitudeEntry] {
        entries.filter { challenge.entries.contains($0.id) }
    }

    func todayEntries(for challenge: GratitudeChallenge) -> [GratitudeEntry] {
        let todayIds = Set(entries.filter { Calendar.current.isDateInToday($0.date) }.map(\.id))
        return entries.filter { challenge.entries.contains($0.id) && todayIds.contains($0.id) }
    }

    func isTodayComplete(for challenge: GratitudeChallenge) -> Bool {
        challenge.completedDayKeys.contains(dayKey(for: Date())) ||
        todayEntries(for: challenge).count >= challenge.requiredEntriesPerDay
    }

    func toggleTodayComplete(for challenge: GratitudeChallenge) {
        guard let index = challenges.firstIndex(where: { $0.id == challenge.id }) else { return }
        let key = dayKey(for: Date())
        if challenges[index].completedDayKeys.contains(key) {
            challenges[index].completedDayKeys.removeAll { $0 == key }
        } else {
            challenges[index].completedDayKeys.append(key)
        }
        refreshBadges()
        saveToUserDefaults()
    }

    func addQuote(_ quote: GratitudeQuote) {
        quotes.append(quote)
        saveToUserDefaults()
    }

    func deleteQuote(_ quote: GratitudeQuote) {
        quotes.removeAll { $0.id == quote.id }
        saveToUserDefaults()
    }

    func toggleQuoteFavorite(_ quote: GratitudeQuote) {
        guard let index = quotes.firstIndex(where: { $0.id == quote.id }) else { return }
        quotes[index].isFavorite.toggle()
        saveToUserDefaults()
    }

    private func linkEntryToActiveChallenges(_ entryId: UUID) {
        for index in challenges.indices where challenges[index].isActive {
            if !challenges[index].entries.contains(entryId) {
                challenges[index].entries.append(entryId)
            }
            let todayCount = todayEntries(for: challenges[index]).count
            if todayCount >= challenges[index].requiredEntriesPerDay {
                let key = dayKey(for: Date())
                if !challenges[index].completedDayKeys.contains(key) {
                    challenges[index].completedDayKeys.append(key)
                }
            }
        }
    }

    private func updateChallenges() {
        for index in challenges.indices where challenges[index].isActive {
            let daysSinceStart = Calendar.current.dateComponents([.day], from: challenges[index].startDate, to: Date()).day ?? 0
            challenges[index].currentDay = min(daysSinceStart + 1, challenges[index].days)
            if challenges[index].currentDay >= challenges[index].days {
                challenges[index].isActive = false
                unlockBadge(id: "challenge_complete")
            }
        }
    }

    private func refreshBadges() {
        if currentStreak >= 7 { unlockBadge(id: "streak_7") }
        if bloomingFlowers >= 50 { unlockBadge(id: "flowers_50") }
        if entries.count >= 30 { unlockBadge(id: "entries_30") }
    }

    private func unlockBadge(id: String) {
        guard let index = badges.firstIndex(where: { $0.id == id && !$0.isUnlocked }) else { return }
        badges[index].isUnlocked = true
        badges[index].unlockedAt = Date()
        if let encoded = try? JSONEncoder().encode(badges) {
            UserDefaults.standard.set(encoded, forKey: badgesKey)
        }
    }

    private func entryCount(inMonth month: Date) -> Int {
        let calendar = Calendar.current
        return entries.filter {
            calendar.component(.month, from: $0.date) == calendar.component(.month, from: month) &&
            calendar.component(.year, from: $0.date) == calendar.component(.year, from: month)
        }.count
    }

    private func dayKey(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter.string(from: Calendar.current.startOfDay(for: date))
    }

    private let entriesKey = "gratitudespace_entries"
    private let quotesKey = "gratitudespace_quotes"
    private let challengesKey = "gratitudespace_challenges"
    private let flowersKey = "gratitudespace_flowers"
    private let badgesKey = "gratitudespace_badges"

    func saveToUserDefaults() {
        if let encoded = try? JSONEncoder().encode(entries) {
            UserDefaults.standard.set(encoded, forKey: entriesKey)
        }
        if let encoded = try? JSONEncoder().encode(quotes) {
            UserDefaults.standard.set(encoded, forKey: quotesKey)
        }
        if let encoded = try? JSONEncoder().encode(challenges) {
            UserDefaults.standard.set(encoded, forKey: challengesKey)
        }
        if let encoded = try? JSONEncoder().encode(flowers) {
            UserDefaults.standard.set(encoded, forKey: flowersKey)
        }
        if let encoded = try? JSONEncoder().encode(badges) {
            UserDefaults.standard.set(encoded, forKey: badgesKey)
        }
    }

    func loadFromUserDefaults() {
        if let data = UserDefaults.standard.data(forKey: entriesKey),
           let decoded = try? JSONDecoder().decode([GratitudeEntry].self, from: data) {
            entries = decoded
        }
        if let data = UserDefaults.standard.data(forKey: quotesKey),
           let decoded = try? JSONDecoder().decode([GratitudeQuote].self, from: data) {
            quotes = decoded
        }
        if let data = UserDefaults.standard.data(forKey: challengesKey),
           let decoded = try? JSONDecoder().decode([GratitudeChallenge].self, from: data) {
            challenges = decoded
        }
        if let data = UserDefaults.standard.data(forKey: flowersKey),
           let decoded = try? JSONDecoder().decode([GardenFlower].self, from: data) {
            flowers = decoded
        }
        if let data = UserDefaults.standard.data(forKey: badgesKey),
           let decoded = try? JSONDecoder().decode([GardenBadge].self, from: data) {
            badges = decoded
        }
        syncFlowerMoodsFromEntries()
        if entries.isEmpty {
            loadDemoData()
        } else {
            refreshBadges()
        }
    }

    private func syncFlowerMoodsFromEntries() {
        for index in flowers.indices {
            if let entry = entries.first(where: { $0.id == flowers[index].entryId }) {
                flowers[index].mood = entry.mood
            }
        }
    }

    private func loadDemoData() {
        let id1 = UUID()
        let id2 = UUID()
        let id3 = UUID()

        var entry1 = GratitudeEntry(
            id: id1,
            date: Date().addingTimeInterval(-86400),
            title: "Beautiful sunset",
            description: "Today I watched an incredible sunset. The sky was orange and pink, and I felt peaceful.",
            category: .nature,
            tags: ["sunset", "nature"],
            people: nil,
            location: "Park",
            imageName: nil,
            isFavorite: true,
            mood: 5,
            createdAt: Date()
        )
        var entry2 = GratitudeEntry(
            id: id2,
            date: Date().addingTimeInterval(-172800),
            title: "Friend's help",
            description: "My friend helped me with a project when I was about to give up.",
            category: .friendship,
            tags: ["friendship", "support"],
            people: ["Alex"],
            location: nil,
            imageName: nil,
            isFavorite: false,
            mood: 4,
            createdAt: Date()
        )
        var entry3 = GratitudeEntry(
            id: id3,
            date: Date(),
            title: "Morning coffee ritual",
            description: "A quiet moment with warm coffee before the day began — simple and perfect.",
            category: .simpleJoy,
            tags: ["morning", "calm"],
            people: nil,
            location: "Home",
            imageName: nil,
            isFavorite: false,
            mood: 5,
            createdAt: Date()
        )

        attachDemoPhoto(to: &entry1, emoji: "🌿", top: UIColor(red: 0.008, green: 0.686, blue: 0.937, alpha: 1), bottom: UIColor(red: 0.004, green: 0.549, blue: 0.816, alpha: 1))
        attachDemoPhoto(to: &entry2, emoji: "🤝", top: UIColor(red: 0.004, green: 0.549, blue: 0.816, alpha: 1), bottom: UIColor(red: 0.008, green: 0.686, blue: 0.937, alpha: 1))
        attachDemoPhoto(to: &entry3, emoji: "☀️", top: UIColor(red: 0.008, green: 0.686, blue: 0.937, alpha: 1), bottom: UIColor(red: 0.55, green: 0.85, blue: 0.98, alpha: 1))

        entries = [entry3, entry1, entry2]
        flowers = [
            GardenFlower(id: UUID(), entryId: entry3.id, title: entry3.title, bloomDate: entry3.date, color: "blue", isWilted: false, mood: 5),
            GardenFlower(id: UUID(), entryId: entry1.id, title: entry1.title, bloomDate: entry1.date, color: "blue", isWilted: false, mood: 5),
            GardenFlower(id: UUID(), entryId: entry2.id, title: entry2.title, bloomDate: entry2.date, color: "blue", isWilted: false, mood: 4)
        ]
        quotes = [
            GratitudeQuote(id: UUID(), text: "Gratitude turns what we have into enough.", author: "Melody Beattie", isFavorite: true),
            GratitudeQuote(id: UUID(), text: "Enjoy the little things, for one day you may look back and realize they were the big things.", author: "Robert Brault", isFavorite: false),
            GratitudeQuote(id: UUID(), text: "The roots of all goodness lie in the soil of appreciation.", author: "Dalai Lama", isFavorite: false)
        ]
        challenges = [
            GratitudeChallenge(
                id: UUID(),
                name: "30 Days of Gratitude",
                description: "Write 3 things you are grateful for every day",
                days: 30,
                currentDay: 2,
                startDate: Date().addingTimeInterval(-172800),
                isActive: true,
                entries: [],
                requiredEntriesPerDay: 3,
                completedDayKeys: []
            )
        ]
        refreshBadges()
        saveToUserDefaults()
    }

    private func attachDemoPhoto(
        to entry: inout GratitudeEntry,
        emoji: String,
        top: UIColor,
        bottom: UIColor
    ) {
        if let image = DemoImageFactory.makeGradientPhoto(topColor: top, bottomColor: bottom, emoji: emoji) {
            entry.imageName = ImageStorage.saveJPEG(image, entryId: entry.id)
        }
    }
}
