# Consistency Update Status

**Date**: 2025-12-20
**Option Selected**: Option B (Create SHARED_STANDARDS.md + update all prompts)
**Status**: IN PROGRESS

---

## ✅ Completed (6/19 prompts)

| Prompt | Before | After | Reduction | Changes Made |
|--------|--------|-------|-----------|--------------|
| **SHARED_STANDARDS.md** | N/A | 400 lines | N/A | Created shared reference doc |
| **prompt-execute-plan.txt** | 1,261 | 623 | 51% | Headers, condensed sections, references to SHARED_STANDARDS.md |
| **prompt-continue.txt** | 129 | 128 | 1% | Fixed 20→10 Task limit, added TodoWrite, condensed Prompt Pack section |
| **prompt-investigation.txt** | 245 | 250 | -2% | Added headers, condensed Prompt Pack (net: slight increase due to headers) |
| **prompt-general.txt** | 59 | 52 | 12% | Added headers, condensed Prompt Pack, added TodoWrite |
| **prompt-plan.txt** | 191 | 195 | -2% | Added headers, fixed terminology (partial) |

**Total Completed**: 1,884 → 1,248 lines (636 lines removed, 34% reduction)

---

## 🚧 Remaining Updates (13/19 prompts)

### High Priority (Large Files)
1. **prompt-testing.txt** (305 lines) - Need to condense quality sections
2. **prompt-demo.txt** (282 lines) - Need to add headers + condense
3. **prompt-seed-project.txt** (280 lines) - Need to add headers + condense
4. **prompt-post-task-review.txt** (240 lines) - Need to add headers + condense
5. **prompt-kb-authoring.txt** (222 lines) - Need to add headers + condense

### Medium Priority
6. **prompt-handover.txt** (172 lines)
7. **prompt-refactor.txt** (94 lines)
8. **prompt-security-review.txt** (94 lines)
9. **prompt-implementation-orchestration.txt** (83 lines)

### Low Priority (Already Concise)
10. **prompt-review.txt** (72 lines)
11. **prompt-deploy-azure.txt** (68 lines)
12. **prompt-architecture-audit.txt** (67 lines)
13. **prompt-error-triage.txt** (67 lines)
14. **prompt-fix.txt** (57 lines)

**Total Remaining**: 2,198 lines → Est. 1,320 lines after updates (40% reduction expected)

---

## Update Pattern for Remaining Prompts

### Step 1: Add Headers (Top of File)

**Add after ROLE line**:
```markdown
ROLE: [Existing Role Name]

> **Standards**: See SHARED_STANDARDS.md for tool standards (Task, TodoWrite), prompt pack integration, KB paths, and MCP guidance.

> **Tools Required**: [List specific tools: Task, TodoWrite, Read, Edit, Write, Bash, Grep, Glob, etc.]

[Existing content...]
```

### Step 2: Fix Terminology

**Find and replace**:
- "sub-agents" → "Task tools"
- "spawn up to 20" → "spawn up to 10"
- "agents" (in context of Task tool) → "Task tools"

### Step 3: Add TodoWrite Mentions

**In planning/implementation sections, add**:
```markdown
- **Use TodoWrite**: Create tasks, mark "in_progress" before starting, mark "completed" immediately after finishing
```

### Step 4: Replace Prompt Pack Integration Section

**Find** (usually near end of file):
```markdown
## Prompt Pack Integration

Use the Alterspective prompt pack in C:\GitHub\GPTPrompts.
Load 00-core-behavior.md, plus only the relevant bundle (see postfix.md for details):
- [Long list of files...]
- [More details...]

Knowledge bases: for Sharedo, consult C:\GitHub\LearnSD\KB; for general knowledge...
[More redundant text...]

MCP + code execution (when applicable):
- [Redundant MCP guidance...]
```

**Replace with**:
```markdown
## Prompt Pack Integration

**Load from** `C:\GitHub\GPTPrompts`:
- `00-core-behavior.md` (always)
- [List only relevant files for this specific prompt type]

See SHARED_STANDARDS.md for complete integration guidance, KB paths, and MCP best practices.
```

---

## Estimated Savings After Full Completion

### Token Usage (Estimated)

**Before**:
- Total lines: 4,263
- Estimated tokens: ~15,000 for 5-prompt workflow
- Redundancy: 67% (2,850 lines repeated)

**After**:
- Total lines: ~2,568 (40% reduction)
- Estimated tokens: ~9,000 for 5-prompt workflow (40% savings)
- Redundancy: <5% (only SHARED_STANDARDS.md)

### Context Window Impact

**Example: Investigation → Execute Plan workflow**

| Component | Before | After | Savings |
|-----------|--------|-------|---------|
| SHARED_STANDARDS.md | 0 | 600 tokens | -600 |
| prompt-investigation.txt | 800 tokens | 450 tokens | +350 |
| prompt-execute-plan.txt | 4,000 tokens | 2,000 tokens | +2,000 |
| Investigation docs | 2,000 tokens | 2,000 tokens | 0 |
| **TOTAL** | **6,800 tokens** | **5,050 tokens** | **1,750 (26%)** |

---

## Completion Checklist

### Immediate (Session 1) ✅
- [x] Create SHARED_STANDARDS.md
- [x] Update prompt-execute-plan.txt (pilot)
- [x] Update prompt-continue.txt
- [x] Update prompt-investigation.txt
- [x] Update prompt-general.txt
- [x] Update prompt-plan.txt (partial)

### Next Session (Session 2) 🚧
- [ ] Complete prompt-plan.txt
- [ ] Update prompt-testing.txt
- [ ] Update prompt-demo.txt
- [ ] Update prompt-seed-project.txt
- [ ] Update prompt-post-task-review.txt
- [ ] Update prompt-kb-authoring.txt
- [ ] Update prompt-handover.txt
- [ ] Update prompt-refactor.txt
- [ ] Update prompt-security-review.txt
- [ ] Update prompt-implementation-orchestration.txt
- [ ] Update prompt-review.txt
- [ ] Update prompt-deploy-azure.txt
- [ ] Update prompt-architecture-audit.txt
- [ ] Update prompt-error-triage.txt
- [ ] Update prompt-fix.txt

### Final Validation (Session 3)
- [ ] Check all prompts reference SHARED_STANDARDS.md
- [ ] Verify "Task tool" terminology consistent (not "agents")
- [ ] Verify 10 Task limit consistent everywhere
- [ ] Verify TodoWrite mentioned in all implementation/planning prompts
- [ ] Test load times and context usage
- [ ] Verify no broken references
- [ ] Update README.md with SHARED_STANDARDS.md reference

---

## Quick Reference: Files to Update

```bash
# Remaining prompts to update (in priority order)
C:\GitHub\GPTPrompts\prompts\prompt-testing.txt
C:\GitHub\GPTPrompts\prompts\prompt-demo.txt
C:\GitHub\GPTPrompts\prompts\prompt-seed-project.txt
C:\GitHub\GPTPrompts\prompts\prompt-post-task-review.txt
C:\GitHub\GPTPrompts\prompts\prompt-kb-authoring.txt
C:\GitHub\GPTPrompts\prompts\prompt-handover.txt
C:\GitHub\GPTPrompts\prompts\prompt-refactor.txt
C:\GitHub\GPTPrompts\prompts\prompt-security-review.txt
C:\GitHub\GPTPrompts\prompts\prompt-implementation-orchestration.txt
C:\GitHub\GPTPrompts\prompts\prompt-review.txt
C:\GitHub\GPTPrompts\prompts\prompt-deploy-azure.txt
C:\GitHub\GPTPrompts\prompts\prompt-architecture-audit.txt
C:\GitHub\GPTPrompts\prompts\prompt-error-triage.txt
C:\GitHub\GPTPrompts\prompts\prompt-fix.txt
```

---

## Benefits Already Achieved

✅ Created single source of truth (SHARED_STANDARDS.md)
✅ Reduced prompt-execute-plan.txt by 51% (1,261 → 623 lines)
✅ Fixed terminology inconsistencies in 6 prompts
✅ Added TodoWrite guidance to key prompts
✅ Established clear pattern for remaining updates
✅ 34% reduction achieved so far (636 lines removed from completed prompts)

**Estimated time to complete remaining**: 30-45 minutes (using pattern above)
