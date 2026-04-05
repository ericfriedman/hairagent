import SwiftUI

struct MonthCalendarView: View {
    let year: Int
    let month: Int
    let texture: HairTexture
    let solutions: [HairSolution]
    let earnedBadges: [EarnedBadge]
    var onBack: () -> Void
    var onEarnBadge: (BadgeType) -> Void

    private let weekdayHeaders = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]

    private let monthNames = [
        "January", "February", "March", "April", "May", "June",
        "July", "August", "September", "October", "November", "December"
    ]

    @State private var completedDays: Set<Int> = []

    private var schedule: [DaySchedule] {
        ScheduleGenerator.generateMonth(
            year: year, month: month, texture: texture, solutions: solutions
        )
    }

    private var firstWeekday: Int {
        ScheduleGenerator.firstWeekday(year: year, month: month)
    }

    private var currentDay: Int {
        let cal = Calendar.current
        let now = Date()
        if cal.component(.year, from: now) == year && cal.component(.month, from: now) == month {
            return cal.component(.day, from: now)
        }
        return 0
    }

    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Button(action: onBack) {
                    HStack(spacing: 6) {
                        Image(systemName: "chevron.left")
                        Text("Back")
                    }
                    .font(AppTheme.bodyFont(size: 16))
                    .foregroundStyle(AppTheme.hotPink)
                }

                Spacer()
            }
            .padding(.horizontal)

            Text("\(monthNames[month - 1]) \(String(year))")
                .font(AppTheme.headingFont(size: 26))
                .foregroundStyle(AppTheme.textPrimary)

            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 3), count: 7), spacing: 3) {
                ForEach(weekdayHeaders, id: \.self) { day in
                    Text(day)
                        .font(AppTheme.headingFont(size: 12))
                        .foregroundStyle(.gray)
                        .frame(maxWidth: .infinity)
                }
            }
            .padding(.horizontal, 8)

            ScrollView {
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 3), count: 7), spacing: 3) {
                    ForEach(0..<(firstWeekday - 1), id: \.self) { _ in
                        Color.clear.frame(height: 72)
                    }

                    ForEach(schedule) { daySchedule in
                        dayCell(daySchedule)
                    }
                }
                .padding(.horizontal, 8)

                if completedDays.count >= 7 {
                    weekCompletionBanner
                }

                legendView
                    .padding(.top, 12)
                    .padding(.bottom, 20)
            }
        }
        .padding(.top, 8)
    }

    @ViewBuilder
    private func dayCell(_ daySchedule: DaySchedule) -> some View {
        let isToday = daySchedule.day == currentDay
        let isCompleted = completedDays.contains(daySchedule.day)
        let hasMask = daySchedule.activities.contains(.mask)

        Button(action: { toggleDay(daySchedule.day) }) {
            VStack(spacing: 2) {
                Text("\(daySchedule.day)")
                    .font(AppTheme.headingFont(size: 13))
                    .foregroundStyle(isToday ? AppTheme.hotPink : AppTheme.textPrimary)

                if !daySchedule.activities.isEmpty {
                    VStack(spacing: 2) {
                        ForEach(Array(daySchedule.activities.prefix(2).enumerated()), id: \.offset) { _, activity in
                            Text(activity.emoji)
                                .font(.system(size: 18))
                        }
                    }
                }

                if isCompleted {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 14))
                        .foregroundStyle(.green)
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 88)
            .background(
                hasMask
                    ? Color(red: 1.0, green: 0.94, blue: 0.96)
                    : Color.white
            )
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(
                        isToday ? AppTheme.hotPink :
                        hasMask ? Color(red: 1.0, green: 0.41, blue: 0.71).opacity(0.5) :
                        Color.clear,
                        lineWidth: isToday ? 2.5 : 1.5
                    )
            )
        }
    }

    private func toggleDay(_ day: Int) {
        if completedDays.contains(day) {
            completedDays.remove(day)
        } else {
            completedDays.insert(day)
            checkForBadge()
        }
    }

    private func checkForBadge() {
        if completedDays.count >= 7 {
            let alreadyEarned = Set(earnedBadges.map(\.type))
            let hasMoisturizing = solutions.contains { $0.solutionType == .moisturizing }
            let hasProtein = solutions.contains { $0.solutionType == .protein }
            let hasScalp = solutions.contains { $0.solutionType == .scalp }

            if hasMoisturizing && !alreadyEarned.contains(.moistureQueen) {
                onEarnBadge(.moistureQueen)
            } else if hasProtein && !alreadyEarned.contains(.strengthBoss) {
                onEarnBadge(.strengthBoss)
            } else if hasScalp && !alreadyEarned.contains(.scalpGuru) {
                onEarnBadge(.scalpGuru)
            } else if !alreadyEarned.contains(.consistencyChamp) {
                onEarnBadge(.consistencyChamp)
            }
        }
    }

    private var weekCompletionBanner: some View {
        HStack {
            Text("Week Complete! Keep it up!")
                .font(AppTheme.headingFont(size: 15))
                .foregroundStyle(.white)
        }
        .padding(12)
        .frame(maxWidth: .infinity)
        .background(
            LinearGradient(
                colors: [Color(red: 1.0, green: 0.84, blue: 0.0), Color(red: 1.0, green: 0.65, blue: 0.0)],
                startPoint: .leading,
                endPoint: .trailing
            )
        )
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .padding(.horizontal)
        .padding(.top, 12)
    }

    private var legendView: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 10), count: 3), spacing: 10) {
            ForEach(ScheduleActivityType.allCases) { activity in
                HStack(spacing: 6) {
                    Text(activity.emoji)
                        .font(.system(size: 20))
                    Text(activity.displayName)
                        .font(AppTheme.bodyFont(size: 15))
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 8)
                .background(.white)
                .clipShape(RoundedRectangle(cornerRadius: 10))
            }
        }
        .padding(.horizontal)
    }
}
