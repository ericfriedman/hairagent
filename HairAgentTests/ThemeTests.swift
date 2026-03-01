import XCTest
@testable import HairAgent
import SwiftUI

final class ThemeTests: XCTestCase {
    func test_theme_has_all_brand_colors() {
        let colors: [Color] = [
            AppTheme.pastelPink,
            AppTheme.pastelBlue,
            AppTheme.pastelYellow,
            AppTheme.pastelCoral,
            AppTheme.background,
            AppTheme.textPrimary,
        ]
        XCTAssertEqual(colors.count, 6)
    }

    func test_theme_has_heading_and_body_fonts() {
        let heading = AppTheme.headingFont(size: 24)
        let body = AppTheme.bodyFont(size: 16)
        XCTAssertNotNil(heading)
        XCTAssertNotNil(body)
    }
}
