import SwiftUI
import StoreKit
import UIKit

struct SettingsView: View {
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 20) {
                GardenSectionHeader(
                    title: "Settings",
                    subtitle: "Support and legal"
                )

                VStack(spacing: 0) {
                    SettingsRow(
                        title: "Rate us",
                        icon: "star.fill",
                        iconColor: .gardenNew
                    ) {
                        rateApp()
                    }

                    settingsDivider

                    SettingsRow(
                        title: AppLink.privacyPolicy.title,
                        icon: "hand.raised.fill",
                        iconColor: .gardenBloom
                    ) {
                        openPolicy(AppLink.privacyPolicy)
                    }

                    settingsDivider

                    SettingsRow(
                        title: AppLink.termsOfUse.title,
                        icon: "doc.text.fill",
                        iconColor: .gardenBloom
                    ) {
                        openPolicy(AppLink.termsOfUse)
                    }
                }
                .gardenCard(padding: 0)
            }
            .padding(.horizontal, GardenDesign.padding)
            .padding(.vertical, 12)
            .padding(.bottom, 24)
        }
        .gardenScreenBackground()
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.large)
    }

    private var settingsDivider: some View {
        Rectangle()
            .fill(Color.gardenNew.opacity(0.1))
            .frame(height: 1)
            .padding(.leading, 62)
    }

    private func openPolicy(_ link: AppLink) {
        if let url = link.url {
            UIApplication.shared.open(url)
        }
    }

    private func rateApp() {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            SKStoreReviewController.requestReview(in: windowScene)
        }
    }
}

private struct SettingsRow: View {
    let title: String
    let icon: String
    let iconColor: Color
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 14) {
                GardenIconCircle(systemName: icon, color: iconColor, size: 40)

                Text(title)
                    .font(.body.weight(.medium))
                    .foregroundColor(.gardenBloom)

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.caption.weight(.semibold))
                    .foregroundColor(.gardenNew.opacity(0.5))
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    NavigationStack {
        SettingsView()
    }
}
