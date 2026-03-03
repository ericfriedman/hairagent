# Usage Frequency Feature -- Design Doc

**Date:** 2026-03-02
**Feature:** v2 Feature 3 -- Usage frequency recommendations per recipe
**Status:** Approved

## Summary

Every hair solution gets a "how often to use it" guide so users know the right amount -- not too much, not too little. The app shows a general recommendation plus a personalized tip based on the user's hair type from the quiz. Every solution also includes a friendly warning about what happens if you overdo it.

## Why This Matters

Some hair treatments (like protein masks or oil treatments) can actually damage hair if used too often. Users need to know the safe frequency, especially younger users who are learning about hair care for the first time.

## Data Model Changes

Add three new fields to `HairSolution`:

- **`defaultFrequency: String`** -- General recommendation everyone sees (e.g., "1-2 times per week")
- **`frequencyByTexture: [HairTexture: String]`** -- Personalized tip per hair type (e.g., `[.oily: "Once a week max -- oil masks can weigh down oily hair"]`)
- **`overuseWarning: String`** -- What happens if you use it too much (e.g., "Too much protein can make hair stiff and brittle")

### Example: Egg & Yogurt Protein Treatment

```swift
defaultFrequency: "Once every 1-2 weeks"
frequencyByTexture: [
    .oily: "Once every 2 weeks -- protein plus oil can feel heavy",
    .dry: "Once a week -- dry hair loves extra protein",
    .frizzy: "Once a week -- helps smooth and strengthen",
    .damaged: "Once a week -- but take a break if hair feels stiff"
]
overuseWarning: "Too much protein can cause hair to feel stiff, dry, or even snap. If your hair starts feeling crunchy, take a 2-week break."
```

## UI Changes

### 1. Results Screen Tabs

The results screen gets two tabs at the top:

- **"My Solutions"** -- the existing results cards (no change)
- **"My Schedule"** -- the new frequency view

### 2. My Schedule Tab

A scrollable list showing all recommended solutions with frequency info:

- **Solution name** -- clear and readable
- **Colorful pastel frequency badge** -- a pill-shaped badge (pink, blue, yellow, or coral) showing the frequency like "2x/week" or "Monthly"
- **Personalized note** -- a short tip based on the user's hair texture from the quiz
- **Tappable** -- tapping a solution opens the detail view

### 3. Detail View -- "How Often" Section

A new section at the bottom of the existing detail view (below ingredients and steps):

1. **Recommended frequency** -- big, clear text showing the general recommendation
2. **Your personal tip** -- colorful card with a tip based on their quiz answers (e.g., "Since you have oily hair: Try once a week max")
3. **Watch out!** -- gentle warning card (light yellow/coral background with an icon) about overuse risks

## Visual Style

- Same colorful pastel gradient backgrounds as the rest of the app
- Same floating decorations (hearts, bows, sparkles, stars, scissors)
- Same hot pink squiggly border
- White cards with slight transparency for readability
- Frequency badges use the existing pastel palette (pink, blue, yellow, coral)
- All text is clear, simple, friendly -- readable for ages 10 and up
- No medical jargon -- straight talk like a friend giving advice

## Navigation

- User completes quiz and sees results
- Results screen has tabs: "My Solutions" | "My Schedule"
- "My Solutions" works exactly as before
- "My Schedule" shows the frequency list
- Tapping any solution (from either tab) opens the detail view with the new "How Often" section

## Content Approach

- All frequency data is hand-written and bundled in the app (static data, same pattern as existing solutions)
- Each of the 8 existing solutions gets frequency info added by the creators
- Language is friendly, educational, and easy for young users to understand

## Scope

- Add 3 fields to HairSolution model
- Write frequency content for all 8 solutions
- Build My Schedule tab view
- Build "How Often" section in detail view
- Add tab switcher to results screen
- Update tests
