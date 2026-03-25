import SwiftUI

struct MyScheduleView: View {
    let solutions: [HairSolution]
    let texture: HairTexture
    var onSelectSolution: (HairSolution) -> Void

    private let badgeColors: [Color] = [
        AppTheme.pastelPink,
        AppTheme.pastelBlue,
        AppTheme.pastelCoral,
        AppTheme.pastelYellow,
    ]

    var body: some View {
        VStack(spacing: 16) {
            if solutions.isEmpty {
                VStack(spacing: 16) {
                    Text("No solutions yet")
                        .font(AppTheme.headingFont(size: 20))
                    Text("Take the quiz to get your personal hair schedule!")
                        .font(AppTheme.bodyFont(size: 16))
                        .foregroundStyle(.gray)
                }
                .padding(.top, 40)
            } else {
                ForEach(Array(solutions.enumerated()), id: \.element.id) { index, solution in
                    Button(action: { onSelectSolution(solution) }) {
                        HStack(spacing: 16) {
                            VStack(alignment: .leading, spacing: 6) {
                                Text(solution.title)
                                    .font(AppTheme.headingFont(size: 17))
                                    .foregroundStyle(AppTheme.textPrimary)
                                    .multilineTextAlignment(.leading)

                                Text(solution.personalizedFrequency(for: texture))
                                    .font(AppTheme.bodyFont(size: 14))
                                    .foregroundStyle(.gray)
                                    .multilineTextAlignment(.leading)
                            }

                            Spacer()

                            FrequencyBadge(
                                text: shortFrequency(solution.defaultFrequency),
                                color: badgeColors[index % badgeColors.count]
                            )
                        }
                        .padding(16)
                        .background(.white.opacity(0.9))
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                    }
                }
            }
        }
    }

    private func shortFrequency(_ full: String) -> String {
        full.replacingOccurrences(of: "times per week", with: "x/week")
            .replacingOccurrences(of: "time per week", with: "x/week")
            .replacingOccurrences(of: "Once every ", with: "Every ")
            .replacingOccurrences(of: "Once a week", with: "1x/week")
            .replacingOccurrences(of: "2-3 times per week", with: "2-3x/week")
    }
}
