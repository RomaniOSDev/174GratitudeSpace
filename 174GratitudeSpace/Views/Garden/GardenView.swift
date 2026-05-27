import SwiftUI

struct GardenView: View {
    @ObservedObject var viewModel: GratitudeSpaceViewModel

    @State private var selectedFlower: GardenFlower?
    @State private var showAddEntry = false
    @State private var showQuotes = false
    private var activeFlowers: [GardenFlower] {
        viewModel.flowers.filter { !$0.isWilted }
    }

    private var season: GardenSeason { .current }

    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottomTrailing) {
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 22) {
                        GardenHeroHeader(
                            title: "My Garden",
                            subtitle: greetingText,
                            trailingIcon: season.decorSymbol,
                            trailingLabel: season.title
                        )

                        quickActionsRow

                        BadgesRowView(badges: viewModel.badges)
                            .padding(.horizontal, GardenDesign.padding)

                        statsSection

                        gardenSection

                        if let quote = viewModel.todayQuote {
                            QuoteHighlightCell(text: quote.text, author: quote.author)
                                .padding(.horizontal, GardenDesign.padding)
                        }
                    }
                    .padding(.bottom, 100)
                }

                GardenFloatingAddButton { openAddEntry() }
                    .padding(24)
            }
            .gardenSeasonBackground(flowerCount: viewModel.bloomingFlowers)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar(.hidden, for: .navigationBar)
            .navigationDestination(item: $selectedFlower) { flower in
                if let entry = viewModel.entry(for: flower) {
                    EntryDetailView(viewModel: viewModel, entry: entry)
                }
            }
            .sheet(isPresented: $showAddEntry) {
                AddEntryView(
                    viewModel: viewModel,
                    dailyPrompt: viewModel.todayPrompt,
                    initialTemplate: .blank
                )
            }
            .sheet(isPresented: $showQuotes) {
                QuotesLibraryView(viewModel: viewModel)
            }
        }
    }

    private var quickActionsRow: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                quickActionButton(icon: "plus.circle.fill", title: "New entry") { openAddEntry() }
                quickActionButton(icon: "quote.bubble.fill", title: "Quotes") { showQuotes = true }
                quickActionButton(icon: "flame.fill", title: "Streak \(viewModel.currentStreak)") { }
            }
            .padding(.horizontal, GardenDesign.padding)
        }
    }

    private func quickActionButton(icon: String, title: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(spacing: 8) {
                Image(systemName: icon)
                Text(title)
                    .font(.subheadline.weight(.medium))
            }
            .foregroundColor(.gardenBloom)
            .padding(.horizontal, 14)
            .padding(.vertical, 10)
            .background {
                Capsule()
                    .fill(Color.white)
                    .overlay(Capsule().stroke(Color.gardenNew.opacity(0.18), lineWidth: 1))
            }
        }
        .buttonStyle(.plain)
    }

    private var statsSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            GardenSectionHeader(title: "Overview", subtitle: "Your garden at a glance")
                .padding(.horizontal, GardenDesign.padding)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    GardenStatCell(title: "Flowers", value: "\(viewModel.totalFlowers)", icon: "leaf.fill", color: .gardenNew)
                    GardenStatCell(title: "Blooming", value: "\(viewModel.bloomingFlowers)", icon: "sparkles", color: .gardenBloom)
                    GardenStatCell(title: "Streak", value: "\(viewModel.currentStreak)", icon: "flame.fill", color: .gardenNew)
                    GardenStatCell(title: "This month", value: "\(viewModel.monthlyCount)", icon: "calendar", color: .gardenBloom)
                }
                .padding(.horizontal, GardenDesign.padding)
            }
        }
    }

    private var gardenSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            GardenSectionHeader(
                title: "Your flowers",
                subtitle: "\(activeFlowers.count) blooming · tap to open"
            )
            .padding(.horizontal, GardenDesign.padding)

            LazyVGrid(
                columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())],
                spacing: 12
            ) {
                ForEach(activeFlowers) { flower in
                    FlowerGridCell(flower: flower)
                        .onTapGesture { selectedFlower = flower }
                }
                ForEach(0..<max(0, 12 - activeFlowers.count), id: \.self) { _ in
                    EmptyFlowerGridCell()
                        .onTapGesture { openAddEntry() }
                }
            }
            .padding(.horizontal, GardenDesign.padding)
        }
    }

    private var greetingText: String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 5..<12: return "Good morning — plant a new moment of joy"
        case 12..<17: return "Good afternoon — your garden is growing"
        case 17..<22: return "Good evening — reflect on today's blessings"
        default: return "Welcome back to your peaceful space"
        }
    }

    private func openAddEntry() { showAddEntry = true }
}
