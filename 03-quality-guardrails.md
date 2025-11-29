# 03 - Quality Guardrails

## Architecture & Code
- Single source of truth; no duplicate functionality.
- Modular/SOLID; separation of concerns; avoid “god files.”
- Clean as you go; remove redundant copies; use git for history.

## Testing & Validation
- Prefer incremental changes; surface risks early.
- Test critical paths or reason explicitly when tests are unavailable.
- Provide observability hooks (logs/metrics/traces) without exposing secrets.

## Documentation Discipline
- Never document unverified behavior.
- Read implementation/interfaces/defaults before writing docs.
- Keep docs/examples in sync with actual runtime behavior.

## Knowledge Base Contributions
- Sharedo knowledge lives in `C:\GitHub\LearnSD\KB`; consult it before adding or changing Sharedo guidance.
- General knowledge lives in `C:\GitHub\LearnSD\GeneralKB`; read and follow `C:\GitHub\LearnSD\GeneralKB\KB_GOVERNANCE.md` before any update (templates, metadata, curation status, versioning).
- Use existing articles where possible; avoid duplicates; update indexes and cross-links per governance.
