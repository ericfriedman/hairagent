import XCTest
@testable import HairAgent

final class SolutionDataTests: XCTestCase {
    func test_allSolutions_is_not_empty() {
        XCTAssertFalse(HairSolutionsData.allSolutions.isEmpty)
    }

    func test_every_solution_has_at_least_one_ingredient() {
        for solution in HairSolutionsData.allSolutions {
            XCTAssertFalse(solution.ingredients.isEmpty, "\(solution.title) has no ingredients")
        }
    }

    func test_every_solution_has_at_least_one_step() {
        for solution in HairSolutionsData.allSolutions {
            XCTAssertFalse(solution.steps.isEmpty, "\(solution.title) has no steps")
        }
    }

    func test_every_solution_has_at_least_one_tag() {
        for solution in HairSolutionsData.allSolutions {
            XCTAssertFalse(solution.goalTags.isEmpty, "\(solution.title) has no goal tags")
        }
    }

    func test_filtering_by_dry_hair_returns_results() {
        let results = HairSolutionsData.solutions(for: .dry, goals: [.addShine])
        XCTAssertFalse(results.isEmpty)
    }
}
