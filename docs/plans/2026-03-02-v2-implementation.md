# Hair Agent v2 Features Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Add three v2 features -- hair color gradient slider, before/after hair illustrations, and usage frequency recommendations with a My Schedule tab.

**Architecture:** Static content approach. All frequency data and illustration styles are hand-coded alongside existing solution data. Gradient slider replaces the card-based color picker. New color flows through to before/after illustrations. New tab on results screen shows frequency schedule.

**Tech Stack:** SwiftUI, SwiftData, Swift Package (iOS 17+ / macOS 14+). No UIKit. All `Color` values via AppTheme or explicit RGB. Run `swift test` for tests, `xcodegen generate` after adding files.

**Design docs:** `docs/plans/2026-03-02-v2-features-design.md`, `docs/plans/2026-03-02-usage-frequency-design.md`

---

### Task 1: Create SelectedHairColor and HairColorGradient models

**Files:**
- Create: `HairAgent/Models/HairColorSelection.swift`
- Create: `HairAgentTests/HairColorSelectionTests.swift`

**Step 1: Write the failing tests**

Create `HairAgentTests/HairColorSelectionTests.swift`:

```swift
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
```

**Step 2: Run tests to verify they fail**

Run: `swift test 2>&1 | tail -20`
Expected: Compilation error -- `SelectedHairColor` and `HairColorGradient` not defined

**Step 3: Implement SelectedHairColor and HairColorGradient**

Create `HairAgent/Models/HairColorSelection.swift`:

```swift
import SwiftUI

struct SelectedHairColor: Equatable, Codable {
    let red: Double
    let green: Double
    let blue: Double
    let label: String

    var color: Color {
        Color(red: red, green: green, blue: blue)
    }
}

struct HairColorStop {
    let position: Double
    let red: Double
    let green: Double
    let blue: Double
    let label: String
}

enum HairColorGradient {
    static let stops: [HairColorStop] = [
        // Natural hair colors
        HairColorStop(position: 0.00, red: 0.07, green: 0.06, blue: 0.06, label: "Black"),
        HairColorStop(position: 0.08, red: 0.26, green: 0.15, blue: 0.07, label: "Dark Brown"),
        HairColorStop(position: 0.16, red: 0.60, green: 0.20, blue: 0.10, label: "Auburn"),
        HairColorStop(position: 0.24, red: 0.48, green: 0.30, blue: 0.15, label: "Medium Brown"),
        HairColorStop(position: 0.32, red: 0.65, green: 0.45, blue: 0.25, label: "Light Brown"),
        HairColorStop(position: 0.40, red: 0.73, green: 0.60, blue: 0.35, label: "Dark Blonde"),
        HairColorStop(position: 0.48, red: 0.90, green: 0.78, blue: 0.50, label: "Blonde"),
        HairColorStop(position: 0.56, red: 0.94, green: 0.92, blue: 0.86, label: "Platinum"),
        // Rainbow / fun colors
        HairColorStop(position: 0.64, red: 1.00, green: 0.41, blue: 0.71, label: "Pink"),
        HairColorStop(position: 0.72, red: 0.90, green: 0.10, blue: 0.10, label: "Red"),
        HairColorStop(position: 0.78, red: 1.00, green: 0.55, blue: 0.00, label: "Orange"),
        HairColorStop(position: 0.84, red: 1.00, green: 0.87, blue: 0.00, label: "Yellow"),
        HairColorStop(position: 0.90, red: 0.00, green: 0.75, blue: 0.35, label: "Green"),
        HairColorStop(position: 0.95, red: 0.15, green: 0.40, blue: 0.95, label: "Blue"),
        HairColorStop(position: 1.00, red: 0.55, green: 0.15, blue: 0.80, label: "Purple"),
    ]

    static var swiftUIGradient: LinearGradient {
        LinearGradient(
            stops: stops.map { Gradient.Stop(color: Color(red: $0.red, green: $0.green, blue: $0.blue), location: $0.position) },
            startPoint: .leading,
            endPoint: .trailing
        )
    }

    static func interpolate(at position: Double) -> SelectedHairColor {
        let pos = max(0, min(1, position))

        // Find the two surrounding stops
        var lower = stops[0]
        var upper = stops[stops.count - 1]

        for i in 0..<(stops.count - 1) {
            if pos >= stops[i].position && pos <= stops[i + 1].position {
                lower = stops[i]
                upper = stops[i + 1]
                break
            }
        }

        let range = upper.position - lower.position
        let t = range > 0 ? (pos - lower.position) / range : 0

        return SelectedHairColor(
            red: lower.red + (upper.red - lower.red) * t,
            green: lower.green + (upper.green - lower.green) * t,
            blue: lower.blue + (upper.blue - lower.blue) * t,
            label: closestLabel(at: pos)
        )
    }

    static func closestLabel(at position: Double) -> String {
        let pos = max(0, min(1, position))
        var closest = stops[0]
        var minDist = Double.infinity
        for stop in stops {
            let dist = abs(stop.position - pos)
            if dist < minDist {
                minDist = dist
                closest = stop
            }
        }
        return closest.label
    }
}
```

**Step 4: Run tests to verify they pass**

Run: `swift test 2>&1 | tail -20`
Expected: All HairColorSelectionTests pass

**Step 5: Commit**

```bash
git add HairAgent/Models/HairColorSelection.swift HairAgentTests/HairColorSelectionTests.swift
git commit -m "feat: add SelectedHairColor and HairColorGradient models"
```

---

### Task 2: Add SolutionType enum and frequency fields to HairSolution

**Files:**
- Modify: `HairAgent/Models/QuizOptions.swift` (add SolutionType enum)
- Modify: `HairAgent/Models/HairSolution.swift` (add fields)
- Modify: `HairAgentTests/ModelTests.swift` (add tests)

**Step 1: Write the failing tests**

Add to `HairAgentTests/ModelTests.swift`:

```swift
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
```

**Step 2: Run tests to verify they fail**

Run: `swift test 2>&1 | tail -20`
Expected: Compilation error -- `SolutionType` not defined, `HairSolution` init missing new params

**Step 3: Add SolutionType and update HairSolution**

Add to the bottom of `HairAgent/Models/QuizOptions.swift`:

```swift
enum SolutionType: String, CaseIterable, Codable, Identifiable {
    case moisturizing
    case protein
    case clarifying
    case smoothing
    case scalp
    case strengthening

    var id: String { rawValue }

    var displayName: String {
        rawValue.capitalized
    }
}
```

Update `HairAgent/Models/HairSolution.swift` to add the new fields:

```swift
import Foundation

struct HairSolution: Identifiable {
    let id = UUID()
    let title: String
    let imageName: String
    let ingredients: [String]
    let steps: [String]
    let helpsWith: [HairTexture]
    let goalTags: [HairGoal]
    let solutionType: SolutionType
    let defaultFrequency: String
    let frequencyByTexture: [HairTexture: String]
    let overuseWarning: String

    func matches(texture: HairTexture, goals: [HairGoal]) -> Bool {
        let textureMatch = helpsWith.contains(texture)
        let goalMatch = goalTags.contains(where: { goals.contains($0) })
        return textureMatch || goalMatch
    }

    func personalizedFrequency(for texture: HairTexture) -> String {
        frequencyByTexture[texture] ?? defaultFrequency
    }
}
```

**Step 4: Fix existing tests and HairSolutionsData**

The existing code in `HairSolutionsData.swift` and `ModelTests.swift` creates `HairSolution` instances without the new fields. These will fail to compile. For now, give every existing `HairSolution(...)` call placeholder values so tests compile:

In `ModelTests.swift`, update the two tests that create HairSolution instances to include:
```swift
solutionType: .moisturizing,
defaultFrequency: "1-2 times per week",
frequencyByTexture: [:],
overuseWarning: "Be careful not to overdo it."
```

In `HairSolutionsData.swift`, add placeholder values to all 8 solutions temporarily (these get real content in Task 3):
```swift
solutionType: .moisturizing,
defaultFrequency: "1-2 times per week",
frequencyByTexture: [:],
overuseWarning: "Placeholder"
```

**Step 5: Run tests to verify they pass**

Run: `swift test 2>&1 | tail -20`
Expected: All tests pass

**Step 6: Commit**

```bash
git add HairAgent/Models/QuizOptions.swift HairAgent/Models/HairSolution.swift HairAgent/Data/HairSolutionsData.swift HairAgentTests/ModelTests.swift
git commit -m "feat: add SolutionType enum and frequency fields to HairSolution"
```

---

### Task 3: Add real frequency content to all 8 solutions

**Files:**
- Modify: `HairAgent/Data/HairSolutionsData.swift` (replace placeholders with real content)
- Modify: `HairAgentTests/SolutionDataTests.swift` (add validation tests)

**Step 1: Write the failing tests**

Add to `HairAgentTests/SolutionDataTests.swift`:

```swift
func test_every_solution_has_a_solution_type() {
    for solution in HairSolutionsData.allSolutions {
        // Just accessing it verifies the field exists and is set
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
```

**Step 2: Run tests to verify they fail**

Run: `swift test 2>&1 | tail -20`
Expected: Failures on empty placeholders and missing texture entries

**Step 3: Replace all 8 solutions with full content**

Replace the entire `allSolutions` array in `HairAgent/Data/HairSolutionsData.swift`:

```swift
static let allSolutions: [HairSolution] = [
    HairSolution(
        title: "Honey & Olive Oil Hair Mask",
        imageName: "honey_olive_mask",
        ingredients: ["2 tbsp honey", "1 tbsp olive oil"],
        steps: [
            "Mix honey and olive oil in a small bowl",
            "Apply to damp hair from roots to tips",
            "Leave on for 20 minutes",
            "Rinse with warm water and shampoo as usual"
        ],
        helpsWith: [.dry, .damaged],
        goalTags: [.addShine, .repairDamage, .stayHealthy],
        solutionType: .moisturizing,
        defaultFrequency: "1-2 times per week",
        frequencyByTexture: [
            .frizzy: "2 times per week -- helps smooth and add moisture",
            .oily: "Once a week -- too much oil can make oily hair heavier",
            .dry: "2 times per week -- dry hair drinks up the moisture",
            .damaged: "2 times per week -- gentle enough for regular use",
        ],
        overuseWarning: "Too much oil can make hair feel greasy and weigh it down. If your hair starts looking limp, cut back to once a week."
    ),
    HairSolution(
        title: "Egg & Yogurt Protein Treatment",
        imageName: "egg_yogurt_mask",
        ingredients: ["1 egg", "2 tbsp plain yogurt"],
        steps: [
            "Whisk egg and yogurt together until smooth",
            "Apply to damp hair, focusing on ends",
            "Cover with a shower cap for 20 minutes",
            "Rinse with cool water (not hot -- it will cook the egg!)"
        ],
        helpsWith: [.damaged, .frizzy],
        goalTags: [.repairDamage, .lessFrizz, .moreVolume],
        solutionType: .protein,
        defaultFrequency: "Once every 1-2 weeks",
        frequencyByTexture: [
            .frizzy: "Once a week -- helps strengthen and smooth",
            .oily: "Once every 2 weeks -- protein plus dairy can feel heavy",
            .dry: "Once a week -- dry hair loves extra protein",
            .damaged: "Once a week -- but take a break if hair feels stiff",
        ],
        overuseWarning: "Too much protein can cause hair to feel stiff, dry, or even snap. If your hair starts feeling crunchy or strawlike, take a 2-week break."
    ),
    HairSolution(
        title: "Coconut Oil Deep Condition",
        imageName: "coconut_oil_treatment",
        ingredients: ["2 tbsp coconut oil"],
        steps: [
            "Warm coconut oil in your hands until melted",
            "Work through hair from mid-length to tips",
            "Leave on for 30 minutes (or overnight with a towel on your pillow)",
            "Shampoo twice to fully rinse out"
        ],
        helpsWith: [.dry, .damaged, .frizzy],
        goalTags: [.addShine, .repairDamage, .lessFrizz, .stayHealthy],
        solutionType: .moisturizing,
        defaultFrequency: "1-2 times per week",
        frequencyByTexture: [
            .frizzy: "2 times per week -- great for taming frizz",
            .oily: "Once every 2 weeks -- coconut oil is heavy on oily hair",
            .dry: "2 times per week -- your hair will love it",
            .damaged: "Once a week -- gives damaged hair time to absorb",
        ],
        overuseWarning: "Coconut oil can build up and make hair feel greasy or heavy. If your hair stops feeling soft, take a break for a week and shampoo extra well."
    ),
    HairSolution(
        title: "Apple Cider Vinegar Rinse",
        imageName: "acv_rinse",
        ingredients: ["2 tbsp apple cider vinegar", "1 cup water"],
        steps: [
            "Mix apple cider vinegar with water",
            "After shampooing, pour mixture over hair",
            "Let it sit for 2 minutes",
            "Rinse with cool water"
        ],
        helpsWith: [.oily, .frizzy],
        goalTags: [.addShine, .lessOil, .lessFrizz],
        solutionType: .clarifying,
        defaultFrequency: "Once a week",
        frequencyByTexture: [
            .frizzy: "Once a week -- helps remove buildup that causes frizz",
            .oily: "1-2 times per week -- great for cutting through oil",
            .dry: "Once every 2 weeks -- too often can dry hair out more",
            .damaged: "Once every 2 weeks -- vinegar can be tough on weak hair",
        ],
        overuseWarning: "Apple cider vinegar is acidic. Using it too often can dry out your hair and irritate your scalp. If your scalp feels tingly or your hair feels dry, use it less often."
    ),
    HairSolution(
        title: "Banana & Honey Smoothing Mask",
        imageName: "banana_honey_mask",
        ingredients: ["1 ripe banana", "1 tbsp honey", "1 tbsp olive oil"],
        steps: [
            "Mash banana until very smooth (no lumps!)",
            "Mix in honey and olive oil",
            "Apply to damp hair and cover with shower cap",
            "Leave on for 15-20 minutes",
            "Rinse thoroughly with warm water"
        ],
        helpsWith: [.frizzy, .dry],
        goalTags: [.lessFrizz, .addShine, .stayHealthy],
        solutionType: .smoothing,
        defaultFrequency: "1-2 times per week",
        frequencyByTexture: [
            .frizzy: "2 times per week -- perfect for keeping frizz away",
            .oily: "Once a week -- banana and honey are gentle but rich",
            .dry: "2 times per week -- adds moisture and smoothness",
            .damaged: "Once a week -- gentle enough for regular use",
        ],
        overuseWarning: "Banana masks are gentle, but using any mask too often can weigh hair down. If your hair feels heavy or flat, take a few days off."
    ),
    HairSolution(
        title: "Aloe Vera Scalp Soother",
        imageName: "aloe_vera_scalp",
        ingredients: ["2 tbsp aloe vera gel (from the plant or store-bought pure gel)"],
        steps: [
            "Apply aloe vera gel directly to scalp",
            "Massage gently for 2 minutes",
            "Leave on for 15 minutes",
            "Rinse and shampoo as usual"
        ],
        helpsWith: [.dry, .oily],
        goalTags: [.stayHealthy, .lessOil, .growLonger],
        solutionType: .scalp,
        defaultFrequency: "2-3 times per week",
        frequencyByTexture: [
            .frizzy: "2 times per week -- soothes and hydrates",
            .oily: "2-3 times per week -- aloe is light and will not add oil",
            .dry: "2-3 times per week -- great for a dry scalp",
            .damaged: "2 times per week -- gentle on sensitive scalps",
        ],
        overuseWarning: "Aloe vera is one of the gentlest treatments, but if you notice any itching or redness, your skin might be sensitive to it. Try a small patch test first."
    ),
    HairSolution(
        title: "Rice Water Strength Rinse",
        imageName: "rice_water_rinse",
        ingredients: ["1/2 cup uncooked rice", "2 cups water"],
        steps: [
            "Rinse rice, then soak in water for 30 minutes",
            "Strain and keep the cloudy water",
            "After shampooing, pour rice water over hair",
            "Massage into scalp for 2 minutes",
            "Rinse with plain water"
        ],
        helpsWith: [.damaged],
        goalTags: [.growLonger, .repairDamage, .moreVolume],
        solutionType: .strengthening,
        defaultFrequency: "Once a week",
        frequencyByTexture: [
            .frizzy: "Once a week -- builds strength without weighing down",
            .oily: "Once a week -- rice water is light",
            .dry: "Once a week -- can dry hair out if used too often",
            .damaged: "Once a week -- great for rebuilding weak hair",
        ],
        overuseWarning: "Rice water is high in protein. Using it too often can make hair stiff and dry, especially if your hair does not need much protein. Stick to once a week max."
    ),
    HairSolution(
        title: "Avocado & Olive Oil Moisture Mask",
        imageName: "avocado_mask",
        ingredients: ["1 ripe avocado", "1 tbsp olive oil"],
        steps: [
            "Mash avocado until creamy",
            "Mix in olive oil",
            "Apply to damp hair from roots to ends",
            "Leave on for 20 minutes",
            "Rinse and shampoo as usual"
        ],
        helpsWith: [.dry, .damaged],
        goalTags: [.addShine, .repairDamage, .stayHealthy],
        solutionType: .moisturizing,
        defaultFrequency: "1-2 times per week",
        frequencyByTexture: [
            .frizzy: "2 times per week -- rich moisture tames frizz",
            .oily: "Once every 2 weeks -- avocado and oil are very rich",
            .dry: "2 times per week -- your hair will drink it up",
            .damaged: "Once a week -- deep moisture for repair",
        ],
        overuseWarning: "Avocado and olive oil are very rich. Too much can make hair greasy and flat. If your hair starts looking limp, cut back and shampoo well."
    ),
]
```

**Step 4: Run tests to verify they pass**

Run: `swift test 2>&1 | tail -20`
Expected: All tests pass including new validation tests

**Step 5: Commit**

```bash
git add HairAgent/Data/HairSolutionsData.swift HairAgentTests/SolutionDataTests.swift
git commit -m "feat: add frequency content and solution types for all 8 solutions"
```

---

### Task 4: Update UserProfile for gradient color storage

**Files:**
- Modify: `HairAgent/Models/UserProfile.swift`
- Modify: `HairAgentTests/ModelTests.swift`

**Step 1: Write the failing test**

Add to `HairAgentTests/ModelTests.swift`:

```swift
func test_userProfile_stores_selected_hair_color() {
    let profile = UserProfile(name: "Luna")
    let color = SelectedHairColor(red: 0.6, green: 0.2, blue: 0.1, label: "Auburn")
    profile.selectedHairColor = color
    XCTAssertEqual(profile.selectedHairColor?.label, "Auburn")
    XCTAssertEqual(profile.selectedHairColor?.red, 0.6)
}
```

**Step 2: Run tests to verify it fails**

Run: `swift test 2>&1 | tail -20`
Expected: Compilation error -- `selectedHairColor` not a property of UserProfile

**Step 3: Update UserProfile**

Replace `HairAgent/Models/UserProfile.swift` with:

```swift
import Foundation
import SwiftData

@Model
final class UserProfile {
    var name: String
    var hairColorRaw: String?
    var hairColorRed: Double?
    var hairColorGreen: Double?
    var hairColorBlue: Double?
    var hairColorLabel: String?
    var hairTextureRaw: String?
    var hairGoalRaws: [String]

    init(name: String) {
        self.name = name
        self.hairGoalRaws = []
    }

    // Legacy -- kept for backward compatibility
    var hairColor: HairColor? {
        get { hairColorRaw.flatMap { HairColor(rawValue: $0) } }
        set { hairColorRaw = newValue?.rawValue }
    }

    var selectedHairColor: SelectedHairColor? {
        get {
            guard let r = hairColorRed, let g = hairColorGreen, let b = hairColorBlue, let label = hairColorLabel else {
                return nil
            }
            return SelectedHairColor(red: r, green: g, blue: b, label: label)
        }
        set {
            hairColorRed = newValue?.red
            hairColorGreen = newValue?.green
            hairColorBlue = newValue?.blue
            hairColorLabel = newValue?.label
        }
    }

    var hairTexture: HairTexture? {
        get { hairTextureRaw.flatMap { HairTexture(rawValue: $0) } }
        set { hairTextureRaw = newValue?.rawValue }
    }

    var hairGoals: [HairGoal] {
        get { hairGoalRaws.compactMap { HairGoal(rawValue: $0) } }
        set { hairGoalRaws = newValue.map(\.rawValue) }
    }
}
```

**Step 4: Run tests to verify they pass**

Run: `swift test 2>&1 | tail -20`
Expected: All tests pass

**Step 5: Commit**

```bash
git add HairAgent/Models/UserProfile.swift HairAgentTests/ModelTests.swift
git commit -m "feat: add gradient color storage to UserProfile"
```

---

### Task 5: Build GradientSliderView component

**Files:**
- Create: `HairAgent/Views/Components/GradientSliderView.swift`

**Step 1: Create the gradient slider component**

Create `HairAgent/Views/Components/GradientSliderView.swift`:

```swift
import SwiftUI

struct GradientSliderView: View {
    @Binding var selectedColor: SelectedHairColor?
    @State private var sliderPosition: Double = 0.3

    var body: some View {
        VStack(spacing: 16) {
            // Color label
            Text(HairColorGradient.closestLabel(at: sliderPosition))
                .font(AppTheme.headingFont(size: 22))
                .foregroundStyle(AppTheme.textPrimary)
                .animation(.easeInOut(duration: 0.15), value: sliderPosition)

            // Selected color preview circle
            Circle()
                .fill(HairColorGradient.interpolate(at: sliderPosition).color)
                .frame(width: 60, height: 60)
                .overlay(
                    Circle()
                        .stroke(Color.white, lineWidth: 3)
                )
                .shadow(color: .black.opacity(0.15), radius: 4, y: 2)

            // Gradient bar with draggable thumb
            GeometryReader { geo in
                let barHeight: CGFloat = 40
                let thumbSize: CGFloat = 44

                ZStack(alignment: .leading) {
                    // Gradient bar
                    RoundedRectangle(cornerRadius: barHeight / 2)
                        .fill(HairColorGradient.swiftUIGradient)
                        .frame(height: barHeight)
                        .overlay(
                            RoundedRectangle(cornerRadius: barHeight / 2)
                                .stroke(Color.white, lineWidth: 2)
                        )

                    // Thumb
                    Circle()
                        .fill(HairColorGradient.interpolate(at: sliderPosition).color)
                        .frame(width: thumbSize, height: thumbSize)
                        .overlay(
                            Circle()
                                .stroke(Color.white, lineWidth: 3)
                        )
                        .shadow(color: .black.opacity(0.2), radius: 4, y: 2)
                        .offset(x: sliderPosition * (geo.size.width - thumbSize))
                }
                .frame(height: max(barHeight, thumbSize))
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { value in
                            let thumbSize: CGFloat = 44
                            let newPos = max(0, min(1, value.location.x / (geo.size.width - thumbSize + 1)))
                            sliderPosition = newPos
                            selectedColor = HairColorGradient.interpolate(at: newPos)
                        }
                )
            }
            .frame(height: 50)
        }
        .padding(.horizontal, 24)
        .onAppear {
            selectedColor = HairColorGradient.interpolate(at: sliderPosition)
        }
    }
}
```

**Step 2: Verify build**

Run: `swift build 2>&1 | tail -10`
Expected: Build succeeds

**Step 3: Commit**

```bash
git add HairAgent/Views/Components/GradientSliderView.swift
git commit -m "feat: add GradientSliderView component"
```

---

### Task 6: Build HairStrandsView for before/after illustrations

**Files:**
- Create: `HairAgent/Views/Components/HairStrandsView.swift`

**Step 1: Create the hair strands component**

Create `HairAgent/Views/Components/HairStrandsView.swift`:

```swift
import SwiftUI

// MARK: - Before hair strands (per texture)

struct BeforeHairStrands: Shape {
    let texture: HairTexture

    func path(in rect: CGRect) -> Path {
        switch texture {
        case .frizzy: return frizzyPath(in: rect)
        case .oily: return oilyPath(in: rect)
        case .dry: return dryPath(in: rect)
        case .damaged: return damagedPath(in: rect)
        case .other: return frizzyPath(in: rect)
        }
    }

    private func frizzyPath(in rect: CGRect) -> Path {
        // Zigzag strands going in different directions
        var path = Path()
        let strandCount = 5
        for i in 0..<strandCount {
            let x = rect.width * CGFloat(i + 1) / CGFloat(strandCount + 1)
            path.move(to: CGPoint(x: x, y: rect.minY + 4))
            let segments = 6
            for s in 1...segments {
                let y = rect.minY + 4 + (rect.height - 8) * CGFloat(s) / CGFloat(segments)
                let offset: CGFloat = ((s % 2 == 0) ? 1 : -1) * (6 + CGFloat(i % 3) * 2)
                path.addLine(to: CGPoint(x: x + offset, y: y))
            }
        }
        return path
    }

    private func oilyPath(in rect: CGRect) -> Path {
        // Strands that droop and clump together toward center
        var path = Path()
        let strandCount = 5
        let centerX = rect.midX
        for i in 0..<strandCount {
            let startX = rect.width * CGFloat(i + 1) / CGFloat(strandCount + 1)
            let endX = centerX + CGFloat(i - 2) * 4
            path.move(to: CGPoint(x: startX, y: rect.minY + 4))
            path.addQuadCurve(
                to: CGPoint(x: endX, y: rect.maxY - 4),
                control: CGPoint(x: (startX + endX) / 2, y: rect.height * 0.7)
            )
        }
        return path
    }

    private func dryPath(in rect: CGRect) -> Path {
        // Rough strands with small jitters
        var path = Path()
        let strandCount = 5
        for i in 0..<strandCount {
            let x = rect.width * CGFloat(i + 1) / CGFloat(strandCount + 1)
            path.move(to: CGPoint(x: x, y: rect.minY + 4))
            let segments = 8
            for s in 1...segments {
                let y = rect.minY + 4 + (rect.height - 8) * CGFloat(s) / CGFloat(segments)
                let jitter = CGFloat((s * (i + 1) * 7) % 11) / 11.0 * 5.0 - 2.5
                path.addLine(to: CGPoint(x: x + jitter, y: y))
            }
        }
        return path
    }

    private func damagedPath(in rect: CGRect) -> Path {
        // Strands with split/forked ends
        var path = Path()
        let strandCount = 5
        for i in 0..<strandCount {
            let x = rect.width * CGFloat(i + 1) / CGFloat(strandCount + 1)
            path.move(to: CGPoint(x: x, y: rect.minY + 4))
            let splitY = rect.maxY - rect.height * 0.25
            path.addLine(to: CGPoint(x: x, y: splitY))
            // Fork left
            path.addLine(to: CGPoint(x: x - 5, y: rect.maxY - 4))
            path.move(to: CGPoint(x: x, y: splitY))
            // Fork right
            path.addLine(to: CGPoint(x: x + 5, y: rect.maxY - 4))
        }
        return path
    }
}

// MARK: - After hair strands (per solution type)

struct AfterHairStrands: Shape {
    let solutionType: SolutionType

    func path(in rect: CGRect) -> Path {
        switch solutionType {
        case .moisturizing: return smoothPath(in: rect)
        case .protein: return strongPath(in: rect)
        case .clarifying: return cleanPath(in: rect)
        case .smoothing: return sleekPath(in: rect)
        case .scalp: return healthyPath(in: rect)
        case .strengthening: return bouncyPath(in: rect)
        }
    }

    private func smoothPath(in rect: CGRect) -> Path {
        // Smooth flowing S-curves
        var path = Path()
        let strandCount = 5
        for i in 0..<strandCount {
            let x = rect.width * CGFloat(i + 1) / CGFloat(strandCount + 1)
            path.move(to: CGPoint(x: x, y: rect.minY + 4))
            path.addCurve(
                to: CGPoint(x: x + 3, y: rect.maxY - 4),
                control1: CGPoint(x: x + 8, y: rect.height * 0.35),
                control2: CGPoint(x: x - 8, y: rect.height * 0.65)
            )
        }
        return path
    }

    private func strongPath(in rect: CGRect) -> Path {
        // Fuller, slightly wavy strands
        var path = Path()
        let strandCount = 6
        for i in 0..<strandCount {
            let x = rect.width * CGFloat(i + 1) / CGFloat(strandCount + 1)
            path.move(to: CGPoint(x: x, y: rect.minY + 4))
            path.addCurve(
                to: CGPoint(x: x + 2, y: rect.maxY - 4),
                control1: CGPoint(x: x + 5, y: rect.height * 0.4),
                control2: CGPoint(x: x - 3, y: rect.height * 0.7)
            )
        }
        return path
    }

    private func cleanPath(in rect: CGRect) -> Path {
        // Light, well-separated straight-ish strands
        var path = Path()
        let strandCount = 5
        for i in 0..<strandCount {
            let x = rect.width * CGFloat(i + 1) / CGFloat(strandCount + 1)
            path.move(to: CGPoint(x: x, y: rect.minY + 4))
            path.addCurve(
                to: CGPoint(x: x, y: rect.maxY - 4),
                control1: CGPoint(x: x + 3, y: rect.height * 0.3),
                control2: CGPoint(x: x - 2, y: rect.height * 0.7)
            )
        }
        return path
    }

    private func sleekPath(in rect: CGRect) -> Path {
        // Very straight, aligned strands
        var path = Path()
        let strandCount = 5
        for i in 0..<strandCount {
            let x = rect.width * CGFloat(i + 1) / CGFloat(strandCount + 1)
            path.move(to: CGPoint(x: x, y: rect.minY + 4))
            path.addCurve(
                to: CGPoint(x: x + 1, y: rect.maxY - 4),
                control1: CGPoint(x: x + 2, y: rect.height * 0.4),
                control2: CGPoint(x: x, y: rect.height * 0.6)
            )
        }
        return path
    }

    private func healthyPath(in rect: CGRect) -> Path {
        // Healthy roots flowing down
        var path = Path()
        let strandCount = 5
        for i in 0..<strandCount {
            let x = rect.width * CGFloat(i + 1) / CGFloat(strandCount + 1)
            path.move(to: CGPoint(x: x, y: rect.minY + 4))
            path.addCurve(
                to: CGPoint(x: x + CGFloat(i - 2) * 2, y: rect.maxY - 4),
                control1: CGPoint(x: x, y: rect.height * 0.3),
                control2: CGPoint(x: x + CGFloat(i - 2) * 3, y: rect.height * 0.6)
            )
        }
        return path
    }

    private func bouncyPath(in rect: CGRect) -> Path {
        // Thick, bouncy strands spread wide
        var path = Path()
        let strandCount = 6
        for i in 0..<strandCount {
            let startX = rect.width * CGFloat(i + 1) / CGFloat(strandCount + 1)
            let spread = CGFloat(i - strandCount / 2) * 3
            path.move(to: CGPoint(x: startX, y: rect.minY + 4))
            path.addCurve(
                to: CGPoint(x: startX + spread, y: rect.maxY - 4),
                control1: CGPoint(x: startX + 6, y: rect.height * 0.3),
                control2: CGPoint(x: startX + spread - 4, y: rect.height * 0.65)
            )
        }
        return path
    }
}

// MARK: - Combined before/after view for cards

struct BeforeAfterView: View {
    let hairColor: Color
    let texture: HairTexture
    let solutionType: SolutionType
    let size: CGSize

    var body: some View {
        HStack(spacing: 8) {
            // Before
            VStack(spacing: 4) {
                BeforeHairStrands(texture: texture)
                    .stroke(hairColor, style: StrokeStyle(lineWidth: 2.5, lineCap: .round))
                    .frame(width: size.width / 2 - 8, height: size.height - 20)

                Text("Before")
                    .font(AppTheme.bodyFont(size: 11))
                    .foregroundStyle(.gray)
            }

            // After
            VStack(spacing: 4) {
                ZStack {
                    // Glow layer
                    AfterHairStrands(solutionType: solutionType)
                        .stroke(hairColor.opacity(0.3), style: StrokeStyle(lineWidth: 6, lineCap: .round))
                        .blur(radius: 4)

                    // Main strands
                    AfterHairStrands(solutionType: solutionType)
                        .stroke(hairColor, style: StrokeStyle(lineWidth: 2.5, lineCap: .round))
                }
                .frame(width: size.width / 2 - 8, height: size.height - 20)

                Text("After")
                    .font(AppTheme.bodyFont(size: 11))
                    .foregroundStyle(.gray)
            }
        }
    }
}
```

**Step 2: Verify build**

Run: `swift build 2>&1 | tail -10`
Expected: Build succeeds

**Step 3: Commit**

```bash
git add HairAgent/Views/Components/HairStrandsView.swift
git commit -m "feat: add BeforeAfterView with hair strand illustrations"
```

---

### Task 7: Build FrequencyBadge and HowOftenSection components

**Files:**
- Create: `HairAgent/Views/Components/FrequencyBadge.swift`
- Create: `HairAgent/Views/Components/HowOftenSection.swift`

**Step 1: Create FrequencyBadge**

Create `HairAgent/Views/Components/FrequencyBadge.swift`:

```swift
import SwiftUI

struct FrequencyBadge: View {
    let text: String
    let color: Color

    var body: some View {
        Text(text)
            .font(AppTheme.bodyFont(size: 14))
            .foregroundStyle(.white)
            .padding(.horizontal, 14)
            .padding(.vertical, 6)
            .background(color)
            .clipShape(Capsule())
    }
}
```

**Step 2: Create HowOftenSection**

Create `HairAgent/Views/Components/HowOftenSection.swift`:

```swift
import SwiftUI

struct HowOftenSection: View {
    let solution: HairSolution
    let texture: HairTexture

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("How Often")
                .font(AppTheme.headingFont(size: 22))
                .foregroundStyle(AppTheme.textPrimary)

            // Default frequency
            HStack(spacing: 12) {
                Image(systemName: "calendar")
                    .font(.system(size: 22))
                    .foregroundStyle(AppTheme.pastelCoral)
                Text(solution.defaultFrequency)
                    .font(AppTheme.headingFont(size: 18))
                    .foregroundStyle(AppTheme.textPrimary)
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(.white.opacity(0.9))
            .clipShape(RoundedRectangle(cornerRadius: 14))

            // Personalized tip
            VStack(alignment: .leading, spacing: 8) {
                Text("Your Personal Tip")
                    .font(AppTheme.headingFont(size: 16))
                    .foregroundStyle(AppTheme.pastelBlue)

                Text("Since you have \(texture.displayName.lowercased()) hair: \(solution.personalizedFrequency(for: texture))")
                    .font(AppTheme.bodyFont(size: 16))
                    .foregroundStyle(AppTheme.textPrimary)
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(AppTheme.pastelBlue.opacity(0.15))
            .clipShape(RoundedRectangle(cornerRadius: 14))

            // Overuse warning
            VStack(alignment: .leading, spacing: 8) {
                HStack(spacing: 8) {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundStyle(AppTheme.pastelCoral)
                    Text("Watch Out!")
                        .font(AppTheme.headingFont(size: 16))
                        .foregroundStyle(AppTheme.pastelCoral)
                }

                Text(solution.overuseWarning)
                    .font(AppTheme.bodyFont(size: 16))
                    .foregroundStyle(AppTheme.textPrimary)
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(AppTheme.pastelYellow.opacity(0.2))
            .clipShape(RoundedRectangle(cornerRadius: 14))
        }
    }
}
```

**Step 3: Verify build**

Run: `swift build 2>&1 | tail -10`
Expected: Build succeeds

**Step 4: Commit**

```bash
git add HairAgent/Views/Components/FrequencyBadge.swift HairAgent/Views/Components/HowOftenSection.swift
git commit -m "feat: add FrequencyBadge and HowOftenSection components"
```

---

### Task 8: Build MyScheduleView

**Files:**
- Create: `HairAgent/Views/MyScheduleView.swift`
- Modify: `HairAgent/Views/Components/DecorativeBackground.swift` (add `.mySchedule` style)

**Step 1: Add mySchedule style to DecorativeBackground**

In `HairAgent/Views/Components/DecorativeBackground.swift`, add `case mySchedule` to the `Style` enum:

After `case tipDetail`, add:
```swift
case mySchedule
```

In the `gradientColors` computed property, add:
```swift
case .mySchedule:
    [AppTheme.pastelBlue.opacity(0.45), AppTheme.pastelPink.opacity(0.35), AppTheme.pastelYellow.opacity(0.3)]
```

In `hasExtraDecorations`, update to:
```swift
self == .welcome || self == .results || self == .mySchedule
```

**Step 2: Create MyScheduleView**

Create `HairAgent/Views/MyScheduleView.swift`:

```swift
import SwiftUI

struct MyScheduleView: View {
    let solutions: [HairSolution]
    let texture: HairTexture
    var onSelectSolution: (HairSolution) -> Void

    private let badgeColors: [Color] = [
        AppTheme.pastelPink,
        AppTheme.pastelBlue,
        AppTheme.pastelCoral,
        AppTheme.pastelYellow,
    ]

    var body: some View {
        VStack(spacing: 16) {
            if solutions.isEmpty {
                VStack(spacing: 16) {
                    Text("No solutions yet")
                        .font(AppTheme.headingFont(size: 20))
                    Text("Take the quiz to get your personal hair schedule!")
                        .font(AppTheme.bodyFont(size: 16))
                        .foregroundStyle(.gray)
                }
                .padding(.top, 40)
            } else {
                ForEach(Array(solutions.enumerated()), id: \.element.id) { index, solution in
                    Button(action: { onSelectSolution(solution) }) {
                        HStack(spacing: 16) {
                            VStack(alignment: .leading, spacing: 6) {
                                Text(solution.title)
                                    .font(AppTheme.headingFont(size: 17))
                                    .foregroundStyle(AppTheme.textPrimary)
                                    .multilineTextAlignment(.leading)

                                Text(solution.personalizedFrequency(for: texture))
                                    .font(AppTheme.bodyFont(size: 14))
                                    .foregroundStyle(.gray)
                                    .multilineTextAlignment(.leading)
                            }

                            Spacer()

                            FrequencyBadge(
                                text: shortFrequency(solution.defaultFrequency),
                                color: badgeColors[index % badgeColors.count]
                            )
                        }
                        .padding(16)
                        .background(.white.opacity(0.9))
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                    }
                }
            }
        }
    }

    private func shortFrequency(_ full: String) -> String {
        // Convert "1-2 times per week" to "1-2x/week" for badge
        full.replacingOccurrences(of: "times per week", with: "x/week")
            .replacingOccurrences(of: "time per week", with: "x/week")
            .replacingOccurrences(of: "Once every ", with: "Every ")
            .replacingOccurrences(of: "Once a week", with: "1x/week")
            .replacingOccurrences(of: "2-3 times per week", with: "2-3x/week")
    }
}
```

**Step 3: Verify build**

Run: `swift build 2>&1 | tail -10`
Expected: Build succeeds

**Step 4: Commit**

```bash
git add HairAgent/Views/MyScheduleView.swift HairAgent/Views/Components/DecorativeBackground.swift
git commit -m "feat: add MyScheduleView and mySchedule background style"
```

---

### Task 9: Replace color picker in QuizView with gradient slider

**Files:**
- Modify: `HairAgent/Views/QuizView.swift`

**Step 1: Update QuizView**

In `HairAgent/Views/QuizView.swift`, make the following changes:

1. Change the state variable from `HairColor?` to `SelectedHairColor?`:
```swift
@State private var selectedColor: SelectedHairColor?
```
(Remove `@State private var selectedColor: HairColor?`)

2. Change the callback signature:
```swift
var onComplete: (SelectedHairColor, HairTexture, [HairGoal]) -> Void
```
(Was `(HairColor, HairTexture, [HairGoal]) -> Void`)

3. Replace the `colorGrid` computed property with:
```swift
private var colorGrid: some View {
    GradientSliderView(selectedColor: $selectedColor)
        .padding(.top, 20)
}
```

4. Update `canProceed` for the color step:
```swift
case .color: return selectedColor != nil
```
(This stays the same since selectedColor is still optional)

5. Update `goNext` for the goals step:
```swift
case .goals:
    if let color = selectedColor, let texture = selectedTexture {
        onComplete(color, texture, Array(selectedGoals))
    }
```

6. Update the quiz step 1 title and subtitle. In the `QuizStep` enum:
```swift
case .color:
    // title stays: "What's your hair color?"
    // change subtitle:
    return "Drag to find your color"
```

**Step 2: Verify build**

Run: `swift build 2>&1 | tail -10`
Expected: May fail because ContentView still expects old HairColor type -- that is fixed in Task 10

**Step 3: Commit (may need to wait for Task 10 if build fails)**

```bash
git add HairAgent/Views/QuizView.swift
git commit -m "feat: replace color picker cards with gradient slider in QuizView"
```

---

### Task 10: Update ContentView to pass new types through

**Files:**
- Modify: `HairAgent/ContentView.swift`

**Step 1: Update ContentView state and callbacks**

In `HairAgent/ContentView.swift`, make these changes:

1. Change the selectedColor state type:
```swift
@State private var selectedColor: SelectedHairColor?
```
(Was `HairColor?`)

2. Update the QuizView callback to match new signature:
```swift
case .quiz:
    QuizView(
        onBack: {
            if selectedColor != nil {
                currentScreen = .results
            } else {
                currentScreen = .nameEntry
            }
        },
        onComplete: { color, texture, goals in
            selectedColor = color
            selectedTexture = texture
            selectedGoals = goals
            matchedSolutions = HairSolutionsData.solutions(for: texture, goals: goals)
            currentScreen = .results
        }
    )
```

3. Update ResultsView to pass hair color and texture:
```swift
case .results:
    ResultsView(
        userName: userName,
        solutions: matchedSolutions,
        selectedHairColor: selectedColor,
        selectedTexture: selectedTexture,
        onSelectSolution: { solution in
            currentScreen = .tipDetail(solution)
        },
        onRetakeQuiz: {
            currentScreen = .quiz
        }
    )
```

4. Update TipDetailView to pass texture:
```swift
case .tipDetail(let solution):
    TipDetailView(
        solution: solution,
        texture: selectedTexture ?? .other
    ) {
        currentScreen = .results
    }
```

**Step 2: Verify build**

Run: `swift build 2>&1 | tail -10`
Expected: May fail because ResultsView and TipDetailView signatures have not been updated yet -- those are Tasks 11-12

**Step 3: Commit (combine with Tasks 11-12 if needed for build)**

```bash
git add HairAgent/ContentView.swift
git commit -m "feat: update ContentView to pass new color and texture types"
```

---

### Task 11: Update SolutionCard with before/after illustrations and update ResultsView with tabs

**Files:**
- Modify: `HairAgent/Views/Components/SolutionCard.swift`
- Modify: `HairAgent/Views/ResultsView.swift`

**Step 1: Update SolutionCard**

Replace `HairAgent/Views/Components/SolutionCard.swift` with:

```swift
import SwiftUI

struct SolutionCard: View {
    let solution: HairSolution
    let accentColor: Color
    let hairColor: Color?
    let texture: HairTexture?
    var onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 12) {
                // Before/After illustration or fallback
                if let hairColor = hairColor, let texture = texture {
                    BeforeAfterView(
                        hairColor: hairColor,
                        texture: texture,
                        solutionType: solution.solutionType,
                        size: CGSize(width: 260, height: 140)
                    )
                    .frame(maxWidth: .infinity)
                    .frame(height: 140)
                    .background(accentColor.opacity(0.15))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                } else {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(accentColor.opacity(0.3))
                        .frame(height: 160)
                        .overlay(
                            Image(systemName: "sparkles")
                                .font(.system(size: 40))
                                .foregroundStyle(accentColor)
                        )
                }

                Text(solution.title)
                    .font(AppTheme.headingFont(size: 18))
                    .foregroundStyle(AppTheme.textPrimary)

                Text(solution.ingredients.joined(separator: ", "))
                    .font(AppTheme.bodyFont(size: 14))
                    .foregroundStyle(.gray)
                    .lineLimit(2)
            }
            .padding()
            .background(.white.opacity(0.9))
            .clipShape(RoundedRectangle(cornerRadius: 16))
        }
    }
}
```

**Step 2: Update ResultsView with tabs**

Replace `HairAgent/Views/ResultsView.swift` with:

```swift
import SwiftUI

enum ResultsTab {
    case solutions
    case schedule
}

struct ResultsView: View {
    let userName: String
    let solutions: [HairSolution]
    let selectedHairColor: SelectedHairColor?
    let selectedTexture: HairTexture?
    var onSelectSolution: (HairSolution) -> Void
    var onRetakeQuiz: () -> Void

    @State private var selectedTab: ResultsTab = .solutions

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                Text("Your Hair Care Plan")
                    .font(AppTheme.headingFont(size: 32))
                    .foregroundStyle(AppTheme.textPrimary)

                Text("Hey \(userName)! Here are solutions made just for you.")
                    .font(AppTheme.bodyFont(size: 18))
                    .foregroundStyle(.gray)

                // Tab bar
                if !solutions.isEmpty {
                    tabBar
                }

                // Tab content
                switch selectedTab {
                case .solutions:
                    solutionsContent
                case .schedule:
                    MyScheduleView(
                        solutions: solutions,
                        texture: selectedTexture ?? .other,
                        onSelectSolution: onSelectSolution
                    )
                }

                Button(action: onRetakeQuiz) {
                    Text("Try Different Goals")
                        .font(AppTheme.headingFont(size: 18))
                        .foregroundStyle(AppTheme.pastelCoral)
                        .padding(.vertical, 16)
                        .frame(maxWidth: 300)
                        .background(.white.opacity(0.9))
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(AppTheme.pastelCoral, lineWidth: 2)
                        )
                }
                .padding(.top, 20)
            }
            .padding()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background {
            DecorativeBackground(style: selectedTab == .solutions ? .results : .mySchedule)
        }
        .animation(.easeInOut(duration: 0.3), value: selectedTab)
    }

    private var tabBar: some View {
        HStack(spacing: 0) {
            tabButton("My Solutions", tab: .solutions)
            tabButton("My Schedule", tab: .schedule)
        }
        .background(.white.opacity(0.7))
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(AppTheme.pastelPink.opacity(0.3), lineWidth: 1.5)
        )
    }

    private func tabButton(_ label: String, tab: ResultsTab) -> some View {
        Button(action: { selectedTab = tab }) {
            Text(label)
                .font(AppTheme.headingFont(size: 16))
                .foregroundStyle(selectedTab == tab ? .white : AppTheme.textPrimary)
                .padding(.vertical, 12)
                .frame(maxWidth: .infinity)
                .background(selectedTab == tab ? AppTheme.pastelCoral : Color.clear)
                .clipShape(RoundedRectangle(cornerRadius: 14))
        }
    }

    @ViewBuilder
    private var solutionsContent: some View {
        if solutions.isEmpty {
            VStack(spacing: 16) {
                Text("No matches found")
                    .font(AppTheme.headingFont(size: 20))
                Text("Try the quiz again with different answers!")
                    .font(AppTheme.bodyFont(size: 16))
                    .foregroundStyle(.gray)
            }
            .padding(.top, 40)
        } else {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 280))], spacing: 20) {
                ForEach(Array(solutions.enumerated()), id: \.element.id) { index, solution in
                    SolutionCard(
                        solution: solution,
                        accentColor: AppTheme.quizAccents[index % AppTheme.quizAccents.count],
                        hairColor: selectedHairColor?.color,
                        texture: selectedTexture
                    ) {
                        onSelectSolution(solution)
                    }
                }
            }
        }
    }
}
```

**Step 3: Verify build**

Run: `swift build 2>&1 | tail -10`
Expected: Build succeeds (or fails only due to TipDetailView signature -- fixed in Task 12)

**Step 4: Commit**

```bash
git add HairAgent/Views/Components/SolutionCard.swift HairAgent/Views/ResultsView.swift
git commit -m "feat: add tabs to ResultsView and before/after illustrations to SolutionCard"
```

---

### Task 12: Update TipDetailView with How Often section

**Files:**
- Modify: `HairAgent/Views/TipDetailView.swift`

**Step 1: Update TipDetailView**

Replace `HairAgent/Views/TipDetailView.swift` with:

```swift
import SwiftUI

struct TipDetailView: View {
    let solution: HairSolution
    let texture: HairTexture
    var onBack: () -> Void

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                Button(action: onBack) {
                    HStack(spacing: 6) {
                        Image(systemName: "chevron.left")
                        Text("Back to Results")
                    }
                    .font(AppTheme.bodyFont(size: 16))
                    .foregroundStyle(AppTheme.pastelCoral)
                }

                Text(solution.title)
                    .font(AppTheme.headingFont(size: 32))
                    .foregroundStyle(AppTheme.textPrimary)

                RoundedRectangle(cornerRadius: 16)
                    .fill(AppTheme.pastelPink.opacity(0.3))
                    .frame(height: 250)
                    .overlay(
                        Image(systemName: "sparkles")
                            .font(.system(size: 50))
                            .foregroundStyle(AppTheme.pastelPink)
                    )

                VStack(alignment: .leading, spacing: 12) {
                    Text("What You Need")
                        .font(AppTheme.headingFont(size: 22))
                        .foregroundStyle(AppTheme.textPrimary)

                    ForEach(solution.ingredients, id: \.self) { ingredient in
                        HStack(spacing: 12) {
                            Circle()
                                .fill(AppTheme.pastelYellow)
                                .frame(width: 8, height: 8)
                            Text(ingredient)
                                .font(AppTheme.bodyFont(size: 18))
                        }
                    }
                }

                VStack(alignment: .leading, spacing: 16) {
                    Text("How To Do It")
                        .font(AppTheme.headingFont(size: 22))
                        .foregroundStyle(AppTheme.textPrimary)

                    ForEach(Array(solution.steps.enumerated()), id: \.offset) { index, step in
                        HStack(alignment: .top, spacing: 16) {
                            Text("\(index + 1)")
                                .font(AppTheme.headingFont(size: 18))
                                .foregroundStyle(.white)
                                .frame(width: 36, height: 36)
                                .background(AppTheme.pastelCoral)
                                .clipShape(Circle())

                            Text(step)
                                .font(AppTheme.bodyFont(size: 18))
                                .foregroundStyle(AppTheme.textPrimary)
                        }
                    }
                }

                // How Often section
                HowOftenSection(solution: solution, texture: texture)
                    .padding(.top, 8)
            }
            .padding(24)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background {
            DecorativeBackground(style: .tipDetail)
        }
    }
}
```

**Step 2: Verify full build**

Run: `swift build 2>&1 | tail -10`
Expected: Build succeeds -- all files now have consistent signatures

**Step 3: Run all tests**

Run: `swift test 2>&1 | tail -20`
Expected: All tests pass

**Step 4: Commit**

```bash
git add HairAgent/Views/TipDetailView.swift
git commit -m "feat: add How Often section to TipDetailView"
```

---

### Task 13: Remove old HairColor enum and update tests

**Files:**
- Modify: `HairAgent/Models/QuizOptions.swift` (remove HairColor enum)
- Modify: `HairAgent/Models/UserProfile.swift` (remove legacy hairColor property)
- Modify: `HairAgentTests/ModelTests.swift` (remove/update HairColor tests)

**Step 1: Remove HairColor enum**

In `HairAgent/Models/QuizOptions.swift`, delete the entire `HairColor` enum (lines 3-15 of the current file).

**Step 2: Remove legacy hairColor from UserProfile**

In `HairAgent/Models/UserProfile.swift`, remove:
- The `hairColorRaw: String?` property
- The `hairColor` computed property (the legacy getter/setter)

The file should still have `hairColorRed`, `hairColorGreen`, `hairColorBlue`, `hairColorLabel`, and the `selectedHairColor` computed property.

**Step 3: Update tests**

In `HairAgentTests/ModelTests.swift`:

- Remove `test_hairColor_has_other_option` (HairColor enum no longer exists)
- Update `test_userProfile_stores_quiz_answers` to use the new color type:

```swift
func test_userProfile_stores_quiz_answers() {
    let profile = UserProfile(name: "Luna")
    profile.selectedHairColor = SelectedHairColor(red: 0.48, green: 0.30, blue: 0.15, label: "Medium Brown")
    profile.hairTexture = .dry
    profile.hairGoals = [.addShine, .repairDamage, .growLonger]
    XCTAssertEqual(profile.selectedHairColor?.label, "Medium Brown")
    XCTAssertEqual(profile.hairTexture, .dry)
    XCTAssertEqual(profile.hairGoals.count, 3)
}
```

**Step 4: Run all tests**

Run: `swift test 2>&1 | tail -20`
Expected: All tests pass

**Step 5: Commit**

```bash
git add HairAgent/Models/QuizOptions.swift HairAgent/Models/UserProfile.swift HairAgentTests/ModelTests.swift
git commit -m "refactor: remove old HairColor enum, use SelectedHairColor everywhere"
```

---

### Task 14: Regenerate Xcode project and verify full build

**Files:**
- Regenerate: `HairAgent.xcodeproj` via xcodegen

**Step 1: Regenerate Xcode project**

Run: `cd /Users/ericfriedman/Dropbox/Documents/AI/claude/hairagent && xcodegen generate`
Expected: "Project generated" message

**Step 2: Run all tests one final time**

Run: `swift test 2>&1 | tail -30`
Expected: All tests pass (original tests + new HairColorSelectionTests + updated ModelTests + updated SolutionDataTests)

**Step 3: Verify build with xcodebuild**

Run: `xcodebuild -project HairAgent.xcodeproj -scheme HairAgent -destination 'platform=iOS Simulator,name=iPad Pro 13-inch (M4)' build 2>&1 | tail -20`
Expected: BUILD SUCCEEDED

**Step 4: Commit**

```bash
git add HairAgent.xcodeproj project.yml
git commit -m "chore: regenerate Xcode project with v2 feature files"
```

---

## Summary

**14 tasks** across 4 phases:

| Phase | Tasks | What |
|-------|-------|------|
| Models & Data | 1-4 | SelectedHairColor, SolutionType, frequency content, UserProfile |
| New Components | 5-8 | GradientSlider, HairStrands, FrequencyBadge, HowOften, MySchedule |
| Integration | 9-12 | QuizView, ContentView, ResultsView, SolutionCard, TipDetailView |
| Cleanup | 13-14 | Remove HairColor, regenerate Xcode project, verify build |

**New files (8):**
- `HairAgent/Models/HairColorSelection.swift`
- `HairAgent/Views/Components/GradientSliderView.swift`
- `HairAgent/Views/Components/HairStrandsView.swift`
- `HairAgent/Views/Components/FrequencyBadge.swift`
- `HairAgent/Views/Components/HowOftenSection.swift`
- `HairAgent/Views/MyScheduleView.swift`
- `HairAgentTests/HairColorSelectionTests.swift`

**Modified files (9):**
- `HairAgent/Models/QuizOptions.swift`
- `HairAgent/Models/HairSolution.swift`
- `HairAgent/Models/UserProfile.swift`
- `HairAgent/Data/HairSolutionsData.swift`
- `HairAgent/Views/QuizView.swift`
- `HairAgent/ContentView.swift`
- `HairAgent/Views/ResultsView.swift`
- `HairAgent/Views/Components/SolutionCard.swift`
- `HairAgent/Views/TipDetailView.swift`
- `HairAgent/Views/Components/DecorativeBackground.swift`
- `HairAgentTests/ModelTests.swift`
- `HairAgentTests/SolutionDataTests.swift`
