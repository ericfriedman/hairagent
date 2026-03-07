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
- **2026-03-07:** Quick session -- restored `@main` attribute to HairAgentApp.swift (was removed for swift test compat, broke Xcode build). Got app building and running on iPad Pro 13-inch (M5) simulator (iOS 26.2). Reviewed v2 task list, ready to start Task 2 next session.
- **2026-03-02:** Finished brainstorming all 3 v2 features! Key design decisions:
  - **Gradient slider:** Natural colors (black to platinum) + rainbow section at the end for dyed hair (pink, blue, purple, etc.). Color-filled draggable circle thumb with white border. Label updates as you drag. Replaces card picker, removes "Other" option.
  - **Before/after illustrations:** Simple SwiftUI Shape hair strands in the user's chosen color. "Before" strands look different per texture (frizzy = zigzag, oily = droopy, dry = rough, damaged = split ends). "After" strands reflect what the solution does (moisturizing = smooth, protein = fuller, etc.) with a glow effect. Side by side on results cards with labels.
  - **Usage frequency:** 3 new fields on HairSolution (defaultFrequency, frequencyByTexture, overuseWarning). Results screen gets "My Solutions" / "My Schedule" tabs. My Schedule shows solutions with colorful frequency badges. Detail view gets "How Often" section with recommendation, personal tip, and overuse warning. All content hand-written, friendly language for ages 10+.
  - Wrote design docs: `docs/plans/2026-03-02-v2-features-design.md` and `docs/plans/2026-03-02-usage-frequency-design.md`
  - Wrote implementation plan: `docs/plans/2026-03-02-v2-implementation.md` (14 tasks, 4 phases)
  - Started development on `v2-features` branch. Task 1 complete (SelectedHairColor + HairColorGradient models, 12 new tests). 27 tests total passing.

## Open Questions
- Image assets / photography for solution cards (currently using placeholder sparkle icons)
- Local persistence with SwiftData (models ready, but ContentView uses @State for now)
- More hair solutions to add beyond the initial 8
- App icon design
- Vercel deployment protection -- needs disabling for public access
- Custom domain for the landing page

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
- v2 work is on `v2-features` branch -- 14 tasks total, Task 1 done, resume at Task 2
- v2 implementation plan: docs/plans/2026-03-02-v2-implementation.md
- Using subagent-driven development: implementer subagent per task, then spec review, then code quality review
- `@main` was removed from HairAgentApp.swift to fix swift test -- will need to verify Xcode build in Task 14
