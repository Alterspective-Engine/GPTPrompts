# Prompts Directory

Authoritative location for operational prompts. Core standards (`00-*.md` .. `10-*.md` and `postfix.md`) stay at repo root.

## Structure
- Files are named `prompt-<domain>.txt` (lowercase, hyphen-separated).
- New prompts should live here unless they are core standards.
- Refer to prompts with full paths (e.g., `C:\GitHub\GPTPrompts\prompts\prompt-plan.txt`).

## Naming Rules
- Prefix with `prompt-`.
- Use short, specific domains (e.g., `plan`, `continue`, `review`, `testing`, `security-review`, `implementation-orchestration`).
- Keep names lowercase; use hyphens to separate words.
- One prompt per concern; avoid overlapping scopes.

## Usage
- Always load `00-core-behavior.md` plus the relevant standards bundle (see `postfix.md`).
- Keep scope tight: restate brief, apply only relevant rules, summarize with evidence.
- Update knowledge bases with evidence when creating durable knowledge; follow `C:\GitHub\LearnSD\GeneralKB\KB_GOVERNANCE.md`.

## Current Prompts
- `prompt-plan.txt`
- `prompt-seed-project.txt`
- `prompt-continue.txt`
- `prompt-handover.txt`
- `prompt-review.txt`
- `prompt-testing.txt`
- `prompt-fix.txt`
- `prompt-refactor.txt`
- `prompt-security-review.txt`
- `prompt-general.txt`
- `prompt-kb-authoring.txt`
- `prompt-error-triage.txt`
- `prompt-project-recovery.txt`
- `prompt-architecture-audit.txt`
- `prompt-implementation-orchestration.txt`
- `prompt-post-task-review.txt`
- `prompt-deploy-azure.txt`
- `prompt-ui-quality.txt`
- `prompt-ngrok-ports.txt`
