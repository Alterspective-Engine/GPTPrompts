# Prompt Updates: Runtime Verification Enforcement

**Date**: 2025-12-20
**Type**: 🔴 **CRITICAL** - Process Fix
**Issue**: Space Shooter marked "complete" without implementing game logic
**Root Cause**: No runtime verification gate in prompts

---

## Executive Summary

### Problem Discovered
Space Shooter project was marked "complete" with **100% brand compliance** but **the game doesn't exist** - only scaffolding was created (HTML, server, configs). We validated branding in HTML/CSS but never started the server, opened a browser, or tested functionality.

### Root Cause
**Our prompts enforce static checks (TypeScript, branding) but don't require runtime verification (does it actually run?).**

### Solution
Add **mandatory runtime verification gates** to 3 key prompts:
1. prompt-testing.txt
2. prompt-execute-plan.txt
3. SHARED_STANDARDS.md

---

## Files to Update

### 1. SHARED_STANDARDS.md

**Add new section after "Code Quality Standards" (around line 320)**:

```markdown
---

## Runtime Verification Standards (MANDATORY)

**CRITICAL**: Static verification (TypeScript compiles, lint passes) is necessary but **NOT sufficient**.

All implementation work MUST include runtime verification before being marked complete.

### When to Apply
✅ **MANDATORY** for:
- All web applications
- All games
- All interactive UIs
- Any code that runs in a browser or server

### Verification Checklist

Before marking ANY implementation complete, verify:

#### Static Checks (Necessary)
- [ ] TypeScript compiles with 0 errors
- [ ] ESLint/Prettier passes
- [ ] Tests pass (if applicable)
- [ ] Code reviewed
- [ ] All planned files created

#### Runtime Checks (REQUIRED - DO NOT SKIP)
- [ ] **Application starts** - Run `start.bat` or `npm start`, no startup errors
- [ ] **Navigate to URL** - Open browser to application URL (e.g., http://localhost:5511)
- [ ] **Console check** - Open DevTools → Console tab → **0 errors on page load**
- [ ] **Primary functionality** - Test core feature (e.g., play game, submit form, navigate)
- [ ] **UI renders** - No broken layouts, components visible
- [ ] **Interactions work** - Can click buttons, type in fields, use controls
- [ ] **No runtime exceptions** - Check console during interaction

### Evidence Required

When marking implementation complete, provide:
1. ✅ **Startup confirmation**: "Started server on port XXXX"
2. ✅ **URL verification**: "Navigated to http://localhost:XXXX, page loaded"
3. ✅ **Console status**: "Browser console shows 0 errors"
4. ✅ **Functionality test**: "Tested [specific feature], works as expected"
5. ✅ **Screenshots** (recommended): Running app + console

### Examples

#### ✅ GOOD - Complete Verification
```
Implementation complete for Dashboard:
- ✅ Static: TypeScript 0 errors, ESLint passed
- ✅ Runtime: Started server (port 3000)
- ✅ Browser: Navigated to http://localhost:3000
- ✅ Console: 0 errors on load
- ✅ Tested: Login form works, dashboard displays data
- ✅ Screenshots: [attached]
```

#### ❌ BAD - Incomplete Verification
```
Implementation complete for Dashboard:
- ✅ Created all files
- ✅ TypeScript compiled
- ✅ Brand colors validated
[Never started server, never opened browser, never tested]
```

### Red Flags (Indicates False Completion)

❌ "Implementation complete" but:
- Never started the application
- Never opened browser
- Never checked console
- Never tested functionality
- Only verified static files exist

❌ "Testing complete" but:
- Only reviewed HTML/CSS
- Never ran application
- No console error check
- No user flow testing

❌ "Validation passed" but:
- Only validated code syntax
- No runtime verification
- No functional testing
- No evidence provided

### Enforcement

**This is not optional.** Implementations marked "complete" without runtime verification are considered **INCOMPLETE**.

If runtime verification reveals issues:
- Mark as BLOCKED
- Document errors with file:line
- Provide console screenshots
- Fix issues before proceeding

---
```

---

### 2. prompt-testing.txt

**Update Section 2 (lines 62-84) to add runtime verification gate**:

Find this section:
```markdown
## 2. Environment & Service Management

Goal: Run the app in a controlled, observable way.

2.1. Detect running services:
```

**Insert AFTER line 84 (after "Document which services you stopped and how.")**:

```markdown

2.4. **RUNTIME VERIFICATION GATE (MANDATORY)**

**CRITICAL**: Before proceeding to test execution, verify the application actually runs.

This gate is non-negotiable. If any step fails, mark as BLOCKING ISSUE.

**Step 1: Start Application**
- Run `start.bat` (Windows) or `start.sh` (Linux/Mac)
- OR run `npm start` / `npm run dev`
- Wait for "server running" or similar message
- Note the port (e.g., "listening on port 5511")

**Evidence**: Server startup message confirmed

**Step 2: Navigate to Application**
- Open browser (Chrome/Edge recommended for DevTools)
- Navigate to application URL (e.g., http://localhost:5511)
- Wait for page to fully load
- **CRITICAL**: Open DevTools (F12 or Cmd+Option+I)
- Navigate to Console tab

**Evidence**: Page loads without 404 errors

**Step 3: Console Error Check**
- Check for errors in console (red text)
- ✅ **PASS**: 0 errors → Proceed to testing
- ❌ **FAIL**: Any errors → **BLOCKED**
  - Document error messages
  - Take console screenshot
  - Provide file:line if available
  - Mark as BLOCKING ISSUE
  - Fix errors before continuing

**Evidence**: Browser console shows 0 errors

**Step 4: Primary Functionality Smoke Test**
- Identify core user flow (e.g., "play game", "submit form", "view dashboard")
- Perform basic interaction:
  - For games: Can player move/interact?
  - For forms: Can user type and submit?
  - For dashboards: Does data display?
- Check console for runtime errors after interaction

**Evidence**: Core feature responds to user input

**Step 5: Document Verification**
- Take screenshots:
  - Running application (full page)
  - Browser console (showing 0 errors)
- Document what was tested:
  - "Started server on port XXXX"
  - "Navigated to http://localhost:XXXX"
  - "Console: 0 errors"
  - "Tested: [specific action], worked as expected"

**Evidence**: Screenshots and test description provided

**If Gate Fails**:
- ❌ Server won't start → BLOCKED: Fix startup errors
- ❌ Page 404 → BLOCKED: Missing files or incorrect paths
- ❌ Console errors → BLOCKED: Fix errors before testing
- ❌ Core feature broken → BLOCKED: Implementation incomplete

**Only proceed to test execution after passing this gate.**
```

**Add to Section 9 (Consolidated Report Content, around line 244)**:

After "4. Results Summary", add:

```markdown
5. Runtime Verification
   - Application startup: [SUCCESS/FAILED with details]
   - URL navigation: [URL + load status]
   - Console errors: [Count + messages if any]
   - Primary functionality: [Feature tested + result]
   - Screenshots: [Paths to screenshots]
```

---

### 3. prompt-execute-plan.txt

**Update Quality Gates section (around lines 230-260)**:

Find this section:
```markdown
## 4. QUALITY GATES (MANDATORY)
```

**Replace with**:

```markdown
## 4. QUALITY GATES (MANDATORY)

**All gates must pass before marking a wave complete.**

### Gate 1: Static Verification

**Compile & Lint**:
- [ ] TypeScript compiles with 0 errors
- [ ] ESLint passes (0 warnings in strict mode)
- [ ] All planned files created and committed

**Tests** (if applicable):
- [ ] Unit tests pass
- [ ] Integration tests pass
- [ ] No skipped tests

**Code Review** (if using Task tools):
- [ ] Review agent found no blocking issues
- [ ] Security agent found no vulnerabilities
- [ ] SOLID principles followed

### Gate 2: Runtime Verification (**CRITICAL - DO NOT SKIP**)

**This gate is mandatory for ALL implementation waves.**

Before marking ANY wave as complete:

**Step 1: Start Application**
```bash
# Run the application
npm start
# OR
start.bat
```
- Verify server starts without errors
- Note the port (e.g., 5511)
- **BLOCKED** if startup fails

**Step 2: Navigate & Console Check**
- Open browser to http://localhost:[PORT]
- Wait for page load
- Open DevTools → Console
- **Check for errors**:
  - ✅ 0 errors → Continue
  - ❌ Any errors → **BLOCKED** - Fix before proceeding

**Step 3: Functionality Test**
- Test the features implemented in this wave:
  - Wave 1 (foundation): Does page render? Are assets loaded?
  - Wave 2 (core logic): Does primary feature work?
  - Wave 3 (polish): Do UI interactions work?
- Verify feature works as designed
- Check console for runtime errors during interaction

**Step 4: Evidence**
Provide in wave report:
- ✅ "Started server on port XXXX"
- ✅ "Navigated to http://localhost:XXXX"
- ✅ "Console: 0 errors"
- ✅ "Tested: [specific feature], works"
- ✅ Screenshots (optional but recommended)

**If Gate 2 Fails**:
- Document exact error messages
- Provide console screenshots
- Mark wave as BLOCKED
- Fix issues before proceeding to next wave

### Gate 3: Documentation

Update before moving to next wave:
- [ ] Wave marked complete in execution-report.md
- [ ] Issues documented (if any)
- [ ] Runtime verification results recorded
- [ ] ai-handover.md updated with context
```

**Add to Wave Completion Template (around line 400)**:

```markdown
## Wave [X] Report

**Implementation**:
- Task 1: [file:line - description] ✅
- Task 2: [file:line - description] ✅

**Static Verification**:
- TypeScript: ✅ 0 errors
- ESLint: ✅ Passed

**Runtime Verification**:
- Server start: ✅ Started on port [XXXX]
- URL navigation: ✅ http://localhost:[XXXX] loaded
- Console check: ✅ 0 errors
- Functionality: ✅ Tested [feature], works as expected
- Screenshots: [Attached/Path]

**Status**: ✅ COMPLETE (all gates passed)
```

---

### 4. prompt-continue.txt

**Update Section 2 (EXECUTE IMMEDIATELY, around line 22)**:

After "### 2. EXECUTE IMMEDIATELY", add:

```markdown
- **Use TodoWrite**: Update todo list with task "in_progress" before starting
- State: "Starting: [task name]"
- Begin implementation without waiting for confirmation
- Work in small, testable increments
- **After each increment**: Verify runtime (see below)
```

**Add new subsection after "### 3. VALIDATE AS YOU GO" (around line 38)**:

```markdown

### 3.5. RUNTIME VALIDATION (CRITICAL)

After implementing functionality:

1. **Start Application**: Run `start.bat` or `npm start`
2. **Open Browser**: Navigate to application URL
3. **Check Console**: Open DevTools, verify 0 errors
4. **Test Feature**: Interact with what you just built
5. **Verify Works**: Confirm feature functions correctly

**If runtime check fails**:
- Fix immediately (don't accumulate issues)
- Re-test after fix
- Only mark complete after runtime passes

**Example**:
```
Task: Add login form
- ✅ Implemented LoginForm component
- ✅ TypeScript compiled
- ✅ Started server, navigated to /login
- ✅ Console: 0 errors
- ✅ Tested: Can type username/password, submit works
- ✅ Mark task complete
```
```

---

## Summary of Changes

| Prompt File | Section | Change Type | Lines Affected |
|-------------|---------|-------------|----------------|
| **SHARED_STANDARDS.md** | After Code Quality | ADD new section | ~320 (insert ~80 lines) |
| **prompt-testing.txt** | Section 2.4 | ADD runtime gate | ~84 (insert ~60 lines) |
| **prompt-testing.txt** | Section 9 | ADD verification report | ~244 (insert ~7 lines) |
| **prompt-execute-plan.txt** | Section 4 (Quality Gates) | REPLACE & expand | ~230-260 (expand to ~100 lines) |
| **prompt-execute-plan.txt** | Wave template | ADD verification | ~400 (insert ~10 lines) |
| **prompt-continue.txt** | Section 3.5 | ADD new subsection | ~38 (insert ~25 lines) |

**Total**: 6 updates across 3 files

---

## Testing the Updates

### Before (Current State)
```
Phase 2: Implementation
- Create HTML ✅
- TypeScript compiles ✅
- Brand colors validated ✅
- Mark complete ✅

Result: Files exist but app doesn't work
```

### After (With Updates)
```
Phase 2: Implementation
- Create HTML ✅
- TypeScript compiles ✅
- Brand colors validated ✅
- **Runtime check**:
  - Start server ✅
  - Open browser ✅
  - Console: 0 errors ✅
  - Test functionality ✅
  - Provide screenshots ✅
- Mark complete ✅

Result: Files exist AND app works
```

---

## Implementation Priority

### Immediate (Do First)
1. ✅ Update SHARED_STANDARDS.md - Sets standard for all prompts
2. ✅ Update prompt-testing.txt - Most critical for catching issues
3. ✅ Update prompt-execute-plan.txt - Prevents false completion

### Short-term (Next)
4. Update prompt-continue.txt - Helps during active development
5. Update prompt-review.txt - Add runtime verification to reviews

### Long-term (Future)
6. Add runtime verification to prompt-fix.txt
7. Add runtime verification to prompt-refactor.txt
8. Create automated runtime check script

---

## Validation Checklist

After implementing these updates, verify:

- [ ] SHARED_STANDARDS.md has "Runtime Verification Standards" section
- [ ] prompt-testing.txt has "RUNTIME VERIFICATION GATE" in Section 2.4
- [ ] prompt-execute-plan.txt has expanded "Quality Gates" with Gate 2
- [ ] All updates use bold **MANDATORY**, **CRITICAL**, **DO NOT SKIP**
- [ ] Evidence requirements clearly stated (screenshots, descriptions)
- [ ] Red flags listed (what indicates false completion)
- [ ] Examples provided (good vs bad verification)

---

## Expected Impact

### Prevents
- ❌ Marking incomplete work as "complete"
- ❌ Validating branding without testing functionality
- ❌ Checking TypeScript compilation but not runtime
- ❌ Creating files without verifying they work

### Ensures
- ✅ Applications actually run before being marked complete
- ✅ Console errors caught during development
- ✅ Core functionality verified not just planned
- ✅ Evidence provided (screenshots, descriptions)

### Result
**"Complete" now means "Implemented AND Verified to Work"** (not just "Files Created")

---

**Status**: Ready for implementation
**Priority**: 🔴 CRITICAL
**Impact**: Prevents false completion of all future projects
