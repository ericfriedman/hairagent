# Hair Agent - Agent Notes

This file tracks what Claude needs to know across sessions. Updated at the end of every session.

## Key Context
- This is a father-daughter project. The daughter (age 11) came up with the idea.
- Keep explanations accessible and fun.
- The app is for iPad, built with SwiftUI.
- All hair solutions must use common household ingredients (coconut oil, honey, olive oil, eggs, aloe vera, etc.).
- Design vibe: bold, trendy, fun but not childish. Pastel pink/blue/yellow/coral + white + black text.
- Target audience: everyone, but inclusive of kids and tweens.

## What We've Done
- **2026-03-01:** Project initialized. Created CLAUDE.md, agents.md, project.md. Set up GitHub repo.
- **2026-03-01:** Completed brainstorming session. Defined app concept, chose SwiftUI, designed flow, locked in colors. Wrote design doc.
- **2026-03-01:** Built entire v1 app! 11 tasks completed: project scaffold, theme, models, 8 hair solutions, welcome screen, name entry, 3-step quiz, results view, tip detail view, navigation wiring. 15 tests all passing.
- **2026-03-01:** Built marketing landing page in site/ folder. Next.js 16 + Tailwind v4 + shadcn/ui. Deployed on Vercel (hairagent project). 5 sections: Hero with iPad mockup, How It Works, What Makes It Different, About the Creators, CTA + Footer. Visual style matches the app (pastel cards with sparkle icons, coral pill buttons). Vercel deployment protection is on -- needs to be disabled in dashboard for public access.
- **2026-03-01:** Major visual polish! Added colorful pastel gradient backgrounds to every screen (DecorativeBackground component with per-screen styles). Added floating decorative elements: hearts, bows (custom BowView), sparkles, stars, scissors. Added hot pink color to AppTheme. Added hot pink squiggly border (SquigglyRectangle shape) around every screen. Increased decoration sizes and opacities to be bold and visible. Updated cards (QuizOptionCard, SolutionCard) with white backgrounds for contrast against colored backgrounds. Regenerated Xcode project via xcodegen. App builds and runs on iPad simulator.
- **2026-03-01:** Started brainstorming v2 features. Three ideas from the creator:
  1. **Hair color gradient slider** -- replace card-based color picker with a draggable slider across a realistic hair color gradient (black to white). Approved: straight gradient bar.
  2. **Before/after hair illustrations** -- results cards show custom-drawn hair in the user's chosen color. "Before" shows damage (frizzy, dry, oily, etc.), "After" shows smooth healthy hair. Approved: drawn SwiftUI shapes approach.
  3. **Usage frequency per recipe** -- each solution shows how often to use it, personalized by hair texture (e.g., oily hair uses oil mask less often than dry hair). Approved: per-solution + per-hair-type frequency.
- **2026-03-24:** BIG session! Completed ALL v2 tasks (2-14). Added SolutionType enum + frequency fields (Task 2), real frequency content for all 8 solutions (Task 3), UserProfile gradient color storage (Task 4), GradientSliderView (Task 5), HairStrandsView before/after illustrations (Task 6), FrequencyBadge + HowOftenSection (Task 7), MyScheduleView (Task 8), replaced color picker with gradient slider (Task 9), updated ContentView (Task 10), added tabs + before/after to ResultsView (Task 11), How Often section in TipDetailView (Task 12), removed old HairColor enum (Task 13), regenerated Xcode project (Task 14). Added Enter/Return key support for Welcome, Name Entry, and Quiz screens. Escape key for TipDetailView back. Fixed Package.swift to exclude HairAgentApp.swift from test target. 33 tests passing. App running on iPad Pro 13-inch simulator.
- **2026-03-24:** Started v3 brainstorming! Three new features approved in concept:
  1. **Monthly calendar schedule** -- all 12 months listed, tap to open real calendar grid. Activities: wash days, mask days, trim reminders, scalp care, heat-free days, protective style days. Personalized to hair type.
  2. **Badge achievement system** -- earn by completing full week of schedule. Mostly hair type/goal themed (Moisture Queen, Frizz Fighter, etc.) with some activity-based. Trophy shelf screen. Confetti celebration popup (needs LOTS of confetti).
  3. **Real hair photos** -- replace drawn shapes with actual photos. 4 before (per texture) + 4 after, color-tinted to gradient slider selection. Need to source 8 photos.
  4. **Fix button double-tap lag** -- animation eating first tap.
  - Visual mockups created and approved in .superpowers/brainstorm/ folder. Next: write design doc and implementation plan.
- **2026-04-05:** v3 BUILD SESSION! Wrote implementation plan (10 tasks). Built ALL v3 features:
  1. ScheduleModels (ScheduleActivityType, DaySchedule, ScheduleGenerator) + 7 tests
  2. BadgeModels (9 BadgeTypes, EarnedBadge) + 4 tests
  3. MonthListView (12-month scrollable card list, current month highlighted)
  4. MonthCalendarView (7-column grid, activity emojis, tap-to-complete days, badge earning)
  5. ConfettiView (40 animated emoji particles)
  6. BadgeCelebrationView (confetti popup overlay)
  7. BadgeTrophyShelfView (3-column badge grid, earned/locked states)
  8. Fixed button double-tap lag (replaced .animation with withAnimation)
  9. Wired everything into ResultsView (3 tabs: Solutions | Schedule | Badges) + ContentView
  10. Real before/after hair photos! 8 AI-generated images (ChatGPT). Woman from back, silver-gray hair, white shirt. Split composites into individual assets. Color-tinted with .blendMode(.color) -- only tints hair, not background/shirt.
  - Updated tagline to "We care for your hair"
  - Removed redundant old Schedule tab (Calendar IS the schedule)
  - Made calendar emojis bigger for readability (18px in cells, 20px in legend)
  - 44 tests passing. App running on iPad Pro 13-inch simulator.
- **2026-03-07:** Quick session -- restored `@main` attribute to HairAgentApp.swift (was removed for swift test compat, broke Xcode build). Got app building and running on iPad Pro 13-inch (M5) simulator (iOS 26.2). Reviewed v2 task list, ready to start Task 2 next session.
- **2026-03-02:** Finished brainstorming all 3 v2 features! Key design decisions:
  - **Gradient slider:** Natural colors (black to platinum) + rainbow section at the end for dyed hair (pink, blue, purple, etc.). Color-filled draggable circle thumb with white border. Label updates as you drag. Replaces card picker, removes "Other" option.
  - **Before/after illustrations:** Simple SwiftUI Shape hair strands in the user's chosen color. "Before" strands look different per texture (frizzy = zigzag, oily = droopy, dry = rough, damaged = split ends). "After" strands reflect what the solution does (moisturizing = smooth, protein = fuller, etc.) with a glow effect. Side by side on results cards with labels.
  - **Usage frequency:** 3 new fields on HairSolution (defaultFrequency, frequencyByTexture, overuseWarning). Results screen gets "My Solutions" / "My Schedule" tabs. My Schedule shows solutions with colorful frequency badges. Detail view gets "How Often" section with recommendation, personal tip, and overuse warning. All content hand-written, friendly language for ages 10+.
  - Wrote design docs: `docs/plans/2026-03-02-v2-features-design.md` and `docs/plans/2026-03-02-usage-frequency-design.md`
  - Wrote implementation plan: `docs/plans/2026-03-02-v2-implementation.md` (14 tasks, 4 phases)
  - Started development on `v2-features` branch. Task 1 complete (SelectedHairColor + HairColorGradient models, 12 new tests). 27 tests total passing.

## Open Questions
- Local persistence with SwiftData (models ready, but ContentView uses @State for now)
- Badge/schedule completion persistence (currently @State, resets on app restart)
- More hair solutions to add beyond the initial 8
- App icon design
- Vercel deployment protection -- needs disabling for public access
- Custom domain for the landing page
- Polish pass on hair photo color tinting (test with all slider colors)

## Things to Remember
- NEVER use em dashes anywhere
- Update these files every session start and end
- Push to GitHub at end of each session
- Design doc: docs/plans/2026-03-01-hair-agent-design.md
- Implementation plan: docs/plans/2026-03-01-hair-agent-implementation.md
- Landing page: site/ folder, deployed on Vercel
- Every quiz question must have an "Other" option
- Solutions must be easy to make at home with common products
- Use SwiftUI-only types (no UIKit) since Package targets both iOS and macOS
- Use `Color.gray.opacity(0.12)` instead of `Color(.systemGray6)`
- Xcode project generated via xcodegen from project.yml -- run `xcodegen generate` after adding new Swift files
- Cards on colored backgrounds use `.white.opacity(0.85-0.9)` instead of gray for visibility
- AppTheme.hotPink = Color(red: 1.0, green: 0.0, blue: 0.5)
- v2 COMPLETE + v3 MOSTLY COMPLETE on `v2-features` branch -- 44 tests passing
- v2 implementation plan: docs/plans/2026-03-02-v2-implementation.md
- v3 implementation plan: docs/plans/2026-04-05-v3-calendar-badges.md
- Package.swift excludes HairAgentApp.swift so swift test works; Xcode uses its own project file
- xcodegen regenerated after adding new files -- run `xcodegen generate` after adding new Swift files
- v3 mockups in .superpowers/brainstorm/ folder
- Enter/Return key support added to Welcome, NameEntry, QuizView; Escape on TipDetailView
- Old HairColor enum removed -- app uses SelectedHairColor (gradient-based) everywhere now
- Tagline: "We care for your hair"
- 3 tabs on results: Solutions | Schedule | Badges (old separate Schedule tab removed)
- Before/after photos: 8 images in Assets.xcassets, originals in collateral/ folder
- Photos use .blendMode(.color) for tinting -- only hair gets colored, not background/shirt
- Calendar emojis sized at 18px (cells) and 20px (legend) for readability
