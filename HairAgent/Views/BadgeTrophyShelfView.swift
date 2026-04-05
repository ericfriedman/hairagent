import SwiftUI

struct BadgeTrophyShelfView: View {
    let earnedBadges: [EarnedBadge]

    private var earnedTypes: Set<BadgeType> {
        Set(earnedBadges.map(\.type))
    }

    var body: some View {
        VStack(spacing: 16) {
            Text("My Badges")
                .font(AppTheme.headingFont(size: 28))
                .foregroundStyle(AppTheme.textPrimary)

            Text("\(earnedBadges.count) badges earned -- keep going!")
                .font(AppTheme.bodyFont(size: 15))
                .foregroundStyle(.gray)

            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 16), count: 3), spacing: 16) {
                ForEach(BadgeType.allCases) { badgeType in
                    badgeCell(badgeType, earned: earnedTypes.contains(badgeType))
                }
            }
            .padding(.horizontal)
        }
    }

    @ViewBuilder
    private func badgeCell(_ badgeType: BadgeType, earned: Bool) -> some View {
        VStack(spacing: 8) {
            if earned {
                let colors = badgeType.gradientColors
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [colors.0, colors.1],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 68, height: 68)
                        .shadow(color: colors.1.opacity(0.4), radius: 6, y: 3)

                    Text(badgeType.icon)
                        .font(.system(size: 30))
                }
            } else {
                ZStack {
                    Circle()
                        .fill(Color.gray.opacity(0.2))
                        .frame(width: 68, height: 68)

                    Text("\u{1F512}")
                        .font(.system(size: 30))
                }
            }

            Text(earned ? badgeType.displayName : "???")
                .font(AppTheme.headingFont(size: 13))
                .foregroundStyle(earned ? AppTheme.textPrimary : .gray.opacity(0.5))

            Text(earned ? badgeType.subtitle : "Keep going!")
                .font(AppTheme.bodyFont(size: 11))
                .foregroundStyle(earned ? .gray : .gray.opacity(0.4))
        }
        .padding(16)
        .background(.white.opacity(earned ? 0.9 : 0.5))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}
