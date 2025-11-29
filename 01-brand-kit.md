# 01 - Alterspective Brand Kit

Apply only when there is a visual/UX surface. Ignore visual rules for pure backend/logic tasks.

## Palette
- Marine #075156 (primary)
- Green #2C8248 (secondary)
- Citrus #ABDD65 (accent)
- Navy #17232D (dark/text)
- Pale Blue #E5EEEF (light background)
- White #FFFFFF
Maintain WCAG AA+ contrast.

## Typography
- Headlines/Display: Chronicle Display
- Body/UI: Montserrat
- Code samples: JetBrains Mono
- Limit hierarchy to 4–5 sizes/weights.

## Spacing & Layout
- 4px spacing scale.
- Minimalist, MD3-influenced surfaces with sensible elevation.

## Patterns
- Geometry: 60°/120° triangular lines.
- One pattern per surface. Approved combos:
  - Navy + Marine (professional)
  - Navy + Green (sustainable)
  - Navy + Citrus (creative accent)
  - Pale Blue + White (subtle)
  - White + Navy (clean)
  - Marine + White (bold)
- Opacity: 30–50% for backgrounds; ~10–20% for overlays.
- Avoid non-brand colors, multiple patterns on one surface, busy photos, or distorted angles.

## Logos
- Use primary/reversed marks from `.../AlterspectiveAssets/Logos/Digital (screen)/`.
- Preserve clear space and minimum sizes; keep backgrounds on-brand.

## Enhancement Modes (optional; never at usability’s expense)
- Glassmorphism: brand colors only; max ~3 layers; blur 8–24px; keep AA contrast.
- Glow: brand-color glows for CTAs/active states; 20–40px radius; sparing use.
- Neumorphism: tactile cards/controls on flat dark surfaces; do not combine with glass.
- Holographic: slow, subtle, special-occasion only; never on text.
- Respect `prefers-reduced-motion`; feature-detect and provide fallbacks.

## Performance & Accessibility
- Optimize assets; responsive by default.
- Semantic HTML/ARIA; keyboard support; avoid main-thread blocks.
