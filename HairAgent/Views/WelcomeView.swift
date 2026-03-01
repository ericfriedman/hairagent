import SwiftUI

struct WelcomeView: View {
    var onGetStarted: () -> Void

    var body: some View {
        VStack(spacing: 40) {
            Spacer()

            VStack(spacing: 16) {
                Text("Hair Agent")
                    .font(AppTheme.headingFont(size: 48))
                    .foregroundStyle(AppTheme.textPrimary)

                Text("Your personal hair care advisor")
                    .font(AppTheme.bodyFont(size: 20))
                    .foregroundStyle(.gray)
            }

            Spacer()

            Button(action: onGetStarted) {
                Text("Get Started")
                    .font(AppTheme.headingFont(size: 20))
                    .foregroundStyle(.white)
                    .frame(maxWidth: 300)
                    .padding(.vertical, 18)
                    .background(AppTheme.pastelCoral)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
            }

            Spacer()
                .frame(height: 60)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(AppTheme.background)
    }
}
