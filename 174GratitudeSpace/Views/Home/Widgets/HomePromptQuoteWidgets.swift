import SwiftUI

struct HomePromptWidget: View {
    let prompt: String
    let onWrite: () -> Void

    var body: some View {
        Button(action: onWrite) {
            HStack(spacing: 0) {
                ZStack {
                    GardenDesign.gradientNew
                    Image(systemName: "lightbulb.fill")
                        .font(.system(size: 36))
                        .foregroundColor(.white.opacity(0.9))
                }
                .frame(width: 100)

                VStack(alignment: .leading, spacing: 8) {
                    Text("Prompt of the day")
                        .font(.caption.weight(.bold))
                        .foregroundColor(.gardenNew)
                    Text(prompt)
                        .font(.subheadline)
                        .foregroundColor(.gardenBloom)
                        .multilineTextAlignment(.leading)
                        .lineLimit(3)
                    Text("Tap to write →")
                        .font(.caption.weight(.semibold))
                        .foregroundColor(.gardenNew)
                }
                .padding(14)
                Spacer(minLength: 0)
            }
            .clipShape(RoundedRectangle(cornerRadius: GardenDesign.radiusM, style: .continuous))
            .background {
                GardenSurface.cardBackground(radius: GardenDesign.radiusM, elevation: .lifted)
            }
        }
        .buttonStyle(.plain)
    }
}

struct HomeQuoteWidget: View {
    let quote: GratitudeQuote

    var body: some View {
        HomeWidgetContainer(title: "Inspiration", subtitle: "Quote of the day") {
            HStack(alignment: .top, spacing: 12) {
                GardenIconCircle(systemName: "quote.opening", color: .gardenNew, size: 40)
                VStack(alignment: .leading, spacing: 8) {
                    Text(quote.text)
                        .font(.body)
                        .italic()
                        .foregroundColor(.gardenBloom)
                    Text("— \(quote.author)")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
        }
    }
}

struct HomeChallengeWidget: View {
    @ObservedObject var viewModel: GratitudeSpaceViewModel
    var onOpen: () -> Void

    var body: some View {
        if let challenge = viewModel.activeChallenge {
            Button(action: onOpen) {
                HomeWidgetContainer(title: "Active challenge", subtitle: challenge.name) {
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            GardenIconCircle(systemName: "trophy.fill", color: .gardenNew, size: 44)
                            VStack(alignment: .leading) {
                                Text("Day \(challenge.currentDay) of \(challenge.days)")
                                    .font(.headline)
                                    .foregroundColor(.gardenBloom)
                                Text("\(challenge.requiredEntriesPerDay) entries per day")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                            Spacer()
                            if viewModel.isTodayComplete(for: challenge) {
                                Image(systemName: "checkmark.seal.fill")
                                    .font(.title2)
                                    .foregroundColor(.gardenNew)
                            }
                        }

                        ProgressView(
                            value: Double(challenge.currentDay),
                            total: Double(challenge.days)
                        )
                        .tint(.gardenNew)
                    }
                }
            }
            .buttonStyle(.plain)
        }
    }
}

struct HomeBadgesWidget: View {
    let badges: [GardenBadge]

    var body: some View {
        HomeWidgetContainer(
            title: "Achievements",
            subtitle: "\(badges.filter(\.isUnlocked).count) unlocked"
        ) {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(badges) { badge in
                        BadgeGridCell(badge: badge)
                            .gardenTile(radius: GardenDesign.radiusS, accent: badge.isUnlocked ? .gardenNew : .gray)
                            .frame(width: 88)
                    }
                }
            }
        }
    }
}
