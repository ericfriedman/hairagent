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
- **Phase:** v2 development in progress (Task 1 of 14 complete)
- **Branch:** `v2-features` (branched from main)
- **Last session:** 2026-03-02 - Finished v2 brainstorming for all 3 features, wrote design docs and implementation plan, started building Task 1 (SelectedHairColor + HairColorGradient models). 27 tests passing.
- **v1 design doc:** docs/plans/2026-03-01-hair-agent-design.md
- **v1 implementation plan:** docs/plans/2026-03-01-hair-agent-implementation.md
- **v2 features design:** docs/plans/2026-03-02-v2-features-design.md
- **v2 usage frequency design:** docs/plans/2026-03-02-usage-frequency-design.md
- **v2 implementation plan:** docs/plans/2026-03-02-v2-implementation.md
- **Landing page design:** docs/plans/2026-03-01-landing-page-design.md
- **Landing page plan:** docs/plans/2026-03-01-landing-page-implementation.md
- **Landing page:** site/ folder (Next.js 16, Tailwind v4, shadcn/ui, deployed on Vercel)
