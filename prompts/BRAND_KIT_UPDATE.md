# Brand Kit Enforcement - Critical Update

**Date**: 2025-12-20
**Type**: CRITICAL - Brand Compliance
**Status**: ✅ Fixed
**Impact**: All UI/Web projects

---

## Issue Identified

### Problem
The Snake Game test project (and potentially other UI projects) was implemented **without Alterspective branding**:

❌ **What was wrong**:
- Used generic purple/blue gradient colors instead of Alterspective Marine/Green/Citrus
- Used generic system fonts instead of Chronicle Display + Montserrat
- No Alterspective logo present
- No reference to brand assets

### Root Cause
The prompts mentioned `01-brand-kit.md` but with **weak, optional language**:
- ❌ "Add 01-brand-kit.md for UI work" (sounds optional)
- ❌ No explicit requirement to USE the brand
- ❌ No clear path to assets
- ❌ No verification checklist

**Result**: AI agents could implement UI projects without brand compliance.

---

## Solution Implemented

### 1. Updated SHARED_STANDARDS.md ✅

**File**: `C:\GitHub\GPTPrompts\prompts\SHARED_STANDARDS.md`

**Changes**:

#### Line 125 - Made brand kit MANDATORY:
```markdown
| **UI/Visual Work** | `01-brand-kit.md` (**MANDATORY**), `02-modality-rules.md` |
```

#### Lines 162-253 - Added NEW Section: "Brand Kit Requirements"
Complete section with:
- ✅ **Clear mandate**: "All UI/web projects for Alterspective MUST use the Alterspective brand"
- ✅ **When to apply**: Lists all UI project types (web apps, games, dashboards, etc.)
- ✅ **Asset location**: `C:\GitHub\GPTPrompts\assets\AlterspectiveAssets\`
- ✅ **Required implementation**: Colors, typography, spacing, logo usage with code examples
- ✅ **Verification checklist**: 5-point checklist before marking UI work complete

---

### 2. Updated prompt-plan.txt ✅

**File**: `C:\GitHub\GPTPrompts\prompts\prompt-plan.txt`

**Line 184 - Changed from**:
```markdown
- Add 01-brand-kit.md for UI-heavy planning.
```

**To**:
```markdown
- **MANDATORY for UI/web projects**: 01-brand-kit.md - All Alterspective UI projects MUST use brand colors, typography, and assets from C:\GitHub\GPTPrompts\assets\AlterspectiveAssets\.
```

---

### 3. Updated prompt-execute-plan.txt ✅

**File**: `C:\GitHub\GPTPrompts\prompts\prompt-execute-plan.txt`

**Line 524 - Changed from**:
```markdown
- Add `01-brand-kit.md` for UI work
```

**To**:
```markdown
- **MANDATORY for UI/web projects**: `01-brand-kit.md` - All Alterspective UI projects MUST use brand colors, typography, and assets from C:\GitHub\GPTPrompts\assets\AlterspectiveAssets\
```

---

## Brand Requirements Summary

### Mandatory Elements for ALL UI Projects

#### 1. **Colors** (Non-Negotiable)
```css
:root {
  --marine: #075156;    /* Primary - NOT generic blue */
  --green: #2c8248;     /* Secondary - NOT generic green */
  --citrus: #abdd65;    /* Accent - NOT yellow */
  --navy: #17232d;      /* Dark/Text */
  --pale-blue: #e5eeef; /* Light background */
  --white: #ffffff;
}
```

❌ **NO generic colors**: No `#667eea`, no `#764ba2`, no random gradients
✅ **USE Alterspective palette**: Marine, Green, Citrus, Navy, Pale Blue

#### 2. **Typography** (Non-Negotiable)
```css
/* Headlines */
font-family: 'Chronicle Display', Georgia, serif;

/* Body/UI */
font-family: 'Montserrat', system-ui, sans-serif;

/* Code */
font-family: 'JetBrains Mono', 'SFMono-Regular', monospace;
```

❌ **NO generic fonts**: No 'Segoe UI', no default system fonts for headlines
✅ **USE Alterspective fonts**: Chronicle Display + Montserrat + JetBrains Mono

#### 3. **Assets** (Mandatory)
**Location**: `C:\GitHub\GPTPrompts\assets\AlterspectiveAssets\`

**Copy to project**:
- Fonts → `public/assets/fonts/`
- Logos → `public/assets/logos/`
- Icons → `public/assets/icons/` (if needed)

#### 4. **Spacing** (Required)
- **4px base scale**: 4, 8, 12, 16, 24, 32, 48
- **Border radius**: 8px default, 12-16px for cards
- **NO random spacing**: No 10px, no 25px, no 5px margins

#### 5. **Logo** (Required)
- Must appear in header or appropriate location
- Minimum height: 32px (UI) / 80px (hero)
- Maintain aspect ratio
- Clear space around logo

---

## Verification Checklist

### Before Marking Any UI Project Complete:

- [ ] **Brand colors used** - NO generic blue/purple/random colors
- [ ] **Typography matches** - Chronicle Display for headlines, Montserrat for body
- [ ] **4px spacing scale** applied throughout
- [ ] **Logo included** in header/footer/appropriate location
- [ ] **Assets copied** from `C:\GitHub\GPTPrompts\assets\AlterspectiveAssets\`
- [ ] **Fonts loaded** via @font-face or CDN
- [ ] **CSS variables** defined for colors
- [ ] **No off-brand elements** (check for random colors, fonts, spacing)

---

## Example: Snake Game Issue

### What It Had (Wrong) ❌
```css
/* WRONG - Generic colors */
background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
color: #667eea;

/* WRONG - Generic fonts */
font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;

/* WRONG - Random spacing */
padding: 30px;  /* Not on 4px scale */
margin-bottom: 30px;  /* Not on 4px scale */
```

### What It Should Have (Correct) ✅
```css
/* CORRECT - Alterspective colors */
background: linear-gradient(135deg, var(--marine) 0%, var(--green) 100%);
color: var(--marine);

/* CORRECT - Alterspective fonts */
h1 { font-family: 'Chronicle Display', Georgia, serif; }
body { font-family: 'Montserrat', system-ui, sans-serif; }

/* CORRECT - 4px scale spacing */
padding: 32px;  /* 8 × 4px */
margin-bottom: 32px;  /* 8 × 4px */
```

---

## Impact Assessment

### Files Modified
1. ✅ `SHARED_STANDARDS.md` - Added mandatory brand section (Lines 162-253)
2. ✅ `prompt-plan.txt` - Made brand kit MANDATORY (Line 184)
3. ✅ `prompt-execute-plan.txt` - Made brand kit MANDATORY (Line 524)

### Projects Affected

#### ✅ Future Projects (All Fixed)
All new UI projects will now:
- ✅ Load `01-brand-kit.md` as **MANDATORY**
- ✅ See explicit asset path in prompts
- ✅ Follow verification checklist
- ✅ Use Alterspective brand by default

#### ⚠️ Existing Projects (Needs Retrofit)
Projects already created without branding:
- ❌ **Snake Game (promptTest)** - needs brand retrofit
- ❌ Any other UI projects without brand colors/fonts

**Action Required**: Retrofit existing UI projects with Alterspective branding.

---

## Retrofit Guide for Snake Game

### Steps to Fix Snake Game

#### 1. Update Colors in styles.css
```css
/* Add at top of file */
:root {
  --marine: #075156;
  --green: #2c8248;
  --citrus: #abdd65;
  --navy: #17232d;
  --pale-blue: #e5eeef;
}

/* Change gradient */
body {
  background: linear-gradient(135deg, var(--marine) 0%, var(--green) 100%);
}

/* Change button */
.btn-restart {
  background: linear-gradient(135deg, var(--marine) 0%, var(--green) 100%);
}

/* Change score color */
.value {
  color: var(--marine);
}
```

#### 2. Add Typography
```html
<!-- In index.html <head> -->
<link rel="preconnect" href="https://fonts.googleapis.com">
<link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@300;400;600;700&display=swap" rel="stylesheet">
```

```css
/* In styles.css */
body {
  font-family: 'Montserrat', system-ui, sans-serif;
}

h1, h2 {
  font-family: 'Chronicle Display', Georgia, serif;
}
```

#### 3. Copy Logo
```bash
# Copy logo file
cp "C:\GitHub\GPTPrompts\assets\AlterspectiveAssets\Logos\Digital (screen)\Primary\..." "C:\GitHub\GPTPrompts\prompts\promptTest\src\public\assets\logos\"
```

#### 4. Add Logo to Header
```html
<!-- In index.html header -->
<header>
  <img src="/assets/logos/alterspective-logo.svg" alt="Alterspective" height="32">
  <h1>🐍 Snake Game</h1>
  <p class="subtitle">Testing Alterspective Prompt Orchestration</p>
</header>
```

#### 5. Fix Spacing
```css
/* Use 4px scale: 4, 8, 12, 16, 24, 32, 48 */
.container {
  padding: 32px;  /* Was 20px */
}

.game-wrapper {
  padding: 32px;  /* Was 30px */
  margin-bottom: 32px;
}

.score-panel {
  margin-bottom: 24px;  /* Was 20px */
  padding: 16px;  /* Was 15px */
}
```

---

## Lessons Learned

### What Went Wrong
1. ❌ **Weak language**: "Add" sounded optional, not mandatory
2. ❌ **No enforcement**: No checklist or verification step
3. ❌ **Hidden assets**: Asset path not explicitly stated in prompts
4. ❌ **No examples**: No reference implementations showing brand usage

### What's Fixed Now
1. ✅ **Strong language**: "MANDATORY" in bold with explicit requirements
2. ✅ **Verification checklist**: 8-point checklist in SHARED_STANDARDS.md
3. ✅ **Explicit paths**: `C:\GitHub\GPTPrompts\assets\AlterspectiveAssets\` in prompts
4. ✅ **Clear guidelines**: Complete section with code examples

---

## Related Files

### Brand Standards
- `C:\GitHub\GPTPrompts\01-brand-kit.md` - Complete brand guidelines
- `C:\GitHub\GPTPrompts\assets\AlterspectiveAssets\` - Brand assets

### Updated Prompts
- `C:\GitHub\GPTPrompts\prompts\SHARED_STANDARDS.md` - Lines 125, 162-253
- `C:\GitHub\GPTPrompts\prompts\prompt-plan.txt` - Line 184
- `C:\GitHub\GPTPrompts\prompts\prompt-execute-plan.txt` - Line 524

### Documentation
- `C:\GitHub\GPTPrompts\prompts\BRAND_KIT_UPDATE.md` - This file
- `C:\GitHub\GPTPrompts\prompts\promptTest\` - Example project (needs retrofit)

---

## Next Steps

### Immediate (Required)
1. ✅ Update SHARED_STANDARDS.md - COMPLETE
2. ✅ Update prompt-plan.txt - COMPLETE
3. ✅ Update prompt-execute-plan.txt - COMPLETE
4. ⏳ **Retrofit Snake Game** - PENDING (optional for test, but recommended as example)

### Future (Recommended)
1. Update other prompts with MANDATORY language (prompt-testing.txt, prompt-review.txt, etc.)
2. Add brand compliance check to prompt-testing.txt verification steps
3. Create brand-compliant example screenshots for documentation
4. Consider adding automated brand compliance checker tool

---

## Conclusion

**Problem**: UI projects were being created without Alterspective branding due to weak, optional language in prompts.

**Solution**: Made brand kit **MANDATORY** for all UI/web projects with:
- ✅ Explicit requirements in SHARED_STANDARDS.md
- ✅ Clear asset paths
- ✅ Verification checklist
- ✅ Code examples
- ✅ Strong "MANDATORY" language in prompts

**Status**: ✅ **FIXED** - All future UI projects will use Alterspective branding by default.

**Backward Compatibility**: Existing projects can optionally be retrofitted using the guide above.

---

**Updated By**: Claude Sonnet 4.5 (Prompt Orchestration)
**Date**: 2025-12-20
**Severity**: HIGH (Brand Compliance)
**Status**: ✅ RESOLVED
