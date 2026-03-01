# Hair Agent - App Design

**Date:** 2026-03-01
**Created by:** Father-daughter team (daughter age 11, original concept creator)

## Vision

Hair Agent is a personalized hair care advisor for iPad. Users take a quiz about their hair, and the app recommends at-home solutions using common household ingredients. It's for everyone -- kids, teens, and adults -- who wants to learn how to care for their hair with things they already have at home.

## App Flow

1. **Welcome Screen** -- Bold logo, app name "Hair Agent", "Get Started" button
2. **Enter Your Name** -- Simple text field, press Continue
3. **Hair Quiz** (one question per screen, progress bar, back button):
   - **Hair Color** -- Grid of color swatches + "Other" option
   - **Hair Texture** -- Frizzy, oily, dry, damaged + "Other" option
   - **Hair Goals** -- "What do you want to fix?" Pick at least 3 (e.g., more shine, less frizz, grow longer, stay healthy, repair damage) + "Other" option
4. **Results Screen** -- Personalized tips and pictures matched to quiz answers
5. **Profile/Home** -- Saved profile, view past results, retake quiz with new goals

Every quiz screen always includes an "Other" button for answers that don't fit the options.

## Content Strategy

- All tips and solutions are created by the team (not AI-generated)
- Solutions use **common household ingredients only** (coconut oil, honey, olive oil, eggs, aloe vera, etc.) -- nothing you'd need to buy at a salon
- Each solution includes:
  - Title
  - Photo
  - Ingredients list (common household items)
  - Step-by-step instructions
  - Tags for which hair concerns it addresses
- Solutions are matched to users based on their texture + goals selections

### Example Solution
**Honey & Olive Oil Hair Mask**
- Helps with: dry hair, add shine, repair damage
- Ingredients: 2 tbsp honey, 1 tbsp olive oil
- Steps: Mix together, apply to damp hair, wait 20 minutes, rinse

## Data Model

**User Profile** (saved locally):
- Name (string)
- Hair color (selection)
- Hair texture (selection)
- Hair goals (3+ selections)
- Saved results history

**Hair Solution** (bundled in app):
- Title
- Photo (asset)
- Ingredients list
- Step-by-step instructions
- Tags (array of concerns it addresses)

## Design Direction

### Vibe
Bold, trendy, and fun -- not childish. Fashion-forward and welcoming for all ages. Think beauty brand meets modern app.

### Color Palette
- **Pastel pink** -- primary accent
- **Pastel blue** -- secondary accent
- **Pastel yellow** -- tertiary accent
- **Pastel coral** -- highlight accent
- **White** -- backgrounds
- **Black** -- text (easy to read)

### Typography
- Clean, modern, highly readable font
- Bold headlines
- Clear hierarchy

### UI Elements
- Large tappable cards/buttons for quiz options (not tiny radio buttons)
- Hair color options as actual color circles
- Results as card-based layout with photo, title, ingredients preview
- Tap card to expand for full instructions
- Smooth transitions between quiz screens
- Satisfying tap feedback on selections

### iPad Optimization
- Takes advantage of larger screen
- Side-by-side layouts where appropriate
- Large, beautiful photos

## Technical Architecture

- **Platform:** SwiftUI for iPadOS
- **Data storage:** SwiftData (local, on-device)
- **Content:** Hair tips, solutions, and images bundled in the app
- **Backend:** None needed -- everything runs locally
- **Min iOS version:** iPadOS 17+

### View Structure
- `WelcomeView` -- landing screen with logo and Get Started
- `NameEntryView` -- enter your name
- `QuizView` -- handles all quiz steps (color, texture, goals)
- `ResultsView` -- matched tips displayed as cards
- `TipDetailView` -- full instructions when a card is tapped
- `ProfileView` -- saved profile, option to retake quiz or change goals

## Key Features (v1)

1. Name entry with local save
2. Multi-step hair quiz with progress bar
3. "Other" option on every quiz question
4. Personalized results matching
5. Card-based tip display with photos
6. Detailed solution view with ingredients and steps
7. Save profile locally
8. Retake quiz with new goals (keep profile)

## Out of Scope (for now)

- User accounts / cloud sync
- AI-generated tips
- Community features
- Android support
- Progress tracking / hair diary
