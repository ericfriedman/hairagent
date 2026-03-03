import XCTest
@testable import HairAgent

final class HairColorSelectionTests: XCTestCase {

    func test_selectedHairColor_stores_rgb_and_label() {
        let color = SelectedHairColor(red: 0.5, green: 0.3, blue: 0.1, label: "Brown")
        XCTAssertEqual(color.red, 0.5)
        XCTAssertEqual(color.green, 0.3)
        XCTAssertEqual(color.blue, 0.1)
        XCTAssertEqual(color.label, "Brown")
    }

    func test_selectedHairColor_equality() {
        let a = SelectedHairColor(red: 0.5, green: 0.3, blue: 0.1, label: "Brown")
        let b = SelectedHairColor(red: 0.5, green: 0.3, blue: 0.1, label: "Brown")
        XCTAssertEqual(a, b)
    }

    func test_selectedHairColor_codable() throws {
        let original = SelectedHairColor(red: 0.9, green: 0.78, blue: 0.5, label: "Blonde")
        let data = try JSONEncoder().encode(original)
        let decoded = try JSONDecoder().decode(SelectedHairColor.self, from: data)
        XCTAssertEqual(decoded, original)
    }

    func test_gradient_has_at_least_15_stops() {
        XCTAssertGreaterThanOrEqual(HairColorGradient.stops.count, 15)
    }

    func test_gradient_starts_with_black() {
        XCTAssertEqual(HairColorGradient.stops.first?.label, "Black")
    }

    func test_gradient_ends_with_purple() {
        XCTAssertEqual(HairColorGradient.stops.last?.label, "Purple")
    }

    func test_gradient_includes_rainbow_colors() {
        let labels = HairColorGradient.stops.map(\.label)
        XCTAssertTrue(labels.contains("Pink"))
        XCTAssertTrue(labels.contains("Blue"))
        XCTAssertTrue(labels.contains("Green"))
    }

    func test_gradient_interpolate_at_zero_is_black() {
        let color = HairColorGradient.interpolate(at: 0.0)
        XCTAssertEqual(color.label, "Black")
        XCTAssertLessThan(color.red, 0.1)
    }

    func test_gradient_interpolate_at_one_is_purple() {
        let color = HairColorGradient.interpolate(at: 1.0)
        XCTAssertEqual(color.label, "Purple")
    }

    func test_gradient_interpolate_midpoint_returns_natural_color() {
        let color = HairColorGradient.interpolate(at: 0.25)
        let naturalLabels = ["Dark Brown", "Auburn", "Medium Brown"]
        XCTAssertTrue(naturalLabels.contains(color.label))
    }

    func test_gradient_interpolate_clamps_below_zero() {
        let color = HairColorGradient.interpolate(at: -0.5)
        XCTAssertEqual(color.label, "Black")
    }

    func test_gradient_interpolate_clamps_above_one() {
        let color = HairColorGradient.interpolate(at: 1.5)
        XCTAssertEqual(color.label, "Purple")
    }
}
