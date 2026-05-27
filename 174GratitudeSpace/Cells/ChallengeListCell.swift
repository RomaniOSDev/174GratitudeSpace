import SwiftUI

struct ChallengeListCell: View {
    let challenge: GratitudeChallenge
    var isTodayComplete: Bool = false
    var progress: Double {
        guard challenge.days > 0 else { return 0 }
        return Double(challenge.currentDay) / Double(challenge.days)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(alignment: .top) {
                GardenIconCircle(systemName: "trophy.fill", color: .gardenNew, size: 48)

                VStack(alignment: .leading, spacing: 4) {
                    Text(challenge.name)
                        .font(.headline)
                        .foregroundColor(.gardenBloom)

                    Text(challenge.description)
                        .font(.caption)
                        .foregroundColor(.gray)
                        .lineLimit(2)
                }

                Spacer()

                statusBadge
            }

            HStack {
                Label("Day \(challenge.currentDay)/\(challenge.days)", systemImage: "calendar")
                Spacer()
                Label("\(challenge.entries.count) linked", systemImage: "link")
            }
            .font(.caption)
            .foregroundColor(.gardenBloom.opacity(0.85))

            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(Color.gardenNew.opacity(0.12))
                        .frame(height: 8)
                    Capsule()
                        .fill(GardenDesign.gradientNew)
                        .frame(width: geo.size.width * progress, height: 8)
                }
            }
            .frame(height: 8)

            HStack {
                Label("\(challenge.requiredEntriesPerDay)/day goal", systemImage: "target")
                    .font(.caption2)
                    .foregroundColor(.gray)
                Spacer()
                if isTodayComplete {
                    Label("Done today", systemImage: "checkmark.seal.fill")
                        .font(.caption.weight(.semibold))
                        .foregroundColor(.gardenNew)
                }
            }
        }
        .gardenCard()
    }

    @ViewBuilder
    private var statusBadge: some View {
        if challenge.isActive {
            Text("Active")
                .font(.caption2.weight(.bold))
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                .foregroundColor(.gardenNew)
                .background(Capsule().fill(Color.gardenNew.opacity(0.15)))
        } else {
            Text("Paused")
                .font(.caption2.weight(.bold))
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                .foregroundColor(.gray)
                .background(Capsule().fill(Color.gray.opacity(0.12)))
        }
    }
}

typealias ChallengeCard = ChallengeListCell
