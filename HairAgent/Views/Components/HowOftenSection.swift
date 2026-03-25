import SwiftUI

struct HowOftenSection: View {
    let solution: HairSolution
    let texture: HairTexture

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("How Often")
                .font(AppTheme.headingFont(size: 22))
                .foregroundStyle(AppTheme.textPrimary)

            HStack(spacing: 12) {
                Image(systemName: "calendar")
                    .font(.system(size: 22))
                    .foregroundStyle(AppTheme.pastelCoral)
                Text(solution.defaultFrequency)
                    .font(AppTheme.headingFont(size: 18))
                    .foregroundStyle(AppTheme.textPrimary)
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(.white.opacity(0.9))
            .clipShape(RoundedRectangle(cornerRadius: 14))

            VStack(alignment: .leading, spacing: 8) {
                Text("Your Personal Tip")
                    .font(AppTheme.headingFont(size: 16))
                    .foregroundStyle(AppTheme.pastelBlue)

                Text("Since you have \(texture.displayName.lowercased()) hair: \(solution.personalizedFrequency(for: texture))")
                    .font(AppTheme.bodyFont(size: 16))
                    .foregroundStyle(AppTheme.textPrimary)
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(AppTheme.pastelBlue.opacity(0.15))
            .clipShape(RoundedRectangle(cornerRadius: 14))

            VStack(alignment: .leading, spacing: 8) {
                HStack(spacing: 8) {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundStyle(AppTheme.pastelCoral)
                    Text("Watch Out!")
                        .font(AppTheme.headingFont(size: 16))
                        .foregroundStyle(AppTheme.pastelCoral)
                }

                Text(solution.overuseWarning)
                    .font(AppTheme.bodyFont(size: 16))
                    .foregroundStyle(AppTheme.textPrimary)
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(AppTheme.pastelYellow.opacity(0.2))
            .clipShape(RoundedRectangle(cornerRadius: 14))
        }
    }
}
