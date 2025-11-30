# 01 - Alterspective Brand Kit

Apply only when there is a visual/UX surface. Ignore visual rules for pure backend/logic tasks.

## Palette
- Marine `#075156` (primary)
- Green `#2C8248` (secondary)
- Citrus `#ABDD65` (accent)
- Navy `#17232D` (dark/text)
- Pale Blue `#E5EEEF` (light background)
- White `#FFFFFF`

Use CSS vars in projects:
```css
:root {
  --marine: #075156;
  --green: #2c8248;
  --citrus: #abdd65;
  --navy: #17232d;
  --pale-blue: #e5eeef;
  --white: #ffffff;
}
```
Maintain WCAG AA+ contrast; avoid light text on Pale Blue without sufficient contrast.

## Typography
- Headlines/Display: Chronicle Display (local asset)
- Body/UI: Montserrat (weights 300–800)
- Code samples: JetBrains Mono
- Limit hierarchy to 4-5 sizes/weights; avoid more than two font families on a surface.

Set up local font-face using repo assets:
```css
@font-face {
  font-family: 'Chronicle Display';
  src: url('/assets/AlterspectiveAssets/Fonts/ChronicleDisplay-Regular.woff2') format('woff2');
  font-weight: 400;
  font-style: normal;
  font-display: swap;
}
body { font-family: 'Montserrat', 'Helvetica Neue', system-ui, sans-serif; }
h1,h2,h3 { font-family: 'Chronicle Display', 'Georgia', serif; }
code, pre { font-family: 'JetBrains Mono', 'SFMono-Regular', ui-monospace; }
```

## Spacing & Layout
- 4px spacing scale; common steps: 4, 8, 12, 16, 24, 32, 48.
- Border radius: 8px default; 12–16px for cards; 999px for pills.
- Elevation (MD3-inspired):
  - Level 1: `0 1px 2px rgba(23,35,45,0.05)`
  - Level 2: `0 2px 4px -1px rgba(23,35,45,0.06), 0 4px 6px rgba(23,35,45,0.08)`
  - Level 3+: only for modals/spotlights; avoid heavy shadows on light UIs.
- Backgrounds: gradient `linear-gradient(135deg, var(--pale-blue) 0%, #fff 100%)` is approved for hero/surfaces.

## Patterns
- Geometry: 60/120-degree triangular lines.
- One pattern per surface. Approved combos:
  - Navy + Marine (professional)
  - Navy + Green (sustainable)
  - Navy + Citrus (creative accent)
  - Pale Blue + White (subtle)
  - White + Navy (clean)
  - Marine + White (bold)
- Opacity: 30-50% for backgrounds; ~10-20% for overlays.
- Avoid non-brand colors, multiple patterns on one surface, busy photos, or distorted angles.

## Logos
- Assets: `assets/AlterspectiveAssets/Logos/Digital (screen)/`.
- Use primary/reversed marks only; keep aspect ratio; minimum height 32px (UI) / 80px (hero).
- Clear space: ≥ half the logomark height around the logo.
- Backgrounds: solid brand colors or subtle patterns at ≤30% opacity.

## Enhancement Modes (optional; never at usability's expense)
- Glassmorphism: brand colors only; max ~3 layers; blur 8-24px; keep AA contrast.
- Glow: brand-color glows for CTAs/active states; 20-40px radius; sparing use.
- Neumorphism: tactile cards/controls on flat dark surfaces; do not combine with glass.
- Holographic: slow, subtle, special-occasion only; never on text.
- Respect `prefers-reduced-motion`; feature-detect and provide fallbacks.

## Performance & Accessibility
- Optimize assets; responsive by default.
- Semantic HTML/ARIA; keyboard support; avoid main-thread blocks.
- Respect `prefers-reduced-motion`; allow motion-off toggle.
- Do not load unused fonts/weights; prefer woff2.

## Assets (local copies for AI use)
- Fonts: `assets/AlterspectiveAssets/Fonts/` (Chronicle Display, Montserrat, JetBrains Mono).
- Icons: `assets/AlterspectiveAssets/Icons/` (SVGs/PNGs).
- Logos: `assets/AlterspectiveAssets/Logos/Digital (screen)/`.
- Usage: copy into project `public/assets/…` or serve via CDN; set `font-display: swap`; keep filenames intact for consistency with examples.

## Do / Avoid
- Do: use Montserrat for UI, Chronicle for headlines, consistent 4px spacing, gradients/patterns sparingly.
- Do: constrain palette to the brand colors and maintain AA contrast.
- Avoid: mixing more than one pattern per surface, neon/off-brand colors, heavy shadows with glass, stretching logos, embedding secrets in asset paths.
