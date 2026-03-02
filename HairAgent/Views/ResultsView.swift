import SwiftUI

struct ResultsView: View {
    let userName: String
    let solutions: [HairSolution]
    var onSelectSolution: (HairSolution) -> Void
    var onRetakeQuiz: () -> Void

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                Text("Your Hair Care Plan")
                    .font(AppTheme.headingFont(size: 32))
                    .foregroundStyle(AppTheme.textPrimary)

                Text("Hey \(userName)! Here are solutions made just for you.")
                    .font(AppTheme.bodyFont(size: 18))
                    .foregroundStyle(.gray)

                if solutions.isEmpty {
                    VStack(spacing: 16) {
                        Text("No matches found")
                            .font(AppTheme.headingFont(size: 20))
                        Text("Try the quiz again with different answers!")
                            .font(AppTheme.bodyFont(size: 16))
                            .foregroundStyle(.gray)
                    }
                    .padding(.top, 40)
                } else {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 280))], spacing: 20) {
                        ForEach(Array(solutions.enumerated()), id: \.element.id) { index, solution in
                            SolutionCard(
                                solution: solution,
                                accentColor: AppTheme.quizAccents[index % AppTheme.quizAccents.count]
                            ) {
                                onSelectSolution(solution)
                            }
                        }
                    }
                }

                Button(action: onRetakeQuiz) {
                    Text("Try Different Goals")
                        .font(AppTheme.headingFont(size: 18))
                        .foregroundStyle(AppTheme.pastelCoral)
                        .padding(.vertical, 16)
                        .frame(maxWidth: 300)
                        .background(.white.opacity(0.9))
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(AppTheme.pastelCoral, lineWidth: 2)
                        )
                }
                .padding(.top, 20)
            }
            .padding()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background {
            DecorativeBackground(style: .results)
        }
    }
}
