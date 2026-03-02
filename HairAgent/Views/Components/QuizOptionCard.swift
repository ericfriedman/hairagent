import SwiftUI

struct QuizOptionCard: View {
    let label: String
    let isSelected: Bool
    let accentColor: Color
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(label)
                .font(AppTheme.bodyFont(size: 18))
                .foregroundStyle(isSelected ? .white : AppTheme.textPrimary)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(isSelected ? accentColor : .white.opacity(0.85))
                .clipShape(RoundedRectangle(cornerRadius: 14))
                .overlay(
                    RoundedRectangle(cornerRadius: 14)
                        .stroke(isSelected ? accentColor : AppTheme.pastelPink.opacity(0.3), lineWidth: isSelected ? 3 : 1.5)
                )
        }
    }
}
