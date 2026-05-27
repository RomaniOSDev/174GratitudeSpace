import SwiftUI

struct ChallengesView: View {
    @ObservedObject var viewModel: GratitudeSpaceViewModel

    @State private var showAddChallengeSheet = false
    @State private var selectedChallenge: GratitudeChallenge?

    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 16) {
                    if viewModel.challenges.isEmpty {
                        emptyState
                    } else {
                        ForEach(viewModel.challenges) { challenge in
                            ChallengeListCell(
                                challenge: challenge,
                                isTodayComplete: viewModel.isTodayComplete(for: challenge)
                            )
                            .onTapGesture { selectedChallenge = challenge }
                            .contextMenu {
                                if !challenge.isActive {
                                    Button("Start challenge") {
                                        viewModel.startChallenge(challenge)
                                    }
                                }
                                Button("Delete", role: .destructive) {
                                    viewModel.deleteChallenge(challenge)
                                }
                            }
                        }
                    }

                    GardenPrimaryButton(title: "New challenge", icon: "plus") {
                        showAddChallengeSheet = true
                    }
                }
                .padding(GardenDesign.padding)
                .padding(.bottom, 24)
            }
            .gardenScreenBackground()
            .navigationTitle("Challenges")
            .navigationBarTitleDisplayMode(.large)
            .sheet(isPresented: $showAddChallengeSheet) {
                AddChallengeView(viewModel: viewModel)
            }
            .sheet(item: $selectedChallenge) { challenge in
                ChallengeDetailSheet(viewModel: viewModel, challenge: challenge)
            }
        }
    }

    private var emptyState: some View {
        VStack(spacing: 16) {
            GardenIconCircle(systemName: "trophy", color: .gardenBloom, size: 64)
            Text("No challenges yet")
                .font(.headline)
                .foregroundColor(.gardenBloom)
            Text("Start a daily habit and link your gratitude entries.")
                .font(.subheadline)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 40)
        .gardenCard()
    }
}

struct ChallengeDetailSheet: View {
    @ObservedObject var viewModel: GratitudeSpaceViewModel
    let challenge: GratitudeChallenge
    @Environment(\.dismiss) private var dismiss

    private var liveChallenge: GratitudeChallenge {
        viewModel.challenges.first { $0.id == challenge.id } ?? challenge
    }

    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 16) {
                    ChallengeListCell(
                        challenge: liveChallenge,
                        isTodayComplete: viewModel.isTodayComplete(for: liveChallenge)
                    )

                    Toggle(isOn: Binding(
                        get: { viewModel.isTodayComplete(for: liveChallenge) },
                        set: { _ in viewModel.toggleTodayComplete(for: liveChallenge) }
                    )) {
                        Text("Mark today as completed")
                            .font(.subheadline.weight(.medium))
                            .foregroundColor(.gardenBloom)
                    }
                    .tint(.gardenNew)
                    .gardenCard(padding: 14)

                    GardenSectionHeader(
                        title: "Linked entries",
                        subtitle: "\(viewModel.entriesLinked(to: liveChallenge).count) total"
                    )

                    if viewModel.entriesLinked(to: liveChallenge).isEmpty {
                        Text("Entries you add while this challenge is active appear here.")
                            .font(.caption)
                            .foregroundColor(.gray)
                            .gardenCard(padding: 14)
                    } else {
                        ForEach(viewModel.entriesLinked(to: liveChallenge)) { entry in
                            EntryListCell(entry: entry, showChevron: false)
                        }
                    }
                }
                .padding(GardenDesign.padding)
            }
            .gardenScreenBackground()
            .navigationTitle(liveChallenge.name)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { dismiss() }
                        .foregroundColor(.gardenNew)
                }
            }
        }
        .presentationCornerRadius(GardenDesign.radiusL)
    }
}
