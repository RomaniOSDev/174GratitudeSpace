import SwiftUI

struct HomeGardenWidget: View {
    @ObservedObject var viewModel: GratitudeSpaceViewModel
    var onSeeAll: () -> Void
    var onSelectFlower: (GardenFlower) -> Void
    var onPlant: () -> Void

    private var flowers: [GardenFlower] {
        viewModel.flowers.filter { !$0.isWilted }.prefix(6).map { $0 }
    }

    var body: some View {
        HomeWidgetContainer(
            title: "Your garden",
            subtitle: "\(viewModel.bloomingFlowers) flowers blooming",
            actionTitle: "See all",
            action: onSeeAll
        ) {
            if flowers.isEmpty {
                Button(action: onPlant) {
                    VStack(spacing: 12) {
                        Image(systemName: "leaf.circle")
                            .font(.system(size: 48))
                            .foregroundColor(.gardenNew.opacity(0.5))
                        Text("Plant your first flower")
                            .font(.subheadline.weight(.medium))
                            .foregroundColor(.gardenNew)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 24)
                }
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(flowers) { flower in
                            Button {
                                onSelectFlower(flower)
                            } label: {
                                gardenFlowerCard(flower)
                            }
                            .buttonStyle(.plain)
                        }
                        Button(action: onPlant) {
                            VStack(spacing: 8) {
                                Image(systemName: "plus.circle.fill")
                                    .font(.largeTitle)
                                    .foregroundColor(.gardenNew)
                                Text("Plant")
                                    .font(.caption.weight(.medium))
                                    .foregroundColor(.gardenNew)
                            }
                            .frame(width: 88, height: 120)
                            .background(
                                RoundedRectangle(cornerRadius: 16, style: .continuous)
                                    .strokeBorder(style: StrokeStyle(lineWidth: 2, dash: [6]))
                                    .foregroundColor(Color.gardenNew.opacity(0.4))
                            )
                        }
                    }
                }
            }
        }
    }

    private func gardenFlowerCard(_ flower: GardenFlower) -> some View {
        VStack(spacing: 8) {
            ZStack {
                if let entry = viewModel.entry(for: flower),
                   let image = viewModel.entryImage(entry) {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 72, height: 72)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(flower.moodLevel.flowerColor, lineWidth: 3))
                } else {
                    Circle()
                        .fill(flower.moodLevel.flowerColor.opacity(0.15))
                        .frame(width: 72, height: 72)
                    Image(systemName: "leaf.circle.fill")
                        .font(.title)
                        .foregroundColor(flower.moodLevel.flowerColor)
                }
                Text(flower.moodLevel.emoji)
                    .font(.caption2)
                    .padding(4)
                    .background(Circle().fill(.white))
                    .offset(x: 26, y: -26)
            }
            Text(flower.title)
                .font(.caption2.weight(.semibold))
                .foregroundColor(.gardenBloom)
                .lineLimit(1)
                .frame(width: 88)
        }
        .gardenTile(accent: flower.moodLevel.flowerColor)
        .frame(width: 96)
    }
}

struct HomeRecentEntriesWidget: View {
    @ObservedObject var viewModel: GratitudeSpaceViewModel
    var onSelect: (GratitudeEntry) -> Void

    var body: some View {
        HomeWidgetContainer(title: "Recent moments", subtitle: "Latest gratitude entries") {
            if viewModel.recentEntries.isEmpty {
                Text("No entries yet — start with today's prompt")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.vertical, 12)
            } else {
                VStack(spacing: 10) {
                    ForEach(viewModel.recentEntries.prefix(4)) { entry in
                        Button {
                            onSelect(entry)
                        } label: {
                            recentRow(entry)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
        }
    }

    private func recentRow(_ entry: GratitudeEntry) -> some View {
        HStack(spacing: 12) {
            Group {
                if let image = viewModel.entryImage(entry) {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                } else {
                    ZStack {
                        Color.gardenNew.opacity(0.12)
                        Text(entry.category.emoji)
                            .font(.title2)
                    }
                }
            }
            .frame(width: 64, height: 64)
            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))

            VStack(alignment: .leading, spacing: 4) {
                Text(entry.title)
                    .font(.subheadline.weight(.semibold))
                    .foregroundColor(.gardenBloom)
                    .lineLimit(1)
                Text(entry.preview)
                    .font(.caption)
                    .foregroundColor(.gray)
                    .lineLimit(2)
                HStack {
                    Text(entry.moodLevel.emoji)
                    Text(entry.formattedDate)
                        .font(.caption2)
                        .foregroundColor(.gray)
                }
            }
            Spacer()
            Image(systemName: "chevron.right")
                .font(.caption.weight(.bold))
                .foregroundColor(.gardenNew.opacity(0.5))
        }
        .padding(10)
        .gardenInsetPanel(radius: 14)
    }
}

struct HomeMoodOverviewWidget: View {
    @ObservedObject var viewModel: GratitudeSpaceViewModel

    private var averageMood: Int {
        guard !viewModel.recentEntries.isEmpty else { return 3 }
        let sum = viewModel.recentEntries.prefix(5).reduce(0) { $0 + $1.mood }
        return sum / min(5, viewModel.recentEntries.count)
    }

    var body: some View {
        HomeWidgetContainer(title: "Mood snapshot", subtitle: "From recent entries") {
            HStack(spacing: 16) {
                Text(GratitudeMood.from(raw: averageMood).emoji)
                    .font(.system(size: 52))
                VStack(alignment: .leading, spacing: 6) {
                    Text(GratitudeMood.from(raw: averageMood).label)
                        .font(.title3.weight(.semibold))
                        .foregroundColor(.gardenBloom)
                    Text("Average mood across last entries")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                Spacer()
            }
        }
    }
}
