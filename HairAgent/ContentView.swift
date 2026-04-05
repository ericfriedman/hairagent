import SwiftUI

enum AppScreen: Equatable {
    case welcome
    case nameEntry
    case quiz
    case results
    case tipDetail(HairSolution)
    case monthCalendar(Int, Int)

    static func == (lhs: AppScreen, rhs: AppScreen) -> Bool {
        switch (lhs, rhs) {
        case (.welcome, .welcome),
             (.nameEntry, .nameEntry),
             (.quiz, .quiz),
             (.results, .results):
            return true
        case (.tipDetail(let a), .tipDetail(let b)):
            return a.id == b.id
        case (.monthCalendar(let y1, let m1), .monthCalendar(let y2, let m2)):
            return y1 == y2 && m1 == m2
        default:
            return false
        }
    }
}

struct ContentView: View {
    @State private var currentScreen: AppScreen = .welcome
    @State private var userName: String = ""
    @State private var selectedColor: SelectedHairColor?
    @State private var selectedTexture: HairTexture?
    @State private var selectedGoals: [HairGoal] = []
    @State private var matchedSolutions: [HairSolution] = []
    @State private var earnedBadges: [EarnedBadge] = []
    @State private var showCelebration = false
    @State private var celebrationBadge: BadgeType?

    var body: some View {
        ZStack {
            Group {
                switch currentScreen {
                case .welcome:
                    WelcomeView {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            currentScreen = .nameEntry
                        }
                    }

                case .nameEntry:
                    NameEntryView { name in
                        userName = name
                        withAnimation(.easeInOut(duration: 0.3)) {
                            currentScreen = .quiz
                        }
                    }

                case .quiz:
                    QuizView(
                        onBack: {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                if selectedColor != nil {
                                    currentScreen = .results
                                } else {
                                    currentScreen = .nameEntry
                                }
                            }
                        },
                        onComplete: { color, texture, goals in
                            selectedColor = color
                            selectedTexture = texture
                            selectedGoals = goals
                            matchedSolutions = HairSolutionsData.solutions(for: texture, goals: goals)
                            withAnimation(.easeInOut(duration: 0.3)) {
                                currentScreen = .results
                            }
                        }
                    )

                case .results:
                    ResultsView(
                        userName: userName,
                        solutions: matchedSolutions,
                        selectedHairColor: selectedColor,
                        selectedTexture: selectedTexture,
                        earnedBadges: earnedBadges,
                        onSelectSolution: { solution in
                            withAnimation(.easeInOut(duration: 0.3)) {
                                currentScreen = .tipDetail(solution)
                            }
                        },
                        onRetakeQuiz: {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                currentScreen = .quiz
                            }
                        },
                        onSelectMonth: { year, month in
                            withAnimation(.easeInOut(duration: 0.3)) {
                                currentScreen = .monthCalendar(year, month)
                            }
                        }
                    )

                case .tipDetail(let solution):
                    TipDetailView(
                        solution: solution,
                        texture: selectedTexture ?? .other
                    ) {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            currentScreen = .results
                        }
                    }

                case .monthCalendar(let year, let month):
                    MonthCalendarView(
                        year: year,
                        month: month,
                        texture: selectedTexture ?? .other,
                        solutions: matchedSolutions,
                        earnedBadges: earnedBadges,
                        onBack: {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                currentScreen = .results
                            }
                        },
                        onEarnBadge: { badgeType in
                            earnBadge(badgeType)
                        }
                    )
                    .background {
                        DecorativeBackground(style: .calendar)
                    }
                }
            }

            if showCelebration, let badge = celebrationBadge {
                BadgeCelebrationView(
                    badge: badge,
                    totalEarned: earnedBadges.count,
                    totalPossible: BadgeType.allCases.count,
                    onDismiss: {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            showCelebration = false
                            celebrationBadge = nil
                        }
                    }
                )
                .transition(.opacity)
            }
        }
    }

    private func earnBadge(_ badgeType: BadgeType) {
        let badge = EarnedBadge(type: badgeType, earnedDate: Date())
        earnedBadges.append(badge)
        celebrationBadge = badgeType
        withAnimation(.easeInOut(duration: 0.3)) {
            showCelebration = true
        }
    }
}
