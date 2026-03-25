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
- **Phase:** v2 COMPLETE, v3 brainstorming in progress
- **Branch:** `v2-features` (branched from main)
- **Last session:** 2026-03-24 - Completed ALL 14 v2 tasks (gradient slider, before/after illustrations, frequency schedule, My Schedule tab). Added Enter key support to all screens. Started v3 brainstorming -- monthly calendar schedule, badge system, real hair photos. Mockups approved. Need to write design doc and implementation plan next session.
- **Next session:** Resume v3 brainstorm -- write design doc, then implementation plan. Fix button double-tap lag. More confetti on badge celebration popup.
- **v1 design doc:** docs/plans/2026-03-01-hair-agent-design.md
- **v1 implementation plan:** docs/plans/2026-03-01-hair-agent-implementation.md
- **v2 features design:** docs/plans/2026-03-02-v2-features-design.md
- **v2 usage frequency design:** docs/plans/2026-03-02-usage-frequency-design.md
- **v2 implementation plan:** docs/plans/2026-03-02-v2-implementation.md
- **Landing page design:** docs/plans/2026-03-01-landing-page-design.md
- **Landing page plan:** docs/plans/2026-03-01-landing-page-implementation.md
- **Landing page:** site/ folder (Next.js 16, Tailwind v4, shadcn/ui, deployed on Vercel)

## v3 Features (brainstorming -- approved but not yet specced)
1. **Monthly calendar schedule** -- 12-month list, tap to open real calendar grid with days. Activities: wash days, mask days, trim reminders, scalp care, heat-free days, protective style days. Schedule personalized to user's hair type.
2. **Badge achievement system** -- earn badges by completing a full week of schedule. Badge themes mostly based on hair type/goals (Moisture Queen, Frizz Fighter, Shine Star, etc.) with some activity-based ones (Mask Master). Badge trophy shelf screen. Confetti celebration popup when earned (lots of confetti!).
3. **Real hair photos** -- replace SwiftUI shape illustrations with real photos. 4 before photos (one per texture: frizzy, oily, dry, damaged) + 4 after photos. Color-tinted to match user's gradient slider selection. Need to source/create 8 photos.
4. **Fix button double-tap lag** -- buttons require two taps, likely animation-related
