# GPT Prompts Index

Location: `C:\GitHub\GPTPrompts`

## Core Prompt Pack
- `00-core-behavior.md` — identity, ethics, interaction pattern, calibrated autonomy.
- `01-brand-kit.md` — Alterspective palette, typography, patterns, logos, enhancements.
- `02-modality-rules.md` — web/GUI, CLI, backend/API, docs rules.
- `03-quality-guardrails.md` — architecture, testing, documentation discipline.
- `04-testing-standards.md` — testing ethics, anti-optimism guardrails, evidence requirements.
- `05-security-standards.md` — input validation, auth patterns, secrets handling, OWASP prevention.
- `06-development-workflow.md` — planning/implementing/testing/completion phases, AI handover.
- `07-code-quality.md` — SOLID principles, file size limits, TypeScript standards, naming.
- `08-multi-agent.md` — sub-agent orchestration, governance rules, coordination patterns.
- `09-documentation-standards.md` — docs folder structure, taxonomy, INDEX files, registers.
- `10-ai-context-guide.md` — smart document loading, task matrix, reasoning effort, context management.
- `postfix.md` — postfix snippet to attach to any prompt to load the right files.

## Operational Prompts
- `prompt-plan.txt` — comprehensive planning with options, architecture, and task breakdown.
- `prompt-seed-project.txt` — bootstrap new repos with standards, configs, and AI references.
- `prompt-continue.txt` — continue implementation with sub-agent orchestration and quality checks.
- `prompt-handover.txt` — AI session handover with context preservation and next steps.
- `prompt-review.txt` — code review for bugs, TypeScript, ESLint, SOLID violations.
- `prompt-testing.txt` — comprehensive QA/UX testing runner with artifact structure.
- `prompt-fix.txt` — targeted bug-fixing workflow with root-cause analysis and verification.
- `prompt-refactor.txt` — code improvement without behavior change; SOLID focus.
- `prompt-security-review.txt` — security-focused review; OWASP, auth, injection, secrets.
- `prompt-general.txt` — minimal postfix for general tasks (loads core pack only).
- `prompt-kb-authoring.txt` — KB research and authoring workflow with governance compliance.

## Usage
Include `00-core-behavior.md` and then only the relevant files for the task:
- **Visual/UI work**: add `01-brand-kit.md` and `02-modality-rules.md`.
- **CLI/backends/docs**: add `02-modality-rules.md`.
- **Quality/shipping**: add `03-quality-guardrails.md`.
- **Development workflow**: add `06-development-workflow.md` for phased development.
- **Code quality**: add `07-code-quality.md` for SOLID, file size, and TypeScript standards.
- **Multi-agent work**: add `08-multi-agent.md` for sub-agent orchestration and governance.
- **Documentation**: add `09-documentation-standards.md` for docs structure and navigation.
- **Planning**: use `prompt-plan.txt` for complex features needing upfront design.
- **New project**: use `prompt-seed-project.txt` to bootstrap repos with standards.
- **Testing**: add `04-testing-standards.md` and use `prompt-testing.txt` to initiate.
- **Security work**: add `05-security-standards.md`; use `prompt-security-review.txt` for audits.
- **Review**: use `prompt-review.txt` after implementation.
- **Refactoring**: use `prompt-refactor.txt` for code improvement without behavior change.
- **Continuation**: use `prompt-continue.txt` when extending or completing multi-step implementations.
- **Session handover**: use `prompt-handover.txt` when ending sessions or approaching context limits.
- **Bug fixing**: use `prompt-fix.txt` for isolating and fixing specific bugs with root-cause analysis.
- **KB authoring**: use `prompt-kb-authoring.txt` when creating or updating knowledge base articles.
- **General tasks**: use `prompt-general.txt` for simple tasks needing only core behavior.
- **Context management**: see `10-ai-context-guide.md` for task→document matrix and loading guidance.
- **MCP patterns**: MCP (Model Context Protocol) guidance is integrated throughout core standards (progressive disclosure in `10-ai-context-guide.md`, security in `05-security-standards.md`, skills in `07-code-quality.md`, state persistence in `06-development-workflow.md`, multi-agent coordination in `08-multi-agent.md`). Human-readable cheatsheet: `docs/mcp-quick-reference.md`.

Provide file paths verbatim so the AI can load them.

## Knowledge Bases to Consult
- Sharedo knowledge: `C:\GitHub\LearnSD\KB` (primary source for Sharedo work). Entry points: `C:\GitHub\LearnSD\KB\README.md` and `C:\GitHub\LearnSD\KB\kb_index.json`.
- General knowledge: `C:\GitHub\LearnSD\GeneralKB` (non-Sharedo). Before adding/updating, read `C:\GitHub\LearnSD\GeneralKB\KB_GOVERNANCE.md` and follow its rules/templates.
