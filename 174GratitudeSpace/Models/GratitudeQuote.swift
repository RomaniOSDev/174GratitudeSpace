import Foundation

struct GratitudeQuote: Identifiable, Codable, Equatable {
    let id: UUID
    var text: String
    var author: String
    var isFavorite: Bool
}
