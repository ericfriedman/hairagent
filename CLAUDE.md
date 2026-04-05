# Hair Agent - Project Instructions

## About This Project
Hair Agent is an iPad app conceived by an 11-year-old creator and built collaboratively with her dad. This is a father-daughter project, so we keep things fun, educational, and empowering.

## Session Protocol
**Every session start:** Read CLAUDE.md, agents.md, and project.md to get up to speed.
**Every session end:** Update CLAUDE.md, agents.md, and project.md with progress, decisions, and next steps. Commit and push to GitHub.

## Tech Stack
- **Platform:** iPadOS 17+
- **Language:** Swift
- **UI Framework:** SwiftUI
- **Data Storage:** SwiftData (local, on-device)
- **Backend:** None -- fully local app
- **Content:** Bundled in-app (tips, images, solutions)

## Architecture & Decisions
- **2026-03-01:** Chose SwiftUI native over React Native and web app for best iPad experience
- **2026-03-01:** No backend/server -- all data and content stored locally
- **2026-03-01:** All hair care content created by the team, not AI-generated
- **2026-03-01:** Solutions must use common household ingredients only

## Design Direction
- **Colors:** Pastel pink, pastel blue, pastel yellow, pastel coral, hot pink, white backgrounds, black text
- **Vibe:** Bold, trendy, fun -- not childish. Fashion-forward, welcoming for all ages
- **Font:** Clean, modern, highly readable
- **Decorations:** Floating hearts, bows, sparkles, stars, scissors across all screens -- bold and visible
- **Hot pink squiggly border** around every screen
- **DecorativeBackground** component with per-screen pastel gradient styles
- **BowView** custom component (ellipses + capsules for ribbon tails)

## Coding Standards
- Swift Package with iOS 17 + macOS 14 targets
- Use SwiftUI-only types (no UIKit references like `Color(.systemGray6)` -- use `Color.gray.opacity(0.12)` instead)
- Views use callback closures for navigation (no NavigationStack)
- AppTheme enum for all colors and fonts
- Enums use `rawValue` strings for Codable/SwiftData compatibility

## Writing Rules
- NEVER use em dashes anywhere -- not in code, copy, docs, or comments

## Current Status
- **Phase:** v3 MOSTLY COMPLETE, polish remaining
- **Branch:** `v2-features` (branched from main)
- **Last session:** 2026-04-05 - Built ALL v3 features! Monthly calendar schedule (12-month list + calendar grid with personalized activities). Badge achievement system (9 badges, trophy shelf, confetti celebration popup). Real before/after hair photos with color tinting (blend mode). Fixed button double-tap lag. Updated tagline to "We care for your hair". Removed redundant Schedule tab (Calendar IS the schedule now). Made calendar emojis bigger for readability. 44 tests passing.
- **Next session:** Test and polish the color tinting on hair photos (verify it looks right with different colors). Consider if before/after photos need more refinement. General polish pass. Maybe merge v2-features to main.
- **v1 design doc:** docs/plans/2026-03-01-hair-agent-design.md
- **v1 implementation plan:** docs/plans/2026-03-01-hair-agent-implementation.md
- **v2 features design:** docs/plans/2026-03-02-v2-features-design.md
- **v2 usage frequency design:** docs/plans/2026-03-02-usage-frequency-design.md
- **v2 implementation plan:** docs/plans/2026-03-02-v2-implementation.md
- **v3 implementation plan:** docs/plans/2026-04-05-v3-calendar-badges.md
- **Landing page design:** docs/plans/2026-03-01-landing-page-design.md
- **Landing page plan:** docs/plans/2026-03-01-landing-page-implementation.md
- **Landing page:** site/ folder (Next.js 16, Tailwind v4, shadcn/ui, deployed on Vercel)

## v3 Features (BUILT)
1. **Monthly calendar schedule** -- DONE. 12-month list, tap to open calendar grid. Activities: wash days, mask days, trim reminders, scalp care, heat-free days, protective style days. Personalized to hair type. Tap days to mark complete.
2. **Badge achievement system** -- DONE. 9 badges (Moisture Queen, Frizz Fighter, Shine Star, Scalp Guru, Strength Boss, Mask Master, Consistency Champ, Heat-Free Hero, Protective Pro). Trophy shelf with earned/locked states. Confetti celebration popup. Earn by completing 7 days.
3. **Real hair photos** -- DONE. 8 AI-generated photos (ChatGPT). Woman from back in white shirt, silver-gray hair. Color-tinted with .blendMode(.color) to match gradient slider selection. Photos in collateral/ folder, assets in Assets.xcassets.
4. **Fix button double-tap lag** -- DONE. Replaced .animation modifier with withAnimation in closures.
5. **Tagline** -- Updated to "We care for your hair"
6. **Tab cleanup** -- Removed old Schedule tab, renamed Calendar to Schedule (3 tabs: Solutions | Schedule | Badges)
