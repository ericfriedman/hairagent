# Hair Agent Landing Page Design

**Date:** 2026-03-01
**Purpose:** Marketing site to showcase the Hair Agent iPad app, drive App Store downloads, and present to affiliate programs (e.g., Sephora)

## Tech Stack

| Layer | Choice |
|-------|--------|
| Framework | Next.js 15 (App Router, static export) |
| Styling | Tailwind CSS v4 |
| Components | shadcn/ui |
| Language | TypeScript |
| Deployment | Vercel (auto-deploy from GitHub) |
| Location | `/site` folder in the existing hairagent repo |

## Color Palette (matches the app)

- Pastel Pink: `#FFB5C2`
- Pastel Blue: `#ADD9F4`
- Pastel Yellow: `#FFF0B3`
- Pastel Coral: `#FF9A8F`
- Background: White
- Text: Black
- Typography: Inter (or similar clean sans-serif web font)

## Page Sections

### 1. Hero

Full-width section with a soft pastel gradient background (pink to coral to blue).

- **Headline:** "Meet Your New Hair BFF."
- **Subheadline:** "Answer a few fun questions about your hair and get custom DIY recipes in seconds."
- **CTA:** Apple "Download on the App Store" badge (or "Coming Soon" variant)
- **Visual:** CSS-rendered iPad mockup showing a styled version of the app's welcome/quiz screen using the real pastel palette

Layout: Text on the left, iPad mockup on the right. Stacks vertically on mobile.

### 2. How It Works (3 steps)

Three cards in a horizontal row, each with a step number, title, and description:

1. **Take a Quick Quiz** -- "Tell us about your hair color, texture, and goals."
2. **Get Personalized Tips** -- "We match you with DIY solutions tailored to your hair."
3. **Make It at Home** -- "Every recipe uses ingredients you already have in your kitchen."

Background: White. Cards have subtle pastel accents.

### 3. What Makes It Different

Feature grid (2x2 on desktop, stacked on mobile):

- **All-Natural Ingredients** -- Honey, coconut oil, aloe vera -- stuff from your kitchen
- **Personalized to You** -- Not generic advice. Matched to YOUR hair type and goals
- **No Salon Needed** -- Professional-quality care, DIY style
- **Fun for Everyone** -- Whether you're 11 or 41, great hair has no age limit

### 4. About the Creators

Warm section with pastel yellow background:

- **Headline:** "Built by a Kid Who Knows Hair"
- **Story:** Short paragraph about the 11-year-old creator and her dad building the app together because she wanted better hair care for everyone -- not just people who can afford expensive products
- This section is the key differentiator for affiliate program pitches

### 5. CTA + Footer

- Repeated App Store download button
- Simple footer: copyright, privacy policy link, contact link

## Design Principles

- **Responsive:** Looks great on desktop, tablet, and mobile
- **Fast:** Static export, no server-side rendering needed
- **On-brand:** Matches the app's pastel palette and fun-but-not-childish vibe
- **Conversion-focused:** Clear CTAs, minimal distractions
- **Professional enough for affiliates:** Clean, polished, shows this is a real product

## Tone

Fun, playful, action-oriented. Not childish. Fashion-forward and welcoming for all ages. The copy should feel like talking to a friend who's really into hair care.
