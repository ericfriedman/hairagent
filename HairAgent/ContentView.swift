import SwiftUI

enum AppScreen: Equatable {
    case welcome
    case nameEntry
    case quiz
    case results
    case tipDetail(HairSolution)

    static func == (lhs: AppScreen, rhs: AppScreen) -> Bool {
        switch (lhs, rhs) {
        case (.welcome, .welcome),
             (.nameEntry, .nameEntry),
             (.quiz, .quiz),
             (.results, .results):
            return true
        case (.tipDetail(let a), .tipDetail(let b)):
            return a.id == b.id
        default:
            return false
        }
    }
}

struct ContentView: View {
    @State private var currentScreen: AppScreen = .welcome
    @State private var userName: String = ""
    @State private var selectedColor: HairColor?
    @State private var selectedTexture: HairTexture?
    @State private var selectedGoals: [HairGoal] = []
    @State private var matchedSolutions: [HairSolution] = []

    var body: some View {
        Group {
            switch currentScreen {
            case .welcome:
                WelcomeView {
                    currentScreen = .nameEntry
                }

            case .nameEntry:
                NameEntryView { name in
                    userName = name
                    currentScreen = .quiz
                }

            case .quiz:
                QuizView(
                    onBack: {
                        if selectedColor != nil {
                            currentScreen = .results
                        } else {
                            currentScreen = .nameEntry
                        }
                    },
                    onComplete: { color, texture, goals in
                        selectedColor = color
                        selectedTexture = texture
                        selectedGoals = goals
                        matchedSolutions = HairSolutionsData.solutions(for: texture, goals: goals)
                        currentScreen = .results
                    }
                )

            case .results:
                ResultsView(
                    userName: userName,
                    solutions: matchedSolutions,
                    onSelectSolution: { solution in
                        currentScreen = .tipDetail(solution)
                    },
                    onRetakeQuiz: {
                        currentScreen = .quiz
                    }
                )

            case .tipDetail(let solution):
                TipDetailView(solution: solution) {
                    currentScreen = .results
                }
            }
        }
        .animation(.easeInOut(duration: 0.3), value: currentScreen)
    }
}
