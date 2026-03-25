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

    func test_every_solution_has_a_solution_type() {
        for solution in HairSolutionsData.allSolutions {
            XCTAssertFalse(solution.solutionType.rawValue.isEmpty, "\(solution.title) has no solution type")
        }
    }

    func test_every_solution_has_default_frequency() {
        for solution in HairSolutionsData.allSolutions {
            XCTAssertFalse(solution.defaultFrequency.isEmpty, "\(solution.title) has no default frequency")
        }
    }

    func test_every_solution_has_overuse_warning() {
        for solution in HairSolutionsData.allSolutions {
            XCTAssertFalse(solution.overuseWarning.isEmpty, "\(solution.title) has no overuse warning")
            XCTAssertNotEqual(solution.overuseWarning, "Placeholder", "\(solution.title) still has placeholder overuse warning")
        }
    }

    func test_every_solution_has_frequency_for_all_textures() {
        let textures: [HairTexture] = [.frizzy, .oily, .dry, .damaged]
        for solution in HairSolutionsData.allSolutions {
            for texture in textures {
                XCTAssertNotNil(
                    solution.frequencyByTexture[texture],
                    "\(solution.title) missing frequency for \(texture.rawValue)"
                )
            }
        }
    }
}
