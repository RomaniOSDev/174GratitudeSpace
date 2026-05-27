import SwiftUI

private struct OnboardingPageData: Identifiable {
    let id: Int
    let icon: String
    let title: String
    let subtitle: String
    let detail: String
}

struct OnboardingView: View {
    var onFinish: () -> Void

    @State private var currentPage = 0

    private let pages: [OnboardingPageData] = [
        OnboardingPageData(
            id: 0,
            icon: "leaf.circle.fill",
            title: "Grow your gratitude garden",
            subtitle: "A calm space for daily reflection",
            detail: "Each entry you write plants a flower in your personal garden. Watch it bloom as you build a mindful habit."
        ),
        OnboardingPageData(
            id: 1,
            icon: "square.and.pencil",
            title: "Capture moments that matter",
            subtitle: "Journal with mood, photos, and prompts",
            detail: "Use daily prompts, mood tracking, and photos to remember what you are grateful for — in your own words."
        ),
        OnboardingPageData(
            id: 2,
            icon: "chart.line.uptrend.xyaxis",
            title: "Stay inspired and consistent",
            subtitle: "Streaks, challenges, and insights",
            detail: "Track your streak on the calendar, join challenges, unlock badges, and see your gratitude grow over time."
        )
    ]

    var body: some View {
        ZStack {
            GardenDesign.gradientScreen
                .ignoresSafeArea()

            decorativeIcons

            VStack(spacing: 0) {
                Spacer(minLength: 24)

                TabView(selection: $currentPage) {
                    ForEach(pages) { page in
                        OnboardingPageView(page: page)
                            .tag(page.id)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .frame(height: 420)

                pageIndicator
                    .padding(.top, 8)

                actionBar
                    .padding(.horizontal, GardenDesign.padding)
                    .padding(.top, 28)
                    .padding(.bottom, 36)
            }
        }
    }

    private var decorativeIcons: some View {
        VStack {
            HStack {
                Image(systemName: "sparkles")
                    .font(.title2)
                    .foregroundColor(Color.gardenNew.opacity(0.2))
                Spacer()
                Image(systemName: "sun.max.fill")
                    .font(.title3)
                    .foregroundColor(Color.gardenBloom.opacity(0.15))
            }
            Spacer()
            HStack {
                Image(systemName: "leaf.fill")
                    .font(.title3)
                    .foregroundColor(Color.gardenNew.opacity(0.18))
                Spacer()
            }
        }
        .padding(32)
        .allowsHitTesting(false)
    }

    private var pageIndicator: some View {
        HStack(spacing: 8) {
            ForEach(pages) { page in
                Group {
                    if currentPage == page.id {
                        Capsule().fill(GardenDesign.gradientNew)
                    } else {
                        Capsule().fill(Color.gardenNew.opacity(0.2))
                    }
                }
                    .frame(width: currentPage == page.id ? 24 : 8, height: 8)
                    .animation(.easeInOut(duration: 0.25), value: currentPage)
            }
        }
    }

    private var actionBar: some View {
        HStack(spacing: 12) {
            if currentPage < pages.count - 1 {
                Button("Skip", action: finish)
                    .font(.subheadline.weight(.medium))
                    .foregroundColor(.gray)

                Spacer()

                Button {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        currentPage += 1
                    }
                } label: {
                    HStack(spacing: 6) {
                        Text("Next")
                        Image(systemName: "arrow.right")
                    }
                    .font(.subheadline.weight(.semibold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 14)
                    .background {
                        Capsule().fill(GardenDesign.gradientNew)
                    }
                }
                .buttonStyle(.plain)
            } else {
                GardenPrimaryButton(title: "Get started", icon: "leaf.fill", action: finish)
            }
        }
    }

    private func finish() {
        onFinish()
    }
}

private struct OnboardingPageView: View {
    let page: OnboardingPageData

    var body: some View {
        VStack(spacing: 24) {
            ZStack {
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [Color.gardenNew.opacity(0.2), Color.gardenNew.opacity(0.02)],
                            center: .center,
                            startRadius: 8,
                            endRadius: 72
                        )
                    )
                    .frame(width: 140, height: 140)

                Circle()
                    .stroke(
                        LinearGradient(
                            colors: [Color.gardenNew.opacity(0.4), Color.gardenBloom.opacity(0.2)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 2
                    )
                    .frame(width: 120, height: 120)

                Image(systemName: page.icon)
                    .font(.system(size: 52, weight: .medium))
                    .foregroundStyle(GardenDesign.gradientNew)
            }

            VStack(spacing: 10) {
                Text(page.title)
                    .font(.title2.weight(.bold))
                    .foregroundColor(.gardenBloom)
                    .multilineTextAlignment(.center)

                Text(page.subtitle)
                    .font(.subheadline.weight(.semibold))
                    .foregroundColor(.gardenNew)
                    .multilineTextAlignment(.center)
            }
            .padding(.horizontal, 8)

            Text(page.detail)
                .font(.body)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .lineSpacing(4)
                .padding(.horizontal, 12)
        }
        .padding(.horizontal, GardenDesign.padding)
    }
}

#Preview {
    OnboardingView(onFinish: {})
}
