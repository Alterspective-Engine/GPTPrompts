# ngrok & Port Registry Guidelines

Use these rules whenever exposing services during development/testing.

## Domain Naming (alterspective.io)
- Default: `{service}.alterspective.io`.
- Multi-surface apps: `{service}_{type}.alterspective.io` (e.g., `myapp_backend.alterspective.io`, `myapp_frontend.alterspective.io`, `myapp_mcp.alterspective.io`).
- Reserve domains in the ngrok dashboard before use; avoid ad-hoc subdomains.

## Port Allocation
- Reserve contiguous 100-port blocks per app to avoid conflicts (e.g., app A: 3300–3399, app B: 3400–3499).
- Suggested offsets in a block:
  - Frontend: base (e.g., 3300)
  - Backend/API: base + 10 (e.g., 3310)
  - Worker/MCP: base + 20 (e.g., 3320)
  - Extras: base + 40 (e.g., 3340) as needed
- Before binding, check the registry; if free, claim and record it. To free a port locally, use `killPort <portNumber>` (or OS equivalent).

## Registration
- For every tunnel, record: service, env (dev/stage), port, domain, owner, purpose.
- Link to the start script (e.g., `scripts/start-ngrok.js`) and note expiry/cleanup for temporary tunnels.
- Update the ngrok/port registry in `C:\GitHub\LearnSD\GeneralKB\Internal\Systems\Ngrok\KB-INT-SYS-001-Ngrok-Configuration.md`.

## Usage in Projects
- When spinning up services (frontend/backend/MCP/etc.), allocate from your app’s 100-port block and expose via ngrok with the domain pattern above.
- Document the chosen domain/port in `ai-handover.md` and `ai-memory.md` for the feature; update the KB registry for long-lived tunnels.
- Respect security: keep secrets out of code, use HTTPS, and treat ngrok as dev-only.
