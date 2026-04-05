import SwiftUI

struct SolutionCard: View {
    let solution: HairSolution
    let accentColor: Color
    let hairColor: Color?
    let texture: HairTexture?
    var onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 12) {
                if let texture = texture {
                    BeforeAfterPhotos(
                        texture: texture,
                        hairColor: hairColor
                    )
                    .frame(maxWidth: .infinity)
                    .frame(height: 180)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                } else {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(accentColor.opacity(0.3))
                        .frame(height: 160)
                        .overlay(
                            Image(systemName: "sparkles")
                                .font(.system(size: 40))
                                .foregroundStyle(accentColor)
                        )
                }

                Text(solution.title)
                    .font(AppTheme.headingFont(size: 18))
                    .foregroundStyle(AppTheme.textPrimary)

                Text(solution.ingredients.joined(separator: ", "))
                    .font(AppTheme.bodyFont(size: 14))
                    .foregroundStyle(.gray)
                    .lineLimit(2)
            }
            .padding()
            .background(.white.opacity(0.9))
            .clipShape(RoundedRectangle(cornerRadius: 16))
        }
    }
}

// MARK: - Before/After Photo Pair

struct BeforeAfterPhotos: View {
    let texture: HairTexture
    let hairColor: Color?

    private var textureKey: String {
        switch texture {
        case .frizzy: return "frizzy"
        case .oily: return "oily"
        case .dry: return "dry"
        case .damaged: return "damaged"
        case .other: return "frizzy"
        }
    }

    var body: some View {
        HStack(spacing: 2) {
            photoView(imageName: "\(textureKey)_before", label: "Before")
            photoView(imageName: "\(textureKey)_after", label: "After")
        }
    }

    @ViewBuilder
    private func photoView(imageName: String, label: String) -> some View {
        VStack(spacing: 4) {
            ZStack {
                // Base: original image
                Image(imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(maxWidth: .infinity)
                    .frame(height: 150)
                    .clipped()

                // Color overlay using .sourceAtop to tint only non-white areas
                // The .color blend mode recolors with our hue while keeping luminance
                if let hairColor = hairColor {
                    Rectangle()
                        .fill(hairColor)
                        .frame(maxWidth: .infinity)
                        .frame(height: 150)
                        .blendMode(.color)
                }
            }

            Text(label)
                .font(AppTheme.headingFont(size: 11))
                .foregroundStyle(.gray)
        }
    }
}
