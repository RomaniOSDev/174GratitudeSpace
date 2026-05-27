import SwiftUI

struct QuoteListCell: View {
    let quote: GratitudeQuote

    var body: some View {
        HStack(alignment: .top, spacing: 14) {
            Image(systemName: "quote.opening")
                .font(.title3)
                .foregroundColor(.gardenNew)
                .frame(width: 32)

            VStack(alignment: .leading, spacing: 8) {
                Text(quote.text)
                    .font(.subheadline)
                    .foregroundColor(.gardenBloom)
                    .italic()
                    .fixedSize(horizontal: false, vertical: true)

                HStack {
                    Text(quote.author)
                        .font(.caption.weight(.medium))
                        .foregroundColor(.gray)
                    Spacer()
                    if quote.isFavorite {
                        Image(systemName: "star.fill")
                            .font(.caption)
                            .foregroundColor(.gardenNew)
                    }
                }
            }
        }
        .gardenCard()
    }
}
