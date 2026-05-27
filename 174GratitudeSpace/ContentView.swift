import SwiftUI
import UIKit

struct ContentView: View {
    @StateObject private var viewModel = GratitudeSpaceViewModel()
    @State private var selectedTab = 0
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false

    init() {
        let tabAppearance = UITabBarAppearance()
        tabAppearance.configureWithOpaqueBackground()
        tabAppearance.backgroundColor = UIColor.white
        tabAppearance.shadowColor = UIColor(Color.gardenNew.opacity(0.12))

        let normal = UITabBarItemAppearance()
        normal.normal.iconColor = UIColor(Color.gardenBloom.opacity(0.45))
        normal.normal.titleTextAttributes = [.foregroundColor: UIColor(Color.gardenBloom.opacity(0.45))]
        normal.selected.iconColor = UIColor(Color.gardenNew)
        normal.selected.titleTextAttributes = [.foregroundColor: UIColor(Color.gardenNew)]

        tabAppearance.stackedLayoutAppearance = normal
        tabAppearance.inlineLayoutAppearance = normal
        tabAppearance.compactInlineLayoutAppearance = normal

        UITabBar.appearance().standardAppearance = tabAppearance
        UITabBar.appearance().scrollEdgeAppearance = tabAppearance
    }

    var body: some View {
        Group {
            if hasCompletedOnboarding {
                mainTabView
            } else {
                OnboardingView {
                    hasCompletedOnboarding = true
                    viewModel.loadFromUserDefaults()
                }
            }
        }
    }

    private var mainTabView: some View {
        TabView(selection: $selectedTab) {
            HomeView(viewModel: viewModel)
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
                .tag(0)

            GardenView(viewModel: viewModel)
                .tabItem {
                    Label("Garden", systemImage: "leaf.fill")
                }
                .tag(1)

            CalendarView(viewModel: viewModel)
                .tabItem {
                    Label("Calendar", systemImage: "calendar")
                }
                .tag(2)

            ChallengesView(viewModel: viewModel)
                .tabItem {
                    Label("Challenges", systemImage: "trophy.fill")
                }
                .tag(3)

            StatsView(viewModel: viewModel)
                .tabItem {
                    Label("Statistics", systemImage: "chart.bar.fill")
                }
                .tag(4)
        }
        .onAppear {
            viewModel.loadFromUserDefaults()
        }
        .tint(.gardenNew)
    }
}

#Preview {
    ContentView()
}
