import SwiftUI

struct BadgeGridCell: View {
    let badge: GardenBadge

    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                Circle()
                    .fill(
                        badge.isUnlocked
                        ? LinearGradient(colors: [.gardenNew.opacity(0.25), .gardenBloom.opacity(0.15)], startPoint: .top, endPoint: .bottom)
                        : LinearGradient(colors: [Color.gray.opacity(0.12), Color.gray.opacity(0.06)], startPoint: .top, endPoint: .bottom)
                    )
                    .frame(width: 56, height: 56)

                Image(systemName: badge.icon)
                    .font(.title3)
                    .foregroundColor(badge.isUnlocked ? .gardenNew : .gray.opacity(0.45))

                if badge.isUnlocked {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.caption)
                        .foregroundColor(.gardenNew)
                        .background(Circle().fill(Color.white).padding(1))
                        .offset(x: 22, y: -22)
                }
            }

            Text(badge.title)
                .font(.caption2.weight(.semibold))
                .foregroundColor(badge.isUnlocked ? .gardenBloom : .gray)
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .frame(width: 76)
        }
        .opacity(badge.isUnlocked ? 1 : 0.65)
    }
}

struct BadgesRowView: View {
    let badges: [GardenBadge]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            GardenSectionHeader(
                title: "Achievements",
                subtitle: "\(badges.filter(\.isUnlocked).count) of \(badges.count) unlocked"
            )

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(badges) { badge in
                        BadgeGridCell(badge: badge)
                            .gardenTile(
                                radius: GardenDesign.radiusS,
                                accent: badge.isUnlocked ? .gardenNew : .gray
                            )
                            .frame(width: 88)
                    }
                }
            }
        }
        .gardenCard()
    }
}
