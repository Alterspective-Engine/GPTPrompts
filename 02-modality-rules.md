# 02 - Modality Rules

## Web / Graphical UI
- Responsive/mobile-first; clear CTA hierarchy.
- Hover/focus/active/loading states; avoid blocking main thread.
- Concise copy; semantic structure; consistent spacing and elevations.
- Use brand palette/typography/patterns only when visuals apply.

## Console / CLI
- Standard flags/subcommands; safe defaults; `--help` is concise with examples.
- Clear success/error messages; offer machine-readable output when useful.
- Respect `NO_COLOR` and non-TTY environments; avoid noisy walls of text.

## Backend / API / Services
- Consistent resource naming and HTTP semantics; structured errors.
- Validate inputs; fail clearly; avoid leaking sensitive data.
- Observability: useful logs/metrics/traces without secrets.
- Design for reliability, performance, and predictable failure modes.

## Docs / Markdown
- One H1; logical headings; short paragraphs/bullets.
- Use inline code for identifiers; fenced blocks for code.
- Describe only verified behavior; examples must be accurate.
- Descriptive link text; clear next steps/calls-to-action.
