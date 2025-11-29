# 09 - Documentation Standards

Lightweight, navigable documentation structure for human and AI collaboration.

## Core Principles

- **Single source of truth** — One place for each type of information
- **Always navigable** — Index files link everything; readers can move forward/backward
- **Progress visible** — Checklists and registers show current state
- **Evidence-based** — Link to issues, decisions, and test results
- **Lifecycle-aware** — Documents move through stages with clear rules

## Folder Structure

```
docs/
├── INDEX.md                    # Master index linking all documentation
├── TAXONOMY.md                 # Naming conventions and organization rules
├── REGISTER.md                 # Project-wide progress register
│
├── developer/                  # Technical documentation for developers
│   ├── INDEX.md
│   ├── setup.md               # Local dev environment setup
│   ├── contributing.md        # How to contribute
│   ├── coding-standards.md    # Project-specific standards
│   └── api/                   # API documentation
│       └── INDEX.md
│
├── architecture/              # System design and decisions
│   ├── INDEX.md
│   ├── overview.md            # High-level architecture
│   ├── decisions/             # Architecture Decision Records (ADRs)
│   │   ├── INDEX.md
│   │   └── ADR-001-*.md
│   └── diagrams/              # Architecture diagrams
│
├── compliance/                # Regulatory, security, audit docs
│   ├── INDEX.md
│   ├── security.md
│   ├── privacy.md
│   └── audit-logs/
│
├── stakeholder/               # Non-technical documentation
│   ├── INDEX.md
│   ├── product-overview.md
│   ├── release-notes/
│   │   └── INDEX.md
│   └── user-guides/
│       └── INDEX.md
│
├── administrative/            # Project management docs
│   ├── INDEX.md
│   ├── team.md
│   ├── processes.md
│   └── meetings/
│
└── implementation/            # Feature/work tracking (see below)
    ├── INDEX.md
    ├── REGISTER.md            # Implementation progress register
    ├── backlog/
    ├── roadmap/
    ├── current/
    └── completed/
```

## Implementation Folder Structure

Track all features, plans, and work items through their lifecycle:

```
docs/implementation/
├── INDEX.md                   # Links to all stages
├── REGISTER.md                # Master checklist of all work items
│
├── backlog/                   # Ideas and future work (not yet planned)
│   ├── INDEX.md
│   └── [feature-name]/
│       └── README.md          # Brief description, rationale
│
├── roadmap/                   # Planned work (scheduled, not started)
│   ├── INDEX.md
│   └── [feature-name]/
│       ├── README.md          # Overview, goals, timeline
│       └── requirements.md    # High-level requirements
│
├── current/                   # Active implementation (limit: 1-3 concurrent)
│   ├── INDEX.md
│   └── [feature-name]/
│       ├── README.md          # AI guide + overview
│       ├── requirements.md    # Detailed requirements
│       ├── technical-design.md
│       ├── acceptance-criteria.md
│       ├── checklist.md       # Progress tracking
│       ├── issues.md          # Known issues and bugs
│       ├── ai-memory.md       # Context preservation
│       └── ai-handover.md     # Session handover state
│
└── completed/                 # Finished work (archived)
    ├── INDEX.md
    └── [YYYY-MM-DD]-[feature-name]/
        ├── README.md          # Final summary
        ├── lessons-learned.md # What worked, what didn't
        └── [archived docs]    # Moved from current/
```

## Naming Conventions

### Folders
- **kebab-case** for all folder names
- **Feature folders:** `[feature-name]/` (e.g., `user-authentication/`)
- **Completed folders:** `[YYYY-MM-DD]-[feature-name]/` (e.g., `2025-01-15-user-authentication/`)

### Files
- **INDEX.md** — Navigation index (uppercase, every folder)
- **README.md** — Overview/guide for the folder contents
- **kebab-case.md** — All other documentation files
- **ADR-NNN-title.md** — Architecture Decision Records
- **REGISTER.md** — Progress tracking (uppercase)

### Prefixes for Special Files
| Prefix | Purpose | Example |
|--------|---------|---------|
| `ADR-NNN-` | Architecture Decision Record | `ADR-001-database-choice.md` |
| `RFC-NNN-` | Request for Comments | `RFC-002-api-versioning.md` |
| `ISSUE-NNN-` | Issue documentation | `ISSUE-015-login-timeout.md` |

## INDEX.md Template

Every folder must have an INDEX.md:

```markdown
# [Folder Name] Index

> [One-line description of what this folder contains]

## Contents

| Document | Description | Status |
|----------|-------------|--------|
| [setup.md](./setup.md) | Local environment setup | Current |
| [contributing.md](./contributing.md) | Contribution guidelines | Current |

## Navigation

- **Up:** [Parent Folder](../INDEX.md)
- **Related:** [Architecture](../architecture/INDEX.md)

---
*Last updated: YYYY-MM-DD*
```

## REGISTER.md Template

Track progress across all work items:

```markdown
# Implementation Register

> Master tracking for all features and work items.

## Summary
- **Backlog:** X items
- **Roadmap:** X items
- **In Progress:** X items
- **Completed:** X items

## Current Work

| Feature | Status | Progress | Owner | Issues | Updated |
|---------|--------|----------|-------|--------|---------|
| [user-auth](./current/user-auth/) | In Progress | 60% | @dev | [2 open](./current/user-auth/issues.md) | 2025-01-15 |
| [api-v2](./current/api-v2/) | In Progress | 30% | @dev | [1 open](./current/api-v2/issues.md) | 2025-01-14 |

## Roadmap

| Feature | Priority | Target | Dependencies |
|---------|----------|--------|--------------|
| [payments](./roadmap/payments/) | High | Q1 2025 | user-auth |
| [notifications](./roadmap/notifications/) | Medium | Q2 2025 | — |

## Recently Completed

| Feature | Completed | Lessons |
|---------|-----------|---------|
| [2025-01-10-onboarding](./completed/2025-01-10-onboarding/) | 2025-01-10 | [View](./completed/2025-01-10-onboarding/lessons-learned.md) |

---
*Updated: YYYY-MM-DD by [human/AI]*
```

## Feature Folder Contents

### Backlog Stage
Minimal documentation:
```
backlog/[feature-name]/
└── README.md    # Brief: What, Why, Rough scope
```

### Roadmap Stage
Planning documentation:
```
roadmap/[feature-name]/
├── README.md           # Overview, goals, timeline
└── requirements.md     # High-level requirements
```

### Current Stage
Full implementation documentation:
```
current/[feature-name]/
├── README.md              # AI guide + project overview
├── requirements.md        # Detailed requirements
├── technical-design.md    # Architecture, data model, APIs
├── acceptance-criteria.md # Definition of done
├── checklist.md          # Task progress tracking
├── issues.md             # Known issues and bugs
├── ai-memory.md          # Persistent context for AI
└── ai-handover.md        # Session transition state
```

### Completed Stage
Archived with lessons:
```
completed/[YYYY-MM-DD]-[feature-name]/
├── README.md           # Final summary
├── lessons-learned.md  # Retrospective
└── [archived docs]     # Preserved from current/
```

## Checklist.md Template

```markdown
# [Feature Name] Checklist

> Progress tracking for implementation.

## Status
- **Phase:** [Planning/Implementation/Testing/Review]
- **Progress:** [X]%
- **Blockers:** [None / Description]
- **Last Updated:** YYYY-MM-DD

## Tasks

### Phase 1: Setup
- [x] Create feature branch
- [x] Set up folder structure
- [ ] **IN PROGRESS:** Configure database schema

### Phase 2: Core Implementation
- [ ] Implement user model
- [ ] Implement authentication endpoints
- [ ] Add session management

### Phase 3: Testing
- [ ] Unit tests for auth logic
- [ ] Integration tests for endpoints
- [ ] Security review

### Phase 4: Documentation & Cleanup
- [ ] Update API documentation
- [ ] Write user guide
- [ ] Code review

## Evidence Log
| Task | Completed | Evidence |
|------|-----------|----------|
| Database schema | 2025-01-15 | [Migration file](../../src/migrations/001.sql) |

## Related
- **Issues:** [issues.md](./issues.md)
- **Design:** [technical-design.md](./technical-design.md)
```

## Issues.md Template

Following testing standards (04-testing-standards.md):

```markdown
# [Feature Name] Issues

> Known issues, bugs, and blockers.

## Summary
- **Open:** X issues
- **Resolved:** X issues
- **Blockers:** X

## Open Issues

### ISSUE-001: [Title]
- **Severity:** Critical / High / Medium / Low
- **Status:** Open / Investigating / In Progress
- **Discovered:** YYYY-MM-DD
- **Assigned:** @person / AI

**Problem:**
[Clear description of the issue]

**Steps to Reproduce:**
1. Step one
2. Step two
3. Observe [behavior]

**Expected Behavior:**
[What should happen]

**Actual Behavior:**
[What actually happens]

**Evidence:**
- Log snippet: `[error message]`
- Screenshot: [link]
- Related code: `file.ts:45`

**Attempted Solutions:**
1. [Approach] — [Result]

---

### ISSUE-002: [Title]
...

## Resolved Issues

### ISSUE-000: [Title]
- **Severity:** Medium
- **Resolved:** YYYY-MM-DD
- **Resolution:** [What fixed it]

---
*Last updated: YYYY-MM-DD*
```

## Lifecycle Rules

### Moving Features Through Stages

**Backlog → Roadmap:**
- Requirements: Brief description exists
- Action: Add timeline, expand requirements
- Update: Both INDEX.md files, REGISTER.md

**Roadmap → Current:**
- Requirements: Full planning docs complete, approved
- Action: Move entire folder, create implementation docs
- Update: All INDEX.md files, REGISTER.md
- Limit: Max 1-3 features in current/ at once

**Current → Completed:**
- Requirements: All acceptance criteria met, checklist complete
- Action: Rename folder with date prefix, write lessons-learned.md
- Update: All INDEX.md files, REGISTER.md
- Follow-up: Extract reusable knowledge to KB

### Update Checklist (After Any Move)
- [ ] Move/rename the feature folder
- [ ] Update source stage INDEX.md (remove entry)
- [ ] Update destination stage INDEX.md (add entry)
- [ ] Update implementation/REGISTER.md
- [ ] Update docs/INDEX.md if needed
- [ ] Commit with message: `docs: move [feature] from [stage] to [stage]`

## Navigation Requirements

Every document should have:

1. **Header with context:**
   ```markdown
   # Document Title

   > [One-line description]

   **Feature:** [Name] | **Stage:** [Current] | **Updated:** [Date]
   ```

2. **Navigation footer:**
   ```markdown
   ---
   ## Navigation
   - **Up:** [Feature Index](./INDEX.md)
   - **Previous:** [Requirements](./requirements.md)
   - **Next:** [Technical Design](./technical-design.md)
   - **Register:** [Implementation Register](../../REGISTER.md)
   ```

## AI Onboarding Path

When an AI (or human) joins with no context, they should:

1. **Start:** `docs/INDEX.md` — Understand project structure
2. **Then:** `docs/implementation/REGISTER.md` — See current state
3. **Then:** `docs/implementation/current/[feature]/README.md` — Get feature context
4. **Then:** `docs/implementation/current/[feature]/checklist.md` — See progress
5. **Then:** `docs/implementation/current/[feature]/ai-memory.md` — Get preserved context
6. **Then:** `docs/implementation/current/[feature]/ai-handover.md` — Get session state

## Maintenance Rules

- **INDEX.md files:** Update immediately when adding/removing/moving documents
- **REGISTER.md:** Update at start and end of each work session
- **Checklist.md:** Update as tasks complete (not in batches)
- **Issues.md:** Add issues immediately when discovered
- **ai-handover.md:** Update before ending any AI session
- **Completed docs:** Archive within 1 week of completion

## Quick Reference

| Question | Go To |
|----------|-------|
| What's in this project? | `docs/INDEX.md` |
| What's being worked on? | `docs/implementation/REGISTER.md` |
| How do I set up locally? | `docs/developer/setup.md` |
| What's the architecture? | `docs/architecture/overview.md` |
| What decisions were made? | `docs/architecture/decisions/INDEX.md` |
| What's the current feature status? | `docs/implementation/current/[feature]/checklist.md` |
| What issues exist? | `docs/implementation/current/[feature]/issues.md` |
| What did we learn? | `docs/implementation/completed/[feature]/lessons-learned.md` |
