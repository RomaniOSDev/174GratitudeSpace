import Foundation

enum DateFormatting {
    private static let englishLocale = Locale(identifier: "en_US")

    static func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMMM yyyy"
        formatter.locale = englishLocale
        return formatter.string(from: date)
    }

    static func formattedShortDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        formatter.locale = englishLocale
        return formatter.string(from: date)
    }

    static func monthYearString(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        formatter.locale = englishLocale
        return formatter.string(from: date)
    }
}
