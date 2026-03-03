# Hair Agent v2 Features -- Design Doc

**Date:** 2026-03-02
**Status:** All 3 features approved

---

## Feature 1: Hair Color Gradient Slider

### Summary
Replace the card-based color picker in quiz Step 1 with a draggable gradient slider that covers all natural hair colors plus rainbow/fantasy colors for dyed hair.

### The Slider Bar
- Horizontal gradient bar, wide and easy to drag on iPad
- Colors flow left to right:
  - **Natural colors:** Black -> Dark Brown -> Auburn/Red -> Medium Brown -> Light Brown -> Dark Blonde -> Blonde -> Platinum/White
  - **Rainbow/fun colors:** Pink -> Red -> Orange -> Yellow -> Green -> Blue -> Purple
- Rainbow section at the right end of the bar

### The Thumb (Draggable Circle)
- Round circle filled with the currently selected color
- White border so it stands out against any part of the gradient

### Color Label
- Text updates as you drag to show the closest named color
- Named stops: "Black", "Dark Brown", "Auburn", "Medium Brown", "Light Brown", "Dark Blonde", "Blonde", "Platinum", "Pink", "Red", "Orange", "Yellow", "Green", "Blue", "Purple"

### Changes from v1
- Removes the card-based color picker entirely
- Removes the "Other" option -- slider covers all colors
- Selected color is saved to user profile and used by Feature 2 (before/after illustrations)

---

## Feature 2: Before/After Hair Illustrations

### Summary
Each solution card in the results list shows a side-by-side illustration of hair strands -- "before" showing the user's hair problem, "after" showing what the solution does -- all drawn in the user's chosen hair color from the gradient slider.

### Placement
- On results cards, side by side
- Small "Before" and "After" labels underneath each illustration

### Art Style
- Simple hair strands drawn with SwiftUI shapes
- All colored in the user's chosen hair color from the gradient slider

### "Before" Strands -- Per Hair Texture
Each texture gets a distinct visual:
- **Frizzy:** Zigzag, poofy strands going in different directions
- **Oily:** Strands sticking together, droopy/heavy-looking
- **Dry:** Rough, broken-looking strands with gaps
- **Damaged:** Frayed tips, split ends visible

### "After" Strands -- Per Solution Type
The "after" reflects what the specific solution does:
- **Moisturizing masks** (Honey & Olive Oil, Coconut Oil Deep Condition, Avocado & Olive Oil): Smooth, flowing, hydrated-looking strands
- **Protein treatments** (Egg & Yogurt): Fuller, stronger-looking strands
- **Clarifying rinses** (Apple Cider Vinegar): Light, separated, clean-looking strands
- **Smoothing masks** (Banana & Honey): Sleek, aligned strands
- **Scalp treatments** (Aloe Vera): Healthy roots, flowing strands
- **Strength rinses** (Rice Water): Thick, bouncy strands

### Glow Effect
All "after" strands have a subtle glow/halo effect to emphasize the transformation.

### Color
Always uses the exact color the user picked on the gradient slider -- both before and after strands match.

---

## Feature 3: Usage Frequency Recommendations

### Summary
Every hair solution gets a "how often to use it" guide with a general recommendation, personalized tips based on hair type, and overuse warnings. A new "My Schedule" tab shows all solutions with frequency badges.

### Data Model Changes
Add three fields to `HairSolution`:
- **`defaultFrequency: String`** -- General recommendation (e.g., "1-2 times per week")
- **`frequencyByTexture: [HairTexture: String]`** -- Personalized tip per hair type
- **`overuseWarning: String`** -- What happens with overuse

### Results Screen Tabs
Two tabs at the top of the results screen:
- **"My Solutions"** -- existing results cards (no change, now with before/after illustrations from Feature 2)
- **"My Schedule"** -- new frequency view

### My Schedule Tab
Scrollable list of all recommended solutions:
- Solution name
- Colorful pastel frequency badge (pill-shaped, using app color palette)
- Personalized note based on user's hair texture
- Tappable -- opens detail view

### Detail View -- "How Often" Section
New section at the bottom of the detail view:
1. **Recommended frequency** -- big, clear text with the general recommendation
2. **Your personal tip** -- colorful card with a tip based on quiz answers
3. **Watch out!** -- gentle warning card (light yellow/coral with icon) about overuse

### Content Approach
- All frequency data hand-written and bundled (static data)
- Language is friendly, educational, readable for ages 10+
- No medical jargon -- straight talk like a friend giving advice

---

## Visual Style (All Features)
- Same colorful pastel gradient backgrounds
- Same floating decorations (hearts, bows, sparkles, stars, scissors)
- Same hot pink squiggly border
- White cards with slight transparency
- Clean, modern, readable fonts
- Consistent with existing v1 visual polish

## How the Features Connect
1. User drags the **gradient slider** to pick their hair color
2. They complete the rest of the quiz (texture, goals)
3. Results show solution cards with **before/after illustrations** in their chosen color
4. User switches to the **"My Schedule" tab** to see how often to use each solution
5. Tapping any solution shows the detail view with ingredients, steps, and the **"How Often" usage guide**
