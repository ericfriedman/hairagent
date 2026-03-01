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
- **Colors:** Pastel pink, pastel blue, pastel yellow, pastel coral, white backgrounds, black text
- **Vibe:** Bold, trendy, fun -- not childish. Fashion-forward, welcoming for all ages
- **Font:** Clean, modern, highly readable

## Coding Standards
- Swift Package with iOS 17 + macOS 14 targets
- Use SwiftUI-only types (no UIKit references like `Color(.systemGray6)` -- use `Color.gray.opacity(0.12)` instead)
- Views use callback closures for navigation (no NavigationStack)
- AppTheme enum for all colors and fonts
- Enums use `rawValue` strings for Codable/SwiftData compatibility

## Current Status
- **Phase:** v1 implementation complete -- all views, models, data, and navigation built
- **Last session:** 2026-03-01 - Built entire v1 app (15 tests passing)
- **Design doc:** docs/plans/2026-03-01-hair-agent-design.md
- **Implementation plan:** docs/plans/2026-03-01-hair-agent-implementation.md
