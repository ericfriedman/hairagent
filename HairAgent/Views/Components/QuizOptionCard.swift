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
                .background(isSelected ? accentColor : Color.gray.opacity(0.12))
                .clipShape(RoundedRectangle(cornerRadius: 14))
                .overlay(
                    RoundedRectangle(cornerRadius: 14)
                        .stroke(isSelected ? accentColor : .clear, lineWidth: 3)
                )
        }
    }
}
