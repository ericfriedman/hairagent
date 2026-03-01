# Hair Agent Landing Page Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Build a marketing landing page for the Hair Agent iPad app, deployed on Vercel from a `/site` folder in the existing repo.

**Architecture:** Next.js 15 App Router with static export. Single page with 5 section components. Tailwind CSS v4 for styling with custom colors matching the app's pastel palette. shadcn/ui for polished base components.

**Tech Stack:** Next.js 15, TypeScript, Tailwind CSS v4, shadcn/ui, Vercel

**Design doc:** `docs/plans/2026-03-01-landing-page-design.md`

**Color reference (from `HairAgent/Theme/AppTheme.swift`):**
- Pastel Pink: `rgb(255, 181, 194)` → `#FFB5C2`
- Pastel Blue: `rgb(173, 217, 244)` → `#ADD9F4`
- Pastel Yellow: `rgb(255, 240, 179)` → `#FFF0B3`
- Pastel Coral: `rgb(255, 153, 143)` → `#FF998F`
- Background: White `#FFFFFF`
- Text: Black `#000000`

---

### Task 1: Scaffold Next.js project in /site

**Files:**
- Create: `site/` (entire Next.js project via create-next-app)
- Modify: `.gitignore` (add site-specific ignores)

**Step 1: Create the Next.js project**

Run from repo root:
```bash
cd /Users/ericfriedman/Dropbox/Documents/AI/claude/hairagent
npx create-next-app@latest site --ts --tailwind --eslint --app --no-src-dir --use-npm --no-import-alias
```

Accept defaults. This creates `site/` with Next.js 15 + Tailwind CSS + TypeScript.

**Step 2: Verify it runs**

```bash
cd site && npm run dev
```

Expected: Dev server starts on localhost:3000. Kill it after confirming.

**Step 3: Update root .gitignore**

Add to `.gitignore`:
```
site/node_modules/
site/.next/
site/out/
```

**Step 4: Configure static export**

Edit `site/next.config.ts`:
```typescript
import type { NextConfig } from "next";

const nextConfig: NextConfig = {
  output: "export",
  images: {
    unoptimized: true,
  },
};

export default nextConfig;
```

Static export means Vercel serves pure HTML/CSS/JS -- no server functions needed.

**Step 5: Commit**

```bash
git add site/ .gitignore
git commit -m "feat: scaffold Next.js landing page in /site"
```

---

### Task 2: Install shadcn/ui and configure theme colors

**Files:**
- Modify: `site/app/globals.css` (custom color tokens)
- Create: `site/components/ui/` (via shadcn init)
- Modify: `site/tailwind.config.ts` or `site/app/globals.css` (color vars)

**Step 1: Initialize shadcn/ui**

```bash
cd /Users/ericfriedman/Dropbox/Documents/AI/claude/hairagent/site
npx shadcn@latest init
```

Choose: New York style, Neutral base color, CSS variables: yes.

**Step 2: Install the Button component**

```bash
npx shadcn@latest add button
```

**Step 3: Add custom color tokens to globals.css**

Add these CSS custom properties inside the `:root` block in `site/app/globals.css`:

```css
:root {
  /* Hair Agent brand colors */
  --ha-pink: 255 181 194;
  --ha-blue: 173 217 244;
  --ha-yellow: 255 240 179;
  --ha-coral: 255 153 143;
}
```

And extend Tailwind usage so we can use classes like `bg-ha-pink`:

In `site/tailwind.config.ts`, extend the theme colors:
```typescript
colors: {
  "ha-pink": "rgb(var(--ha-pink) / <alpha-value>)",
  "ha-blue": "rgb(var(--ha-blue) / <alpha-value>)",
  "ha-yellow": "rgb(var(--ha-yellow) / <alpha-value>)",
  "ha-coral": "rgb(var(--ha-coral) / <alpha-value>)",
}
```

Note: If Tailwind v4 uses CSS-based config instead of `tailwind.config.ts`, add the colors directly in `globals.css` using `@theme` directive:
```css
@theme {
  --color-ha-pink: #FFB5C2;
  --color-ha-blue: #ADD9F4;
  --color-ha-yellow: #FFF0B3;
  --color-ha-coral: #FF998F;
}
```

**Step 4: Set global font to Inter**

In `site/app/layout.tsx`, import Inter from `next/font/google`:
```typescript
import { Inter } from "next/font/google";

const inter = Inter({ subsets: ["latin"] });
```

Apply it to the `<body>` className.

**Step 5: Verify colors work**

Temporarily add a test div in `site/app/page.tsx`:
```tsx
<div className="bg-ha-pink p-4">Pink works</div>
```

Run `npm run dev`, confirm the color renders.

**Step 6: Commit**

```bash
git add -A site/
git commit -m "feat: configure shadcn/ui and brand color theme"
```

---

### Task 3: Build the Hero section

**Files:**
- Create: `site/components/hero.tsx`
- Modify: `site/app/page.tsx`

**Step 1: Create the Hero component**

Create `site/components/hero.tsx`:

```tsx
export function Hero() {
  return (
    <section className="relative min-h-[90vh] flex items-center overflow-hidden">
      {/* Gradient background */}
      <div className="absolute inset-0 bg-gradient-to-br from-ha-pink via-ha-coral/30 to-ha-blue/40" />

      <div className="relative z-10 mx-auto max-w-7xl px-6 py-20 grid grid-cols-1 lg:grid-cols-2 gap-12 items-center">
        {/* Left: Copy */}
        <div>
          <h1 className="text-5xl md:text-7xl font-bold tracking-tight text-black">
            Meet Your New
            <br />
            Hair BFF.
          </h1>
          <p className="mt-6 text-xl md:text-2xl text-black/70 max-w-lg">
            Answer a few fun questions about your hair and get custom DIY
            recipes in seconds.
          </p>
          <div className="mt-10">
            <a
              href="#"
              className="inline-block bg-black text-white px-8 py-4 rounded-full text-lg font-semibold hover:bg-black/80 transition-colors"
            >
              Coming Soon to the App Store
            </a>
          </div>
        </div>

        {/* Right: iPad Mockup */}
        <div className="flex justify-center lg:justify-end">
          <div className="relative w-[380px] h-[520px] bg-white rounded-[2rem] shadow-2xl border-[8px] border-gray-800 p-6 flex flex-col items-center justify-center">
            {/* Fake app screen */}
            <div className="w-16 h-16 rounded-full bg-ha-coral mb-6" />
            <h2 className="text-3xl font-bold text-black">Hair Agent</h2>
            <p className="text-gray-500 mt-2 text-center">
              Your personal hair care advisor
            </p>
            <div className="mt-8 w-full bg-ha-coral text-white text-center py-3 rounded-full font-semibold">
              Get Started
            </div>
            {/* Decorative dots */}
            <div className="flex gap-2 mt-6">
              <div className="w-3 h-3 rounded-full bg-ha-pink" />
              <div className="w-3 h-3 rounded-full bg-ha-blue" />
              <div className="w-3 h-3 rounded-full bg-ha-yellow" />
            </div>
          </div>
        </div>
      </div>
    </section>
  );
}
```

**Step 2: Wire into page.tsx**

Replace `site/app/page.tsx` contents:

```tsx
import { Hero } from "@/components/hero";

export default function Home() {
  return (
    <main>
      <Hero />
    </main>
  );
}
```

Note: `@/` alias should already be configured by create-next-app. If not, the import path is `../components/hero`.

**Step 3: Verify**

Run `npm run dev`. Confirm: gradient background, bold headline, subheadline, CTA button, iPad mockup with fake app screen.

**Step 4: Commit**

```bash
git add site/components/hero.tsx site/app/page.tsx
git commit -m "feat: add Hero section with iPad mockup"
```

---

### Task 4: Build the How It Works section

**Files:**
- Create: `site/components/how-it-works.tsx`
- Modify: `site/app/page.tsx`

**Step 1: Create the component**

Create `site/components/how-it-works.tsx`:

```tsx
const steps = [
  {
    number: "1",
    title: "Take a Quick Quiz",
    description:
      "Tell us about your hair color, texture, and goals.",
    color: "bg-ha-pink",
  },
  {
    number: "2",
    title: "Get Personalized Tips",
    description:
      "We match you with DIY solutions tailored to your hair.",
    color: "bg-ha-blue",
  },
  {
    number: "3",
    title: "Make It at Home",
    description:
      "Every recipe uses ingredients you already have in your kitchen.",
    color: "bg-ha-yellow",
  },
];

export function HowItWorks() {
  return (
    <section className="py-24 px-6 bg-white">
      <div className="mx-auto max-w-7xl">
        <h2 className="text-4xl md:text-5xl font-bold text-center text-black mb-16">
          How It Works
        </h2>
        <div className="grid grid-cols-1 md:grid-cols-3 gap-8">
          {steps.map((step) => (
            <div
              key={step.number}
              className="text-center p-8 rounded-3xl bg-gray-50"
            >
              <div
                className={`inline-flex items-center justify-center w-14 h-14 rounded-full ${step.color} text-black text-2xl font-bold mb-6`}
              >
                {step.number}
              </div>
              <h3 className="text-2xl font-bold text-black mb-3">
                {step.title}
              </h3>
              <p className="text-lg text-black/60">{step.description}</p>
            </div>
          ))}
        </div>
      </div>
    </section>
  );
}
```

**Step 2: Add to page.tsx**

```tsx
import { Hero } from "@/components/hero";
import { HowItWorks } from "@/components/how-it-works";

export default function Home() {
  return (
    <main>
      <Hero />
      <HowItWorks />
    </main>
  );
}
```

**Step 3: Verify**

Run `npm run dev`. Confirm: 3 cards with step numbers, titles, descriptions, pastel accent circles.

**Step 4: Commit**

```bash
git add site/components/how-it-works.tsx site/app/page.tsx
git commit -m "feat: add How It Works section"
```

---

### Task 5: Build the Features section

**Files:**
- Create: `site/components/features.tsx`
- Modify: `site/app/page.tsx`

**Step 1: Create the component**

Create `site/components/features.tsx`:

```tsx
const features = [
  {
    title: "All-Natural Ingredients",
    description:
      "Honey, coconut oil, aloe vera — stuff from your kitchen.",
    color: "bg-ha-pink/30",
  },
  {
    title: "Personalized to You",
    description:
      "Not generic advice. Matched to YOUR hair type and goals.",
    color: "bg-ha-blue/30",
  },
  {
    title: "No Salon Needed",
    description: "Professional-quality care, DIY style.",
    color: "bg-ha-coral/30",
  },
  {
    title: "Fun for Everyone",
    description:
      "Whether you're 11 or 41, great hair has no age limit.",
    color: "bg-ha-yellow/30",
  },
];

export function Features() {
  return (
    <section className="py-24 px-6 bg-gray-50">
      <div className="mx-auto max-w-7xl">
        <h2 className="text-4xl md:text-5xl font-bold text-center text-black mb-16">
          What Makes It Different
        </h2>
        <div className="grid grid-cols-1 md:grid-cols-2 gap-8">
          {features.map((feature) => (
            <div
              key={feature.title}
              className={`p-8 rounded-3xl ${feature.color}`}
            >
              <h3 className="text-2xl font-bold text-black mb-3">
                {feature.title}
              </h3>
              <p className="text-lg text-black/60">
                {feature.description}
              </p>
            </div>
          ))}
        </div>
      </div>
    </section>
  );
}
```

**Step 2: Add to page.tsx**

```tsx
import { Hero } from "@/components/hero";
import { HowItWorks } from "@/components/how-it-works";
import { Features } from "@/components/features";

export default function Home() {
  return (
    <main>
      <Hero />
      <HowItWorks />
      <Features />
    </main>
  );
}
```

**Step 3: Verify**

Run `npm run dev`. Confirm: 2x2 grid with pastel background cards, titles, descriptions.

**Step 4: Commit**

```bash
git add site/components/features.tsx site/app/page.tsx
git commit -m "feat: add Features section"
```

---

### Task 6: Build the About the Creators section

**Files:**
- Create: `site/components/about.tsx`
- Modify: `site/app/page.tsx`

**Step 1: Create the component**

Create `site/components/about.tsx`:

```tsx
export function About() {
  return (
    <section className="py-24 px-6 bg-ha-yellow/40">
      <div className="mx-auto max-w-3xl text-center">
        <h2 className="text-4xl md:text-5xl font-bold text-black mb-8">
          Built by a Kid Who Knows Hair
        </h2>
        <p className="text-xl text-black/70 leading-relaxed">
          Hair Agent was dreamed up by an 11-year-old who believed everyone
          deserves great hair care — not just people who can afford expensive
          salon products. Together with her dad, she built an app that gives
          you personalized, all-natural hair tips using ingredients you
          already have at home. Real advice, from a real kid, for real hair.
        </p>
      </div>
    </section>
  );
}
```

**Step 2: Add to page.tsx**

```tsx
import { Hero } from "@/components/hero";
import { HowItWorks } from "@/components/how-it-works";
import { Features } from "@/components/features";
import { About } from "@/components/about";

export default function Home() {
  return (
    <main>
      <Hero />
      <HowItWorks />
      <Features />
      <About />
    </main>
  );
}
```

**Step 3: Verify**

Run `npm run dev`. Confirm: yellow-tinted section with headline and story paragraph.

**Step 4: Commit**

```bash
git add site/components/about.tsx site/app/page.tsx
git commit -m "feat: add About the Creators section"
```

---

### Task 7: Build the CTA + Footer section

**Files:**
- Create: `site/components/footer.tsx`
- Modify: `site/app/page.tsx`

**Step 1: Create the component**

Create `site/components/footer.tsx`:

```tsx
export function Footer() {
  return (
    <>
      {/* Final CTA */}
      <section className="py-24 px-6 bg-white text-center">
        <h2 className="text-4xl md:text-5xl font-bold text-black mb-6">
          Ready to Meet Your Hair BFF?
        </h2>
        <p className="text-xl text-black/60 mb-10">
          Download Hair Agent and start your personalized hair care journey.
        </p>
        <a
          href="#"
          className="inline-block bg-black text-white px-8 py-4 rounded-full text-lg font-semibold hover:bg-black/80 transition-colors"
        >
          Coming Soon to the App Store
        </a>
      </section>

      {/* Footer */}
      <footer className="py-8 px-6 bg-gray-100 text-center">
        <p className="text-sm text-black/40">
          &copy; {new Date().getFullYear()} Hair Agent. Made with love by a
          father-daughter team.
        </p>
      </footer>
    </>
  );
}
```

**Step 2: Add to page.tsx**

```tsx
import { Hero } from "@/components/hero";
import { HowItWorks } from "@/components/how-it-works";
import { Features } from "@/components/features";
import { About } from "@/components/about";
import { Footer } from "@/components/footer";

export default function Home() {
  return (
    <main>
      <Hero />
      <HowItWorks />
      <Features />
      <About />
      <Footer />
    </main>
  );
}
```

**Step 3: Verify**

Run `npm run dev`. Confirm: CTA section with download button, footer with copyright.

**Step 4: Commit**

```bash
git add site/components/footer.tsx site/app/page.tsx
git commit -m "feat: add CTA and Footer sections"
```

---

### Task 8: Add metadata and final polish

**Files:**
- Modify: `site/app/layout.tsx` (metadata, favicon, og tags)
- Modify: `site/app/page.tsx` (smooth scroll behavior)

**Step 1: Update layout.tsx metadata**

In `site/app/layout.tsx`, update the metadata export:

```tsx
import type { Metadata } from "next";

export const metadata: Metadata = {
  title: "Hair Agent — Your Personal Hair Care Advisor",
  description:
    "Take a quick hair quiz and get personalized DIY hair care recipes using ingredients you already have at home.",
  openGraph: {
    title: "Hair Agent — Meet Your New Hair BFF",
    description:
      "Personalized hair care tips from your kitchen. Take the quiz, get custom recipes.",
    type: "website",
  },
};
```

**Step 2: Add smooth scroll to html**

In `site/app/globals.css`, add:
```css
html {
  scroll-behavior: smooth;
}
```

**Step 3: Verify full page**

Run `npm run dev`. Scroll through the entire page. Check:
- [ ] Hero: gradient, headline, subheadline, CTA, iPad mockup
- [ ] How It Works: 3 step cards
- [ ] Features: 2x2 grid
- [ ] About: yellow section with story
- [ ] Footer: CTA + copyright
- [ ] Responsive: resize browser to mobile width, all sections stack properly
- [ ] Page title in browser tab shows "Hair Agent — Your Personal Hair Care Advisor"

**Step 4: Build static export**

```bash
cd /Users/ericfriedman/Dropbox/Documents/AI/claude/hairagent/site
npm run build
```

Expected: builds successfully to `site/out/` directory.

**Step 5: Commit**

```bash
git add site/
git commit -m "feat: add metadata and final polish for landing page"
```

---

### Task 9: Configure Vercel deployment and push

**Files:**
- Create: `vercel.json` (root of repo, point to /site)

**Step 1: Create vercel.json**

Create `vercel.json` in the repo root (NOT in /site):

```json
{
  "buildCommand": "cd site && npm run build",
  "outputDirectory": "site/out",
  "installCommand": "cd site && npm install",
  "framework": "nextjs"
}
```

**Step 2: Commit and push**

```bash
git add vercel.json
git commit -m "feat: add Vercel deployment config"
git push origin main
```

**Step 3: Verify deployment**

After pushing, check Vercel dashboard for the deployment. It should:
- Install deps in /site
- Build the static export
- Deploy to a `.vercel.app` URL

If Vercel is already connected to the repo, the deployment should trigger automatically.

---
