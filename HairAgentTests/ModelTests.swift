import XCTest
@testable import HairAgent

final class ModelTests: XCTestCase {

    func test_hairColor_has_other_option() {
        XCTAssertTrue(HairColor.allCases.contains(.other))
    }

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
        profile.hairColor = .brown
        profile.hairTexture = .dry
        profile.hairGoals = [.addShine, .repairDamage, .growLonger]
        XCTAssertEqual(profile.hairColor, .brown)
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
            goalTags: [.addShine, .repairDamage]
        )
        XCTAssertEqual(solution.title, "Honey Mask")
        XCTAssertEqual(solution.ingredients.count, 2)
        XCTAssertEqual(solution.steps.count, 4)
    }

    func test_hairSolution_matches_texture_and_goals() {
        let solution = HairSolution(
            title: "Honey Mask",
            imageName: "honey_mask",
            ingredients: ["honey"],
            steps: ["apply"],
            helpsWith: [.dry],
            goalTags: [.addShine, .repairDamage]
        )
        XCTAssertTrue(solution.matches(texture: .dry, goals: [.addShine, .growLonger]))
        XCTAssertFalse(solution.matches(texture: .oily, goals: [.growLonger]))
    }
}
