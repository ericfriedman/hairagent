# v3 Calendar Schedule + Badge System Implementation Plan

> **For agentic workers:** REQUIRED: Use superpowers:subagent-driven-development (if subagents available) or superpowers:executing-plans to implement this plan. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add a monthly calendar schedule (12-month list + calendar grid with personalized activities), a badge achievement system (trophy shelf + confetti celebration popup), and fix the button double-tap lag.

**Architecture:** Schedule data is generated in-memory from the user's quiz results (texture + matched solutions). Each solution's frequency drives how often activities appear on the calendar. Badges are earned by completing full weeks. For this phase, state is managed with @State (no SwiftData persistence yet -- that's a future task). The calendar replaces the existing My Schedule tab. Badges get their own tab.

**Tech Stack:** SwiftUI, existing AppTheme + DecorativeBackground patterns, callback-based navigation (no NavigationStack)

---

## File Structure

### New Files
| File | Responsibility |
|------|---------------|
| `HairAgent/Models/ScheduleModels.swift` | ScheduleActivityType enum, DaySchedule struct, ScheduleGenerator (builds a month of activities from texture + solutions) |
| `HairAgent/Models/BadgeModels.swift` | BadgeDefinition struct, BadgeType enum (all badge types with names/icons/colors/descriptions) |
| `HairAgent/Views/MonthListView.swift` | Scrollable list of 12 month cards, current month highlighted, badges earned shown per month |
| `HairAgent/Views/MonthCalendarView.swift` | 7-column calendar grid for one month, activity icons on days, legend at bottom |
| `HairAgent/Views/BadgeTrophyShelfView.swift` | 3-column grid of badge circles, earned vs locked states |
| `HairAgent/Views/Components/ConfettiView.swift` | Animated confetti particles (hearts, stars, sparkles) falling across the screen |
| `HairAgent/Views/Components/BadgeCelebrationView.swift` | Modal overlay: dark backdrop, badge card, confetti, "Awesome!" dismiss button |
| `HairAgentTests/ScheduleModelTests.swift` | Tests for ScheduleGenerator output and activity distribution |
| `HairAgentTests/BadgeModelTests.swift` | Tests for badge definitions and types |

### Modified Files
| File | Changes |
|------|---------|
| `HairAgent/Views/ResultsView.swift` | Add `.calendar` and `.badges` tabs (4 total), update tab bar |
| `HairAgent/ContentView.swift` | Fix double-tap lag (replace `.animation` modifier with `withAnimation` in closures), pass new state to ResultsView |
| `HairAgent/Views/Components/DecorativeBackground.swift` | Add `.calendar` and `.badges` background styles |
| `HairAgent/Theme/AppTheme.swift` | Add badge color palette (gold, green, purple gradients) |

---

## Chunk 1: Data Models + Tests

### Task 1: Schedule Activity Models

**Files:**
- Create: `HairAgent/Models/ScheduleModels.swift`
- Test: `HairAgentTests/ScheduleModelTests.swift`

- [ ] **Step 1: Write the failing tests**

```swift
// HairAgentTests/ScheduleModelTests.swift
import XCTest
@testable import HairAgent

final class ScheduleModelTests: XCTestCase {

    func test_scheduleActivityType_has_all_cases() {
        let types: [ScheduleActivityType] = [
            .wash, .mask, .trim, .scalpCare, .heatFree, .protectiveStyle
        ]
        XCTAssertEqual(types.count, 6)
    }

    func test_scheduleActivityType_has_display_properties() {
        XCTAssertFalse(ScheduleActivityType.wash.displayName.isEmpty)
        XCTAssertFalse(ScheduleActivityType.wash.icon.isEmpty)
    }

    func test_daySchedule_stores_activities() {
        let day = DaySchedule(day: 5, activities: [.wash, .heatFree])
        XCTAssertEqual(day.day, 5)
        XCTAssertEqual(day.activities.count, 2)
    }

    func test_scheduleGenerator_produces_days_for_month() {
        let solutions = HairSolutionsData.allSolutions.filter { $0.helpsWith.contains(.dry) }
        let days = ScheduleGenerator.generateMonth(
            year: 2026, month: 4, texture: .dry, solutions: solutions
        )
        // April has 30 days
        XCTAssertEqual(days.count, 30)
    }

    func test_scheduleGenerator_assigns_wash_days() {
        let solutions = HairSolutionsData.allSolutions.filter { $0.helpsWith.contains(.oily) }
        let days = ScheduleGenerator.generateMonth(
            year: 2026, month: 4, texture: .oily, solutions: solutions
        )
        let washDays = days.filter { $0.activities.contains(.wash) }
        // Oily hair should have more wash days (at least 8 per month)
        XCTAssertGreaterThanOrEqual(washDays.count, 8)
    }

    func test_scheduleGenerator_assigns_mask_days() {
        let solutions = HairSolutionsData.allSolutions.filter { $0.helpsWith.contains(.dry) }
        let days = ScheduleGenerator.generateMonth(
            year: 2026, month: 4, texture: .dry, solutions: solutions
        )
        let maskDays = days.filter { $0.activities.contains(.mask) }
        // Should have some mask days
        XCTAssertGreaterThan(maskDays.count, 0)
    }

    func test_scheduleGenerator_includes_trim_reminder() {
        let solutions = HairSolutionsData.allSolutions.filter { $0.helpsWith.contains(.damaged) }
        let days = ScheduleGenerator.generateMonth(
            year: 2026, month: 4, texture: .damaged, solutions: solutions
        )
        let trimDays = days.filter { $0.activities.contains(.trim) }
        // One trim reminder per month
        XCTAssertEqual(trimDays.count, 1)
    }
}
```

- [ ] **Step 2: Run tests to verify they fail**

Run: `cd /Users/ericfriedman/Dropbox/Documents/AI/claude/hairagent && swift test --filter ScheduleModelTests 2>&1 | tail -20`
Expected: Compilation errors (types not defined)

- [ ] **Step 3: Write the ScheduleModels implementation**

```swift
// HairAgent/Models/ScheduleModels.swift
import Foundation

enum ScheduleActivityType: String, CaseIterable, Identifiable {
    case wash
    case mask
    case trim
    case scalpCare
    case heatFree
    case protectiveStyle

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .wash: return "Wash Day"
        case .mask: return "Mask Day"
        case .trim: return "Trim"
        case .scalpCare: return "Scalp Care"
        case .heatFree: return "Heat-Free"
        case .protectiveStyle: return "Protective Style"
        }
    }

    var icon: String {
        switch self {
        case .wash: return "drop.fill"
        case .mask: return "theatermask.and.paintbrush.fill"
        case .trim: return "scissors"
        case .scalpCare: return "hand.raised.fingers.spread.fill"
        case .heatFree: return "flame.fill"
        case .protectiveStyle: return "shield.fill"
        }
    }

    var emoji: String {
        switch self {
        case .wash: return "🧴"
        case .mask: return "🧖"
        case .trim: return "💇"
        case .scalpCare: return "💆"
        case .heatFree: return "🚫🔥"
        case .protectiveStyle: return "🛡️"
        }
    }
}

struct DaySchedule: Identifiable {
    let id = UUID()
    let day: Int
    var activities: [ScheduleActivityType]
}

enum ScheduleGenerator {
    /// How many days in a given month/year
    static func daysInMonth(year: Int, month: Int) -> Int {
        var components = DateComponents()
        components.year = year
        components.month = month
        let calendar = Calendar.current
        guard let date = calendar.date(from: components),
              let range = calendar.range(of: .day, in: .month, for: date) else {
            return 30
        }
        return range.count
    }

    /// What weekday does day 1 fall on? (1 = Sunday, 7 = Saturday)
    static func firstWeekday(year: Int, month: Int) -> Int {
        var components = DateComponents()
        components.year = year
        components.month = month
        components.day = 1
        let calendar = Calendar.current
        guard let date = calendar.date(from: components) else { return 1 }
        return calendar.component(.weekday, from: date)
    }

    /// Generate a full month of scheduled activities based on hair type and matched solutions
    static func generateMonth(
        year: Int,
        month: Int,
        texture: HairTexture,
        solutions: [HairSolution]
    ) -> [DaySchedule] {
        let totalDays = daysInMonth(year: year, month: month)
        var days = (1...totalDays).map { DaySchedule(day: $0, activities: []) }

        // Wash frequency based on texture
        let washInterval: Int
        switch texture {
        case .oily: washInterval = 2    // every 2 days
        case .frizzy: washInterval = 3  // every 3 days
        case .dry: washInterval = 4     // every 4 days
        case .damaged: washInterval = 3 // every 3 days
        case .other: washInterval = 3
        }

        // Place wash days
        var day = 1
        while day <= totalDays {
            days[day - 1].activities.append(.wash)
            day += washInterval
        }

        // Mask days: based on whether moisturizing/protein/smoothing solutions matched
        let hasMaskSolution = solutions.contains { [.moisturizing, .protein, .smoothing].contains($0.solutionType) }
        if hasMaskSolution {
            let maskInterval: Int
            switch texture {
            case .dry, .frizzy: maskInterval = 4    // twice a week-ish
            case .damaged: maskInterval = 5          // about once a week
            case .oily: maskInterval = 10            // every ~10 days
            case .other: maskInterval = 7
            }
            var maskDay = 4 // offset from wash days
            while maskDay <= totalDays {
                if !days[maskDay - 1].activities.contains(.wash) {
                    days[maskDay - 1].activities.append(.mask)
                }
                maskDay += maskInterval
            }
        }

        // Scalp care: if scalp solution matched
        let hasScalpSolution = solutions.contains { $0.solutionType == .scalp }
        if hasScalpSolution {
            let scalpInterval: Int
            switch texture {
            case .oily: scalpInterval = 3
            case .dry: scalpInterval = 4
            default: scalpInterval = 4
            }
            var scalpDay = 5
            while scalpDay <= totalDays {
                if days[scalpDay - 1].activities.count < 2 {
                    days[scalpDay - 1].activities.append(.scalpCare)
                }
                scalpDay += scalpInterval
            }
        }

        // Heat-free days: 2 per week, scattered
        var heatFreeDay = 2
        while heatFreeDay <= totalDays {
            if days[heatFreeDay - 1].activities.isEmpty {
                days[heatFreeDay - 1].activities.append(.heatFree)
            }
            heatFreeDay += 4
        }

        // Protective style: once a week
        var protectDay = 7
        while protectDay <= totalDays {
            if days[protectDay - 1].activities.count < 2 {
                days[protectDay - 1].activities.append(.protectiveStyle)
            }
            protectDay += 7
        }

        // Trim reminder: one per month around the 15th
        let trimDay = min(15, totalDays)
        days[trimDay - 1].activities.append(.trim)

        return days
    }
}
```

- [ ] **Step 4: Run tests to verify they pass**

Run: `cd /Users/ericfriedman/Dropbox/Documents/AI/claude/hairagent && swift test --filter ScheduleModelTests 2>&1 | tail -20`
Expected: All 7 tests pass

- [ ] **Step 5: Commit**

```bash
cd /Users/ericfriedman/Dropbox/Documents/AI/claude/hairagent
git add HairAgent/Models/ScheduleModels.swift HairAgentTests/ScheduleModelTests.swift
git commit -m "feat: add schedule activity models and generator with tests"
```

---

### Task 2: Badge Models

**Files:**
- Create: `HairAgent/Models/BadgeModels.swift`
- Test: `HairAgentTests/BadgeModelTests.swift`

- [ ] **Step 1: Write the failing tests**

```swift
// HairAgentTests/BadgeModelTests.swift
import XCTest
@testable import HairAgent

final class BadgeModelTests: XCTestCase {

    func test_badgeType_has_all_types() {
        XCTAssertGreaterThanOrEqual(BadgeType.allCases.count, 7)
    }

    func test_badgeType_has_display_properties() {
        for badge in BadgeType.allCases {
            XCTAssertFalse(badge.displayName.isEmpty, "\(badge) missing displayName")
            XCTAssertFalse(badge.icon.isEmpty, "\(badge) missing icon")
            XCTAssertFalse(badge.subtitle.isEmpty, "\(badge) missing subtitle")
        }
    }

    func test_badgeType_has_unique_names() {
        let names = BadgeType.allCases.map(\.displayName)
        XCTAssertEqual(names.count, Set(names).count, "Badge names should be unique")
    }

    func test_earnedBadge_stores_date() {
        let badge = EarnedBadge(type: .moistureQueen, earnedDate: Date())
        XCTAssertEqual(badge.type, .moistureQueen)
        XCTAssertNotNil(badge.earnedDate)
    }
}
```

- [ ] **Step 2: Run tests to verify they fail**

Run: `cd /Users/ericfriedman/Dropbox/Documents/AI/claude/hairagent && swift test --filter BadgeModelTests 2>&1 | tail -20`
Expected: Compilation errors (types not defined)

- [ ] **Step 3: Write the BadgeModels implementation**

```swift
// HairAgent/Models/BadgeModels.swift
import SwiftUI

enum BadgeType: String, CaseIterable, Identifiable {
    case moistureQueen
    case frizzFighter
    case shineStar
    case scalpGuru
    case strengthBoss
    case maskMaster
    case consistencyChamp
    case heatFreeHero
    case protectivePro

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .moistureQueen: return "Moisture Queen"
        case .frizzFighter: return "Frizz Fighter"
        case .shineStar: return "Shine Star"
        case .scalpGuru: return "Scalp Guru"
        case .strengthBoss: return "Strength Boss"
        case .maskMaster: return "Mask Master"
        case .consistencyChamp: return "Consistency Champ"
        case .heatFreeHero: return "Heat-Free Hero"
        case .protectivePro: return "Protective Pro"
        }
    }

    var icon: String {
        switch self {
        case .moistureQueen: return "💖"
        case .frizzFighter: return "⚡"
        case .shineStar: return "✨"
        case .scalpGuru: return "🌿"
        case .strengthBoss: return "💪"
        case .maskMaster: return "🧖"
        case .consistencyChamp: return "🏆"
        case .heatFreeHero: return "🔥"
        case .protectivePro: return "🛡️"
        }
    }

    var subtitle: String {
        switch self {
        case .moistureQueen: return "Completed mask week"
        case .frizzFighter: return "Beat the frizz"
        case .shineStar: return "3 shine weeks done"
        case .scalpGuru: return "5 scalp care days"
        case .strengthBoss: return "Protein week done"
        case .maskMaster: return "10 masks completed"
        case .consistencyChamp: return "4 weeks in a row"
        case .heatFreeHero: return "No heat for 2 weeks"
        case .protectivePro: return "Protected all month"
        }
    }

    var gradientColors: (Color, Color) {
        switch self {
        case .moistureQueen: return (Color(red: 1.0, green: 0.41, blue: 0.71), Color(red: 1.0, green: 0.08, blue: 0.58))
        case .frizzFighter: return (Color(red: 0.53, green: 0.81, blue: 0.92), Color(red: 0.25, green: 0.41, blue: 0.88))
        case .shineStar: return (Color(red: 1.0, green: 0.84, blue: 0.0), Color(red: 1.0, green: 0.65, blue: 0.0))
        case .scalpGuru: return (Color(red: 0.60, green: 0.98, blue: 0.60), Color(red: 0.20, green: 0.80, blue: 0.20))
        case .strengthBoss: return (Color(red: 0.87, green: 0.63, blue: 0.87), Color(red: 0.58, green: 0.44, blue: 0.86))
        case .maskMaster: return (Color(red: 1.0, green: 0.71, blue: 0.76), Color(red: 1.0, green: 0.41, blue: 0.71))
        case .consistencyChamp: return (Color(red: 1.0, green: 0.84, blue: 0.0), Color(red: 1.0, green: 0.27, blue: 0.0))
        case .heatFreeHero: return (Color(red: 1.0, green: 0.60, blue: 0.56), Color(red: 1.0, green: 0.27, blue: 0.0))
        case .protectivePro: return (Color(red: 0.53, green: 0.81, blue: 0.92), Color(red: 0.20, green: 0.80, blue: 0.20))
        }
    }
}

struct EarnedBadge: Identifiable {
    let id = UUID()
    let type: BadgeType
    let earnedDate: Date
}
```

- [ ] **Step 4: Run tests to verify they pass**

Run: `cd /Users/ericfriedman/Dropbox/Documents/AI/claude/hairagent && swift test --filter BadgeModelTests 2>&1 | tail -20`
Expected: All 4 tests pass

- [ ] **Step 5: Commit**

```bash
cd /Users/ericfriedman/Dropbox/Documents/AI/claude/hairagent
git add HairAgent/Models/BadgeModels.swift HairAgentTests/BadgeModelTests.swift
git commit -m "feat: add badge type definitions and earned badge model with tests"
```

---

## Chunk 2: Calendar Views

### Task 3: Month List View

**Files:**
- Create: `HairAgent/Views/MonthListView.swift`
- Modify: `HairAgent/Views/Components/DecorativeBackground.swift` (add `.calendar` style)

The month list shows all 12 months as white rounded-rect cards in a scrollable list. The current month is highlighted with a hot pink border and sparkles. Past months show earned badge stars. Future months show a lock icon and "Coming soon". Tapping a month calls `onSelectMonth(year, month)`.

- [ ] **Step 1: Add `.calendar` background style**

In `DecorativeBackground.swift`, add `case calendar` to the `Style` enum. Gradient colors: `[AppTheme.pastelPink.opacity(0.45), AppTheme.pastelYellow.opacity(0.4), AppTheme.pastelBlue.opacity(0.35)]`. Set `hasExtraDecorations` to true for `.calendar`.

- [ ] **Step 2: Write MonthListView**

```swift
// HairAgent/Views/MonthListView.swift
import SwiftUI

struct MonthListView: View {
    let texture: HairTexture
    let solutions: [HairSolution]
    let earnedBadges: [EarnedBadge]
    var onSelectMonth: (Int, Int) -> Void  // (year, month)

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
                    Text("🔒")
                        .font(.system(size: 20))
                        .opacity(0.6)
                } else {
                    // Show star badges
                    HStack(spacing: 4) {
                        ForEach(0..<badgeCountForMonth(month), id: \.self) { _ in
                            Text("⭐")
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
        // For demo: past months get 2-3 stars, current month gets earned count
        if month < currentMonth {
            return min(month % 3 + 2, 4)
        } else if month == currentMonth {
            return earnedBadges.count
        }
        return 0
    }
}
```

- [ ] **Step 3: Run `swift build` to verify compilation**

Run: `cd /Users/ericfriedman/Dropbox/Documents/AI/claude/hairagent && swift build 2>&1 | tail -10`
Expected: Build succeeds

- [ ] **Step 4: Commit**

```bash
cd /Users/ericfriedman/Dropbox/Documents/AI/claude/hairagent
git add HairAgent/Views/MonthListView.swift HairAgent/Views/Components/DecorativeBackground.swift
git commit -m "feat: add MonthListView with 12-month card layout and calendar background style"
```

---

### Task 4: Month Calendar Grid View

**Files:**
- Create: `HairAgent/Views/MonthCalendarView.swift`

The calendar grid shows a 7-column layout (Sun-Sat) for one month. Each day cell shows the day number and activity emoji icons. A legend at the bottom shows all activity types. Uses ScheduleGenerator to build the data.

- [ ] **Step 1: Write MonthCalendarView**

```swift
// HairAgent/Views/MonthCalendarView.swift
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
            // Header with back button
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

            // Weekday headers
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 3), count: 7), spacing: 3) {
                ForEach(weekdayHeaders, id: \.self) { day in
                    Text(day)
                        .font(AppTheme.headingFont(size: 12))
                        .foregroundStyle(.gray)
                        .frame(maxWidth: .infinity)
                }
            }
            .padding(.horizontal, 8)

            // Calendar grid
            ScrollView {
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 3), count: 7), spacing: 3) {
                    // Empty cells before first day
                    ForEach(0..<(firstWeekday - 1), id: \.self) { _ in
                        Color.clear.frame(height: 72)
                    }

                    // Day cells
                    ForEach(schedule) { daySchedule in
                        dayCell(daySchedule)
                    }
                }
                .padding(.horizontal, 8)

                // Week completion banner (if any completed days)
                if completedDays.count >= 7 {
                    weekCompletionBanner
                }

                // Legend
                legendView
                    .padding(.top, 12)
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
                    VStack(spacing: 1) {
                        ForEach(daySchedule.activities.prefix(2), id: \.rawValue) { activity in
                            Text(activity.emoji)
                                .font(.system(size: 10))
                        }
                    }
                }

                if isCompleted {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 10))
                        .foregroundStyle(.green)
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 72)
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
        // Check if user completed 7 consecutive days
        if completedDays.count >= 7 {
            let alreadyEarned = Set(earnedBadges.map(\.type))
            // Award a badge based on what solutions the user has
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
        HStack(spacing: 8) {
            ForEach(ScheduleActivityType.allCases) { activity in
                HStack(spacing: 4) {
                    Text(activity.emoji)
                        .font(.system(size: 12))
                    Text(activity.displayName)
                        .font(AppTheme.bodyFont(size: 11))
                }
                .padding(.horizontal, 8)
                .padding(.vertical, 5)
                .background(.white)
                .clipShape(RoundedRectangle(cornerRadius: 8))
            }
        }
        .padding(.horizontal)
    }
}
```

- [ ] **Step 2: Run `swift build` to verify compilation**

Run: `cd /Users/ericfriedman/Dropbox/Documents/AI/claude/hairagent && swift build 2>&1 | tail -10`
Expected: Build succeeds

- [ ] **Step 3: Commit**

```bash
cd /Users/ericfriedman/Dropbox/Documents/AI/claude/hairagent
git add HairAgent/Views/MonthCalendarView.swift
git commit -m "feat: add MonthCalendarView with calendar grid, activity icons, and day completion"
```

---

## Chunk 3: Badge Views + Confetti

### Task 5: Confetti Animation

**Files:**
- Create: `HairAgent/Views/Components/ConfettiView.swift`

Animated confetti particles that fall from the top of the screen. Uses hearts, stars, sparkles in the app's pastel colors. Pure SwiftUI with TimelineView for animation.

- [ ] **Step 1: Write ConfettiView**

```swift
// HairAgent/Views/Components/ConfettiView.swift
import SwiftUI

struct ConfettiPiece: Identifiable {
    let id = UUID()
    let emoji: String
    let x: CGFloat        // horizontal position (0-1)
    let speed: Double     // fall speed multiplier
    let rotation: Double  // rotation angle
    let size: CGFloat
    let delay: Double     // start delay
}

struct ConfettiView: View {
    @State private var animate = false

    private let pieces: [ConfettiPiece] = {
        let emojis = ["🎉", "🎊", "⭐", "💖", "✨", "💗", "🌟", "💫", "🎀", "❤️", "💜", "💛"]
        var result: [ConfettiPiece] = []
        for i in 0..<40 {
            result.append(ConfettiPiece(
                emoji: emojis[i % emojis.count],
                x: CGFloat.random(in: 0.0...1.0),
                speed: Double.random(in: 0.6...1.4),
                rotation: Double.random(in: -30...30),
                size: CGFloat.random(in: 16...32),
                delay: Double.random(in: 0...0.8)
            ))
        }
        return result
    }()

    var body: some View {
        GeometryReader { geo in
            ZStack {
                ForEach(pieces) { piece in
                    Text(piece.emoji)
                        .font(.system(size: piece.size))
                        .rotationEffect(.degrees(animate ? piece.rotation + 360 : piece.rotation))
                        .position(
                            x: piece.x * geo.size.width,
                            y: animate
                                ? geo.size.height + 50
                                : -50
                        )
                        .animation(
                            .easeIn(duration: 2.5 * piece.speed)
                            .delay(piece.delay),
                            value: animate
                        )
                }
            }
        }
        .allowsHitTesting(false)
        .onAppear { animate = true }
    }
}
```

- [ ] **Step 2: Run `swift build` to verify compilation**

Run: `cd /Users/ericfriedman/Dropbox/Documents/AI/claude/hairagent && swift build 2>&1 | tail -10`
Expected: Build succeeds

- [ ] **Step 3: Commit**

```bash
cd /Users/ericfriedman/Dropbox/Documents/AI/claude/hairagent
git add HairAgent/Views/Components/ConfettiView.swift
git commit -m "feat: add ConfettiView with 40 animated emoji particles"
```

---

### Task 6: Badge Celebration Popup

**Files:**
- Create: `HairAgent/Views/Components/BadgeCelebrationView.swift`

A modal overlay that appears when a badge is earned. Dark semi-transparent backdrop, white card with badge icon, name, description, confetti overlay, and an "Awesome!" dismiss button.

- [ ] **Step 1: Write BadgeCelebrationView**

```swift
// HairAgent/Views/Components/BadgeCelebrationView.swift
import SwiftUI

struct BadgeCelebrationView: View {
    let badge: BadgeType
    let totalEarned: Int
    let totalPossible: Int
    var onDismiss: () -> Void

    var body: some View {
        ZStack {
            // Dark backdrop
            Color.black.opacity(0.6)
                .ignoresSafeArea()
                .onTapGesture(perform: onDismiss)

            // Confetti layer
            ConfettiView()
                .ignoresSafeArea()

            // Badge card
            VStack(spacing: 16) {
                Text("🎉 Badge Earned! 🎉")
                    .font(AppTheme.headingFont(size: 22))
                    .foregroundStyle(AppTheme.hotPink)

                // Badge circle
                let colors = badge.gradientColors
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [colors.0, colors.1],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 90, height: 90)
                        .shadow(color: colors.1.opacity(0.4), radius: 8, y: 4)

                    Text(badge.icon)
                        .font(.system(size: 42))
                }

                Text(badge.displayName)
                    .font(AppTheme.headingFont(size: 24))
                    .foregroundStyle(AppTheme.textPrimary)

                Text(badge.subtitle)
                    .font(AppTheme.bodyFont(size: 15))
                    .foregroundStyle(.gray)

                Text("Badge \(totalEarned) of \(totalPossible) earned!")
                    .font(AppTheme.bodyFont(size: 14))
                    .foregroundStyle(AppTheme.hotPink)
                    .padding(.top, 4)

                Button(action: onDismiss) {
                    Text("Awesome! 🎉")
                        .font(AppTheme.headingFont(size: 17))
                        .foregroundStyle(.white)
                        .padding(.horizontal, 36)
                        .padding(.vertical, 14)
                        .background(AppTheme.hotPink)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                }
                .padding(.top, 8)
            }
            .padding(36)
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 28))
            .shadow(color: AppTheme.hotPink.opacity(0.3), radius: 16, y: 8)
            .padding(.horizontal, 40)
        }
    }
}
```

- [ ] **Step 2: Run `swift build` to verify compilation**

Run: `cd /Users/ericfriedman/Dropbox/Documents/AI/claude/hairagent && swift build 2>&1 | tail -10`
Expected: Build succeeds

- [ ] **Step 3: Commit**

```bash
cd /Users/ericfriedman/Dropbox/Documents/AI/claude/hairagent
git add HairAgent/Views/Components/BadgeCelebrationView.swift
git commit -m "feat: add BadgeCelebrationView with confetti overlay and dismiss button"
```

---

### Task 7: Badge Trophy Shelf View

**Files:**
- Create: `HairAgent/Views/BadgeTrophyShelfView.swift`
- Modify: `HairAgent/Views/Components/DecorativeBackground.swift` (add `.badges` style)

3-column grid of all badge types. Earned badges show their gradient circle and icon. Locked badges show a gray circle with a lock icon. Count shows "N badges earned -- keep going!"

- [ ] **Step 1: Add `.badges` background style**

In `DecorativeBackground.swift`, add `case badges` to the `Style` enum. Gradient colors: `[AppTheme.pastelYellow.opacity(0.45), AppTheme.pastelPink.opacity(0.4), AppTheme.pastelBlue.opacity(0.35)]`. Set `hasExtraDecorations` to true for `.badges`.

- [ ] **Step 2: Write BadgeTrophyShelfView**

```swift
// HairAgent/Views/BadgeTrophyShelfView.swift
import SwiftUI

struct BadgeTrophyShelfView: View {
    let earnedBadges: [EarnedBadge]

    private var earnedTypes: Set<BadgeType> {
        Set(earnedBadges.map(\.type))
    }

    var body: some View {
        VStack(spacing: 16) {
            Text("My Badges")
                .font(AppTheme.headingFont(size: 28))
                .foregroundStyle(AppTheme.textPrimary)

            Text("\(earnedBadges.count) badges earned -- keep going!")
                .font(AppTheme.bodyFont(size: 15))
                .foregroundStyle(.gray)

            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 16), count: 3), spacing: 16) {
                ForEach(BadgeType.allCases) { badgeType in
                    badgeCell(badgeType, earned: earnedTypes.contains(badgeType))
                }
            }
            .padding(.horizontal)
        }
    }

    @ViewBuilder
    private func badgeCell(_ badgeType: BadgeType, earned: Bool) -> some View {
        VStack(spacing: 8) {
            if earned {
                let colors = badgeType.gradientColors
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [colors.0, colors.1],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 68, height: 68)
                        .shadow(color: colors.1.opacity(0.4), radius: 6, y: 3)

                    Text(badgeType.icon)
                        .font(.system(size: 30))
                }
            } else {
                ZStack {
                    Circle()
                        .fill(Color.gray.opacity(0.2))
                        .frame(width: 68, height: 68)

                    Text("🔒")
                        .font(.system(size: 30))
                }
            }

            Text(earned ? badgeType.displayName : "???")
                .font(AppTheme.headingFont(size: 13))
                .foregroundStyle(earned ? AppTheme.textPrimary : .gray.opacity(0.5))

            Text(earned ? badgeType.subtitle : "Keep going!")
                .font(AppTheme.bodyFont(size: 11))
                .foregroundStyle(earned ? .gray : .gray.opacity(0.4))
        }
        .padding(16)
        .background(.white.opacity(earned ? 0.9 : 0.5))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}
```

- [ ] **Step 3: Run `swift build` to verify compilation**

Run: `cd /Users/ericfriedman/Dropbox/Documents/AI/claude/hairagent && swift build 2>&1 | tail -10`
Expected: Build succeeds

- [ ] **Step 4: Commit**

```bash
cd /Users/ericfriedman/Dropbox/Documents/AI/claude/hairagent
git add HairAgent/Views/BadgeTrophyShelfView.swift HairAgent/Views/Components/DecorativeBackground.swift
git commit -m "feat: add BadgeTrophyShelfView with earned/locked states and badges background"
```

---

## Chunk 4: Integration + Double-Tap Fix

### Task 8: Fix Button Double-Tap Lag

**Files:**
- Modify: `HairAgent/ContentView.swift:88`

The `.animation(.easeInOut(duration: 0.3), value: currentScreen)` modifier on the `Group` in ContentView causes a double-tap issue. The animation modifier intercepts the first tap to trigger animation state, requiring a second tap for the action. Fix: remove the `.animation` modifier and wrap each screen transition in `withAnimation` instead.

- [ ] **Step 1: Update ContentView**

Remove the `.animation(.easeInOut(duration: 0.3), value: currentScreen)` line (line 88). Then wrap every `currentScreen = ...` assignment inside `withAnimation(.easeInOut(duration: 0.3)) { }`. There are 7 places:
1. Line 38: `currentScreen = .nameEntry`
2. Line 51: `currentScreen = .results` (in onBack)
3. Line 53: `currentScreen = .nameEntry` (in onBack)
4. Line 60: `currentScreen = .results` (in onComplete)
5. Line 71: `currentScreen = .tipDetail(solution)` (in onSelectSolution)
6. Line 74: `currentScreen = .quiz` (in onRetakeQuiz)
7. Line 84: `currentScreen = .results` (in TipDetailView onBack)

- [ ] **Step 2: Run `swift build` to verify compilation**

Run: `cd /Users/ericfriedman/Dropbox/Documents/AI/claude/hairagent && swift build 2>&1 | tail -10`
Expected: Build succeeds

- [ ] **Step 3: Run all tests**

Run: `cd /Users/ericfriedman/Dropbox/Documents/AI/claude/hairagent && swift test 2>&1 | tail -20`
Expected: All tests pass (no logic changes)

- [ ] **Step 4: Commit**

```bash
cd /Users/ericfriedman/Dropbox/Documents/AI/claude/hairagent
git add HairAgent/ContentView.swift
git commit -m "fix: replace .animation modifier with withAnimation to fix button double-tap lag"
```

---

### Task 9: Wire Everything Together

**Files:**
- Modify: `HairAgent/Views/ResultsView.swift` -- expand tabs to 4: My Solutions, Calendar, Badges, My Schedule
- Modify: `HairAgent/ContentView.swift` -- add badge state, calendar navigation, celebration popup overlay

- [ ] **Step 1: Update ResultsTab and ResultsView**

Add new cases to `ResultsTab`: `.calendar`, `.badges`. Update the tab bar to show 4 tabs. Update the switch to render `MonthListView` and `BadgeTrophyShelfView`. Add state for `earnedBadges`, `showCelebration`, `celebrationBadge`. Add callbacks: `onSelectMonth`, `onEarnBadge`.

The tab bar should show: "Solutions" | "Calendar" | "Badges" | "Schedule" -- with the pastel coral highlight for the active tab.

- [ ] **Step 2: Update ContentView**

Add new `AppScreen` cases: `.monthCalendar(Int, Int)` for the calendar drill-down. Add `@State var earnedBadges: [EarnedBadge] = []`, `@State var showCelebration = false`, `@State var celebrationBadge: BadgeType?`.

In the `.results` case, pass `earnedBadges`, `onSelectMonth` (navigates to `.monthCalendar`), `onEarnBadge` (triggers celebration).

Add a new `case .monthCalendar(let year, let month)` to the switch, rendering `MonthCalendarView`.

Wrap the main `Group` in a ZStack. After the Group, add the celebration popup overlay:
```swift
if showCelebration, let badge = celebrationBadge {
    BadgeCelebrationView(...)
}
```

- [ ] **Step 3: Run `swift build` to verify compilation**

Run: `cd /Users/ericfriedman/Dropbox/Documents/AI/claude/hairagent && swift build 2>&1 | tail -10`
Expected: Build succeeds

- [ ] **Step 4: Run all tests**

Run: `cd /Users/ericfriedman/Dropbox/Documents/AI/claude/hairagent && swift test 2>&1 | tail -20`
Expected: All tests pass

- [ ] **Step 5: Commit**

```bash
cd /Users/ericfriedman/Dropbox/Documents/AI/claude/hairagent
git add HairAgent/Views/ResultsView.swift HairAgent/ContentView.swift
git commit -m "feat: wire up calendar, badges, and celebration popup into main navigation"
```

---

### Task 10: Regenerate Xcode Project + Simulator Test

**Files:**
- Run xcodegen to regenerate the Xcode project after adding new files

- [ ] **Step 1: Regenerate Xcode project**

Run: `cd /Users/ericfriedman/Dropbox/Documents/AI/claude/hairagent && xcodegen generate`
Expected: "Project generated"

- [ ] **Step 2: Build for iPad simulator**

Use XcodeBuildMCP tools: set session defaults, then build and run on iPad Pro 13-inch simulator.

- [ ] **Step 3: Verify all tests pass**

Run: `cd /Users/ericfriedman/Dropbox/Documents/AI/claude/hairagent && swift test 2>&1 | tail -20`
Expected: All tests pass (33 existing + 11 new = 44 tests)

- [ ] **Step 4: Commit**

```bash
cd /Users/ericfriedman/Dropbox/Documents/AI/claude/hairagent
git add -A
git commit -m "chore: regenerate Xcode project with v3 calendar and badge files"
```
