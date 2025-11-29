# 06 - Development Workflow

Structured phases for feature development with documentation, handover, and knowledge preservation.

> **Full documentation structure:** See `09-documentation-standards.md` for complete folder taxonomy, templates, and navigation rules.

## Implementation Lifecycle

```
docs/implementation/
├── backlog/        → Ideas, future work (not yet planned)
├── roadmap/        → Planned work (scheduled, not started)
├── current/        → Active implementation (limit: 1-3 features)
└── completed/      → Archived finished work
```

Features move through these stages with explicit transitions.

## Phase 1: Backlog

**Location:** `docs/implementation/backlog/[feature-name]/`

Minimal documentation for ideas:
- `README.md` — What, why, rough scope

**Exit to Roadmap:**
- Feature prioritized and scheduled
- Basic requirements understood

## Phase 2: Roadmap (Planning)

**Location:** `docs/implementation/roadmap/[feature-name]/`

Planning documentation:
- `README.md` — Overview, goals, timeline
- `requirements.md` — High-level requirements

**Exit to Current:**
- Requirements documented and approved
- Technical approach decided
- Acceptance criteria defined
- Resources allocated

## Phase 3: Current (Implementation)

**Location:** `docs/implementation/current/[feature-name]/`

Full implementation documentation:
```
current/[feature-name]/
├── README.md              # AI guide + project overview
├── requirements.md        # Detailed requirements
├── technical-design.md    # Architecture, data model, APIs
├── acceptance-criteria.md # Definition of done
├── checklist.md          # Progress tracking (see below)
├── issues.md             # Known issues and bugs (see below)
├── ai-memory.md          # Persistent context for AI
└── ai-handover.md        # Session transition state
```

**Rules:**
- Maximum 1-3 features in current/ at once
- Update checklist.md as tasks complete (not in batches)
- Document issues immediately when discovered
- Update ai-handover.md before ending sessions

### MCP State Management

For resumable workflows with MCP servers:

**Location:** `docs/implementation/current/[feature]/.mcp-state/`

```
current/[feature]/
├── .mcp-state/              # MCP execution state
│   ├── session-YYYYMMDD-HHMMSS.json  # Session snapshots
│   ├── tool-results/        # Cached tool outputs
│   └── progress.json        # Execution checkpoint
```

**State File Format:**
```json
{
  "sessionId": "uuid",
  "timestamp": "ISO-8601",
  "lastTool": "tool_name",
  "checkpoint": {
    "phase": "implementation",
    "completedSteps": ["step1", "step2"],
    "nextStep": "step3"
  },
  "cachedResults": {
    "tool_name": { "result": "...", "timestamp": "..." }
  }
}
```

**Rules:**
- Save state after each significant MCP operation
- Clear stale state older than 7 days
- Document state schema in `technical-design.md`
- Gitignore `.mcp-state/` to avoid bloating repo (unless needed for audit)

**Exit to Completed:**
- All acceptance criteria met
- Checklist 100% complete
- Issues resolved or documented
- Code reviewed and merged

## Phase 4: Completed

**Location:** `docs/implementation/completed/[YYYY-MM-DD]-[feature-name]/`

Archive with retrospective:
- Move entire folder from current/
- Rename with date prefix
- Add `lessons-learned.md`
- Extract reusable knowledge → KB

## Checklist.md Format

```markdown
# [Feature Name] Checklist

## Status
- **Phase:** [Implementation/Testing/Review]
- **Progress:** [X]%
- **Blockers:** [None / Description]
- **Updated:** YYYY-MM-DD

## Tasks

### Phase 1: Setup
- [x] Completed task
- [ ] **IN PROGRESS:** Current task
- [ ] Pending task

### Phase 2: Core Implementation
- [ ] Task description
- [ ] Task description

## Evidence Log
| Task | Completed | Evidence |
|------|-----------|----------|
| Setup | 2025-01-15 | [commit abc123] |
```

## Issues.md Format

Following `04-testing-standards.md`:

```markdown
# Issues

## Open Issues

### ISSUE-001: [Title]
- **Severity:** Critical / High / Medium / Low
- **Status:** Open / Investigating
- **Discovered:** YYYY-MM-DD

**Problem:** [Description]

**Steps to Reproduce:**
1. Step one
2. Step two

**Evidence:** [Log, screenshot, code reference]

**Attempted Solutions:**
1. [Approach] — [Result]

## Resolved Issues

### ISSUE-000: [Title]
- **Resolved:** YYYY-MM-DD
- **Resolution:** [What fixed it]
```

## AI Handover Process

Update `ai-handover.md` before ending a session:

```markdown
# AI Handover

## Session: YYYY-MM-DD
**Progress:** [X]% → [Y]%

## Current Status
[2-3 sentences on immediate state]

## Files Modified
- `path/to/file.ts:L45-L120` — [What changed]
- `path/to/other.ts:L10-L30` — [What changed]

## Next Immediate Steps
1. [Very specific next action]
2. [Following action]

## Blockers
- [Any blockers or pending decisions]

## Context
See `ai-memory.md` for preserved context.
```

## AI Memory Management

Use `ai-memory.md` for context that must survive across sessions:

```markdown
# AI Memory

## Key Decisions
- [Decision]: [Rationale] (Date)

## Established Patterns
- [Pattern]: [How and why]

## Gotchas
- [What to watch out for]

## Do Not Forget
- [Critical items]

## MCP State
- [MCP servers used and their purpose]
- [State persistence locations and schemas]
- [Cached tool results worth preserving]
```

## Stage Transition Checklist

When moving a feature between stages:

- [ ] Move/rename the feature folder
- [ ] Update source stage `INDEX.md` (remove entry)
- [ ] Update destination stage `INDEX.md` (add entry)
- [ ] Update `docs/implementation/REGISTER.md`
- [ ] Commit: `docs: move [feature] from [stage] to [stage]`

## Register Updates

Update `docs/implementation/REGISTER.md` at:
- Start of each work session
- End of each work session
- Any stage transition
- Significant progress milestones

## Knowledge Base Updates

After feature completion:
1. Review `lessons-learned.md`
2. Extract generalizable patterns
3. Add to appropriate KB category
4. Keep KB entries project-agnostic
5. Update KB immediately when patterns discovered

## Version Control

- **Commit messages:** Conventional commits (`feat:`, `fix:`, `docs:`)
- **Branch naming:** `feature/`, `bugfix/`, `docs/`, `refactor/`
- **Commits:** Atomic; one logical change per commit
- **Doc moves:** `docs: move [feature] from [stage] to [stage]`
