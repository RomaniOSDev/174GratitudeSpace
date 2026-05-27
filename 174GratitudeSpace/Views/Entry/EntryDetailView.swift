import SwiftUI

struct EntryDetailView: View {
    @ObservedObject var viewModel: GratitudeSpaceViewModel
    let entry: GratitudeEntry
    @Environment(\.dismiss) private var dismiss

    @State private var showEditSheet = false
    @State private var showDeleteConfirmation = false

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 18) {
                heroHeader
                photoSection
                descriptionCard
                metricsGrid
                peopleSection
                tagsSection
                actionButtons
            }
            .padding(.bottom, 32)
        }
        .gardenScreenBackground()
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showEditSheet) {
            EditEntryView(viewModel: viewModel, entry: entry)
        }
        .alert("Delete entry?", isPresented: $showDeleteConfirmation) {
            Button("Cancel", role: .cancel) {}
            Button("Delete", role: .destructive) {
                viewModel.deleteEntry(entry)
                dismiss()
            }
        } message: {
            Text("This flower will wilt in your garden.")
        }
    }

    private var heroHeader: some View {
        HStack(alignment: .top, spacing: 16) {
            Text(entry.category.emoji)
                .font(.system(size: 52))
                .frame(width: 72, height: 72)
                .background {
                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                        .fill(
                            LinearGradient(
                                colors: [
                                    entry.moodLevel.flowerColor.opacity(0.22),
                                    entry.moodLevel.flowerColor.opacity(0.06)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 18, style: .continuous)
                                .stroke(entry.moodLevel.flowerColor.opacity(0.25), lineWidth: 1)
                        )
                }

            VStack(alignment: .leading, spacing: 6) {
                Text(entry.title)
                    .font(.title.weight(.bold))
                    .foregroundColor(.gardenBloom)

                Label(entry.formattedDate, systemImage: "calendar")
                    .font(.subheadline)
                    .foregroundColor(.gray)

                HStack(spacing: 8) {
                    Text(entry.moodLevel.emoji)
                    Text(entry.moodLevel.label)
                        .font(.caption.weight(.semibold))
                        .foregroundColor(entry.moodLevel.flowerColor)
                    if entry.isFavorite {
                        Image(systemName: "star.fill")
                            .foregroundColor(.gardenNew)
                    }
                }
            }
            Spacer()
        }
        .gardenCard()
        .padding(.horizontal, GardenDesign.padding)
        .padding(.top, 8)
    }

    @ViewBuilder
    private var photoSection: some View {
        if let image = ImageStorage.load(fileName: entry.imageName) {
            Image(uiImage: image)
                .resizable()
                .scaledToFill()
                .frame(height: 240)
                .frame(maxWidth: .infinity)
                .clipped()
                .clipShape(RoundedRectangle(cornerRadius: GardenDesign.radiusM, style: .continuous))
                .overlay {
                    RoundedRectangle(cornerRadius: GardenDesign.radiusM, style: .continuous)
                        .stroke(
                            LinearGradient(
                                colors: [Color.white.opacity(0.6), Color.gardenNew.opacity(0.2)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1.5
                        )
                }
                .background {
                    GardenSurface.cardBackground(radius: GardenDesign.radiusM, elevation: .raised)
                }
                .padding(.horizontal, GardenDesign.padding)
        }
    }

    private var descriptionCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            GardenSectionHeader(title: "Reflection", subtitle: nil)
            Text(entry.description)
                .font(.body)
                .foregroundColor(.gardenBloom)
                .fixedSize(horizontal: false, vertical: true)
        }
        .gardenCard()
        .padding(.horizontal, GardenDesign.padding)
    }

    private var metricsGrid: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
            DetailMetricCell(title: "Mood", value: entry.moodLevel.label, icon: "heart.fill", color: entry.moodLevel.flowerColor)
            DetailMetricCell(title: "Category", value: entry.category.displayName, icon: "folder.fill", color: .gardenNew)
            if let location = entry.location, !location.isEmpty {
                DetailMetricCell(title: "Place", value: location, icon: "location.fill", color: .gardenNew)
            }
        }
        .padding(.horizontal, GardenDesign.padding)
    }

    @ViewBuilder
    private var peopleSection: some View {
        if let people = entry.people, !people.isEmpty {
            VStack(alignment: .leading, spacing: 12) {
                GardenSectionHeader(title: "Together with", subtitle: nil)
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        ForEach(people, id: \.self) { person in
                            HStack(spacing: 6) {
                                Image(systemName: "person.circle.fill")
                                    .foregroundColor(.gardenNew)
                                Text(person)
                                    .font(.subheadline.weight(.medium))
                                    .foregroundColor(.gardenBloom)
                            }
                            .padding(.horizontal, 14)
                            .padding(.vertical, 10)
                            .background(Capsule().fill(Color.gardenNew.opacity(0.1)))
                        }
                    }
                }
            }
            .gardenCard()
            .padding(.horizontal, GardenDesign.padding)
        }
    }

    @ViewBuilder
    private var tagsSection: some View {
        if !entry.tags.isEmpty {
            VStack(alignment: .leading, spacing: 12) {
                GardenSectionHeader(title: "Tags", subtitle: nil)
                FlowLayout(spacing: 8) {
                    ForEach(entry.tags, id: \.self) { tag in
                        Text("#\(tag)")
                            .font(.caption.weight(.semibold))
                            .padding(.horizontal, 12)
                            .padding(.vertical, 7)
                            .background(Capsule().fill(Color.gardenNew.opacity(0.12)))
                            .foregroundColor(.gardenNew)
                    }
                }
            }
            .gardenCard()
            .padding(.horizontal, GardenDesign.padding)
        }
    }

    private var actionButtons: some View {
        VStack(spacing: 12) {
            GardenPrimaryButton(title: "Edit entry", icon: "pencil", action: { showEditSheet = true })
            GardenSecondaryButton(title: "Delete", action: { showDeleteConfirmation = true })
        }
        .padding(.horizontal, GardenDesign.padding)
    }
}
