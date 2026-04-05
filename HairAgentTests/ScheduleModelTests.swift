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
        XCTAssertEqual(days.count, 30)
    }

    func test_scheduleGenerator_assigns_wash_days() {
        let solutions = HairSolutionsData.allSolutions.filter { $0.helpsWith.contains(.oily) }
        let days = ScheduleGenerator.generateMonth(
            year: 2026, month: 4, texture: .oily, solutions: solutions
        )
        let washDays = days.filter { $0.activities.contains(.wash) }
        XCTAssertGreaterThanOrEqual(washDays.count, 8)
    }

    func test_scheduleGenerator_assigns_mask_days() {
        let solutions = HairSolutionsData.allSolutions.filter { $0.helpsWith.contains(.dry) }
        let days = ScheduleGenerator.generateMonth(
            year: 2026, month: 4, texture: .dry, solutions: solutions
        )
        let maskDays = days.filter { $0.activities.contains(.mask) }
        XCTAssertGreaterThan(maskDays.count, 0)
    }

    func test_scheduleGenerator_includes_trim_reminder() {
        let solutions = HairSolutionsData.allSolutions.filter { $0.helpsWith.contains(.damaged) }
        let days = ScheduleGenerator.generateMonth(
            year: 2026, month: 4, texture: .damaged, solutions: solutions
        )
        let trimDays = days.filter { $0.activities.contains(.trim) }
        XCTAssertEqual(trimDays.count, 1)
    }
}
