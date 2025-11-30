# Prompt Postfix (attach to any request)

Use the Alterspective prompt pack in `C:\GitHub\GPTPrompts` (operational prompts live in `prompts/`).

## Context Loading (Standard Bundles)
- Always load: `00-core-behavior.md`.
- Pick bundles by task (add only what is relevant; prefer progressive disclosure):
  - UI/Visual build: `01-brand-kit.md` + `02-modality-rules.md` (+`03-quality-guardrails.md` when shipping).
  - Backend/API/CLI/Docs: `02-modality-rules.md` + `03-quality-guardrails.md` + `07-code-quality.md`; add `04-testing-standards.md` when validating; add `05-security-standards.md` for auth/data sensitivity.
  - Planning/Architecture: `02-modality-rules.md` + `03-quality-guardrails.md` + `06-development-workflow.md` + `10-ai-context-guide.md`; add `07-code-quality.md` for technical depth; add `05-security-standards.md` when data/auth boundaries matter.
  - Implementation/Continuation/Refactor/Fix: `02-modality-rules.md` + `03-quality-guardrails.md` + `04-testing-standards.md` + `06-development-workflow.md` + `07-code-quality.md`; add `05-security-standards.md` for sensitive changes; add `01-brand-kit.md` for UI.
  - Testing: `02-modality-rules.md` + `03-quality-guardrails.md` + `04-testing-standards.md`; add `01-brand-kit.md` for UI; add `05-security-standards.md` for security-sensitive validation.
  - Review: `02-modality-rules.md` + `03-quality-guardrails.md` + `04-testing-standards.md` + `07-code-quality.md`; add `05-security-standards.md` for auth/data; add `01-brand-kit.md` for UI.
  - Architecture/Microservices: `02-modality-rules.md` + `03-quality-guardrails.md` + `05-security-standards.md` + `06-development-workflow.md` + `07-code-quality.md`.
  - Recovery/Handover: `06-development-workflow.md` + `10-ai-context-guide.md` + feature docs under `docs/implementation/current/`.
- Do not preload KBs or unrelated standards. For context guidance see `10-ai-context-guide.md`. MCP patterns are also summarized in `docs/mcp-quick-reference.md`.

## Knowledge Bases (Consult, then update when creating durable knowledge)
- **Sharedo:** `C:\GitHub\LearnSD\KB` - Entry points: `README.md`, `kb_index.json`.
- **General:** `C:\GitHub\LearnSD\GeneralKB` - Follow `KB_GOVERNANCE.md` for updates.
- Rules: Search before writing; update or append to the correct article when you produce confirmed, reusable knowledge. Cite evidence, keep metadata complete, and avoid placeholders. If you cannot update (lack evidence/permission), say so explicitly instead of guessing.

## Execution Pattern
1. Restate the brief and assumptions.
2. Load only the relevant bundle above.
3. Execute with progressive discovery; log evidence.
4. Update artifacts: tests/docs/checklists; update KB articles if new durable knowledge; refresh `ai-memory.md`/`ai-handover.md` when pausing.
5. Summarize results and next steps (with file/line references where applicable).
