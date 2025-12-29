# Web-App-Development Framework Improvement Plan

**Date**: 2025-12-08
**Status**: DRAFT - Pending Approval
**Problem Statement**: Test project achieved only 40-50% framework compliance, producing 88 QA issues that should have been prevented by process

---

## Executive Summary

The framework's design is excellent (9.3/10) but lacks **enforcement mechanisms**. AI agents (and humans) optimize for "working code" over "process compliance" when given freedom. This plan introduces:

1. **Phase Gate Validators** - Hard stops at phase boundaries
2. **Mandatory File Enforcement** - Required files cannot be skipped
3. **Pre-QA Quality Checks** - Security, accessibility, code quality gates
4. **Prompt Enhancements** - Close gaps in existing prompts
5. **UX Standards Integration** - Wire UX-UI-STANDARDS.md into workflow

**Estimated Effort**: 4-6 hours total
**Risk Level**: Low (additive changes, no breaking changes)

---

## Root Cause Analysis

### Why Compliance Failed

| Expected Behavior | Actual Behavior | Root Cause |
|-------------------|-----------------|------------|
| Create CLAUDE.md/AGENTS.md | Skipped entirely | No prompt enforces creation |
| Use src/areas/{area}/ structure | Monolithic files | No validation checkpoint |
| Write tests (80% coverage) | Zero tests written | Testing not mandatory |
| Follow UX-UI-STANDARDS.md | 8 critical accessibility issues | Not referenced in dev workflow |
| Security best practices | Hardcoded secrets, open CORS | No security checklist |

### The Core Issue

```
Framework provides GUIDANCE → Agent ignores guidance → Bad output reaches QA

Framework provides GATES → Agent cannot proceed without compliance → Good output
```

---

## Proposed Solution Architecture

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                         ENHANCED FRAMEWORK FLOW                              │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  Phase 0              Phase 1                Phase 2              Phase 3    │
│  ┌────────┐           ┌────────┐            ┌────────┐          ┌────────┐  │
│  │ Seed   │──GATE──►  │ Arch   │──GATE──►   │Feature │──GATE──► │ Impl   │  │
│  │ Repo   │    ▲      │ Design │    ▲       │ Design │    ▲     │        │  │
│  └────────┘    │      └────────┘    │       └────────┘    │     └────────┘  │
│                │                    │                     │          │      │
│         13-phase-validator   13-phase-validator   13-phase-validator  │      │
│         (validates 0→1)      (validates 1→2)      (validates 2→3)    │      │
│                                                                      │      │
│                              GATE ◄──────────────────────────────────┘      │
│                                │                                            │
│                     13-phase-validator (validates 3→4)                      │
│                                │                                            │
│                                ▼                                            │
│  Phase 4              Phase 5                                               │
│  ┌────────┐           ┌────────┐                                           │
│  │  QA    │──GATE──►  │Govern  │──► Next Cycle                             │
│  │ Review │    ▲      │  ance  │                                           │
│  └────────┘    │      └────────┘                                           │
│                │                                                            │
│         13-phase-validator                                                  │
│         (validates 4→5)                                                     │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

---

## Implementation Plan

### Phase 1: Critical Enforcement (Priority: HIGH)

**Objective**: Prevent structural deviation and missing tests
**Effort**: 2 hours
**Files to Create/Modify**:

#### 1.1 Create Phase Validator Prompt

**New File**: `13-phase-validator.txt`

Purpose: Act as gatekeeper at phase boundaries, blocking progression until requirements met.

Key validation points:
- Phase 0→1: CLAUDE.md, AGENTS.md, folder structure exist
- Phase 1→2: Architecture docs, area folders, interfaces defined
- Phase 2→3: Feature folder complete, AI instructions exist, checklists created
- Phase 3→4: Code in correct locations, tests exist (>80%), demo created
- Phase 4→5: QA signoff, all tests pass, docs complete

Output format:
```markdown
# Phase Validation Report
**Status**: PASS / BLOCK
**Blockers**: [list of missing items]
**Remediation**: [steps to fix]
```

#### 1.2 Update 00-seed-repository.txt

**Add at end of prompt**:
```markdown
## Validation Requirement

After creating all files, run `13-phase-validator.txt` with:
- Current Phase: 0
- Target Phase: 1
- Feature: "Repository-wide"

**DO NOT proceed to Phase 1 until validator returns PASS.**

If validator returns BLOCK:
1. Read the specific error messages
2. Create missing files as specified
3. Re-run validator
4. Repeat until PASS
```

#### 1.3 Update 05-developer-agent.txt

**Add new section after Step 3 (before Step 4: Implement)**:

```markdown
## Step 3.5: Verify Folder Structure (MANDATORY)

Before ANY implementation, verify your folder structure:

```bash
ls -la src/areas/{your-area}/
```

**Required structure**:
```
src/areas/{your-area}/
├── src/          # ALL your code goes here
├── tests/        # ALL your tests go here
└── implementation/
    ├── instructions/
    └── checklists/
```

**Boundary Enforcement**:
- DO NOT create files in `src/` at project root
- DO NOT create files in other `src/areas/{other-area}/`
- DO NOT modify `src/common/` (read-only)

**Verification Checklist** (add to "2. Built" section):
- [ ] All code files in `src/areas/{your-area}/src/`
- [ ] All test files in `src/areas/{your-area}/tests/`
- [ ] No files created outside area boundary
```

**Add new section after Step 5 (Testing)**:

```markdown
### 5.4 Zero Tests = Failure (MANDATORY)

Before marking "3. Tested" complete:

```bash
npm test src/areas/{area} -- --reporter=verbose
```

**Acceptance Criteria for Testing Stage**:
- [ ] At least 1 test file created
- [ ] Minimum 3 test cases (happy path + error + edge case)
- [ ] 80%+ code coverage (if measurable)
- [ ] All tests passing (green)

**If tests = 0**: DO NOT proceed to Step 6. Write tests first.

**Test Template**:
```typescript
import { describe, it, expect } from 'vitest';

describe('{Feature}', () => {
  // HAPPY PATH
  it('should {expected behavior} with valid input', () => {
    // Arrange, Act, Assert
  });

  // ERROR CASE
  it('should throw error when {condition}', () => {
    expect(() => fn()).toThrow();
  });

  // EDGE CASE
  it('should handle {boundary condition}', () => {
    // Test limits
  });
});
```
```

---

### Phase 2: Security & Accessibility Gates (Priority: HIGH)

**Objective**: Prevent security vulnerabilities and accessibility issues from reaching QA
**Effort**: 1.5 hours
**Files to Modify**:

#### 2.1 Add Pre-QA Quality Checklist to 05-developer-agent.txt

**Add new section before Step 7 (Create Demo)**:

```markdown
## Step 6.5: Pre-QA Quality Gate (MANDATORY)

Before creating demo, complete these checks:

### Security Check (if handling auth/data)
- [ ] No hardcoded secrets (search: `grep -r "password\|secret\|key" src/`)
- [ ] Input validation on all user inputs
- [ ] Parameterized queries (no SQL string concatenation)
- [ ] CORS configured (not `cors()` with no options)
- [ ] Error messages don't leak internal details

### Accessibility Check (if building UI)
- [ ] Forms use `<form>` elements (not just `onclick` buttons)
- [ ] Focus indicators visible (no `outline: none` without replacement)
- [ ] ARIA labels on icon-only buttons
- [ ] Keyboard navigation works (test with Tab key)
- [ ] Color contrast meets WCAG AA (4.5:1 for text)

### Code Quality Check
- [ ] Error handling present (try-catch, error middleware)
- [ ] No console.log in production code
- [ ] TypeScript types used (no `any` in public APIs)
- [ ] Lint passes: `npm run lint`
- [ ] TypeScript passes: `npm run typecheck`

### UX Check (if building UI)
- [ ] Loading states for async operations (>200ms)
- [ ] Error messages are user-friendly (not "Error 500")
- [ ] Empty states are helpful (not just "No items")
- [ ] Responsive at mobile/tablet/desktop

**If ANY check fails**: Fix before creating demo. Do not proceed.
```

#### 2.2 Update 01-schematic-capture.txt

**Expand Security section** (replace existing):

```markdown
### Security Requirements (MANDATORY)

- **Authentication**:
  - Method: {JWT | Session | OAuth2}
  - Session duration: {minutes}
  - Token storage: {localStorage | httpOnly cookie}

- **Authorization**:
  - Model: {RBAC | ABAC}
  - Permission levels: {list permissions}
  - Who can access what: {matrix}

- **Data Protection**:
  - Sensitive fields: {list: passwords, emails, etc.}
  - Encryption: {at rest? in transit?}
  - Never log: {passwords, tokens, PII}

- **Input Validation**:
  - All inputs validated: {Yes}
  - Max lengths defined: {Yes}
  - Format validation: {email, phone, etc.}

- **API Security**:
  - Rate limiting: {requests per minute}
  - CORS policy: {allowed origins - NOT "*"}
  - Token validation: {how verified}

**Note**: Features touching auth/data MUST address all items above.
```

---

### Phase 3: UX Standards Integration (Priority: MEDIUM)

**Objective**: Wire UX-UI-STANDARDS.md into the development workflow
**Effort**: 1 hour
**Files to Modify**:

#### 3.1 Update 04-instruction-writer.txt

**Add UX Requirements section to instruction template**:

```markdown
## UX/UI Requirements (if feature has UI)

Reference: `docs/UX-UI-STANDARDS.md`

### User Flow
```
[Entry Point] → [Screen 1] → [Action] → [Screen 2] → [Exit]
```

### States to Implement
- [ ] Initial: What user sees first
- [ ] Loading: Spinner/skeleton for async (>200ms)
- [ ] Success: Confirmation feedback
- [ ] Error: User-friendly message
- [ ] Empty: Helpful guidance if no data

### Accessibility Requirements
- [ ] Keyboard navigation works
- [ ] Focus indicators visible
- [ ] Form labels (not placeholder-as-label)
- [ ] ARIA labels for icons
- [ ] Color contrast 4.5:1

### Responsive Design
- [ ] Mobile (<640px): {how it adapts}
- [ ] Tablet (640-1024px): {how it adapts}
- [ ] Touch targets: 44px minimum
```

#### 3.2 Update 07-qa-review.txt

**Add UX Verification section** (after Code Quality Review):

```markdown
## Step 4.5: UX/Accessibility Verification

### Visual Design
- [ ] Layout consistent (aligned, proper spacing)
- [ ] Colors from design system
- [ ] Buttons look clickable
- [ ] Hover states present

### Interaction Quality
- [ ] All buttons work as labeled
- [ ] Forms validate correctly
- [ ] Error messages helpful
- [ ] Loading indicators visible
- [ ] Success feedback shown

### Keyboard Testing
- [ ] Can Tab through all elements
- [ ] Focus order is logical
- [ ] Enter submits forms
- [ ] Escape closes modals
- [ ] No keyboard traps

### Responsive Testing
- [ ] Mobile (320px): works
- [ ] Tablet (768px): works
- [ ] Desktop (1920px): works
- [ ] No horizontal scroll

### Accessibility Testing
- [ ] Screen reader compatible
- [ ] Color not only indicator
- [ ] Focus indicators visible

**Severity**: Accessibility failures = MEDIUM or HIGH
```

---

### Phase 4: Mandatory Documentation Enforcement (Priority: MEDIUM)

**Objective**: Ensure CLAUDE.md and AGENTS.md are always created
**Effort**: 0.5 hours
**Files to Modify**:

#### 4.1 Update 04-instruction-writer.txt

**Add at the beginning** (after Quick Start):

```markdown
## Prerequisites Check (MANDATORY)

Before writing any instructions, verify these files exist:

**Project-Level** (run once per project):
- [ ] `CLAUDE.md` exists (>500 chars, has required sections)
- [ ] `AGENTS.md` exists (>800 chars, has required sections)
- [ ] `project/CURRENT_STATE.md` exists

**If missing**: Run `00-seed-repository.txt` first. Do not proceed without these files.

**Area-Level** (run once per area):
- [ ] `src/areas/{area}/` folder exists
- [ ] `AIFeedback/{area}/` folder exists

**If missing**: Request Architect to run `02-architecture-design.txt`.
```

---

### Phase 5: Integration & Documentation (Priority: LOW)

**Objective**: Document the new enforcement system
**Effort**: 1 hour
**Files to Create**:

#### 5.1 Create INTEGRATION.md

Document how the phase validator integrates with existing prompts:

```markdown
# Phase Validator Integration Guide

## Automatic Checkpoints

| After This Prompt | Run Validator | Transition |
|-------------------|---------------|------------|
| 00-seed-repository | 13-phase-validator | 0 → 1 |
| 03-interface-contracts | 13-phase-validator | 1 → 2 |
| 04-instruction-writer | 13-phase-validator | 2 → 3 |
| 06-demo-walkthrough | 13-phase-validator | 3 → 4 |
| 07-qa-review (signoff) | 13-phase-validator | 4 → 5 |

## Workflow with Validators

[Full workflow diagram with validator checkpoints]
```

#### 5.2 Update README.md

Add enforcement section to README:

```markdown
## Enforcement Mechanisms

This framework includes mandatory quality gates:

1. **Phase Validators**: Run `13-phase-validator.txt` at phase boundaries
2. **Pre-QA Checks**: Security, accessibility, code quality in `05-developer-agent.txt`
3. **Mandatory Files**: CLAUDE.md, AGENTS.md required before development
4. **Test Requirements**: 80% coverage, minimum 3 test cases per feature

Skipping these checks will result in blocked progression.
```

---

## File Change Summary

| File | Action | Priority | Effort |
|------|--------|----------|--------|
| `13-phase-validator.txt` | CREATE | HIGH | 1 hour |
| `00-seed-repository.txt` | MODIFY | HIGH | 15 min |
| `05-developer-agent.txt` | MODIFY | HIGH | 30 min |
| `01-schematic-capture.txt` | MODIFY | HIGH | 15 min |
| `04-instruction-writer.txt` | MODIFY | MEDIUM | 20 min |
| `07-qa-review.txt` | MODIFY | MEDIUM | 20 min |
| `INTEGRATION.md` | CREATE | LOW | 30 min |
| `README.md` | MODIFY | LOW | 15 min |

**Total New Content**: ~2000 lines
**Total Effort**: 4-6 hours

---

## Risk Assessment

| Risk | Likelihood | Impact | Mitigation |
|------|------------|--------|------------|
| Validators too strict | Medium | Low | Start lenient, tighten based on feedback |
| Slow down development | Low | Medium | Validators run in <5 min |
| Agents game the system | Low | Low | Compliance scoring catches patterns |
| Existing projects break | Low | Low | Changes are additive, not breaking |

---

## Success Metrics

After implementation, measure:

| Metric | Current | Target |
|--------|---------|--------|
| QA issues found | 88 | <20 |
| Framework compliance | 40-50% | >90% |
| Tests per feature | 0 | >3 |
| Security issues | 16 critical | 0 critical |
| Accessibility issues | 8 critical | 0 critical |

---

## Approval Checklist

- [ ] Plan reviewed by stakeholder
- [ ] Scope agreed (all 5 phases or subset)
- [ ] Effort estimate accepted
- [ ] Risk assessment acknowledged
- [ ] Success metrics agreed

---

## Next Steps (Post-Approval)

1. Create `13-phase-validator.txt` (complete prompt from agent research)
2. Update `05-developer-agent.txt` with enforcement sections
3. Update `00-seed-repository.txt` with validation requirement
4. Update remaining prompts (01, 04, 07)
5. Create `INTEGRATION.md` documentation
6. Update `README.md` with enforcement section
7. Test with new project to validate

---

---

## Phase 6: 2025 Cutting-Edge Multi-Agent Coordination (Priority: HIGH)

**Date Added**: 2025-12-29
**Status**: NEW - Addressing Industry Gap
**Objective**: Implement 2025 state-of-the-art multi-agent coordination patterns identified from industry research
**Effort**: 8-12 hours total

### Industry Research Summary (December 2025)

| Pattern | Industry Status | Our Current | Gap |
|---------|-----------------|-------------|-----|
| Structured State Schemas | Emerging standard | Markdown checklists | **CRITICAL** |
| Automated File Locking | 40% of multi-AI teams | None | **HIGH** |
| Git Worktrees | Best practice for parallel AI | Not documented | **MEDIUM** |
| Orchestration Tooling | claude-flow, Claude Squad | AI-Office (v1.0.2) | **EVOLVING** |
| Token Cost Awareness | 15× overhead documented | Not tracked | **LOW** |

### 6.1 Structured State Schemas (CRITICAL)

**Problem**: Markdown checklists are ambiguous. AI agents interpret them differently, causing drift.

**Solution**: Replace markdown task coordination with typed JSON schemas.

**Create File**: `src/common/coordination/task-state.schema.json`

```json
{
  "$schema": "http://json-schema.org/draft-07/schema#",
  "title": "AgentTaskState",
  "type": "object",
  "required": ["taskId", "phase", "status", "agent", "boundaries", "artifacts"],
  "properties": {
    "taskId": {
      "type": "string",
      "pattern": "^TASK-[0-9]{8}-[A-Z0-9]{8}$"
    },
    "phase": {
      "type": "integer",
      "minimum": 0,
      "maximum": 5
    },
    "status": {
      "enum": ["pending", "in_progress", "blocked", "review", "completed", "failed"]
    },
    "agent": {
      "type": "object",
      "required": ["id", "role", "worktree"],
      "properties": {
        "id": { "type": "string" },
        "role": { "enum": ["architect", "developer", "qa", "housekeeping"] },
        "worktree": { "type": "string" }
      }
    },
    "boundaries": {
      "type": "object",
      "required": ["canModify", "canRead", "cannotTouch"],
      "properties": {
        "canModify": { "type": "array", "items": { "type": "string" } },
        "canRead": { "type": "array", "items": { "type": "string" } },
        "cannotTouch": { "type": "array", "items": { "type": "string" } }
      }
    },
    "artifacts": {
      "type": "object",
      "properties": {
        "created": { "type": "array", "items": { "type": "string" } },
        "modified": { "type": "array", "items": { "type": "string" } },
        "locked": { "type": "array", "items": { "type": "string" } }
      }
    },
    "dependencies": {
      "type": "array",
      "items": {
        "type": "object",
        "properties": {
          "taskId": { "type": "string" },
          "status": { "enum": ["pending", "satisfied", "failed"] }
        }
      }
    },
    "validation": {
      "type": "object",
      "properties": {
        "phaseGate": { "enum": ["pending", "passed", "failed"] },
        "preQA": { "enum": ["pending", "passed", "failed"] },
        "lastValidated": { "type": "string", "format": "date-time" }
      }
    }
  }
}
```

**Update Prompts**:
- `00-seed-repository.txt`: Create `src/common/coordination/` folder with schema
- `15-implementation-orchestrator.txt`: Use JSON state instead of markdown
- All prompts: Read/write state via structured JSON, not markdown checklists

### 6.2 Automated File Locking Protocol (HIGH)

**Problem**: Two agents modifying same file causes silent conflicts.

**Solution**: Lock files before editing, release after commit.

**Create File**: `16-file-lock-protocol.txt`

```markdown
# File Lock Protocol for Multi-Agent Development

## Lock File Format
Location: `.ai-office/locks/{path-hash}.lock.json`

{
  "path": "src/areas/frontend/src/App.tsx",
  "lockedBy": "agent-frontend",
  "lockedAt": "2025-12-29T10:30:00Z",
  "expiresAt": "2025-12-29T11:30:00Z",
  "operation": "edit",
  "reason": "Implementing FEAT-001 component"
}

## Locking Rules

### Before ANY file modification:
1. Check if lock exists: `cat .ai-office/locks/{hash}.lock.json`
2. If locked by another agent: STOP, wait or request release
3. If unlocked: Create lock file with your agent ID
4. Proceed with modification
5. After git commit: Release lock (delete lock file)

### Lock Expiry
- Locks expire after 1 hour (configurable)
- Expired locks can be overridden
- Override requires notification to original agent

### Conflict Resolution
- If two agents need same file: Escalate to Architect
- Architect decides: sequential work or interface boundary

## Integration with Git Worktrees
- Each worktree tracks its own locks
- Locks are NOT committed to git
- Locks stored in shared `.ai-office/locks/` outside worktrees
```

**Update Prompts**:
- `05-developer-agent.txt`: Add lock acquisition before editing
- `08-architect-review.txt`: Add lock release during integration

### 6.3 Git Worktree Integration (MEDIUM)

**Problem**: Multiple AI agents on same branch cause merge conflicts.

**Solution**: Each agent gets isolated worktree, Architect merges.

**Add to `AGENTS.md` template** (seeded by `00-seed-repository.txt`):

```markdown
## Git Worktree Protocol

### Directory Structure
```
project-root/
├── main/                    # Main working tree (main branch)
└── worktrees/               # Worktree container (OUTSIDE main/)
    ├── coordination.json    # Structured task state (shared)
    ├── locks/               # File locks (shared)
    ├── ai-frontend/         # Frontend Agent worktree
    ├── ai-api/              # API Agent worktree
    └── ai-analysis/         # Analysis Agent worktree
```

### Setting Up Worktrees (Architect runs once)
```bash
# From main project directory
git worktree add ../worktrees/ai-frontend feature/frontend-agent
git worktree add ../worktrees/ai-api feature/api-agent
git worktree add ../worktrees/ai-analysis feature/analysis-agent
```

### Agent Rules
1. **Work ONLY in your worktree**: Never `cd` to another worktree
2. **Commit frequently**: Small commits reduce merge conflicts
3. **Sync before work**: `git fetch origin && git rebase origin/main`
4. **Update coordination.json**: After each task state change

### Merging Protocol (Architect Only)
1. Agent completes task, updates coordination.json with status: "review"
2. Architect reviews work in agent's worktree
3. Architect runs: `git checkout main && git merge feature/{agent}-agent`
4. Resolve any conflicts (should be minimal with area isolation)
5. Update coordination.json with status: "completed"
6. Notify next agent their dependencies are satisfied
```

### 6.4 Orchestration Tooling Integration (EVOLVING)

**Current State**: AI-Office v1.0.2 provides file-based coordination.

**Enhancement Path**: Prepare for integration with emerging tools.

**Create File**: `docs/ORCHESTRATION-INTEGRATION.md`

```markdown
# Orchestration Integration Guide

## Supported Orchestrators

### 1. AI-Office (Current - v1.0.2)
File-based coordination with supervisor pattern.
- Installation: `npm install github:alterspective/ai-office#v1.0.2`
- Config: `ai-office.config.json`
- Works with: Structured state schemas, file locking

### 2. Claude-Flow (Experimental)
DAG-based multi-agent orchestration.
- When to use: Complex dependency graphs
- Integration: Wrap prompts as nodes

### 3. Claude Squad (Experimental)
Real-time collaboration between agents.
- When to use: Tight coordination needed
- Integration: Shared memory protocol

## Integration Points

The framework supports orchestrators through:
1. **Structured State**: `coordination.json` readable by any orchestrator
2. **File Locks**: Universal lock protocol in `.ai-office/locks/`
3. **Phase Validators**: Can be called as gates in any DAG
4. **Completion Signals**: Outbox pattern for task completion

## Seeding with Orchestration

When running `00-seed-repository.txt`, add orchestration config:
- Creates `ai-office.config.json` with agent boundaries from AGENTS.md
- Creates `src/common/coordination/` with state schemas
- Creates `.ai-office/` folder structure (gitignored)
```

### 6.5 Token Cost Awareness (LOW)

**Problem**: Multi-agent development uses ~15× more tokens than single-chat.

**Solution**: Track and optimize token usage.

**Add to `11-housekeeping.txt`**:

```markdown
## Token Usage Report (Monthly)

Track and report:
- Total tokens used per agent
- Tokens per phase (which phases are expensive?)
- Retry overhead (failed validations, rejected PRs)
- Context window efficiency (are we passing too much?)

Optimization targets:
- Reduce cross-area context passing
- Cache common lookups (interfaces, standards)
- Use streaming for large file reads
```

---

## Phase 7: Seeding Implementation Path (Priority: HIGH)

**Objective**: Ensure new projects automatically get 2025 features
**Effort**: 2 hours

### 7.1 Update `00-seed-repository.txt`

Add to seeded folder structure:

```
project/
├── CLAUDE.md
├── AGENTS.md
├── ai-office.config.json        # NEW: Orchestration config
├── src/
│   └── common/
│       └── coordination/        # NEW: Structured state
│           ├── task-state.schema.json
│           └── current-state.json
├── .ai-office/                  # NEW: Runtime coordination (gitignored)
│   ├── locks/
│   └── queue/
└── worktrees/                   # NEW: Documented but not created
    └── .gitkeep                 # Placeholder for worktree docs
```

### 7.2 Update `.gitignore` template

Add to seeded `.gitignore`:

```gitignore
# AI-Office runtime (never commit)
.ai-office/

# Worktrees are outside main, but document the pattern
worktrees/

# Lock files (temporary)
*.lock.json
```

### 7.3 Create `continue.bat` / `continue.ps1`

Seeded scripts that:
1. Read `coordination.json` for current state
2. Identify incomplete tasks
3. Recommend next prompt to run
4. Check for lock conflicts

---

## Updated File Change Summary

| File | Action | Priority | Phase | Effort |
|------|--------|----------|-------|--------|
| `13-phase-validator.txt` | CREATE | HIGH | 1 | 1 hr |
| `16-file-lock-protocol.txt` | CREATE | HIGH | 6 | 1 hr |
| `task-state.schema.json` | CREATE | HIGH | 6 | 30 min |
| `ORCHESTRATION-INTEGRATION.md` | CREATE | MEDIUM | 6 | 1 hr |
| `00-seed-repository.txt` | MODIFY | HIGH | 1,6,7 | 1 hr |
| `05-developer-agent.txt` | MODIFY | HIGH | 1,6 | 1 hr |
| `15-implementation-orchestrator.txt` | MODIFY | HIGH | 6 | 1 hr |
| `AGENTS.md` (template) | MODIFY | MEDIUM | 6 | 30 min |
| `11-housekeeping.txt` | MODIFY | LOW | 6 | 30 min |
| `.gitignore` (template) | MODIFY | LOW | 7 | 15 min |

**Additional Effort for Phase 6-7**: 8-12 hours
**Total Plan Effort**: 12-18 hours

---

## AI-Office Integration Checklist

For AI-Office to leverage these patterns:

- [ ] Update `ai-office.config.json.template` with structured state schema path
- [ ] Add file lock support to `AgentMonitor` class
- [ ] Add worktree detection to supervisor
- [ ] Create JSON state read/write utilities
- [ ] Add phase validator integration to job queue

---

**Prepared By**: Claude (Planning & Architecture Assistant)
**Date**: 2025-12-08 (Updated: 2025-12-29)
**Version**: 2.0
