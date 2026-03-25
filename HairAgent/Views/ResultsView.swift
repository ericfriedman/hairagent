import SwiftUI

enum ResultsTab {
    case solutions
    case schedule
}

struct ResultsView: View {
    let userName: String
    let solutions: [HairSolution]
    let selectedHairColor: SelectedHairColor?
    let selectedTexture: HairTexture?
    var onSelectSolution: (HairSolution) -> Void
    var onRetakeQuiz: () -> Void

    @State private var selectedTab: ResultsTab = .solutions

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                Text("Your Hair Care Plan")
                    .font(AppTheme.headingFont(size: 32))
                    .foregroundStyle(AppTheme.textPrimary)

                Text("Hey \(userName)! Here are solutions made just for you.")
                    .font(AppTheme.bodyFont(size: 18))
                    .foregroundStyle(.gray)

                if !solutions.isEmpty {
                    tabBar
                }

                switch selectedTab {
                case .solutions:
                    solutionsContent
                case .schedule:
                    MyScheduleView(
                        solutions: solutions,
                        texture: selectedTexture ?? .other,
                        onSelectSolution: onSelectSolution
                    )
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
            DecorativeBackground(style: selectedTab == .solutions ? .results : .mySchedule)
        }
        .animation(.easeInOut(duration: 0.3), value: selectedTab)
    }

    private var tabBar: some View {
        HStack(spacing: 0) {
            tabButton("My Solutions", tab: .solutions)
            tabButton("My Schedule", tab: .schedule)
        }
        .background(.white.opacity(0.7))
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(AppTheme.pastelPink.opacity(0.3), lineWidth: 1.5)
        )
    }

    private func tabButton(_ label: String, tab: ResultsTab) -> some View {
        Button(action: { selectedTab = tab }) {
            Text(label)
                .font(AppTheme.headingFont(size: 16))
                .foregroundStyle(selectedTab == tab ? .white : AppTheme.textPrimary)
                .padding(.vertical, 12)
                .frame(maxWidth: .infinity)
                .background(selectedTab == tab ? AppTheme.pastelCoral : Color.clear)
                .clipShape(RoundedRectangle(cornerRadius: 14))
        }
    }

    @ViewBuilder
    private var solutionsContent: some View {
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
                        accentColor: AppTheme.quizAccents[index % AppTheme.quizAccents.count],
                        hairColor: selectedHairColor?.color,
                        texture: selectedTexture
                    ) {
                        onSelectSolution(solution)
                    }
                }
            }
        }
    }
}
