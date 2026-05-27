import SwiftUI

struct DailyPromptSheet: View {
    let prompt: String
    let onStart: () -> Void
    let onDismiss: () -> Void

    var body: some View {
        NavigationStack {
            VStack(spacing: 28) {
                GardenIconCircle(systemName: "lightbulb.fill", color: .gardenNew, size: 72)

                Text("Prompt of the day")
                    .font(.title2.weight(.semibold))
                    .foregroundColor(.gardenBloom)

                Text(prompt)
                    .font(.title3)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.gardenBloom)
                    .padding(.horizontal, 24)

                VStack(spacing: 12) {
                    GardenPrimaryButton(title: "Start writing", icon: "pencil", action: onStart)
                    GardenSecondaryButton(title: "Maybe later", action: onDismiss)
                }
                .padding(.horizontal, GardenDesign.padding)
            }
            .padding(.vertical, 32)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .gardenScreenBackground()
        }
        .presentationDetents([.medium])
        .presentationCornerRadius(GardenDesign.radiusL)
    }
}
