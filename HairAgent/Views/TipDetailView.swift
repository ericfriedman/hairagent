import SwiftUI

struct TipDetailView: View {
    let solution: HairSolution
    let texture: HairTexture
    var onBack: () -> Void

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                Button(action: onBack) {
                    HStack(spacing: 6) {
                        Image(systemName: "chevron.left")
                        Text("Back to Results")
                    }
                    .font(AppTheme.bodyFont(size: 16))
                    .foregroundStyle(AppTheme.pastelCoral)
                }

                Text(solution.title)
                    .font(AppTheme.headingFont(size: 32))
                    .foregroundStyle(AppTheme.textPrimary)

                RoundedRectangle(cornerRadius: 16)
                    .fill(AppTheme.pastelPink.opacity(0.3))
                    .frame(height: 250)
                    .overlay(
                        Image(systemName: "sparkles")
                            .font(.system(size: 50))
                            .foregroundStyle(AppTheme.pastelPink)
                    )

                VStack(alignment: .leading, spacing: 12) {
                    Text("What You Need")
                        .font(AppTheme.headingFont(size: 22))
                        .foregroundStyle(AppTheme.textPrimary)

                    ForEach(solution.ingredients, id: \.self) { ingredient in
                        HStack(spacing: 12) {
                            Circle()
                                .fill(AppTheme.pastelYellow)
                                .frame(width: 8, height: 8)
                            Text(ingredient)
                                .font(AppTheme.bodyFont(size: 18))
                        }
                    }
                }

                VStack(alignment: .leading, spacing: 16) {
                    Text("How To Do It")
                        .font(AppTheme.headingFont(size: 22))
                        .foregroundStyle(AppTheme.textPrimary)

                    ForEach(Array(solution.steps.enumerated()), id: \.offset) { index, step in
                        HStack(alignment: .top, spacing: 16) {
                            Text("\(index + 1)")
                                .font(AppTheme.headingFont(size: 18))
                                .foregroundStyle(.white)
                                .frame(width: 36, height: 36)
                                .background(AppTheme.pastelCoral)
                                .clipShape(Circle())

                            Text(step)
                                .font(AppTheme.bodyFont(size: 18))
                                .foregroundStyle(AppTheme.textPrimary)
                        }
                    }
                }

                HowOftenSection(solution: solution, texture: texture)
                    .padding(.top, 8)
            }
            .padding(24)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background {
            DecorativeBackground(style: .tipDetail)
        }
        .onKeyPress(.escape) {
            onBack()
            return .handled
        }
    }
}
