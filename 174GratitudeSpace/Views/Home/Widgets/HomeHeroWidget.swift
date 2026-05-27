import SwiftUI

struct HomeHeroWidget: View {
    @ObservedObject var viewModel: GratitudeSpaceViewModel
    let greeting: String
    let onAdd: () -> Void

    private var season: GardenSeason { .current }

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            heroBackground
                .frame(height: 220)

            LinearGradient(
                colors: [Color.clear, Color.gardenBloom.opacity(0.82)],
                startPoint: .top,
                endPoint: .bottom
            )

            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Label(season.title, systemImage: season.decorSymbol)
                        .font(.caption.weight(.semibold))
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(Capsule().fill(Color.white.opacity(0.22)))
                        .foregroundColor(.white)
                    Spacer()
                    Button(action: onAdd) {
                        Image(systemName: "plus")
                            .font(.body.weight(.bold))
                            .foregroundColor(.gardenNew)
                            .frame(width: 36, height: 36)
                            .background(Circle().fill(Color.white))
                    }
                }

                Text("Home")
                    .font(.caption.weight(.medium))
                    .foregroundColor(.white.opacity(0.9))

                Text(greeting)
                    .font(.title2.weight(.bold))
                    .foregroundColor(.white)
                    .fixedSize(horizontal: false, vertical: true)

                HStack(spacing: 16) {
                    heroStat("\(viewModel.bloomingFlowers)", label: "Blooming")
                    heroStat("\(viewModel.currentStreak)", label: "Streak")
                    heroStat("\(viewModel.todayEntries.count)", label: "Today")
                }
            }
            .padding(18)
        }
        .clipShape(RoundedRectangle(cornerRadius: GardenDesign.radiusL, style: .continuous))
        .background {
            GardenSurface.cardBackground(radius: GardenDesign.radiusL, elevation: .lifted)
        }
    }

    private var heroBackground: some View {
        let photos = Array(viewModel.photoGalleryEntries.prefix(3))
        return Group {
            if photos.isEmpty {
                DecorativeGardenBanner()
            } else {
                HStack(spacing: -24) {
                    ForEach(photos) { entry in
                        photoBlock(entry: entry)
                            .frame(width: 130, height: 200)
                    }
                }
                .frame(maxWidth: .infinity)
            }
        }
    }

    private func photoBlock(entry: GratitudeEntry) -> some View {
        Group {
            if let image = viewModel.entryImage(entry) {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
            } else {
                DecorativeGardenBanner()
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(Color.white.opacity(0.35), lineWidth: 2)
        )
    }

    private func heroStat(_ value: String, label: String) -> some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(value)
                .font(.headline.weight(.bold))
                .foregroundColor(.white)
            Text(label)
                .font(.caption2)
                .foregroundColor(.white.opacity(0.85))
        }
    }
}

struct DecorativeGardenBanner: View {
    var body: some View {
        ZStack {
            GardenDesign.gradientNew
            HStack(spacing: 20) {
                Image(systemName: "leaf.fill")
                    .font(.system(size: 44))
                    .foregroundColor(.white.opacity(0.35))
                Image(systemName: "sparkles")
                    .font(.system(size: 36))
                    .foregroundColor(.white.opacity(0.5))
                Image(systemName: "sun.max.fill")
                    .font(.system(size: 40))
                    .foregroundColor(.white.opacity(0.4))
            }
        }
    }
}
