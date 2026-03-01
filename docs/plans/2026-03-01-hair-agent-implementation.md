# Hair Agent Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Build a SwiftUI iPad app where users take a hair quiz and get personalized at-home hair care solutions using common household ingredients.

**Architecture:** Single-target SwiftUI app with SwiftData for local persistence. No backend. Content (hair solutions) is hardcoded in a data file. The app flows linearly: Welcome → Name → Quiz (3 steps) → Results → Tip Detail. A ProfileView allows revisiting results or retaking the quiz.

**Tech Stack:** Swift, SwiftUI, SwiftData, iPadOS 17+, Xcode

---

## Task 1: Create Xcode Project

**Files:**
- Create: `HairAgent.xcodeproj` (via Xcode CLI)
- Create: `HairAgent/HairAgentApp.swift`
- Create: `HairAgent/ContentView.swift`

**Step 1: Create the SwiftUI project**

```bash
cd /Users/ericfriedman/Dropbox/Documents/AI/claude/hairagent
# We'll create the project structure manually since we're in CLI
mkdir -p HairAgent/Models
mkdir -p HairAgent/Views
mkdir -p HairAgent/Data
mkdir -p HairAgent/Theme
mkdir -p HairAgentTests
```

**Step 2: Create the Swift Package structure**

Since we're working from CLI without Xcode, create a `Package.swift` for building and testing:

```swift
// Package.swift
// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "HairAgent",
    platforms: [.iOS(.v17)],
    products: [
        .library(name: "HairAgent", targets: ["HairAgent"]),
    ],
    targets: [
        .target(
            name: "HairAgent",
            path: "HairAgent"
        ),
        .testTarget(
            name: "HairAgentTests",
            dependencies: ["HairAgent"],
            path: "HairAgentTests"
        ),
    ]
)
```

**Step 3: Create the app entry point**

```swift
// HairAgent/HairAgentApp.swift
import SwiftUI
import SwiftData

@main
struct HairAgentApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: UserProfile.self)
    }
}
```

**Step 4: Create a placeholder ContentView**

```swift
// HairAgent/ContentView.swift
import SwiftUI

struct ContentView: View {
    var body: some View {
        Text("Hair Agent")
    }
}
```

**Step 5: Commit**

```bash
git add -A
git commit -m "feat: scaffold SwiftUI project structure"
```

---

## Task 2: Define the Theme (Colors & Typography)

**Files:**
- Create: `HairAgent/Theme/AppTheme.swift`

**Step 1: Write the failing test**

```swift
// HairAgentTests/ThemeTests.swift
import XCTest
@testable import HairAgent
import SwiftUI

final class ThemeTests: XCTestCase {
    func test_theme_has_all_brand_colors() {
        // Verify all brand colors exist and are distinct
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
```

**Step 2: Run test to verify it fails**

Run: `swift test --filter ThemeTests`
Expected: FAIL — `AppTheme` not defined

**Step 3: Write the implementation**

```swift
// HairAgent/Theme/AppTheme.swift
import SwiftUI

enum AppTheme {
    // Brand colors - pastel palette
    static let pastelPink = Color(red: 1.0, green: 0.71, blue: 0.76)
    static let pastelBlue = Color(red: 0.68, green: 0.85, blue: 0.96)
    static let pastelYellow = Color(red: 1.0, green: 0.94, blue: 0.70)
    static let pastelCoral = Color(red: 1.0, green: 0.60, blue: 0.56)
    static let background = Color.white
    static let textPrimary = Color.black

    // Accent colors for quiz options
    static let quizAccents: [Color] = [pastelPink, pastelBlue, pastelYellow, pastelCoral]

    // Typography
    static func headingFont(size: CGFloat) -> Font {
        .system(size: size, weight: .bold, design: .rounded)
    }

    static func bodyFont(size: CGFloat) -> Font {
        .system(size: size, weight: .regular, design: .rounded)
    }
}
```

**Step 4: Run test to verify it passes**

Run: `swift test --filter ThemeTests`
Expected: PASS

**Step 5: Commit**

```bash
git add HairAgent/Theme/AppTheme.swift HairAgentTests/ThemeTests.swift
git commit -m "feat: add AppTheme with pastel color palette and typography"
```

---

## Task 3: Data Models (UserProfile & HairSolution)

**Files:**
- Create: `HairAgent/Models/UserProfile.swift`
- Create: `HairAgent/Models/HairSolution.swift`
- Create: `HairAgent/Models/QuizOptions.swift`
- Create: `HairAgentTests/ModelTests.swift`

**Step 1: Write the failing tests**

```swift
// HairAgentTests/ModelTests.swift
import XCTest
@testable import HairAgent

final class ModelTests: XCTestCase {

    // MARK: - QuizOptions

    func test_hairColor_has_other_option() {
        XCTAssertTrue(HairColor.allCases.contains(.other))
    }

    func test_hairTexture_has_other_option() {
        XCTAssertTrue(HairTexture.allCases.contains(.other))
    }

    func test_hairGoal_has_other_option() {
        XCTAssertTrue(HairGoal.allCases.contains(.other))
    }

    // MARK: - UserProfile

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

    // MARK: - HairSolution

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
```

**Step 2: Run tests to verify they fail**

Run: `swift test --filter ModelTests`
Expected: FAIL — types not defined

**Step 3: Write QuizOptions**

```swift
// HairAgent/Models/QuizOptions.swift
import Foundation

enum HairColor: String, CaseIterable, Codable, Identifiable {
    case black, brown, blonde, red, gray, auburn
    case other

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .other: return "Other"
        default: return rawValue.capitalized
        }
    }
}

enum HairTexture: String, CaseIterable, Codable, Identifiable {
    case frizzy, oily, dry, damaged
    case other

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .other: return "Other"
        default: return rawValue.capitalized
        }
    }
}

enum HairGoal: String, CaseIterable, Codable, Identifiable {
    case addShine
    case lessFrizz
    case growLonger
    case stayHealthy
    case repairDamage
    case moreVolume
    case lessOil
    case other

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .addShine: return "Add Shine"
        case .lessFrizz: return "Less Frizz"
        case .growLonger: return "Grow Longer"
        case .stayHealthy: return "Stay Healthy"
        case .repairDamage: return "Repair Damage"
        case .moreVolume: return "More Volume"
        case .lessOil: return "Less Oil"
        case .other: return "Other"
        }
    }
}
```

**Step 4: Write UserProfile**

```swift
// HairAgent/Models/UserProfile.swift
import Foundation
import SwiftData

@Model
final class UserProfile {
    var name: String
    var hairColorRaw: String?
    var hairTextureRaw: String?
    var hairGoalRaws: [String]

    init(name: String) {
        self.name = name
        self.hairGoalRaws = []
    }

    var hairColor: HairColor? {
        get { hairColorRaw.flatMap { HairColor(rawValue: $0) } }
        set { hairColorRaw = newValue?.rawValue }
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

**Step 5: Write HairSolution**

```swift
// HairAgent/Models/HairSolution.swift
import Foundation

struct HairSolution: Identifiable {
    let id = UUID()
    let title: String
    let imageName: String
    let ingredients: [String]
    let steps: [String]
    let helpsWith: [HairTexture]
    let goalTags: [HairGoal]

    func matches(texture: HairTexture, goals: [HairGoal]) -> Bool {
        let textureMatch = helpsWith.contains(texture)
        let goalMatch = goalTags.contains(where: { goals.contains($0) })
        return textureMatch || goalMatch
    }
}
```

**Step 6: Run tests to verify they pass**

Run: `swift test --filter ModelTests`
Expected: PASS

**Step 7: Commit**

```bash
git add HairAgent/Models/ HairAgentTests/ModelTests.swift
git commit -m "feat: add data models for UserProfile, HairSolution, and quiz options"
```

---

## Task 4: Hair Solutions Data

**Files:**
- Create: `HairAgent/Data/HairSolutionsData.swift`
- Create: `HairAgentTests/SolutionDataTests.swift`

**Step 1: Write the failing test**

```swift
// HairAgentTests/SolutionDataTests.swift
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
```

**Step 2: Run test to verify it fails**

Run: `swift test --filter SolutionDataTests`
Expected: FAIL — `HairSolutionsData` not defined

**Step 3: Write the solutions data**

```swift
// HairAgent/Data/HairSolutionsData.swift
import Foundation

enum HairSolutionsData {
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
            goalTags: [.addShine, .repairDamage, .stayHealthy]
        ),
        HairSolution(
            title: "Egg & Yogurt Protein Treatment",
            imageName: "egg_yogurt_mask",
            ingredients: ["1 egg", "2 tbsp plain yogurt"],
            steps: [
                "Whisk egg and yogurt together until smooth",
                "Apply to damp hair, focusing on ends",
                "Cover with a shower cap for 20 minutes",
                "Rinse with cool water (not hot — it will cook the egg!)"
            ],
            helpsWith: [.damaged, .frizzy],
            goalTags: [.repairDamage, .lessFrizz, .moreVolume]
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
            goalTags: [.addShine, .repairDamage, .lessFrizz, .stayHealthy]
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
            goalTags: [.addShine, .lessOil, .lessFrizz]
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
            goalTags: [.lessFrizz, .addShine, .stayHealthy]
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
            goalTags: [.stayHealthy, .lessOil, .growLonger]
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
            goalTags: [.growLonger, .repairDamage, .moreVolume]
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
            goalTags: [.addShine, .repairDamage, .stayHealthy]
        ),
    ]

    static func solutions(for texture: HairTexture, goals: [HairGoal]) -> [HairSolution] {
        allSolutions.filter { $0.matches(texture: texture, goals: goals) }
    }
}
```

**Step 4: Run tests to verify they pass**

Run: `swift test --filter SolutionDataTests`
Expected: PASS

**Step 5: Commit**

```bash
git add HairAgent/Data/HairSolutionsData.swift HairAgentTests/SolutionDataTests.swift
git commit -m "feat: add 8 starter hair solutions with household ingredients"
```

---

## Task 5: Welcome Screen

**Files:**
- Create: `HairAgent/Views/WelcomeView.swift`

**Step 1: Write the WelcomeView**

```swift
// HairAgent/Views/WelcomeView.swift
import SwiftUI

struct WelcomeView: View {
    var onGetStarted: () -> Void

    var body: some View {
        VStack(spacing: 40) {
            Spacer()

            VStack(spacing: 16) {
                Text("Hair Agent")
                    .font(AppTheme.headingFont(size: 48))
                    .foregroundStyle(AppTheme.textPrimary)

                Text("Your personal hair care advisor")
                    .font(AppTheme.bodyFont(size: 20))
                    .foregroundStyle(.gray)
            }

            Spacer()

            Button(action: onGetStarted) {
                Text("Get Started")
                    .font(AppTheme.headingFont(size: 20))
                    .foregroundStyle(.white)
                    .frame(maxWidth: 300)
                    .padding(.vertical, 18)
                    .background(AppTheme.pastelCoral)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
            }

            Spacer()
                .frame(height: 60)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(AppTheme.background)
    }
}
```

**Step 2: Verify it compiles**

Run: `swift build`
Expected: BUILD SUCCEEDED

**Step 3: Commit**

```bash
git add HairAgent/Views/WelcomeView.swift
git commit -m "feat: add WelcomeView with bold title and Get Started button"
```

---

## Task 6: Name Entry Screen

**Files:**
- Create: `HairAgent/Views/NameEntryView.swift`

**Step 1: Write the NameEntryView**

```swift
// HairAgent/Views/NameEntryView.swift
import SwiftUI

struct NameEntryView: View {
    @State private var name = ""
    var onContinue: (String) -> Void

    var body: some View {
        VStack(spacing: 40) {
            Spacer()

            Text("What's your name?")
                .font(AppTheme.headingFont(size: 36))
                .foregroundStyle(AppTheme.textPrimary)

            TextField("Enter your name", text: $name)
                .font(AppTheme.bodyFont(size: 22))
                .padding()
                .frame(maxWidth: 400)
                .background(Color(.systemGray6))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .multilineTextAlignment(.center)

            Button(action: { onContinue(name) }) {
                Text("Continue")
                    .font(AppTheme.headingFont(size: 20))
                    .foregroundStyle(.white)
                    .frame(maxWidth: 300)
                    .padding(.vertical, 18)
                    .background(name.isEmpty ? Color.gray : AppTheme.pastelCoral)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
            }
            .disabled(name.isEmpty)

            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(AppTheme.background)
    }
}
```

**Step 2: Verify it compiles**

Run: `swift build`
Expected: BUILD SUCCEEDED

**Step 3: Commit**

```bash
git add HairAgent/Views/NameEntryView.swift
git commit -m "feat: add NameEntryView with text field and Continue button"
```

---

## Task 7: Quiz View (Color, Texture, Goals)

**Files:**
- Create: `HairAgent/Views/QuizView.swift`
- Create: `HairAgent/Views/Components/QuizOptionCard.swift`
- Create: `HairAgent/Views/Components/ProgressBar.swift`

**Step 1: Write the ProgressBar component**

```swift
// HairAgent/Views/Components/ProgressBar.swift
import SwiftUI

struct ProgressBar: View {
    let currentStep: Int
    let totalSteps: Int

    var body: some View {
        HStack(spacing: 8) {
            ForEach(0..<totalSteps, id: \.self) { index in
                RoundedRectangle(cornerRadius: 4)
                    .fill(index <= currentStep
                          ? AppTheme.quizAccents[index % AppTheme.quizAccents.count]
                          : Color(.systemGray4))
                    .frame(height: 8)
            }
        }
        .padding(.horizontal)
    }
}
```

**Step 2: Write the QuizOptionCard component**

```swift
// HairAgent/Views/Components/QuizOptionCard.swift
import SwiftUI

struct QuizOptionCard: View {
    let label: String
    let isSelected: Bool
    let accentColor: Color
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(label)
                .font(AppTheme.bodyFont(size: 18))
                .foregroundStyle(isSelected ? .white : AppTheme.textPrimary)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(isSelected ? accentColor : Color(.systemGray6))
                .clipShape(RoundedRectangle(cornerRadius: 14))
                .overlay(
                    RoundedRectangle(cornerRadius: 14)
                        .stroke(isSelected ? accentColor : .clear, lineWidth: 3)
                )
        }
        .sensoryFeedback(.selection, trigger: isSelected)
    }
}
```

**Step 3: Write the QuizView**

```swift
// HairAgent/Views/QuizView.swift
import SwiftUI

enum QuizStep: Int, CaseIterable {
    case color = 0
    case texture = 1
    case goals = 2

    var title: String {
        switch self {
        case .color: return "What's your hair color?"
        case .texture: return "How is your hair?"
        case .goals: return "What do you want to fix?"
        }
    }

    var subtitle: String {
        switch self {
        case .color: return "Pick the closest match"
        case .texture: return "Choose your hair texture"
        case .goals: return "Pick at least 3"
        }
    }
}

struct QuizView: View {
    @State private var step: QuizStep = .color
    @State private var selectedColor: HairColor?
    @State private var selectedTexture: HairTexture?
    @State private var selectedGoals: Set<HairGoal> = []

    var onBack: () -> Void
    var onComplete: (HairColor, HairTexture, [HairGoal]) -> Void

    var body: some View {
        VStack(spacing: 24) {
            // Top bar with back button and progress
            HStack {
                Button(action: goBack) {
                    Image(systemName: "chevron.left")
                        .font(.title2.bold())
                        .foregroundStyle(AppTheme.textPrimary)
                }
                Spacer()
            }
            .padding(.horizontal)

            ProgressBar(currentStep: step.rawValue, totalSteps: QuizStep.allCases.count)

            Text(step.title)
                .font(AppTheme.headingFont(size: 32))
                .foregroundStyle(AppTheme.textPrimary)

            Text(step.subtitle)
                .font(AppTheme.bodyFont(size: 18))
                .foregroundStyle(.gray)

            // Quiz content
            ScrollView {
                switch step {
                case .color:
                    colorGrid
                case .texture:
                    textureGrid
                case .goals:
                    goalsGrid
                }
            }

            // Next button
            Button(action: goNext) {
                Text(step == .goals ? "See My Results" : "Next")
                    .font(AppTheme.headingFont(size: 20))
                    .foregroundStyle(.white)
                    .frame(maxWidth: 300)
                    .padding(.vertical, 18)
                    .background(canProceed ? AppTheme.pastelCoral : Color.gray)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
            }
            .disabled(!canProceed)
            .padding(.bottom)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(AppTheme.background)
        .animation(.easeInOut(duration: 0.3), value: step)
    }

    // MARK: - Grids

    private var colorGrid: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 160))], spacing: 16) {
            ForEach(HairColor.allCases) { color in
                QuizOptionCard(
                    label: color.displayName,
                    isSelected: selectedColor == color,
                    accentColor: AppTheme.pastelPink
                ) {
                    selectedColor = color
                }
            }
        }
        .padding(.horizontal)
    }

    private var textureGrid: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 160))], spacing: 16) {
            ForEach(HairTexture.allCases) { texture in
                QuizOptionCard(
                    label: texture.displayName,
                    isSelected: selectedTexture == texture,
                    accentColor: AppTheme.pastelBlue
                ) {
                    selectedTexture = texture
                }
            }
        }
        .padding(.horizontal)
    }

    private var goalsGrid: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 160))], spacing: 16) {
            ForEach(HairGoal.allCases) { goal in
                QuizOptionCard(
                    label: goal.displayName,
                    isSelected: selectedGoals.contains(goal),
                    accentColor: AppTheme.pastelYellow
                ) {
                    if selectedGoals.contains(goal) {
                        selectedGoals.remove(goal)
                    } else {
                        selectedGoals.insert(goal)
                    }
                }
            }
        }
        .padding(.horizontal)
    }

    // MARK: - Navigation

    private var canProceed: Bool {
        switch step {
        case .color: return selectedColor != nil
        case .texture: return selectedTexture != nil
        case .goals: return selectedGoals.count >= 3
        }
    }

    private func goNext() {
        switch step {
        case .color:
            step = .texture
        case .texture:
            step = .goals
        case .goals:
            if let color = selectedColor, let texture = selectedTexture {
                onComplete(color, texture, Array(selectedGoals))
            }
        }
    }

    private func goBack() {
        switch step {
        case .color:
            onBack()
        case .texture:
            step = .color
        case .goals:
            step = .texture
        }
    }
}
```

**Step 4: Verify it compiles**

Run: `swift build`
Expected: BUILD SUCCEEDED

**Step 5: Commit**

```bash
git add HairAgent/Views/QuizView.swift HairAgent/Views/Components/
git commit -m "feat: add QuizView with 3-step quiz, progress bar, and option cards"
```

---

## Task 8: Results View

**Files:**
- Create: `HairAgent/Views/ResultsView.swift`
- Create: `HairAgent/Views/Components/SolutionCard.swift`

**Step 1: Write the SolutionCard component**

```swift
// HairAgent/Views/Components/SolutionCard.swift
import SwiftUI

struct SolutionCard: View {
    let solution: HairSolution
    let accentColor: Color
    var onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 12) {
                // Placeholder for photo
                RoundedRectangle(cornerRadius: 12)
                    .fill(accentColor.opacity(0.3))
                    .frame(height: 160)
                    .overlay(
                        Image(systemName: "sparkles")
                            .font(.system(size: 40))
                            .foregroundStyle(accentColor)
                    )

                Text(solution.title)
                    .font(AppTheme.headingFont(size: 18))
                    .foregroundStyle(AppTheme.textPrimary)

                Text(solution.ingredients.joined(separator: ", "))
                    .font(AppTheme.bodyFont(size: 14))
                    .foregroundStyle(.gray)
                    .lineLimit(2)
            }
            .padding()
            .background(Color(.systemGray6))
            .clipShape(RoundedRectangle(cornerRadius: 16))
        }
    }
}
```

**Step 2: Write the ResultsView**

```swift
// HairAgent/Views/ResultsView.swift
import SwiftUI

struct ResultsView: View {
    let userName: String
    let solutions: [HairSolution]
    var onSelectSolution: (HairSolution) -> Void
    var onRetakeQuiz: () -> Void

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                Text("Your Hair Care Plan")
                    .font(AppTheme.headingFont(size: 32))
                    .foregroundStyle(AppTheme.textPrimary)

                Text("Hey \(userName)! Here are solutions made just for you.")
                    .font(AppTheme.bodyFont(size: 18))
                    .foregroundStyle(.gray)

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
                                accentColor: AppTheme.quizAccents[index % AppTheme.quizAccents.count]
                            ) {
                                onSelectSolution(solution)
                            }
                        }
                    }
                }

                Button(action: onRetakeQuiz) {
                    Text("Try Different Goals")
                        .font(AppTheme.headingFont(size: 18))
                        .foregroundStyle(AppTheme.pastelCoral)
                        .padding(.vertical, 16)
                        .frame(maxWidth: 300)
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
        .background(AppTheme.background)
    }
}
```

**Step 3: Verify it compiles**

Run: `swift build`
Expected: BUILD SUCCEEDED

**Step 4: Commit**

```bash
git add HairAgent/Views/ResultsView.swift HairAgent/Views/Components/SolutionCard.swift
git commit -m "feat: add ResultsView with personalized solution cards"
```

---

## Task 9: Tip Detail View

**Files:**
- Create: `HairAgent/Views/TipDetailView.swift`

**Step 1: Write the TipDetailView**

```swift
// HairAgent/Views/TipDetailView.swift
import SwiftUI

struct TipDetailView: View {
    let solution: HairSolution
    var onBack: () -> Void

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                // Back button
                Button(action: onBack) {
                    HStack(spacing: 6) {
                        Image(systemName: "chevron.left")
                        Text("Back to Results")
                    }
                    .font(AppTheme.bodyFont(size: 16))
                    .foregroundStyle(AppTheme.pastelCoral)
                }

                // Title
                Text(solution.title)
                    .font(AppTheme.headingFont(size: 32))
                    .foregroundStyle(AppTheme.textPrimary)

                // Photo placeholder
                RoundedRectangle(cornerRadius: 16)
                    .fill(AppTheme.pastelPink.opacity(0.3))
                    .frame(height: 250)
                    .overlay(
                        Image(systemName: "sparkles")
                            .font(.system(size: 50))
                            .foregroundStyle(AppTheme.pastelPink)
                    )

                // Ingredients
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

                // Steps
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
            }
            .padding(24)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(AppTheme.background)
    }
}
```

**Step 2: Verify it compiles**

Run: `swift build`
Expected: BUILD SUCCEEDED

**Step 3: Commit**

```bash
git add HairAgent/Views/TipDetailView.swift
git commit -m "feat: add TipDetailView with ingredients and step-by-step instructions"
```

---

## Task 10: App Navigation (Wire Everything Together)

**Files:**
- Modify: `HairAgent/ContentView.swift`

**Step 1: Write the main navigation coordinator**

```swift
// HairAgent/ContentView.swift
import SwiftUI
import SwiftData

enum AppScreen {
    case welcome
    case nameEntry
    case quiz
    case results
    case tipDetail(HairSolution)
}

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var profiles: [UserProfile]
    @State private var currentScreen: AppScreen = .welcome
    @State private var currentProfile: UserProfile?
    @State private var matchedSolutions: [HairSolution] = []

    var body: some View {
        Group {
            switch currentScreen {
            case .welcome:
                WelcomeView {
                    if let existing = profiles.first {
                        currentProfile = existing
                        currentScreen = .results
                        loadResults()
                    } else {
                        currentScreen = .nameEntry
                    }
                }

            case .nameEntry:
                NameEntryView { name in
                    let profile = UserProfile(name: name)
                    modelContext.insert(profile)
                    currentProfile = profile
                    currentScreen = .quiz
                }

            case .quiz:
                QuizView(
                    onBack: {
                        currentScreen = currentProfile?.hairColor != nil ? .results : .nameEntry
                    },
                    onComplete: { color, texture, goals in
                        guard let profile = currentProfile else { return }
                        profile.hairColor = color
                        profile.hairTexture = texture
                        profile.hairGoals = goals
                        loadResults()
                        currentScreen = .results
                    }
                )

            case .results:
                ResultsView(
                    userName: currentProfile?.name ?? "",
                    solutions: matchedSolutions,
                    onSelectSolution: { solution in
                        currentScreen = .tipDetail(solution)
                    },
                    onRetakeQuiz: {
                        currentScreen = .quiz
                    }
                )

            case .tipDetail(let solution):
                TipDetailView(solution: solution) {
                    currentScreen = .results
                }
            }
        }
        .animation(.easeInOut(duration: 0.3), value: screenID)
    }

    private var screenID: String {
        switch currentScreen {
        case .welcome: return "welcome"
        case .nameEntry: return "name"
        case .quiz: return "quiz"
        case .results: return "results"
        case .tipDetail(let s): return "tip-\(s.id)"
        }
    }

    private func loadResults() {
        guard let profile = currentProfile,
              let texture = profile.hairTexture else {
            matchedSolutions = []
            return
        }
        matchedSolutions = HairSolutionsData.solutions(for: texture, goals: profile.hairGoals)
    }
}
```

**Step 2: Verify it compiles**

Run: `swift build`
Expected: BUILD SUCCEEDED

**Step 3: Commit**

```bash
git add HairAgent/ContentView.swift
git commit -m "feat: wire up full app navigation flow from welcome through results"
```

---

## Task 11: Final Integration & Polish

**Step 1: Run full test suite**

Run: `swift test`
Expected: ALL PASS

**Step 2: Add .gitignore for Xcode/Swift artifacts**

```gitignore
# .gitignore
.build/
*.xcodeproj/xcuserdata/
*.xcworkspace/xcuserdata/
DerivedData/
.swiftpm/
```

**Step 3: Final commit**

```bash
git add .gitignore
git commit -m "chore: add .gitignore for Swift build artifacts"
```

**Step 4: Push everything to GitHub**

```bash
git push
```

---

## Summary of Tasks

| Task | What | Estimated Steps |
|------|------|----------------|
| 1 | Create project structure | 5 |
| 2 | Theme (colors & fonts) | 5 |
| 3 | Data models | 7 |
| 4 | Hair solutions data | 5 |
| 5 | Welcome screen | 3 |
| 6 | Name entry screen | 3 |
| 7 | Quiz view (3 steps) | 5 |
| 8 | Results view | 4 |
| 9 | Tip detail view | 3 |
| 10 | App navigation | 3 |
| 11 | Final integration | 4 |
