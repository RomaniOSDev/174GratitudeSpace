import SwiftUI

struct QuotesLibraryView: View {
    @ObservedObject var viewModel: GratitudeSpaceViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var showAddQuote = false

    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 14) {
                    if viewModel.quotes.isEmpty {
                        VStack(spacing: 14) {
                            GardenIconCircle(systemName: "quote.bubble", color: .gardenBloom, size: 56)
                            Text("Your quote library is empty")
                                .foregroundColor(.gardenBloom)
                            Text("Save words that inspire your practice.")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 40)
                        .gardenCard()
                    } else {
                        ForEach(viewModel.quotes) { quote in
                            QuoteListCell(quote: quote)
                                .contextMenu {
                                    Button {
                                        viewModel.toggleQuoteFavorite(quote)
                                    } label: {
                                        Label(
                                            quote.isFavorite ? "Remove favorite" : "Favorite",
                                            systemImage: quote.isFavorite ? "star.slash" : "star"
                                        )
                                    }
                                    Button(role: .destructive) {
                                        viewModel.deleteQuote(quote)
                                    } label: {
                                        Label("Delete", systemImage: "trash")
                                    }
                                }
                        }
                    }
                }
                .padding(GardenDesign.padding)
            }
            .gardenScreenBackground()
            .navigationTitle("Quote library")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Done") { dismiss() }
                        .foregroundColor(.gardenNew)
                }
                ToolbarItem(placement: .primaryAction) {
                    Button { showAddQuote = true } label: {
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(.gardenNew)
                    }
                }
            }
            .sheet(isPresented: $showAddQuote) {
                AddQuoteView(viewModel: viewModel)
            }
        }
        .presentationCornerRadius(GardenDesign.radiusL)
    }
}

struct AddQuoteView: View {
    @ObservedObject var viewModel: GratitudeSpaceViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var text = ""
    @State private var author = ""

    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Quote")
                        .font(.caption.weight(.semibold))
                        .foregroundColor(.gray)
                    TextEditor(text: $text)
                        .frame(height: 120)
                        .padding(8)
                        .background(RoundedRectangle(cornerRadius: 12).fill(Color.white))
                        .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.gardenNew.opacity(0.2)))
                }

                VStack(alignment: .leading, spacing: 8) {
                    Text("Author")
                        .font(.caption.weight(.semibold))
                        .foregroundColor(.gray)
                    TextField("Author name", text: $author)
                        .padding(12)
                        .background(RoundedRectangle(cornerRadius: 12).fill(Color.white))
                        .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.gardenNew.opacity(0.2)))
                }

                GardenPrimaryButton(title: "Save quote", icon: "checkmark", action: save)
                    .disabled(text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                    .opacity(text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? 0.5 : 1)

                Spacer()
            }
            .padding(GardenDesign.padding)
            .gardenScreenBackground()
            .navigationTitle("New quote")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                        .foregroundColor(.gardenNew)
                }
            }
        }
    }

    private func save() {
        viewModel.addQuote(
            GratitudeQuote(
                id: UUID(),
                text: text.trimmingCharacters(in: .whitespacesAndNewlines),
                author: author.trimmingCharacters(in: .whitespacesAndNewlines),
                isFavorite: false
            )
        )
        dismiss()
    }
}
