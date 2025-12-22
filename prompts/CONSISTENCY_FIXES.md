# Prompt Collection Consistency Fixes

**Created**: 2025-12-20
**Priority**: HIGH
**Estimated Effort**: 2-3 hours

---

## Issues Summary

### 1. Context Window Risk
- **prompt-execute-plan.txt**: 1,261 lines (~4,000 tokens)
- **Risk**: Consuming 2% of 200K window before work begins
- **Impact**: Could hit limits with large codebases + multiple Task outputs

### 2. Terminology Inconsistency
- Mixed use of "agents", "sub-agents", "Task tool"
- Inconsistent limits (10 vs 20)
- Confuses AI about capabilities

### 3. Redundancy
- ~2,850 lines of repeated content across 19 prompts
- 67% of total content is redundant
- "Prompt Pack Integration" section repeated 19 times

### 4. Missing TodoWrite
- Critical tool not mentioned in most prompts
- Inconsistent progress tracking guidance

---

## Recommended Solution: Option B (Shared Standards Doc)

### Phase 1: Create Shared Doc

**Action**: Create `prompts/SHARED_STANDARDS.md`

**Content** (estimated 200 lines):
```markdown
# Shared Standards for All Prompts

## Tool Standards

### Task Tool Usage
- **Purpose**: Spawn independent sub-tasks for parallel execution
- **Limit**: Maximum 10 concurrent Task tool calls per message
- **Subagent types**:
  - "general-purpose" (default for build/review/test/fix)
  - "Explore" (codebase search, architecture understanding)
- **Parallel execution**: Spawn independent tasks in SINGLE message with multiple Task calls
- **Terminology**: Use "Task tool" consistently (not "agents" or "sub-agents")

### TodoWrite Tool Usage (MANDATORY)
- **When**: ALL implementation/planning/execution prompts
- **Pattern**:
  1. Create todos at task start
  2. Mark one "in_progress" before starting
  3. Mark "completed" immediately after finishing
- **Update frequency**: After every significant step/wave

## Prompt Pack Integration

Use the Alterspective prompt pack in `C:\GitHub\GPTPrompts`.

**Core Load (Always)**:
- `00-core-behavior.md`

**Bundle Selection** (load ONLY relevant files):
- CLI/backends/docs: `02-modality-rules.md`
- UI/visual: `01-brand-kit.md` + `02-modality-rules.md`
- Quality/shipping: `03-quality-guardrails.md`
- Testing: `04-testing-standards.md`
- Security: `05-security-standards.md`
- Workflow/context: `06-development-workflow.md`, `10-ai-context-guide.md`
- Code quality: `07-code-quality.md`
- Multi-agent: `08-multi-agent.md`
- Documentation: `09-documentation-standards.md`

## Knowledge Bases

- **Sharedo**: `C:\GitHub\LearnSD\KB`
  - Entry points: `README.md`, `kb_index.json`
- **General**: `C:\GitHub\LearnSD\GeneralKB`
- **Governance**: Read `C:\GitHub\LearnSD\GeneralKB\KB_GOVERNANCE.md` before updates

**Before updating**: Follow governance rules, cite evidence.

## MCP + Code Execution

**Best Practices**:
- Discover tools on demand (filesystem/search); load only needed
- Keep intermediate data in execution environment
- Filter/aggregate before returning to model
- Tokenize PII; keep sensitive data out of context
- Persist reusable scripts/state to disk
- Respect sandbox/resource limits

## Context Window Management

**200K token budget management**:
- Consolidate results: summary only for successful tasks
- Use file:line references, not full content
- Progressive documentation: write to disk frequently
- Wave size limits: max 4 tasks per parallel wave
- Selective detail: full output only for failures/blockers

## Standard Output Format

**All prompts should end with**:
```
## Summary
**Status**: [COMPLETE/BLOCKED/IN_PROGRESS]
**Changes**: [file:line references]
**Evidence**: [test output, checks run]
**Next**: 1) ... 2) ... 3) ...
```

---

**Reference this doc**: At the top of each prompt, include:
```markdown
> **Standards**: See SHARED_STANDARDS.md for tool standards, prompt pack integration, KB paths, MCP guidance, and output formats.
```
```

### Phase 2: Update All Prompts

**Pattern to apply to ALL 19 prompts**:

**Remove** (~150 lines per prompt):
- Full "Prompt Pack Integration" section
- Detailed MCP guidance
- Knowledge base path details
- Redundant tool explanations

**Add** (3 lines at top):
```markdown
> **Standards**: See SHARED_STANDARDS.md for tool standards, prompt pack integration, KB paths, and MCP guidance.

> **Tools Required**: [List specific tools needed, e.g., "Task, TodoWrite, Read, Edit, Bash"]
```

**Result**: Each prompt reduced by ~40-50%

### Phase 3: Fix Specific Prompts

#### 3.1 prompt-execute-plan.txt (1261 → ~600 lines)

**Remove/Externalize**:
- Lines 1128-1225: "Common Mistakes" → Move to separate `EXECUTION_MISTAKES.md`
- Lines 274-336: Full task brief example → Move to `TASK_BRIEF_EXAMPLES.md`
- Lines 492-662: Execution report template → Move to `templates/execution-report-template.md`
- Lines 733-825: Redundant sections (already in SHARED_STANDARDS.md)

**Keep**:
- Core execution pattern (waves, quality gates)
- Failure handling protocols
- Delegation strategy
- Pre-flight checklist

**Result**: ~600 lines (52% reduction)

#### 3.2 prompt-continue.txt (129 → ~70 lines)

**Changes**:
- Line 7: Change "20 sub-agents" → "10 Task tools (see SHARED_STANDARDS.md)"
- Add TodoWrite requirement (new section)
- Remove lines 113-129 (redundant Prompt Pack section)

**Result**: ~70 lines (46% reduction)

#### 3.3 prompt-investigation.txt (245 → ~140 lines)

**Changes**:
- Remove lines 233-245 (redundant)
- Add TodoWrite for tracking investigation steps
- Shorten output template (reference external template)

**Result**: ~140 lines (43% reduction)

#### 3.4 prompt-general.txt (59 lines - ALREADY CONCISE)

**Changes**:
- Add TodoWrite mention for multi-step tasks
- Update line 20: clarify "10 Task tools (max)"
- Remove lines 35-58 (move to SHARED_STANDARDS.md)

**Result**: ~35 lines (41% reduction)

#### 3.5 All Other Prompts

Apply same pattern:
- Reference SHARED_STANDARDS.md at top
- Remove redundant sections
- Ensure TodoWrite mentioned where applicable
- Standardize "Task tool" terminology

---

## Implementation Checklist

### Step 1: Create Foundation
- [ ] Create `prompts/SHARED_STANDARDS.md` with content above
- [ ] Create `prompts/templates/` directory
- [ ] Move execution-report-template.md
- [ ] Create `TASK_BRIEF_EXAMPLES.md`
- [ ] Create `EXECUTION_MISTAKES.md`

### Step 2: Update Core Prompts (High Priority)
- [ ] prompt-execute-plan.txt (reduce to ~600 lines)
- [ ] prompt-continue.txt (fix limit, add TodoWrite)
- [ ] prompt-investigation.txt (reduce redundancy)
- [ ] prompt-general.txt (reduce, clarify)
- [ ] prompt-plan.txt (add TodoWrite)

### Step 3: Update Supporting Prompts
- [ ] prompt-testing.txt
- [ ] prompt-review.txt
- [ ] prompt-fix.txt
- [ ] prompt-refactor.txt
- [ ] prompt-implementation-orchestration.txt
- [ ] prompt-post-task-review.txt
- [ ] prompt-seed-project.txt
- [ ] prompt-handover.txt
- [ ] prompt-kb-authoring.txt
- [ ] prompt-security-review.txt
- [ ] prompt-architecture-audit.txt
- [ ] prompt-error-triage.txt
- [ ] prompt-deploy-azure.txt
- [ ] prompt-demo.txt

### Step 4: Validate
- [ ] Check all prompts reference SHARED_STANDARDS.md
- [ ] Verify "Task tool" terminology consistent (not "agents")
- [ ] Verify 10 Task limit consistent everywhere
- [ ] Verify TodoWrite mentioned in all implementation prompts
- [ ] Test load times and context usage
- [ ] Verify no broken references

---

## Expected Results

### Before
- Total lines: ~4,263
- prompt-execute-plan.txt: 1,261 lines
- Redundancy: ~67%
- Context usage: ~15,000 tokens for 5-prompt workflow
- Terminology: Inconsistent
- TodoWrite: Missing from most prompts

### After
- Total lines: ~2,100 (51% reduction)
- prompt-execute-plan.txt: ~600 lines (52% reduction)
- Redundancy: ~5% (shared doc only)
- Context usage: ~7,500 tokens for 5-prompt workflow (50% savings)
- Terminology: Consistent ("Task tool", 10 max)
- TodoWrite: Integrated everywhere

### Context Window Budget Impact

**Example workflow**: Investigation → Execute Plan

**Before**:
```
prompt-investigation.txt:    ~800 tokens
prompt-execute-plan.txt:   ~4,000 tokens
Investigation docs:        ~2,000 tokens
TOTAL PROMPT OVERHEAD:     ~6,800 tokens (3.4%)
```

**After**:
```
SHARED_STANDARDS.md:         ~600 tokens (loaded once)
prompt-investigation.txt:    ~450 tokens
prompt-execute-plan.txt:   ~1,900 tokens
Investigation docs:        ~2,000 tokens
TOTAL PROMPT OVERHEAD:     ~4,950 tokens (2.5%)
Savings:                    1,850 tokens (27%)
```

---

## Risk Assessment

**Low Risk**:
- ✅ Prompts remain self-contained if SHARED_STANDARDS.md not loaded
- ✅ Backward compatible (old prompts still work)
- ✅ Can rollback easily (version control)

**Medium Risk**:
- ⚠️ Users must remember to load SHARED_STANDARDS.md
- ⚠️ Breaking changes if users have custom prompt modifications

**Mitigation**:
- Add reminder at top of each prompt: "Load SHARED_STANDARDS.md first"
- Document in README.md
- Create test script to validate references

---

## Next Steps

**Immediate** (This Session):
1. Get user approval for Option B approach
2. Create SHARED_STANDARDS.md
3. Update prompt-execute-plan.txt as pilot

**Follow-up** (Next Session):
4. Update remaining high-priority prompts
5. Update supporting prompts
6. Validation and testing

---

## Alternative: If User Prefers Option A

**Minimal changes, keep self-contained**:

1. **prompt-execute-plan.txt only**:
   - Reduce to ~800 lines (36% reduction)
   - Move examples to comments/collapse sections
   - Compress templates

2. **Terminology fixes** (all prompts):
   - Standardize to "Task tool" and "10 max"
   - Update prompt-continue.txt from 20 → 10

3. **Add TodoWrite** (5 prompts):
   - prompt-continue.txt
   - prompt-plan.txt
   - prompt-general.txt
   - prompt-implementation-orchestration.txt
   - prompt-investigation.txt

**Savings**: ~30% reduction, minimal disruption
**Time**: 1 hour instead of 2-3 hours
