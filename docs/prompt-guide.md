# Prompt Usage Guide

Visual guide to pick the right prompt, load the right standards, and understand expected AI responses.

## Quick Selection Map
```mermaid
flowchart TD
    Start([New Task]) --> Plan{Need upfront design?}
    Plan -->|Yes| PPlan[prompts/prompt-plan]
    Plan -->|No| Build{Coding change?}
    Build -->|Fix bug/error| PFx[prompts/prompt-error-triage + prompt-fix]
    Build -->|Refactor| PRef[prompts/prompt-refactor]
    Build -->|New/continue feature| PCont[prompts/prompt-continue]
    Build -->|Orchestrate plan| PImpl[prompts/prompt-implementation-orchestration]
    Build -->|Security focus| PSec[prompts/prompt-security-review]
    Build -->|No code| Other{Docs/KB/Context?}
    Other -->|Docs/KB| PKB[prompts/prompt-kb-authoring]
    Other -->|Session recovery| PRec[prompts/prompt-project-recovery]
    Other -->|Architecture| PAudit[prompts/prompt-architecture-audit]
    Other -->|General| PGen[prompts/prompt-general]
    PCont --> Review[prompts/prompt-review]
    PImpl --> Review
    PFx --> Review
    PRef --> Review
    Review --> Test[prompts/prompt-testing]
    Review --> PostQ[prompts/prompt-post-task-review]
    Test --> Handover[prompts/prompt-handover]
    PostQ --> Handover
    Build --> Deploy[prompts/prompt-deploy-azure]
    Deploy --> Test
    PRec --> Handover
```

## Bundle Cheat Sheet (see `postfix.md` for details)
- **Always**: `00-core-behavior.md`.
- **UI/Visual**: `01-brand-kit.md` + `02-modality-rules.md` (+`03-quality-guardrails.md` when shipping).
- **Backend/API/CLI/Docs**: `02-modality-rules.md` + `03-quality-guardrails.md` + `07-code-quality.md`; add `04-testing-standards.md` for validation; add `05-security-standards.md` when auth/data sensitive.
- **Planning/Architecture**: `02-modality-rules.md` + `03-quality-guardrails.md` + `06-development-workflow.md` + `10-ai-context-guide.md`; add `07-code-quality.md` for depth; add `05-security-standards.md` when boundaries matter.
- **Implementation/Refactor/Fix**: `02-modality-rules.md` + `03-quality-guardrails.md` + `04-testing-standards.md` + `06-development-workflow.md` + `07-code-quality.md`; add `05-security-standards.md` for sensitive areas; add `01-brand-kit.md` for UI.
- **Recovery/Handover**: `06-development-workflow.md` + `10-ai-context-guide.md` + feature docs under `docs/implementation/current/`.

## Flow Examples

### Bug/Error Fix
```mermaid
sequenceDiagram
    participant User
    participant AI
    User->>AI: Prompt with prompt-error-triage.txt<br/>(error message, context)
    AI->>AI: Capture error, minimal repro, trace, root cause
    AI->>User: Triage report (cause, fix plan, evidence)
    User->>AI: Prompt with prompt-fix.txt<br/>(loaded standards)
    AI->>AI: Apply minimal fix, add targeted test/log
    AI->>User: Summary + evidence + risks
```

### Project Recovery After Interruption
```mermaid
flowchart LR
    Start([Lost Context]) --> Docs[Read docs/implementation/REGISTER.md<br/>+ current feature INDEX]
    Docs --> Handover[Read ai-handover.md / ai-memory.md / checklist.md / issues*.md]
    Handover --> Git[Check git status and recent commits]
    Git --> State[Determine phase + active tasks]
    State --> Next[List next 3 steps]
    Next --> Update[Update ai-handover.md + checklist.md]
```

### Architecture / Microservice Audit
```mermaid
flowchart TD
    drivers["Drivers and constraints"] --> map["Domains and integrations"]
    map --> hotspots["Hotspots (churn, incidents, perf)"]
    hotspots --> seams["Refactor seams: ports, adapters, boundaries"]
    seams --> services["Microservice candidates: domain, data, API, migration"]
    services --> roadmap["Sequenced plan and guardrails"]
```

## Expected Response Styles
- **prompt-review.txt:** Findings first, ordered by severity, each with `file:line`, impact, and fix/test suggestion. Short next steps.
- **prompt-fix.txt:** Root cause, smallest fix, evidence from tests/logs, residual risks.
- **prompt-project-recovery.txt:** Session summary with phase, last actions (evidence), uncommitted work, blockers, next 3 steps, confidence.
- **prompt-general.txt:** Restate -> light plan -> execute in small steps -> validate -> summarize with evidence and next actions.

## Knowledge and State Updates
- Search KBs before writing; update the correct KB entry with evidence when new durable knowledge is produced (`C:\GitHub\LearnSD\GeneralKB\KB_GOVERNANCE.md`).
- Keep `ai-memory.md` for persistent context and `ai-handover.md` for session transitions.
- Persist MCP state under `.mcp-state/` per feature when using MCP tools (see `06-development-workflow.md` and `10-ai-context-guide.md`).
