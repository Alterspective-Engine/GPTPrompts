# Deployment Guidelines (Azure-first, Cost-aware)

Opinionated playbook for staging/vnext and production deployments using Azure (with optional local/low-cost dev setups). Tools: `az` CLI, `swa` CLI, `npx supabase` (Postgres), plus IaC where available.

## Environments & Resource Groups
- Prefer one Resource Group (RG) per environment: `rg-<app>-dev`, `rg-<app>-stg`, `rg-<app>-prod`.
- For short-lived preview/vnext, use `rg-<app>-vnext-<suffix>` and tag with `expires_on` to enable cleanup.
- Tag all resources: `env`, `owner`, `cost_center`, `expires_on` (for non-prod), `app`.
- Default regions: choose closest to users; align across services to reduce egress.

## Service Selection (cost-aware)
- Static/front-end: Azure Static Web Apps (SWA). Use free/standard tiers for dev/staging; production on standard/premium as needed.
- API: Azure App Service (Linux) or Functions for light workloads; containerized workloads via Azure Container Apps. Prefer consumption/serverless for staging to control idle costs.
- Database: Postgres (Flexible Server). For dev/staging, use Burstable tier (B1/B2) with auto-stop if acceptable; enable backups and IP firewall rules.
- Caching/queues: use managed options only when required; otherwise defer to app-layer queues for early stages.
- Secrets/config: Azure Key Vault; avoid storing secrets in app settings or code. Use managed identity where possible.
- Storage/assets: Azure Storage (blob/static website) with lifecycle rules for logs/artifacts.
- Consider local/cheaper dev: Supabase local (`npx supabase start`) or Dockerized Postgres for dev; migrate to Azure Postgres for staging/prod. Document deltas.

## Network/Security
- Restrict ingress: IP allowlists for staging; enable HTTPS-only; set CORS narrowly.
- Use managed identity for intra-Azure auth; avoid embedding keys.
- Apply minimal NSG rules; avoid open SSH/RDP.
- Rotate secrets; never commit them. Check `05-security-standards.md`.

## CI/CD & Deployment Process
1. Plan: confirm target env (staging/vnext/prod), RG, and services.
2. Build: run lint/type/tests before packaging.
3. Provision (if needed):
   - Create RG: `az group create -n rg-<app>-<env> -l <region> --tags ...`
   - SWA: `az staticwebapp create ...` (or deploy from GitHub Actions).
   - API: `az containerapp create ...` or `az functionapp create ...` or `az webapp create ...`
   - Postgres: `az postgres flexible-server create ...` with firewall rules.
   - Key Vault: `az keyvault create ...`
4. Configure:
   - App settings / connection strings via `az webapp config appsettings set` or Container Apps secrets.
   - SWA environment variables via `swa deploy --env <env> --env-vars ...` or portal API.
   - Set CORS, HTTPS-only, and logging.
5. Deploy:
   - Frontend: `swa deploy --app-location <path> --output-location <dist> --env <env>`
   - API: `az webapp up ...` or `az containerapp update ...`
   - DB migrations: run via app migration tool or `supabase db push` (if using Supabase locally) translated to Azure Postgres migration path.
6. Validate:
   - Health checks (HTTP 200/ready), smoke tests, env-specific config sanity.
   - Run E2E tests (Playwright) against staging/vnext with Postgres backing.
   - Verify logs and metrics (App Insights/Log Analytics if enabled).
7. Promote/cleanup:
   - For vnext, swap routes/slots if used; otherwise update DNS.
   - Clean expired preview resources using `expires_on` tag.

## Cost Controls
- Use lower tiers and auto-pause for non-prod databases where acceptable.
- Enable logging retention limits; apply lifecycle rules to storage.
- Turn off always-on for non-critical staging.
- Delete preview RGs on schedule; enforce via tags + scripts.
- Monitor spend with budgets/alerts (if enabled in subscription).

## Documentation Expectations
- Record deployment commands, parameters, and outcomes in `docs/implementation/current/<feature>/ai-handover.md`.
- Keep connection info, endpoints, and credentials (as secret references) in `ai-memory.md` or appropriate vault references; never in code.
- Update `docs/deployment-guidelines.md` if the process changes; update KB if durable knowledge is discovered (see `C:\GitHub\LearnSD\GeneralKB\KB_GOVERNANCE.md`).

## Quick Command Cheats
- List RGs: `az group list -o table`
- Create RG: `az group create -n rg-<app>-<env> -l <region>`
- SWA deploy: `swa deploy --app-location <src> --output-location <dist> --env <env>`
- Web App deploy (zip): `az webapp up --sku B1 -n <appname> -g rg-<app>-<env>`
- Container App deploy: `az containerapp up -n <name> -g rg-<app>-<env> --source .`
- Postgres create (flexible): `az postgres flexible-server create -n <name> -g rg-<app>-<env> -l <region> --tier Burstable --sku-name Standard_B1ms`
- Set app settings: `az webapp config appsettings set -g <rg> -n <app> --settings KEY=VALUE`
