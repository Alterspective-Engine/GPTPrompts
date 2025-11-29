# 10 - AI Context & Loading Guide

Smart document loading to maximize effectiveness while minimizing context waste.

## Core Principle

**Load only what you need.** This prompt pack is modular—don't load everything.

## Progressive Disclosure (MCP Pattern)

**Core insight:** Don't load all tool/file definitions upfront. Discover incrementally.

**Traditional approach:**
```
Load all 50 tool schemas → 10,000 tokens → Use 2 tools
```

**Progressive disclosure:**
```
Explore tool directory → Load schema for 2 needed tools → 130 tokens (98.7% savings)
```

### How to Apply
1. **Explore first:** Use `list_directory`, `search`, `grep` to understand what's available.
2. **Load on demand:** Read specific files/schemas only when needed.
3. **Cache discoveries:** Remember what you found; don't re-explore in same session.
4. **Early exit:** Stop exploring when you have enough context.

### Example: Codebase Understanding

**Bad (eager loading):**
```
Read all 50 source files → 30,000 tokens → Modify 2 files
```

**Good (progressive):**
```
1. List src/ directory → See 50 files
2. Grep for "authenticate" → Find 3 relevant files
3. Read those 3 files → 2,000 tokens
4. Modify target files
```

**Token savings: 93%**

## Context Tiers

### Tier 1: Always Load
```
00-core-behavior.md (1KB)
```
Load this for every task. Contains identity, ethics, autonomy calibration.

### Tier 2: Load by Task Type
| Task Type | Load These |
|-----------|------------|
| Planning/Design | 06-development-workflow.md |
| Implementation | 07-code-quality.md |
| Visual/UI | 01-brand-kit.md, 02-modality-rules.md |
| API/Backend/CLI | 02-modality-rules.md |
| Testing | 04-testing-standards.md |
| Security | 05-security-standards.md |
| Multi-agent | 08-multi-agent.md |
| Documentation | 09-documentation-standards.md |

### Tier 3: Reference Only (Don't Pre-Load)
- `03-quality-guardrails.md` — Reference during shipping/review
- Operational prompts — Load only the one you're using
- KB articles — Fetch on demand, don't pre-load

## Task → Document Matrix

**MCP Principle:** This matrix already applies progressive disclosure. Load ONE task-specific standard, not all standards. Explore knowledge bases on demand via search, don't pre-load entire KB folders.

```
┌─────────────────────┬─────┬─────┬─────┬─────┬─────┬─────┬─────┬─────┬─────┬─────┐
│ Task                │ 00  │ 01  │ 02  │ 03  │ 04  │ 05  │ 06  │ 07  │ 08  │ 09  │
├─────────────────────┼─────┼─────┼─────┼─────┼─────┼─────┼─────┼─────┼─────┼─────┤
│ New feature plan    │  ●  │     │     │     │     │     │  ●  │     │     │     │
│ UI implementation   │  ●  │  ●  │  ●  │     │     │     │     │  ●  │     │     │
│ API implementation  │  ●  │     │  ●  │     │     │     │     │  ●  │     │     │
│ Bug fix             │  ●  │     │     │     │     │     │     │  ●  │     │     │
│ Code review         │  ●  │     │     │  ○  │     │     │     │  ●  │     │     │
│ Security review     │  ●  │     │     │     │     │  ●  │     │     │     │     │
│ Testing             │  ●  │     │     │     │  ●  │     │     │     │     │     │
│ Multi-agent work    │  ●  │     │     │     │     │     │     │     │  ●  │     │
│ Docs/KB authoring   │  ●  │     │  ●  │     │     │     │     │     │     │  ●  │
│ Project setup       │  ●  │     │     │     │     │     │  ●  │     │     │  ●  │
│ Session handover    │  ●  │     │     │     │     │     │  ●  │     │     │     │
└─────────────────────┴─────┴─────┴─────┴─────┴─────┴─────┴─────┴─────┴─────┴─────┘
● = Load    ○ = Reference if needed
```

## Reasoning Effort Calibration

Match effort to task complexity:

### High Effort (Thorough)
- Complex architectural decisions
- Multi-system integrations
- Security-critical code
- Debugging elusive issues

**Behavior:** Explore thoroughly, consider alternatives, validate assumptions.

### Medium Effort (Balanced)
- Standard feature implementation
- Code review
- Documentation updates
- Most day-to-day tasks

**Behavior:** Default mode. Gather sufficient context, then act.

### Low Effort (Efficient)
- Simple bug fixes with clear cause
- Formatting/style changes
- Routine updates
- Time-sensitive tasks

**Behavior:** Act decisively. Don't over-research obvious tasks.

## Agentic Behavior Control

### When to Explore More
- Requirements are ambiguous
- Multiple valid approaches exist
- Impact is high/irreversible
- Existing code patterns unclear

**Pattern:**
```
Start broad, then fan out to focused queries.
Early stop when: You can name exact changes needed.
```

### When to Act Decisively
- Task is well-defined
- Similar patterns exist in codebase
- Changes are easily reversible
- User explicitly requested quick action

**Pattern:**
```
Act on best judgment. Document assumptions.
Proceed rather than asking for confirmation.
```

### Stopping Criteria
Define clear stopping points:
- "Stop when all acceptance criteria met"
- "Stop after maximum 3 tool calls for context"
- "Stop when tests pass"

Avoid vague criteria like "when it looks good."

## Anti-Patterns to Avoid

### Don't: Over-Gather Context
**Bad:** Loading all 10 standard files for a simple bug fix.
**Good:** Load 00-core-behavior.md + 07-code-quality.md only.

### Don't: Contradict Instructions
**Bad:** "Always ask for confirmation" + "Act autonomously"
**Good:** Clear hierarchy: "Act autonomously unless security-critical, then confirm."

### Don't: Repeat Searches
**Bad:** Searching same patterns multiple times.
**Good:** Cache findings mentally; reference previous results.

### Don't: Over-Explain Simple Tasks
**Bad:** Lengthy preamble for adding a log statement.
**Good:** Brief statement, then act.

### Don't: Ask When You Can Decide
**Bad:** "Should I use async/await here?"
**Good:** Use established patterns; note assumption if uncertain.

## Prompt Structure Best Practices

### Use Clear Sections
```xml
<task>
[What to accomplish]
</task>

<constraints>
[Boundaries and limits]
</constraints>

<output>
[Expected format]
</output>
```

### Provide Escape Hatches
Allow proceeding under uncertainty:
```
If exact solution unclear, implement best-effort approach
and document assumptions for review.
```

### Set Tool Budgets When Needed
```
Maximum 3 file reads for context.
If more needed, summarize findings and ask.
```

## Context Window Management

### Signs You're Overloading Context
- Loading more than 3-4 standard files
- Pre-loading KB articles "just in case"
- Including full file contents when snippets suffice
- Repeating instructions across messages

### Strategies to Reduce Load
1. **Reference, don't embed:** "See 07-code-quality.md" vs copying content
2. **Summarize previous work:** Don't repeat full history
3. **Use file:line references:** Point to code, don't paste blocks
4. **Archive completed context:** Move to ai-memory.md, clear working memory

### When Context Is Filling Up
1. Update ai-handover.md with current state
2. Summarize key decisions in ai-memory.md
3. Clear non-essential context
4. Use prompt-handover.txt to transition

## Quick Start by Role

### For Planning
```
Load: 00-core-behavior.md, 06-development-workflow.md
Use: prompt-plan.txt
Output: docs/implementation/roadmap/[feature]/
```

### For Implementation
```
Load: 00-core-behavior.md, 07-code-quality.md
Use: prompt-continue.txt
Track: docs/implementation/current/[feature]/checklist.md
```

### For Review
```
Load: 00-core-behavior.md, 07-code-quality.md
Use: prompt-review.txt
Optionally: 05-security-standards.md for security review
```

### For Testing
```
Load: 00-core-behavior.md, 04-testing-standards.md
Use: prompt-testing.txt
Output: tests/[date]/ artifacts
```

### For New Projects
```
Load: 00-core-behavior.md, 06-development-workflow.md, 09-documentation-standards.md
Use: prompt-seed-project.txt
Output: Full project structure with docs/
```

## Metaprompting (Self-Optimization)

If prompts aren't working well, ask:

```
What phrases should be added to or removed from this prompt
to more consistently produce [desired behavior]?

Current behavior: [what's happening]
Desired behavior: [what should happen]
```

## Summary: The Minimal Load

For most tasks, you need only:

```
Always:     00-core-behavior.md
Usually:    One task-specific standard (06, 07, 04, 05, etc.)
Sometimes:  One operational prompt
Rarely:     Multiple standards simultaneously
```

**Default to minimal. Expand only when needed.**
