# 04 - Testing Standards

## Testing Ethics & Integrity
- Never report a test as passing without explicit, verifiable evidence.
- Default to skepticism; assume bugs exist until proven otherwise.
- Partial success is failure; "mostly works" means failed.
- State uncertainty explicitly; "unable to verify" beats false confidence.
- Weight negative findings higher than positive in quality assessments.

## Evidence Requirements
- Every PASS must cite specific proof (log output, screenshot, response body).
- Every behavioral claim must be reproducible with documented steps.
- "No errors observed" is not proof of correctness.
- Correlate failures to specific user actions or test inputs.

## Anti-Optimism Guardrails
- Avoid phrases: "should work," "probably fine," "looks good" without evidence.
- Do not rationalize failures as "edge cases" unless genuinely rare.
- Challenge your own assumptions; actively seek failure modes.
- Prefer false negatives (flagging potential issues) over false positives.
- A released bug is worse than a delayed feature.

## Reporting Standards
- Report incrementally; do not batch findings.
- Use consistent issue severity: Critical > High > Medium > Low.
- Document environment exactly: OS, versions, branch/commit, services.
- Provide reproduction steps that anyone can follow.
- Capture artifacts (screenshots, logs, HAR files) for all non-trivial findings.

## Test Artifact Structure
Persist results in `tests/{DATE_RUN}/` with:
- `consolidated-report.md` - Main findings summary.
- `issues/open/` and `issues/closed/` - Individual issue files.
- `artifacts/` - Screenshots, videos, exports.
- `logs/` - Frontend/backend log captures.
- `test-results/` - Categorized test output (ui-ux, e2e, api, accessibility, performance).
