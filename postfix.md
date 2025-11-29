# Prompt Postfix (attach to any request)

Use the Alterspective prompt pack in `C:\GitHub\GPTPrompts`.

## Context Loading (Minimal by Default)

**Always load:**
- `00-core-behavior.md`

**Add ONE based on task type:**
| Task | Load |
|------|------|
| UI/Visual | `01-brand-kit.md` + `02-modality-rules.md` |
| API/CLI/Backend | `02-modality-rules.md` |
| Testing | `04-testing-standards.md` |
| Security | `05-security-standards.md` |
| Planning | `06-development-workflow.md` |
| Implementation | `07-code-quality.md` |
| Multi-agent | `08-multi-agent.md` |
| Documentation | `09-documentation-standards.md` |

**Don't pre-load:** KB articles, all standards, operational prompts you're not using.

**For context guidance:** See `10-ai-context-guide.md`.

**MCP patterns:** Integrated throughout standards (see `05-security-standards.md`, `06-development-workflow.md`, `07-code-quality.md`, `08-multi-agent.md`, `10-ai-context-guide.md` for progressive disclosure, state persistence, security, skills, and coordination). Human cheatsheet: `docs/mcp-quick-reference.md`.

## Knowledge Bases (Reference on Demand)
- **Sharedo:** `C:\GitHub\LearnSD\KB` — Entry points: `README.md`, `kb_index.json`
- **General:** `C:\GitHub\LearnSD\GeneralKB` — Follow `KB_GOVERNANCE.md` for updates

## Execution Pattern
1. Restate brief + assumptions
2. Load only relevant rules
3. Execute with bias toward action
4. Summarize results + next steps
