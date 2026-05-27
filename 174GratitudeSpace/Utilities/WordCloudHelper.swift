import Foundation

struct WordCloudItem: Identifiable {
    let id = UUID()
    let word: String
    let count: Int
}

enum WordCloudHelper {
    private static let stopWords: Set<String> = [
        "the", "a", "an", "and", "or", "but", "in", "on", "at", "to", "for",
        "of", "with", "by", "from", "is", "was", "are", "were", "be", "been",
        "it", "this", "that", "i", "my", "me", "we", "our", "you", "your",
        "today", "very", "so", "as", "am", "have", "had", "not"
    ]

    static func topWords(from entries: [GratitudeEntry], limit: Int = 24) -> [WordCloudItem] {
        var counts: [String: Int] = [:]

        for entry in entries {
            let text = "\(entry.title) \(entry.description)".lowercased()
            let words = text
                .components(separatedBy: CharacterSet.alphanumerics.inverted)
                .filter { $0.count > 2 && !stopWords.contains($0) }

            for word in words {
                counts[word, default: 0] += 1
            }
        }

        return counts
            .map { WordCloudItem(word: $0.key, count: $0.value) }
            .sorted { $0.count > $1.count }
            .prefix(limit)
            .map { $0 }
    }
}
