import SwiftUI

struct FrequencyBadge: View {
    let text: String
    let color: Color

    var body: some View {
        Text(text)
            .font(AppTheme.bodyFont(size: 14))
            .foregroundStyle(.white)
            .padding(.horizontal, 14)
            .padding(.vertical, 6)
            .background(color)
            .clipShape(Capsule())
    }
}
