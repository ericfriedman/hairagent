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
            goalTags: [.addShine, .repairDamage, .stayHealthy],
            solutionType: .moisturizing,
            defaultFrequency: "1-2 times per week",
            frequencyByTexture: [
                .frizzy: "2 times per week -- your frizzy hair will love the extra moisture!",
                .oily: "Once every 2 weeks -- oil-based masks can make oily hair feel heavy, so go easy.",
                .dry: "2 times per week -- dry hair drinks this up like a sponge!",
                .damaged: "1-2 times per week -- give your hair a steady dose of TLC."
            ],
            overuseWarning: "Using this mask too often can make your hair feel greasy or weighed down. Stick to the schedule so your hair stays bouncy!"
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
            defaultFrequency: "1-2 times per week",
            frequencyByTexture: [
                .frizzy: "Once per week -- protein helps tame frizz without overdoing it.",
                .oily: "Once every 2 weeks -- too much protein on oily hair can make it stiff.",
                .dry: "Once every 1-2 weeks -- balance protein with moisture so hair stays soft.",
                .damaged: "1-2 times per week -- damaged hair needs that protein boost to get strong again!"
            ],
            overuseWarning: "Too much protein can actually make your hair feel dry and straw-like. If your hair starts feeling crunchy, take a break and use a moisturizing mask instead."
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
                .frizzy: "1-2 times per week -- coconut oil is amazing at smoothing frizzy strands!",
                .oily: "Once every 2 weeks max -- coconut oil is super rich, so oily hair only needs a little.",
                .dry: "2 times per week -- your thirsty hair will soak it right up!",
                .damaged: "1-2 times per week -- a steady coconut oil routine helps repair and protect."
            ],
            overuseWarning: "Coconut oil is heavy, so using it too much can leave a buildup that makes hair look greasy. If your hair starts feeling coated, skip a week and shampoo well."
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
            defaultFrequency: "1-2 times per week",
            frequencyByTexture: [
                .frizzy: "Once per week -- helps smooth the hair cuticle and calm frizz!",
                .oily: "2 times per week -- great for cutting through oil and buildup.",
                .dry: "Once every 2 weeks -- too often can dry your hair out, so keep it light.",
                .damaged: "Once every 2 weeks -- be gentle with damaged hair. Vinegar is strong stuff!"
            ],
            overuseWarning: "Apple cider vinegar is acidic, so overdoing it can dry out your hair and irritate your scalp. If your scalp starts feeling itchy or tight, take a break."
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
                .frizzy: "2 times per week -- banana is a frizz-fighting superstar!",
                .oily: "Once every 2 weeks -- the olive oil in this mask can be a lot for oily hair.",
                .dry: "1-2 times per week -- the banana and honey combo is perfect for adding softness.",
                .damaged: "Once per week -- a gentle smoothing treat to keep fragile hair happy."
            ],
            overuseWarning: "This mask is rich and nourishing, but using it too much can weigh your hair down and make it feel limp. Space it out so your hair keeps its bounce!"
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
                .frizzy: "2 times per week -- a happy scalp means happier, smoother hair!",
                .oily: "2-3 times per week -- aloe is light and helps balance oil without adding grease.",
                .dry: "2-3 times per week -- aloe soothes dry, flaky scalps like a charm.",
                .damaged: "2 times per week -- keeping your scalp healthy helps new hair grow in stronger."
            ],
            overuseWarning: "Aloe vera is super gentle, but if you notice any sticky residue building up, rinse more thoroughly or take a day off between uses."
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
            defaultFrequency: "1-2 times per week",
            frequencyByTexture: [
                .frizzy: "Once per week -- rice water adds strength without weighing frizzy hair down.",
                .oily: "Once per week -- a light rinse that won't add extra oil. Nice!",
                .dry: "Once per week -- pair it with a moisturizing mask on other days for best results.",
                .damaged: "2 times per week -- rice water is packed with good stuff to help rebuild weak hair!"
            ],
            overuseWarning: "Rice water has a lot of protein, so using it every day can make hair stiff and brittle. Stick to 1-2 times a week and your hair will thank you!"
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
                .frizzy: "1-2 times per week -- avocado is full of healthy fats that smooth frizz right out.",
                .oily: "Once every 2 weeks -- this mask is super rich, so oily hair only needs it once in a while.",
                .dry: "2 times per week -- dry hair goes crazy for avocado! It is like a big drink of water.",
                .damaged: "1-2 times per week -- the natural oils help patch up and protect damaged strands."
            ],
            overuseWarning: "Avocado and olive oil together are very rich. Using this too often can cause buildup that makes your hair feel heavy and hard to style. Give your hair some breathing room between treatments!"
        ),
    ]

    static func solutions(for texture: HairTexture, goals: [HairGoal]) -> [HairSolution] {
        allSolutions.filter { $0.matches(texture: texture, goals: goals) }
    }
}
