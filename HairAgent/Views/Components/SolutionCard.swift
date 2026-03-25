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
                if let hairColor = hairColor, let texture = texture {
                    BeforeAfterView(
                        hairColor: hairColor,
                        texture: texture,
                        solutionType: solution.solutionType,
                        size: CGSize(width: 260, height: 140)
                    )
                    .frame(maxWidth: .infinity)
                    .frame(height: 140)
                    .background(accentColor.opacity(0.15))
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
