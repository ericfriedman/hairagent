import SwiftUI

enum QuizStep: Int, CaseIterable {
    case color = 0
    case texture = 1
    case goals = 2

    var title: String {
        switch self {
        case .color: return "What's your hair color?"
        case .texture: return "How is your hair?"
        case .goals: return "What do you want to fix?"
        }
    }

    var subtitle: String {
        switch self {
        case .color: return "Pick the closest match"
        case .texture: return "Choose your hair texture"
        case .goals: return "Pick at least 3"
        }
    }
}

struct QuizView: View {
    @State private var step: QuizStep = .color
    @State private var selectedColor: HairColor?
    @State private var selectedTexture: HairTexture?
    @State private var selectedGoals: Set<HairGoal> = []

    var onBack: () -> Void
    var onComplete: (HairColor, HairTexture, [HairGoal]) -> Void

    var body: some View {
        VStack(spacing: 24) {
            HStack {
                Button(action: goBack) {
                    Image(systemName: "chevron.left")
                        .font(.title2.bold())
                        .foregroundStyle(AppTheme.textPrimary)
                }
                Spacer()
            }
            .padding(.horizontal)

            ProgressBar(currentStep: step.rawValue, totalSteps: QuizStep.allCases.count)

            Text(step.title)
                .font(AppTheme.headingFont(size: 32))
                .foregroundStyle(AppTheme.textPrimary)

            Text(step.subtitle)
                .font(AppTheme.bodyFont(size: 18))
                .foregroundStyle(.gray)

            ScrollView {
                switch step {
                case .color:
                    colorGrid
                case .texture:
                    textureGrid
                case .goals:
                    goalsGrid
                }
            }

            Button(action: goNext) {
                Text(step == .goals ? "See My Results" : "Next")
                    .font(AppTheme.headingFont(size: 20))
                    .foregroundStyle(.white)
                    .frame(maxWidth: 300)
                    .padding(.vertical, 18)
                    .background(canProceed ? AppTheme.pastelCoral : Color.gray)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
            }
            .disabled(!canProceed)
            .padding(.bottom)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(AppTheme.background)
        .animation(.easeInOut(duration: 0.3), value: step)
    }

    private var colorGrid: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 160))], spacing: 16) {
            ForEach(HairColor.allCases) { color in
                QuizOptionCard(
                    label: color.displayName,
                    isSelected: selectedColor == color,
                    accentColor: AppTheme.pastelPink
                ) {
                    selectedColor = color
                }
            }
        }
        .padding(.horizontal)
    }

    private var textureGrid: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 160))], spacing: 16) {
            ForEach(HairTexture.allCases) { texture in
                QuizOptionCard(
                    label: texture.displayName,
                    isSelected: selectedTexture == texture,
                    accentColor: AppTheme.pastelBlue
                ) {
                    selectedTexture = texture
                }
            }
        }
        .padding(.horizontal)
    }

    private var goalsGrid: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 160))], spacing: 16) {
            ForEach(HairGoal.allCases) { goal in
                QuizOptionCard(
                    label: goal.displayName,
                    isSelected: selectedGoals.contains(goal),
                    accentColor: AppTheme.pastelYellow
                ) {
                    if selectedGoals.contains(goal) {
                        selectedGoals.remove(goal)
                    } else {
                        selectedGoals.insert(goal)
                    }
                }
            }
        }
        .padding(.horizontal)
    }

    private var canProceed: Bool {
        switch step {
        case .color: return selectedColor != nil
        case .texture: return selectedTexture != nil
        case .goals: return selectedGoals.count >= 3
        }
    }

    private func goNext() {
        switch step {
        case .color:
            step = .texture
        case .texture:
            step = .goals
        case .goals:
            if let color = selectedColor, let texture = selectedTexture {
                onComplete(color, texture, Array(selectedGoals))
            }
        }
    }

    private func goBack() {
        switch step {
        case .color:
            onBack()
        case .texture:
            step = .color
        case .goals:
            step = .texture
        }
    }
}
