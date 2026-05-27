import SwiftUI

struct HomeView: View {
    @ObservedObject var viewModel: GratitudeSpaceViewModel

    @State private var showAddEntry = false
    @State private var showQuotes = false
    @State private var showSettings = false
    @State private var showPromptSheet = false
    @State private var showFullGarden = false
    @State private var selectedChallenge: GratitudeChallenge?
    @State private var selectedEntry: GratitudeEntry?
    @State private var selectedFlower: GardenFlower?
    @AppStorage("lastPromptDayKey") private var lastPromptDayKey = ""

    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottomTrailing) {
                VStack {
                    HStack(spacing: 10) {
                        Spacer()
                        topBarButton(icon: "gearshape.fill") { showSettings = true }
                        topBarButton(icon: "quote.bubble.fill") { showQuotes = true }
                    }
                    .padding(.trailing, GardenDesign.padding)
                    .padding(.top, 8)
                    Spacer()
                }
                .zIndex(1)

                ScrollView(showsIndicators: false) {
                    VStack(spacing: 18) {
                        HomeHeroWidget(
                            viewModel: viewModel,
                            greeting: greetingText,
                            onAdd: { showAddEntry = true }
                        )

                        HomePromptWidget(
                            prompt: viewModel.todayPrompt,
                            onWrite: { showAddEntry = true }
                        )

                        HomeTodayProgressWidget(
                            viewModel: viewModel,
                            onAdd: { showAddEntry = true }
                        )

                        HomePhotoGalleryWidget(viewModel: viewModel) { entry in
                            selectedEntry = entry
                        }

                        HomeStatsGridWidget(viewModel: viewModel)

                        HomeMoodOverviewWidget(viewModel: viewModel)

                        HomeGardenWidget(
                            viewModel: viewModel,
                            onSeeAll: { showFullGarden = true },
                            onSelectFlower: { selectedFlower = $0 },
                            onPlant: { showAddEntry = true }
                        )

                        HomeRecentEntriesWidget(viewModel: viewModel) { entry in
                            selectedEntry = entry
                        }

                        HomeChallengeWidget(viewModel: viewModel) {
                            if let challenge = viewModel.activeChallenge {
                                selectedChallenge = challenge
                            }
                        }

                        if let quote = viewModel.todayQuote {
                            HomeQuoteWidget(quote: quote)
                        }

                        HomeBadgesWidget(badges: viewModel.badges)
                    }
                    .padding(.horizontal, GardenDesign.padding)
                    .padding(.top, 8)
                    .padding(.bottom, 100)
                }
                GardenFloatingAddButton { showAddEntry = true }
                    .padding(24)
            }
            .gardenScreenBackground()
            .navigationBarHidden(true)
            .navigationDestination(isPresented: $showSettings) {
                SettingsView()
            }
            .navigationDestination(isPresented: $showFullGarden) {
                GardenView(viewModel: viewModel)
                    .navigationBarHidden(false)
            }
            .navigationDestination(item: $selectedEntry) { entry in
                EntryDetailView(viewModel: viewModel, entry: entry)
            }
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
            .sheet(isPresented: $showPromptSheet) {
                DailyPromptSheet(
                    prompt: viewModel.todayPrompt,
                    onStart: {
                        showPromptSheet = false
                        showAddEntry = true
                    },
                    onDismiss: { showPromptSheet = false }
                )
            }
            .sheet(isPresented: $showQuotes) {
                QuotesLibraryView(viewModel: viewModel)
            }
            .sheet(item: $selectedChallenge) { challenge in
                ChallengeDetailSheet(viewModel: viewModel, challenge: challenge)
            }
            .onAppear { presentDailyPromptIfNeeded() }
        }
    }

    private func topBarButton(icon: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.body.weight(.semibold))
                .foregroundColor(.gardenNew)
                .frame(width: 40, height: 40)
                .background {
                    Circle()
                        .fill(Color.white)
                        .overlay(Circle().stroke(Color.gardenNew.opacity(0.15), lineWidth: 1))
                }
        }
    }

    private var greetingText: String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 5..<12: return "Good morning — your garden awaits"
        case 12..<17: return "Good afternoon — grow your gratitude"
        case 17..<22: return "Good evening — cherish today's light"
        default: return "Welcome home to your peaceful garden"
        }
    }

    private func presentDailyPromptIfNeeded() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let todayKey = formatter.string(from: Date())
        guard lastPromptDayKey != todayKey else { return }
        lastPromptDayKey = todayKey
        showPromptSheet = true
    }
}
