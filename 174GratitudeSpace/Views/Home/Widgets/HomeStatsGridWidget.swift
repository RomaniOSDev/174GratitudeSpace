import SwiftUI

struct HomeStatsGridWidget: View {
    @ObservedObject var viewModel: GratitudeSpaceViewModel

    var body: some View {
        HomeWidgetContainer(title: "At a glance", subtitle: "Your gratitude pulse") {
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                HomeMiniStatTile(icon: "leaf.fill", value: "\(viewModel.totalFlowers)", label: "Flowers", color: .gardenNew)
                HomeMiniStatTile(icon: "flame.fill", value: "\(viewModel.currentStreak)", label: "Day streak", color: .gardenNew)
                HomeMiniStatTile(icon: "calendar", value: "\(viewModel.monthlyCount)", label: "This month", color: .gardenBloom)
                HomeMiniStatTile(icon: "trophy.fill", value: "\(viewModel.unlockedBadgesCount)", label: "Badges", color: .gardenBloom)
            }
        }
    }
}

struct HomeTodayProgressWidget: View {
    @ObservedObject var viewModel: GratitudeSpaceViewModel
    let onAdd: () -> Void

    private var progress: Double {
        let p = viewModel.todayProgress
        return min(1, Double(p.current) / Double(p.goal))
    }

    var body: some View {
        HomeWidgetContainer(title: "Today's progress", subtitle: "Keep your garden growing") {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .stroke(Color.gardenNew.opacity(0.15), lineWidth: 10)
                    Circle()
                        .trim(from: 0, to: progress)
                        .stroke(GardenDesign.gradientNew, style: StrokeStyle(lineWidth: 10, lineCap: .round))
                        .rotationEffect(.degrees(-90))
                    VStack(spacing: 2) {
                        Text("\(viewModel.todayProgress.current)")
                            .font(.title2.weight(.bold))
                            .foregroundColor(.gardenBloom)
                        Text("of \(viewModel.todayProgress.goal)")
                            .font(.caption2)
                            .foregroundColor(.gray)
                    }
                }
                .frame(width: 88, height: 88)

                VStack(alignment: .leading, spacing: 10) {
                    Text(viewModel.todayProgress.current >= viewModel.todayProgress.goal
                         ? "Daily goal reached!"
                         : "Plant \(viewModel.todayProgress.goal - viewModel.todayProgress.current) more today")
                        .font(.subheadline.weight(.medium))
                        .foregroundColor(.gardenBloom)

                    Button(action: onAdd) {
                        Label("Add entry", systemImage: "plus.circle.fill")
                            .font(.subheadline.weight(.semibold))
                    }
                    .foregroundColor(.gardenNew)
                }
                Spacer()
            }
        }
    }
}
