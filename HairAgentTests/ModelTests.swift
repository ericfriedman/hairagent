import XCTest
@testable import HairAgent

final class ModelTests: XCTestCase {

    func test_hairTexture_has_other_option() {
        XCTAssertTrue(HairTexture.allCases.contains(.other))
    }

    func test_hairGoal_has_other_option() {
        XCTAssertTrue(HairGoal.allCases.contains(.other))
    }

    func test_userProfile_stores_name() {
        let profile = UserProfile(name: "Luna")
        XCTAssertEqual(profile.name, "Luna")
    }

    func test_userProfile_stores_quiz_answers() {
        let profile = UserProfile(name: "Luna")
        profile.selectedHairColor = SelectedHairColor(red: 0.48, green: 0.30, blue: 0.15, label: "Medium Brown")
        profile.hairTexture = .dry
        profile.hairGoals = [.addShine, .repairDamage, .growLonger]
        XCTAssertEqual(profile.selectedHairColor?.label, "Medium Brown")
        XCTAssertEqual(profile.hairTexture, .dry)
        XCTAssertEqual(profile.hairGoals.count, 3)
    }

    func test_hairSolution_has_required_fields() {
        let solution = HairSolution(
            title: "Honey Mask",
            imageName: "honey_mask",
            ingredients: ["2 tbsp honey", "1 tbsp olive oil"],
            steps: ["Mix together", "Apply to damp hair", "Wait 20 min", "Rinse"],
            helpsWith: [.dry, .damaged],
            goalTags: [.addShine, .repairDamage],
            solutionType: .moisturizing,
            defaultFrequency: "1-2 times per week",
            frequencyByTexture: [:],
            overuseWarning: "Be careful not to overdo it."
        )
        XCTAssertEqual(solution.title, "Honey Mask")
        XCTAssertEqual(solution.ingredients.count, 2)
        XCTAssertEqual(solution.steps.count, 4)
    }

    func test_solutionType_has_all_cases() {
        let types: [SolutionType] = [.moisturizing, .protein, .clarifying, .smoothing, .scalp, .strengthening]
        XCTAssertEqual(types.count, 6)
    }

    func test_hairSolution_has_frequency_fields() {
        let solution = HairSolution(
            title: "Test Mask",
            imageName: "test",
            ingredients: ["honey"],
            steps: ["apply"],
            helpsWith: [.dry],
            goalTags: [.addShine],
            solutionType: .moisturizing,
            defaultFrequency: "1-2 times per week",
            frequencyByTexture: [.dry: "2 times per week -- dry hair loves moisture"],
            overuseWarning: "Too much can weigh hair down."
        )
        XCTAssertEqual(solution.solutionType, .moisturizing)
        XCTAssertEqual(solution.defaultFrequency, "1-2 times per week")
        XCTAssertEqual(solution.frequencyByTexture[.dry], "2 times per week -- dry hair loves moisture")
        XCTAssertEqual(solution.overuseWarning, "Too much can weigh hair down.")
    }

    func test_hairSolution_matches_texture_and_goals() {
        let solution = HairSolution(
            title: "Honey Mask",
            imageName: "honey_mask",
            ingredients: ["honey"],
            steps: ["apply"],
            helpsWith: [.dry],
            goalTags: [.addShine, .repairDamage],
            solutionType: .moisturizing,
            defaultFrequency: "1-2 times per week",
            frequencyByTexture: [:],
            overuseWarning: "Be careful not to overdo it."
        )
        XCTAssertTrue(solution.matches(texture: .dry, goals: [.addShine, .growLonger]))
        XCTAssertFalse(solution.matches(texture: .oily, goals: [.growLonger]))
    }

    func test_userProfile_stores_selected_hair_color() {
        let profile = UserProfile(name: "Luna")
        let color = SelectedHairColor(red: 0.6, green: 0.2, blue: 0.1, label: "Auburn")
        profile.selectedHairColor = color
        XCTAssertEqual(profile.selectedHairColor?.label, "Auburn")
        XCTAssertEqual(profile.selectedHairColor?.red, 0.6)
    }
}
