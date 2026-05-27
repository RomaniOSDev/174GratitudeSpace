import SwiftUI

// MARK: - Tokens (reuse gradients — less allocation during scroll)

enum GardenDesign {
    static let radiusS: CGFloat = 10
    static let radiusM: CGFloat = 16
    static let radiusL: CGFloat = 22
    static let padding: CGFloat = 16
    static let spacing: CGFloat = 12

    static let gradientNew = LinearGradient(
        colors: [Color.gardenNew, Color.gardenBloom],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static let gradientSoft = LinearGradient(
        colors: [
            Color.gardenNew.opacity(0.14),
            Color.gardenBloom.opacity(0.06)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static let gradientScreen = LinearGradient(
        colors: [
            Color(red: 0.97, green: 0.99, blue: 1.0),
            Color.gardenBackground,
            Color.gardenBloom.opacity(0.04)
        ],
        startPoint: .top,
        endPoint: .bottom
    )

    static let surfaceShine = LinearGradient(
        colors: [Color.white.opacity(0.55), Color.white.opacity(0.0)],
        startPoint: .top,
        endPoint: .center
    )

    /// Legacy tint for toolbars — prefer `GardenElevation` on cards.
    static let cardShadow = Color.gardenBloom.opacity(0.16)
}

// MARK: - Elevation (single shadow per view — GPU-friendly)

enum GardenElevation {
    case flat
    case soft
    case raised
    case lifted

    var shadowColor: Color {
        switch self {
        case .flat: return .clear
        case .soft: return Color.gardenBloom.opacity(0.12)
        case .raised: return Color.gardenBloom.opacity(0.16)
        case .lifted: return Color.gardenBloom.opacity(0.22)
        }
    }

    var shadowRadius: CGFloat {
        switch self {
        case .flat: return 0
        case .soft: return 4
        case .raised: return 8
        case .lifted: return 12
        }
    }

    var shadowY: CGFloat {
        switch self {
        case .flat: return 0
        case .soft: return 2
        case .raised: return 4
        case .lifted: return 6
        }
    }
}

// MARK: - Surface shape (one background pass)

enum GardenSurface {
    static func cardBackground(
        radius: CGFloat,
        elevation: GardenElevation,
        fill: Color = .white
    ) -> some View {
        RoundedRectangle(cornerRadius: radius, style: .continuous)
            .fill(fill)
            .overlay(
                RoundedRectangle(cornerRadius: radius, style: .continuous)
                    .fill(GardenDesign.surfaceShine)
            )
            .overlay(
                RoundedRectangle(cornerRadius: radius, style: .continuous)
                    .stroke(
                        LinearGradient(
                            colors: [
                                Color.white.opacity(0.9),
                                Color.gardenNew.opacity(0.12)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1
                    )
            )
            .shadow(
                color: elevation.shadowColor,
                radius: elevation.shadowRadius,
                x: 0,
                y: elevation.shadowY
            )
    }

    static func tileBackground(
        radius: CGFloat,
        accent: Color
    ) -> some View {
        RoundedRectangle(cornerRadius: radius, style: .continuous)
            .fill(
                LinearGradient(
                    colors: [Color.white, accent.opacity(0.06)],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            .overlay(
                RoundedRectangle(cornerRadius: radius, style: .continuous)
                    .stroke(accent.opacity(0.18), lineWidth: 1)
            )
    }
}

// MARK: - View modifiers

struct GardenCardModifier: ViewModifier {
    var padding: CGFloat = GardenDesign.padding
    var radius: CGFloat = GardenDesign.radiusM
    var elevation: GardenElevation = .raised

    func body(content: Content) -> some View {
        content
            .padding(padding)
            .background {
                GardenSurface.cardBackground(radius: radius, elevation: elevation)
            }
    }
}

struct GardenScreenBackgroundModifier: ViewModifier {
    func body(content: Content) -> some View {
        ZStack {
            GardenDesign.gradientScreen
                .ignoresSafeArea()
            content
        }
    }
}

struct GardenTileModifier: ViewModifier {
    var radius: CGFloat = GardenDesign.radiusM
    var accent: Color = .gardenNew

    func body(content: Content) -> some View {
        content
            .background {
                GardenSurface.tileBackground(radius: radius, accent: accent)
            }
    }
}

struct GardenInsetPanelModifier: ViewModifier {
    var radius: CGFloat = GardenDesign.radiusS

    func body(content: Content) -> some View {
        content
            .background {
                RoundedRectangle(cornerRadius: radius, style: .continuous)
                    .fill(Color.gardenNew.opacity(0.04))
                    .overlay(
                        RoundedRectangle(cornerRadius: radius, style: .continuous)
                            .stroke(Color.gardenNew.opacity(0.1), lineWidth: 1)
                    )
            }
    }
}

extension View {
    func gardenCard(
        padding: CGFloat = GardenDesign.padding,
        radius: CGFloat = GardenDesign.radiusM,
        elevation: GardenElevation = .raised
    ) -> some View {
        modifier(GardenCardModifier(padding: padding, radius: radius, elevation: elevation))
    }

    func gardenScreenBackground() -> some View {
        modifier(GardenScreenBackgroundModifier())
    }

    /// Grid / list tiles — no shadow (scroll performance).
    func gardenTile(radius: CGFloat = GardenDesign.radiusM, accent: Color = .gardenNew) -> some View {
        modifier(GardenTileModifier(radius: radius, accent: accent))
    }

    func gardenInsetPanel(radius: CGFloat = GardenDesign.radiusS) -> some View {
        modifier(GardenInsetPanelModifier(radius: radius))
    }

    /// Bottom action bar — border only, no shadow (scroll-friendly).
    func gardenStickyFooter() -> some View {
        background {
            Color.white
                .overlay(alignment: .top) {
                    Rectangle()
                        .fill(Color.gardenNew.opacity(0.12))
                        .frame(height: 1)
                }
        }
    }
}

// MARK: - Components

struct GardenSectionHeader: View {
    let title: String
    var subtitle: String? = nil
    var actionTitle: String? = nil
    var action: (() -> Void)? = nil

    var body: some View {
        HStack(alignment: .bottom) {
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.title3.weight(.semibold))
                    .foregroundColor(.gardenBloom)
                if let subtitle {
                    Text(subtitle)
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
            Spacer()
            if let actionTitle, let action {
                Button(actionTitle, action: action)
                    .font(.subheadline.weight(.medium))
                    .foregroundColor(.gardenNew)
            }
        }
    }
}

struct GardenIconCircle: View {
    let systemName: String
    let color: Color
    var size: CGFloat = 44

    var body: some View {
        ZStack {
            Circle()
                .fill(
                    LinearGradient(
                        colors: [color.opacity(0.22), color.opacity(0.06)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .overlay(Circle().stroke(color.opacity(0.2), lineWidth: 1))
                .frame(width: size, height: size)
            Image(systemName: systemName)
                .font(.system(size: size * 0.4, weight: .semibold))
                .foregroundStyle(color)
        }
    }
}

struct GardenPrimaryButton: View {
    let title: String
    var icon: String? = nil
    let action: () -> Void
    var isEnabled: Bool = true

    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                if let icon {
                    Image(systemName: icon)
                }
                Text(title)
                    .fontWeight(.semibold)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .foregroundColor(.white)
            .background {
                RoundedRectangle(cornerRadius: GardenDesign.radiusS, style: .continuous)
                    .fill(
                        isEnabled
                        ? GardenDesign.gradientNew
                        : LinearGradient(
                            colors: [Color.gray.opacity(0.35), Color.gray.opacity(0.3)],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .shadow(
                        color: isEnabled ? Color.gardenNew.opacity(0.35) : .clear,
                        radius: isEnabled ? 8 : 0,
                        y: isEnabled ? 4 : 0
                    )
            }
        }
        .disabled(!isEnabled)
    }
}

struct GardenSecondaryButton: View {
    let title: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .fontWeight(.medium)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .foregroundColor(.gardenNew)
                .background {
                    RoundedRectangle(cornerRadius: GardenDesign.radiusS, style: .continuous)
                        .fill(Color.white)
                        .overlay(
                            RoundedRectangle(cornerRadius: GardenDesign.radiusS, style: .continuous)
                                .stroke(GardenDesign.gradientNew, lineWidth: 1.5)
                        )
                }
        }
    }
}

struct GardenChip: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.subheadline.weight(.medium))
                .padding(.horizontal, 14)
                .padding(.vertical, 8)
                .foregroundColor(isSelected ? .white : .gardenBloom)
                .background {
                    if isSelected {
                        Capsule().fill(GardenDesign.gradientNew)
                    } else {
                        Capsule().fill(Color.gardenNew.opacity(0.08))
                    }
                }
        }
        .buttonStyle(.plain)
    }
}

struct GardenFloatingAddButton: View {
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: "plus")
                .font(.title2.weight(.bold))
                .foregroundColor(.white)
                .frame(width: 58, height: 58)
                .background {
                    Circle()
                        .fill(GardenDesign.gradientNew)
                        .shadow(color: Color.gardenNew.opacity(0.4), radius: 10, y: 5)
                }
        }
    }
}
