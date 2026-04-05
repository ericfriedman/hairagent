import SwiftUI

struct BadgeCelebrationView: View {
    let badge: BadgeType
    let totalEarned: Int
    let totalPossible: Int
    var onDismiss: () -> Void

    var body: some View {
        ZStack {
            Color.black.opacity(0.6)
                .ignoresSafeArea()
                .onTapGesture(perform: onDismiss)

            ConfettiView()
                .ignoresSafeArea()

            VStack(spacing: 16) {
                Text("\u{1F389} Badge Earned! \u{1F389}")
                    .font(AppTheme.headingFont(size: 22))
                    .foregroundStyle(AppTheme.hotPink)

                let colors = badge.gradientColors
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [colors.0, colors.1],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 90, height: 90)
                        .shadow(color: colors.1.opacity(0.4), radius: 8, y: 4)

                    Text(badge.icon)
                        .font(.system(size: 42))
                }

                Text(badge.displayName)
                    .font(AppTheme.headingFont(size: 24))
                    .foregroundStyle(AppTheme.textPrimary)

                Text(badge.subtitle)
                    .font(AppTheme.bodyFont(size: 15))
                    .foregroundStyle(.gray)

                Text("Badge \(totalEarned) of \(totalPossible) earned!")
                    .font(AppTheme.bodyFont(size: 14))
                    .foregroundStyle(AppTheme.hotPink)
                    .padding(.top, 4)

                Button(action: onDismiss) {
                    Text("Awesome! \u{1F389}")
                        .font(AppTheme.headingFont(size: 17))
                        .foregroundStyle(.white)
                        .padding(.horizontal, 36)
                        .padding(.vertical, 14)
                        .background(AppTheme.hotPink)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                }
                .padding(.top, 8)
            }
            .padding(36)
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 28))
            .shadow(color: AppTheme.hotPink.opacity(0.3), radius: 16, y: 8)
            .padding(.horizontal, 40)
        }
    }
}
