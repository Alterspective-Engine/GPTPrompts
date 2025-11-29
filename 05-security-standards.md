# 05 - Security Standards

## Input Validation
- Validate all input at system boundaries (user input, APIs, file uploads).
- Use allowlists over denylists; reject unexpected input.
- Enforce type, length, format, and range constraints.
- Sanitize before use; encode before output.

## Authentication
- Use proven libraries/frameworks; do not roll your own crypto.
- Enforce strong password policies; use bcrypt/argon2 for hashing.
- Implement account lockout and rate limiting on auth endpoints.
- Use MFA for sensitive operations where appropriate.

## Authorization
- Check permissions server-side on every request; never trust client-side checks alone.
- Apply principle of least privilege; default to deny.
- Validate object-level access (IDOR protection).
- Log authorization failures for monitoring.

## Session Management
- Use secure, HttpOnly, SameSite cookies for session tokens.
- Regenerate session IDs on authentication state changes.
- Implement session timeout and idle timeout.
- Invalidate sessions on logout and password change.

## Data Protection
- Encrypt sensitive data at rest and in transit (TLS 1.2+).
- Never log secrets, tokens, passwords, or PII.
- Mask sensitive data in UI and error messages.
- Use environment variables or secret managers for credentials.

## Common Vulnerability Prevention

### Injection
- Use parameterized queries / prepared statements for SQL.
- Use ORM methods that auto-escape; avoid raw queries with user input.
- Validate and sanitize all dynamic command/query construction.

### XSS (Cross-Site Scripting)
- Encode output based on context (HTML, JS, URL, CSS).
- Use Content-Security-Policy headers.
- Avoid innerHTML/dangerouslySetInnerHTML with untrusted data.

### CSRF (Cross-Site Request Forgery)
- Include anti-CSRF tokens on all state-changing requests.
- Verify Origin/Referer headers for sensitive operations.
- Use SameSite cookie attribute.

### Security Misconfiguration
- Disable debug mode and verbose errors in production.
- Remove default credentials and sample files.
- Configure CORS restrictively; avoid wildcard origins.
- Set security headers: X-Frame-Options, X-Content-Type-Options, Strict-Transport-Security.

## Dependency Management
- Regularly scan dependencies for known vulnerabilities.
- Keep dependencies updated; have a process for security patches.
- Review new dependencies before adding; prefer well-maintained packages.

## Secrets Management
- Never commit secrets to version control.
- Use `.gitignore` for env files; use secret scanning in CI.
- Rotate secrets periodically and on suspected compromise.
- Use least-privilege service accounts.

## Logging & Monitoring
- Log security-relevant events: auth failures, access denials, input validation failures.
- Never log sensitive data (passwords, tokens, PII).
- Monitor logs for anomalies; set up alerts for critical events.
- Retain logs per compliance requirements.

## MCP Security & Privacy

When using Model Context Protocol servers:

### Sandboxing & Isolation
- **Run MCP servers in isolated environments** (containers, VMs, sandboxes).
- Apply principle of least privilege for file system access.
- Restrict network access to only required endpoints.
- Use separate sandboxes for untrusted code execution.
- Implement resource quotas per MCP server instance.

### Resource Limits
- **Set memory limits** for MCP server processes to prevent DoS.
- Implement timeouts for long-running operations (default: 30-60s).
- Monitor CPU usage and terminate runaway processes.
- Rate-limit API calls to prevent abuse (both per-user and per-server).
- Track and alert on unusual resource consumption patterns.

### PII & Data Protection
- **Tokenize PII before sending** to MCP servers when possible.
- Replace sensitive data with placeholders: `[USER_123]`, `[EMAIL_456]`, `[PHONE_789]`.
- Filter data in execution environments — sanitize logs and outputs.
- Never persist raw PII in MCP state files (`.mcp-state/`).
- Document what data crosses MCP boundaries in `technical-design.md`.
- Implement data retention policies for MCP state files (e.g., auto-delete after 7 days).

**PII Tokenization Example:**
```typescript
// Before sending to MCP
const sanitized = tokenizePII(userData);
// userData: { name: "John Doe", email: "john@example.com" }
// sanitized: { name: "[USER_123]", email: "[EMAIL_456]" }

const result = await mcpServer.callTool('analyze_user', sanitized);

// After receiving from MCP, detokenize if needed
const detokenized = detokenizePII(result);
```

### Secrets Management
- **Never pass secrets directly** to MCP tools as plain text.
- Use secret references resolved server-side: `${SECRET_NAME}`.
- Rotate MCP server access tokens periodically (e.g., every 90 days).
- Audit MCP tool calls for accidental secret exposure in logs.
- Store MCP credentials in secret managers (HashiCorp Vault, AWS Secrets Manager).
- Revoke compromised credentials immediately and rotate all dependent secrets.

### Monitoring & Auditing
- **Log all MCP tool calls** with timestamps, tool name, and sanitized parameters.
- Monitor for anomalous patterns:
  - Unusual tools being called (tools never used before).
  - High volume of calls (potential abuse or runaway automation).
  - Failed authentication attempts to MCP servers.
  - Tools accessing sensitive data outside normal patterns.
- Set up alerts for security-relevant events:
  - Access to PII-containing tools.
  - Failed authorization checks.
  - Resource limit violations.
- Retain audit logs per compliance requirements (typically 90 days minimum).

**Audit Log Format:**
```json
{
  "timestamp": "2025-11-30T10:15:30Z",
  "mcpServer": "analysis-server",
  "tool": "scan_vulnerabilities",
  "user": "user_id_hash",
  "parameters": "[SANITIZED]",
  "result": "success",
  "duration_ms": 1250
}
```

### Code Execution Safety
- **Validate all code** before execution using static analysis.
- Use static analysis to detect malicious patterns:
  - File system access outside allowed directories.
  - Network calls to unexpected domains.
  - Process spawning or shell command execution.
- Run untrusted code **only in disposable sandboxes** that are destroyed after use.
- Disable network access for code execution unless explicitly required and approved.
- Time-limit code execution (fail-fast on infinite loops, default: 30s).
- Whitelist allowed imports/modules; block dangerous APIs (`eval`, `exec`, `subprocess`).

**Code Execution Checklist:**
- [ ] Code runs in isolated sandbox
- [ ] Network access disabled or restricted
- [ ] File system access restricted to specific directories
- [ ] Memory and CPU limits enforced
- [ ] Execution timeout set
- [ ] Static analysis passed
- [ ] Audit log entry created

### MCP Server Trust Model
- **Verify MCP servers** before deployment:
  - Review source code or use verified/official servers only.
  - Check server provenance and maintainer reputation.
  - Scan server dependencies for vulnerabilities.
- Keep MCP SDKs and servers updated with latest security patches.
- Maintain an inventory of all MCP servers in use (server name, version, purpose, owner).
- Implement a process for emergency server deactivation.

### Compliance Considerations
- Document MCP data flows for compliance reviews (GDPR, HIPAA, etc.).
- Ensure MCP servers meet data residency requirements.
- Include MCP systems in security assessments and penetration tests.
- Maintain vendor risk assessments for third-party MCP servers.
