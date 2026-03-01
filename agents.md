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

## Open Questions
- Image assets / photography for solution cards (currently using placeholder sparkles icons)
- Local persistence with SwiftData (models ready, but ContentView uses @State for now)
- Xcode project setup (currently Swift Package -- need .xcodeproj for App Store)
- More hair solutions to add beyond the initial 8
- App icon design

## Things to Remember
- Update these files every session start and end
- Push to GitHub at end of each session
- Design doc: docs/plans/2026-03-01-hair-agent-design.md
- Implementation plan: docs/plans/2026-03-01-hair-agent-implementation.md
- Every quiz question must have an "Other" option
- Solutions must be easy to make at home with common products
- Use SwiftUI-only types (no UIKit) since Package targets both iOS and macOS
- Use `Color.gray.opacity(0.12)` instead of `Color(.systemGray6)`
