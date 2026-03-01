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
