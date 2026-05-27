import SwiftUI

struct AddChallengeView: View {
    @ObservedObject var viewModel: GratitudeSpaceViewModel
    @Environment(\.dismiss) private var dismiss

    @State private var name = ""
    @State private var description = ""
    @State private var days = 7
    @State private var requiredPerDay = 1

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 14) {
                    formBlock(title: "Challenge", subtitle: "Name and purpose") {
                        VStack(spacing: 12) {
                            field("Name", text: $name)
                            ZStack(alignment: .topLeading) {
                                if description.isEmpty {
                                    Text("Description")
                                        .foregroundColor(.gray.opacity(0.5))
                                        .padding(14)
                                }
                                TextEditor(text: $description)
                                    .frame(height: 90)
                                    .padding(8)
                                    .scrollContentBackground(.hidden)
                            }
                            .background(fieldBg)
                        }
                    }

                    formBlock(title: "Duration", subtitle: "How long it runs") {
                        Stepper("Days: \(days)", value: $days, in: 3...90)
                            .foregroundColor(.gardenBloom)
                    }

                    formBlock(title: "Daily goal", subtitle: "Entries required per day") {
                        Stepper("Entries: \(requiredPerDay)", value: $requiredPerDay, in: 1...5)
                            .foregroundColor(.gardenBloom)
                    }

                    GardenPrimaryButton(title: "Create challenge", icon: "trophy.fill", action: createChallenge, isEnabled: canSave)
                }
                .padding(GardenDesign.padding)
            }
            .gardenScreenBackground()
            .navigationTitle("New challenge")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                        .foregroundColor(.gardenNew)
                }
            }
        }
        .presentationCornerRadius(GardenDesign.radiusL)
    }

    private func formBlock<Content: View>(title: String, subtitle: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            GardenSectionHeader(title: title, subtitle: subtitle)
            content()
        }
        .gardenCard(padding: 14)
    }

    private func field(_ placeholder: String, text: Binding<String>) -> some View {
        TextField(placeholder, text: text)
            .padding(12)
            .background(fieldBg)
            .foregroundColor(.gardenBloom)
    }

    private var fieldBg: some View {
        RoundedRectangle(cornerRadius: 12, style: .continuous)
            .fill(Color.gardenNew.opacity(0.04))
            .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.gardenNew.opacity(0.15)))
    }

    private var canSave: Bool {
        !name.trimmingCharacters(in: .whitespaces).isEmpty &&
        !description.trimmingCharacters(in: .whitespaces).isEmpty
    }

    private func createChallenge() {
        viewModel.addChallenge(
            GratitudeChallenge(
                id: UUID(),
                name: name.trimmingCharacters(in: .whitespaces),
                description: description.trimmingCharacters(in: .whitespaces),
                days: days,
                currentDay: 0,
                startDate: Date(),
                isActive: false,
                entries: [],
                requiredEntriesPerDay: requiredPerDay,
                completedDayKeys: []
            )
        )
        dismiss()
    }
}
