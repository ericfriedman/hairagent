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
