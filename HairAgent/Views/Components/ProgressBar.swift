import SwiftUI

struct ProgressBar: View {
    let currentStep: Int
    let totalSteps: Int

    var body: some View {
        HStack(spacing: 8) {
            ForEach(0..<totalSteps, id: \.self) { index in
                RoundedRectangle(cornerRadius: 4)
                    .fill(index <= currentStep
                          ? AppTheme.quizAccents[index % AppTheme.quizAccents.count]
                          : Color.gray.opacity(0.3))
                    .frame(height: 8)
            }
        }
        .padding(.horizontal)
    }
}
