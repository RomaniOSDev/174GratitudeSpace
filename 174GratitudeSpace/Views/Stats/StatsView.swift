import SwiftUI
import Charts

struct StatsView: View {
    @ObservedObject var viewModel: GratitudeSpaceViewModel

    private var maxCategoryCount: Int {
        viewModel.topCategories.map(\.1).max() ?? 1
    }

    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 20) {
                    overviewGrid
                    monthComparisonSection
                    chartCard(title: "Daily activity", subtitle: "Last 7 days") { activityChart }
                    chartCard(title: "Categories", subtitle: "Distribution") { categoryPieChart }
                    chartCard(title: "Word cloud", subtitle: "Most used words") { WordCloudView(items: viewModel.wordCloudItems) }
                    topCategoriesSection
                }
                .padding(.vertical, 12)
                .padding(.bottom, 24)
            }
            .gardenScreenBackground()
            .navigationTitle("Statistics")
            .navigationBarTitleDisplayMode(.large)
        }
    }

    private var overviewGrid: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
            GardenStatCell(title: "Flowers", value: "\(viewModel.totalFlowers)", icon: "leaf.fill", color: .gardenNew, compact: false)
            GardenStatCell(title: "Streak", value: "\(viewModel.currentStreak)", icon: "flame.fill", color: .gardenNew, compact: false)
            GardenStatCell(title: "Avg. words", value: "\(viewModel.averageWords)", icon: "text.word.spacing", color: .gardenBloom, compact: false)
            GardenStatCell(title: "Activity", value: String(format: "%.1f/wk", viewModel.averageEntriesPerWeek), icon: "chart.line.uptrend.xyaxis", color: .gardenNew, compact: false)
        }
        .padding(.horizontal, GardenDesign.padding)
    }

    @ViewBuilder
    private var monthComparisonSection: some View {
        if let comparison = viewModel.monthComparison {
            VStack(alignment: .leading, spacing: 14) {
                GardenSectionHeader(title: "Month comparison", subtitle: "Current vs previous")

                HStack(spacing: 12) {
                    monthCompareCell(
                        label: comparison.current.label,
                        count: comparison.current.entryCount,
                        isPrimary: true
                    )
                    Image(systemName: "arrow.left.arrow.right.circle.fill")
                        .font(.title2)
                        .foregroundColor(.gardenNew)
                    monthCompareCell(
                        label: comparison.previous.label,
                        count: comparison.previous.entryCount,
                        isPrimary: false
                    )
                }

                let delta = comparison.current.entryCount - comparison.previous.entryCount
                HStack {
                    Image(systemName: delta >= 0 ? "arrow.up.right" : "arrow.down.right")
                    Text(delta >= 0 ? "+\(delta) entries vs last month" : "\(delta) entries vs last month")
                }
                .font(.caption.weight(.medium))
                .foregroundColor(delta >= 0 ? .gardenNew : .gray)
            }
            .gardenCard()
            .padding(.horizontal, GardenDesign.padding)
        }
    }

    private func monthCompareCell(label: String, count: Int, isPrimary: Bool) -> some View {
        VStack(spacing: 6) {
            Text(label)
                .font(.caption)
                .foregroundColor(.gray)
                .lineLimit(1)
                .minimumScaleFactor(0.8)
            Text("\(count)")
                .font(.system(size: 32, weight: .bold, design: .rounded))
                .foregroundColor(isPrimary ? .gardenNew : .gardenBloom)
            Text("entries")
                .font(.caption2)
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background {
            RoundedRectangle(cornerRadius: GardenDesign.radiusS, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: isPrimary
                        ? [Color.gardenNew.opacity(0.18), Color.gardenNew.opacity(0.06)]
                        : [Color.gardenBloom.opacity(0.12), Color.gardenBloom.opacity(0.03)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
        }
    }

    private func chartCard<Content: View>(title: String, subtitle: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 14) {
            GardenSectionHeader(title: title, subtitle: subtitle)
            content()
        }
        .gardenCard()
        .padding(.horizontal, GardenDesign.padding)
    }

    private var activityChart: some View {
        Chart(viewModel.weeklyActivity) { data in
            BarMark(
                x: .value("Day", data.day),
                y: .value("Entries", data.count)
            )
            .foregroundStyle(GardenDesign.gradientNew)
            .cornerRadius(6)
        }
        .frame(height: 160)
    }

    private var categoryPieChart: some View {
        Group {
            if viewModel.categoryChartData.isEmpty {
                Text("No data yet")
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity, minHeight: 120)
            } else {
                Chart(viewModel.categoryChartData) { slice in
                    SectorMark(
                        angle: .value("Count", slice.count),
                        innerRadius: .ratio(0.58),
                        angularInset: 2
                    )
                    .foregroundStyle(by: .value("Category", slice.category.displayName))
                    .cornerRadius(4)
                }
                .frame(height: 200)
            }
        }
    }

    private var topCategoriesSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            GardenSectionHeader(title: "Top categories", subtitle: "Ranked by entries")

            if viewModel.topCategories.isEmpty {
                Text("No entries yet")
                    .foregroundColor(.gray)
            } else {
                ForEach(viewModel.topCategories, id: \.0) { category, count in
                    CategoryStatRow(
                        emoji: category.emoji,
                        name: category.displayName,
                        count: count,
                        maxCount: maxCategoryCount
                    )
                }
            }
        }
        .gardenCard()
        .padding(.horizontal, GardenDesign.padding)
    }
}
