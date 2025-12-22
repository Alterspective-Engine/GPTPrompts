# Shared Standards for All Alterspective Prompts

**Version**: 1.0
**Last Updated**: 2025-12-20
**Purpose**: Common standards, tool usage, and integration guidance for all prompts in this collection.

---

## Quick Reference

**Include this at the top of every prompt**:
```markdown
> **Standards**: See SHARED_STANDARDS.md for tool standards, prompt pack integration, KB paths, and MCP guidance.
```

---

## Tool Standards

### Task Tool (Multi-Agent Coordination)

**Purpose**: Spawn independent sub-tasks for parallel or sequential execution.

**Parameters**:
- **description**: Short 3-5 word description (e.g., "Implement user validation")
- **prompt**: Detailed instructions for the task
- **subagent_type**:
  - `"general-purpose"` - Default for build/review/test/fix tasks
  - `"Explore"` - For codebase search, architecture understanding (use sparingly)
  - Other types are specialized; stick with "general-purpose" for most work
- **model** (optional): Defaults to current model (sonnet). Only specify if task needs different model.

**Limits**:
- **Maximum 10 concurrent Task tool calls** per message
- Each Task runs independently, completes work, returns results to orchestrator
- Tasks cannot communicate with each other - only with you

**Parallel Execution** (Critical for Performance):
- When tasks are independent: Spawn ALL in SINGLE message with multiple Task tool calls
- Claude Sonnet 4.5 will execute them in parallel automatically
- Example: 3 independent build tasks → 1 message with 3 Task tool calls

**Sequential Execution**:
- When a task depends on another's results: Wait for completion before spawning next
- Pattern: Spawn → Wait for ALL results → Consolidate → Spawn next wave

**Terminology** (Use Consistently):
- ✅ "Task tool", "Task invocation", "spawning a Task"
- ❌ "agent" (ambiguous), "sub-agent" (deprecated), "spawning agents"

**When to Self-Implement vs Spawn Task**:
- **Self-implement**: Simple reads (1-3 files), coordination, small edits, tool discovery, TodoWrite updates
- **Spawn Task**: Implementation, review, testing, complex analysis, parallel work, domain expertise needed

---

### TodoWrite Tool (Progress Tracking)

**Purpose**: Track task progress, maintain state across sessions, demonstrate work to user.

**Mandatory Usage**:
- ALL planning prompts
- ALL implementation prompts
- ALL execution/orchestration prompts

**Pattern**:
1. **At task start**: Create todos with phases and tasks
2. **Before work**: Mark one task "in_progress"
3. **After completion**: Mark "completed" immediately (don't batch)
4. **Update frequency**: After every significant step/wave

**Task States**:
- `pending`: Not yet started
- `in_progress`: Currently working (limit to ONE at a time)
- `completed`: Finished successfully

**Task Format**:
```json
{
  "content": "Imperative form (e.g., 'Run tests')",
  "activeForm": "Present continuous (e.g., 'Running tests')",
  "status": "pending | in_progress | completed"
}
```

**Example**:
```javascript
TodoWrite({
  todos: [
    {content: "Load investigation context", activeForm: "Loading investigation context", status: "completed"},
    {content: "Decompose plan into waves", activeForm: "Decomposing plan into waves", status: "in_progress"},
    {content: "Spawn build tasks", activeForm: "Spawning build tasks", status: "pending"}
  ]
})
```

---

### Other Common Tools

**Read**: Read files from filesystem (use for code review, context gathering)
**Edit**: Make exact string replacements in files (requires Read first)
**Write**: Create new files or overwrite existing (requires Read first for existing)
**Glob**: Find files by pattern (e.g., `**/*.ts`)
**Grep**: Search file contents with regex
**Bash**: Execute terminal commands (git, npm, testing, etc.)
**AskUserQuestion**: Get user decisions during execution (use for blockers requiring input)

---

## Prompt Pack Integration

**Location**: `C:\GitHub\GPTPrompts`

### Core Load (Always)
- `00-core-behavior.md` - Identity, ethics, calibrated autonomy (MANDATORY for all prompts)

### Bundle Selection (Load ONLY Relevant Files)

Choose files based on task type:

| Task Type | Load These Files |
|-----------|------------------|
| **CLI/Backend/Docs** | `02-modality-rules.md` |
| **UI/Visual Work** | `01-brand-kit.md` (**MANDATORY**), `02-modality-rules.md` |
| **Quality/Shipping** | `03-quality-guardrails.md` |
| **Testing** | `04-testing-standards.md` |
| **Security** | `05-security-standards.md` |
| **Workflow/Context** | `06-development-workflow.md`, `10-ai-context-guide.md` |
| **Code Quality/SOLID** | `07-code-quality.md` |
| **Multi-Agent** | `08-multi-agent.md` |
| **Documentation** | `09-documentation-standards.md` |

### Loading Pattern

**In your prompt, include**:
```markdown
## Prompt Pack Integration

Use the Alterspective prompt pack in C:\GitHub\GPTPrompts.

**Load**:
- `00-core-behavior.md` (always)
- [List specific .md files needed for this task from table above]
```

**Example for Implementation Task**:
```markdown
**Load**:
- `00-core-behavior.md`
- `02-modality-rules.md`
- `03-quality-guardrails.md`
- `04-testing-standards.md`
- `07-code-quality.md`
```

**Reference for Sub-Tasks**:
When spawning Task tools, tell them to load specific standards files in their brief.

---

## Brand Kit Requirements (UI/Web Projects)

**CRITICAL**: All UI/web projects for Alterspective **MUST** use the Alterspective brand.

### When to Apply
✅ **MANDATORY** for:
- Web applications with user interfaces
- Web games (like Snake Game example)
- Landing pages, marketing sites
- Dashboards, admin panels
- Any visual/interactive surfaces

❌ **NOT required** for:
- Pure backend APIs (no UI)
- CLI tools (terminal only)
- Internal scripts/automation
- Libraries without visual components

### Brand Assets Location
**Path**: `C:\GitHub\GPTPrompts\assets\AlterspectiveAssets\`

**Structure**:
```
assets/AlterspectiveAssets/
├── Fonts/
│   ├── ChronicleDisplay-Regular.woff2
│   ├── Montserrat/ (various weights)
│   └── JetBrainsMono/ (code font)
├── Logos/
│   └── Digital (screen)/
│       ├── Primary/
│       ├── Reversed/
│       └── Logomark/
└── Icons/
```

### Required Implementation

**1. Colors (MANDATORY)**:
```css
:root {
  --marine: #075156;    /* Primary */
  --green: #2c8248;     /* Secondary */
  --citrus: #abdd65;    /* Accent */
  --navy: #17232d;      /* Dark/Text */
  --pale-blue: #e5eeef; /* Light BG */
  --white: #ffffff;
}
```

**2. Typography (MANDATORY)**:
- **Headlines**: Chronicle Display (load from assets)
- **Body/UI**: Montserrat (Google Fonts or assets)
- **Code**: JetBrains Mono

```css
@font-face {
  font-family: 'Chronicle Display';
  src: url('/assets/fonts/ChronicleDisplay-Regular.woff2') format('woff2');
  font-weight: 400;
  font-display: swap;
}

body { font-family: 'Montserrat', system-ui, sans-serif; }
h1, h2, h3 { font-family: 'Chronicle Display', Georgia, serif; }
```

**3. Spacing (MANDATORY)**:
- 4px base scale: 4, 8, 12, 16, 24, 32, 48
- Border radius: 8px default, 12-16px cards

**4. Logo Usage**:
- Copy logo from assets to `public/assets/logos/`
- Use in header/footer as appropriate
- Minimum height: 32px (UI) / 80px (hero)

### Verification Checklist

Before marking UI work complete, verify:
- [ ] Brand colors used (not generic blue/purple/random)
- [ ] Typography matches (Chronicle Display for headlines, Montserrat for body)
- [ ] 4px spacing scale applied
- [ ] Logo included in appropriate locations
- [ ] Assets copied from `C:\GitHub\GPTPrompts\assets\AlterspectiveAssets\`

### Reference
See `01-brand-kit.md` for complete guidelines including:
- Palette details and contrast ratios
- Pattern usage (geometric, opacity guidelines)
- Enhancement modes (glassmorphism, glow effects)
- Performance and accessibility requirements

---

## Knowledge Bases

### Locations

**Sharedo-Specific Knowledge**:
- Path: `C:\GitHub\LearnSD\KB`
- Entry points: `C:\GitHub\LearnSD\KB\README.md`, `C:\GitHub\LearnSD\KB\kb_index.json`

**General Knowledge**:
- Path: `C:\GitHub\LearnSD\GeneralKB`

**Governance**:
- Path: `C:\GitHub\LearnSD\GeneralKB\KB_GOVERNANCE.md`
- **CRITICAL**: Read governance rules BEFORE updating any KB

### Usage Pattern

**Reading Knowledge**:
```markdown
For Sharedo-specific knowledge, consult C:\GitHub\LearnSD\KB.
For general knowledge, consult C:\GitHub\LearnSD\GeneralKB.
```

**Updating Knowledge**:
```markdown
If you create durable, reusable knowledge:
1. Read C:\GitHub\LearnSD\GeneralKB\KB_GOVERNANCE.md
2. Follow governance rules
3. Update appropriate KB with evidence
4. If unable to update, state why and record in ai-memory.md
```

---

## MCP + Code Execution Best Practices

**When Applicable**: Projects using Model Context Protocol or code execution environments.

### Tool Discovery
- **Don't**: Load all tool definitions into context
- **Do**: Discover via filesystem (`list ./servers/*`) or search tool
- **Do**: Read only needed tool files on demand

### Data Management
- **Keep intermediate data in execution environment** (don't return large datasets to model)
- **Filter/aggregate before returning** to model to save tokens
- **Use code** (loops/conditionals) instead of many sequential tool calls

### Security
- **Tokenize or avoid emitting sensitive data** from tool responses
- **Keep PII out of model context**
- **Sanitize logs before returning**

### State Persistence
- **Persist reusable scripts/state to disk** when helpful for resumability
- **Mind sandbox/resource limits**
- **Save MCP state after significant operations**

---

## Context Window Management

**Budget**: Claude Sonnet 4.5 has 200K token context window.

### Guidelines

**Consolidate Results**:
- Don't keep full Task outputs in context
- Summarize: "Task 1: COMPLETE - auth.ts:45-120 - 5 tests passing"
- Only include full output for failed/blocked tasks

**Use File References**:
- Reference `file:line` instead of pasting full content
- Example: "Fixed issue in auth.ts:145" not "Fixed: [50 lines of code]"

**Progressive Documentation**:
- Write to disk frequently (orchestration-status.md, execution-report.md)
- Don't accumulate everything in memory

**Wave Size Limits**:
- Maximum 4 build tasks per parallel wave (not 10)
- Each task should target <500 lines of code changes
- If scope too large, break into more waves

**Selective Detail**:
Include full output only for:
- Failed/blocked tasks (need details for fixing)
- Critical security findings
- Complex issues requiring analysis

For successful, routine tasks: summary only.

---

## Standard Output Format

**All prompts should end with consistent summary format**:

```markdown
## Summary

**Status**: [COMPLETE / BLOCKED / IN_PROGRESS / PARTIAL]

**Changes**:
- file:line - Description of change
- file:line - Description of change

**Evidence**:
- Test output: [results]
- Type checks: [0 errors]
- Linting: [0 errors, X warnings]

**Issues Found**: [None or list with severity]

**Next Steps**:
1. [Next action with file reference if applicable]
2. [Following action]
3. [Subsequent action]
```

---

## Code Quality Standards

### File Size Limits
- **Maximum**: 400 lines per file
- **Ideal**: < 250 lines per file
- If exceeded: Split into multiple files with clear responsibilities

### Function Complexity
- **Maximum**: 50 lines per function
- **Ideal**: < 20 lines per function
- **Cyclomatic complexity**: < 10 per function (< 5 ideal)

### SOLID Principles
- **S**: Single Responsibility - One reason to change per class/module
- **O**: Open/Closed - Extend via composition, not modification
- **L**: Liskov Substitution - Subtypes must honor parent contracts
- **I**: Interface Segregation - Many small interfaces > one fat interface
- **D**: Dependency Inversion - Depend on abstractions, not concretions

### Testing Requirements
- **Unit tests**: Min 3 per changed function (more for complex logic)
- **Integration tests**: All affected paths covered
- **Edge cases**: Null, empty, boundary conditions tested
- **Regression tests**: Related functionality verified
- **Coverage target**: 80%+ on changed code

### Zero Technical Debt Policy
Never proceed with:
- TODO comments
- FIXME markers
- Commented-out code (delete it)
- Known bugs "to fix later"
- Skipped tests
- Incomplete error handling

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

## Innovation & Isolation Testing Pattern

**Purpose**: Build complex features in isolation before integration to reduce risk and accelerate development.

### Pattern Overview

When building large, complex, or unfamiliar features:
1. Build first in `Innovation/[feature]/` as standalone CLI/module
2. Test and iterate rapidly without affecting main codebase
3. Design clean integration points
4. Integrate into main application once validated
5. Archive or delete innovation folder

### When to Use

✅ **Use Innovation/Isolation when**:
- **Component size**: >200 LOC or >3 files
- **Technology**: Unfamiliar library/framework
- **Risk level**: High-risk (security, performance-critical)
- **Complexity**: Novel algorithms, complex business logic
- **Reusability**: Component may span multiple projects
- **Unknown requirements**: Need to experiment to understand what works

❌ **Skip isolation when**:
- **Simple operations**: Basic CRUD, minor UI changes
- **Well-known patterns**: Standard implementations
- **Tight coupling**: Must interact deeply with existing code from start
- **Time constraints**: Feature is trivial and low-risk

### Innovation Folder Structure

```
Innovation/
├── README.md                    # Pattern documentation
└── [feature-name]/
    ├── README.md                # What/why for this feature
    ├── package.json             # Feature-specific dependencies (optional)
    ├── src/
    │   └── index.ts             # CLI entry point for testing
    ├── tests/                   # Unit/integration tests
    └── integration-notes.md     # How to integrate into main app
```

### Workflow Phases

**Phase 0: Innovation Build** (isolation)
- Create Innovation/[feature]/ structure
- Implement as standalone CLI or module
- Test in isolation with no main app dependencies
- Iterate rapidly using AI assistance
- Focus: Does it work? Does it do what we need?

**Phase 0.5: Validation**
- Verify isolated feature meets all requirements
- Test edge cases, performance, security
- Document final API/interface design
- Get user approval before proceeding

**Phase 1: Integration Design**
- Identify integration points in main application
- Design adapters/wrappers if needed
- Plan final file locations and structure
- Update main app architecture docs

**Phase 2: Integration & Testing**
- Move/adapt code from Innovation/ to main app
- Implement integration layer
- Run full integration and E2E tests
- Verify no regressions

**Phase 3: Cleanup**
- Archive Innovation/[feature]/ or delete
- Update documentation
- Record learnings in ai-memory.md

### Benefits

✅ **Faster Iteration**: No dependency management, no build complexity
✅ **Easier Testing**: No mocks needed, pure unit tests
✅ **Lower Risk**: Main codebase unaffected during experimentation
✅ **Better Design**: Forces thinking about clean interfaces
✅ **AI-Friendly**: Can experiment aggressively without consequences
✅ **Clear Success Criteria**: Can validate feature works before integration complexity

### Integration into Planning

**In prompt-plan.txt**:
- Evaluate during "IDENTIFY OPTIONS" if isolation is needed
- Add "Phase 0: Innovation/Isolation" to task breakdown when applicable
- Include decision criteria in recommendations

**In prompt-execute-plan.txt**:
- Check if plan includes innovation phase
- Use "Wave 0" pattern for isolation build
- Transition to integration waves after validation

**In prompt-seed-project.txt**:
- Always include Innovation/ folder in new projects
- Add Innovation/README.md with pattern guidance

**In prompt-general.txt**:
- Evaluate isolation need during planning step
- Recommend pattern when applicable

### Example: Building a Complex Data Transformer

**❌ Without Innovation Pattern**:
- Build directly in `src/transformers/complexTransform.ts`
- Must handle all main app dependencies, types, interfaces
- Every test requires extensive mocking
- Breaking changes affect entire app
- Slow iteration due to build/test cycles

**✅ With Innovation Pattern**:
- Build in `Innovation/complex-transformer/src/index.ts`
- Standalone CLI: `node Innovation/complex-transformer/src/index.ts input.json`
- Pure unit tests, no mocks needed
- Iterate rapidly, AI can experiment freely
- Once working, integrate into `src/transformers/` with clean interface

### Template: Innovation/README.md

When creating Innovation/ folder in new projects, include this README:

```markdown
# Innovation Folder

Build complex features here first, in isolation, before integrating into the main application.

## Purpose
This folder enables rapid, risk-free development of complex features by allowing you to:
- Build standalone implementations without main app dependencies
- Test and iterate quickly with AI assistance
- Validate the approach before integration
- Design clean interfaces through forced isolation

## When to Use
- Large/complex components (>200 LOC or >3 files)
- Unfamiliar technologies or libraries
- High-risk implementations (security, performance-critical)
- Novel algorithms or complex business logic
- Reusable components that may span projects
- Unknown requirements requiring experimentation

## Structure
Each innovation feature should have:
```
Innovation/[feature-name]/
├── README.md               # What we're testing, why isolated
├── package.json            # Feature dependencies (if needed)
├── src/
│   └── index.ts           # CLI entry for testing
├── tests/                 # Tests for isolated feature
└── integration-notes.md   # How to integrate into main app
```

## Workflow
1. **Create**: Make `Innovation/[feature-name]/` folder
2. **Build**: Implement as standalone CLI/module
3. **Test**: Iterate rapidly with fast feedback
4. **Validate**: Ensure it does what you need
5. **Design**: Document integration points
6. **Integrate**: Move to main app with adapters
7. **Cleanup**: Archive or delete innovation code

## Benefits
- ✅ Faster iteration (no main app complexity)
- ✅ Easier testing (no mocks required)
- ✅ Lower risk (experimentation is safe)
- ✅ Better design (forces clean interfaces)
- ✅ AI-friendly (aggressive experimentation welcome)

## Example
Instead of building a complex image processor directly in `src/processors/`,
build it first as `Innovation/image-processor/src/index.ts` with a simple CLI:
```bash
node Innovation/image-processor/src/index.ts input.jpg --resize=800x600
```
Once it works perfectly, integrate it into the main app.
```

---

## Documentation Standards

### File References
Always include `file:line` references for:
- Code changes
- Issues found
- Test locations
- Configuration updates

**Format**: `src/auth/validator.ts:145-167`

### Session Documentation
Update these files appropriately:
- **ai-handover.md**: Session summary, what was done, what's next
- **ai-memory.md**: Key decisions, risks, gotchas, learnings
- **checklist.md**: Task completion status (if using checklist approach)

### Evidence Requirements
Every claim needs evidence:
- "Tests passing" → Include test output
- "No TypeScript errors" → Include `tsc` output
- "Fixed bug" → Include before/after behavior
- "Improved performance" → Include benchmark results

---

## Anti-Drift Rules

Prevent scope creep and maintain focus:

### Scope Management
- ❌ Do NOT add features beyond the approved plan
- ❌ Do NOT refactor unrelated code "while you're there"
- ❌ Do NOT skip quality gates to "move faster"
- ❌ Do NOT defer issues for later

### Quality Management
- ❌ Do NOT accept "good enough" - it must be excellent
- ❌ Do NOT rationalize skipping tests
- ❌ Do NOT leave TODO comments
- ❌ Do NOT merge with known issues

### Task Management
- ❌ Do NOT spawn more than 10 Task tools in a single message
- ❌ Do NOT skip wait-for-completion step between waves
- ❌ Do NOT proceed until all reviews pass
- ❌ Do NOT accept unverified fixes
- ✅ ALWAYS use TodoWrite to track progress
- ✅ ALWAYS spawn independent tasks in parallel

---

## Error Messages & Blockers

### When Blocked
1. **State the blocker clearly** with context
2. **Classify blocker type**:
   - **Information gap**: Missing context (can resolve by asking)
   - **Dependency blocker**: Need different task first
   - **Technical blocker**: Environment/tooling issue
   - **Decision blocker**: Requires user input (use AskUserQuestion)
3. **Propose solution or escalate** (don't just report)

### Error Handling
- Include full error message
- Include file:line location
- Include steps to reproduce
- Include impact assessment (Critical/High/Medium/Low)

---

## Version History

| Version | Date | Changes |
|---------|------|---------|
| 1.0 | 2025-12-20 | Initial creation - consolidated standards from 19 prompts |

---

## Usage Examples

### Example 1: Referencing in a Prompt

```markdown
ROLE: Implementation Assistant

> **Standards**: See SHARED_STANDARDS.md for tool standards, prompt pack integration, KB paths, and MCP guidance.

Execute approved implementation plan...

[Rest of prompt-specific content]

## Prompt Pack Integration

Use the Alterspective prompt pack in C:\GitHub\GPTPrompts.

**Load**:
- `00-core-behavior.md`
- `02-modality-rules.md`
- `07-code-quality.md`
```

### Example 2: Task Brief Referencing Standards

```markdown
TASK BRIEF: Implement Authentication Validator

**Standards**: Load these from C:\GitHub\GPTPrompts:
- 00-core-behavior.md (always)
- 05-security-standards.md (security-sensitive)
- 07-code-quality.md

See SHARED_STANDARDS.md for tool usage and output format.

[Rest of task brief]
```

---

**This document is the single source of truth for standards shared across all Alterspective prompts.**
