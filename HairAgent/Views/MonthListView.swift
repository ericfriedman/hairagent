import SwiftUI

struct MonthListView: View {
    let texture: HairTexture
    let solutions: [HairSolution]
    let earnedBadges: [EarnedBadge]
    var onSelectMonth: (Int, Int) -> Void

    private let currentYear: Int = {
        Calendar.current.component(.year, from: Date())
    }()

    private let currentMonth: Int = {
        Calendar.current.component(.month, from: Date())
    }()

    private let monthNames = [
        "January", "February", "March", "April", "May", "June",
        "July", "August", "September", "October", "November", "December"
    ]

    var body: some View {
        VStack(spacing: 16) {
            Text("My Hair Schedule")
                .font(AppTheme.headingFont(size: 28))
                .foregroundStyle(AppTheme.textPrimary)

            Text("Your personalized hair care calendar")
                .font(AppTheme.bodyFont(size: 16))
                .foregroundStyle(.gray)

            ScrollView {
                VStack(spacing: 10) {
                    ForEach(1...12, id: \.self) { month in
                        monthCard(month: month)
                    }
                }
                .padding(.horizontal)
            }
        }
    }

    @ViewBuilder
    private func monthCard(month: Int) -> some View {
        let isCurrent = month == currentMonth
        let isPast = month < currentMonth
        let isFuture = month > currentMonth

        Button(action: { onSelectMonth(currentYear, month) }) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    if isCurrent {
                        Text("\u{2728} \(monthNames[month - 1]) \u{2728}")
                            .font(AppTheme.headingFont(size: 17))
                            .foregroundStyle(AppTheme.textPrimary)
                    } else {
                        Text(monthNames[month - 1])
                            .font(AppTheme.headingFont(size: 17))
                            .foregroundStyle(AppTheme.textPrimary)
                    }

                    if isCurrent {
                        Text("Current month")
                            .font(AppTheme.bodyFont(size: 13))
                            .foregroundStyle(AppTheme.hotPink)
                            .bold()
                    } else if isPast {
                        Text("4 weeks completed")
                            .font(AppTheme.bodyFont(size: 13))
                            .foregroundStyle(.gray)
                    } else {
                        Text("Coming soon")
                            .font(AppTheme.bodyFont(size: 13))
                            .foregroundStyle(.gray)
                    }
                }

                Spacer()

                if isFuture {
                    Text("\u{1F512}")
                        .font(.system(size: 20))
                        .opacity(0.6)
                } else {
                    HStack(spacing: 4) {
                        ForEach(0..<badgeCountForMonth(month), id: \.self) { _ in
                            Text("\u{2B50}")
                                .font(.system(size: 16))
                                .background(
                                    Circle()
                                        .fill(Color(red: 1.0, green: 0.84, blue: 0.0))
                                        .frame(width: 22, height: 22)
                                )
                        }
                    }
                }
            }
            .padding(16)
            .background(.white.opacity(isFuture ? 0.6 : 0.9))
            .clipShape(RoundedRectangle(cornerRadius: 14))
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(isCurrent ? AppTheme.hotPink : Color.clear, lineWidth: 3)
            )
        }
        .disabled(isFuture)
        .opacity(isFuture ? 0.6 : 1.0)
    }

    private func badgeCountForMonth(_ month: Int) -> Int {
        if month < currentMonth {
            return min(month % 3 + 2, 4)
        } else if month == currentMonth {
            return earnedBadges.count
        }
        return 0
    }
}
