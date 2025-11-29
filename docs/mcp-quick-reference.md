# MCP Quick Reference Cheatsheet

> **Purpose:** Human-readable quick reference for Model Context Protocol patterns. NOT for AI context loading.
>
> **Full documentation:** See integrated guidance in `00-core-behavior.md`, `05-security-standards.md`, `06-development-workflow.md`, `07-code-quality.md`, `08-multi-agent.md`, and `10-ai-context-guide.md`.

---

## Progressive Disclosure Pattern

**Core Principle:** Don't load all tool/file definitions upfront. Discover incrementally.

### Token Savings

| Approach | Tokens | Result |
|----------|--------|--------|
| Traditional (load all 50 schemas) | 10,000 | Use 2 tools |
| Progressive (explore → load 2) | 130 | Use 2 tools |
| **Savings** | **98.7%** | Same outcome |

### How to Apply

```
1. Explore first
   └─ Use list_directory, search, grep to understand what's available

2. Load on demand
   └─ Read specific files/schemas only when needed

3. Cache discoveries
   └─ Remember what you found; don't re-explore in same session

4. Early exit
   └─ Stop exploring when you have enough context
```

### Example: Codebase Understanding

**❌ Bad (eager loading):**
```
Read all 50 source files → 30,000 tokens → Modify 2 files
```

**✅ Good (progressive):**
```
1. List src/ directory → See 50 files
2. Grep for "authenticate" → Find 3 relevant files
3. Read those 3 files → 2,000 tokens
4. Modify target files

Token savings: 93%
```

---

## Code-First Interaction Template

**Principle:** Write code to call MCP tools instead of direct tool calls.

### Basic Skill Structure

```typescript
/**
 * Higher-level function that composes MCP tool calls.
 * Skills are documented, tested, and reusable across sessions.
 */
async function analyzeDependencyTree(projectPath: string): Promise<AnalysisResult> {
  // 1. Discover available analysis tools
  const tools = await mcpServer.listTools('analysis');

  // 2. Read project structure
  const files = await mcpServer.callTool('list_directory', { path: projectPath });

  // 3. Compose multiple tool calls
  const dependencies = await mcpServer.callTool('parse_dependencies', { files });
  const vulnerabilities = await mcpServer.callTool('scan_vulnerabilities', { dependencies });

  // 4. Return structured result
  return {
    dependencies,
    vulnerabilities,
    summary: generateSummary(dependencies, vulnerabilities)
  };
}
```

### Benefits

- Better error handling
- Composability (combine multiple tools)
- Logging and debugging
- Testability
- Reusability across sessions

### Skill Organization

```
src/skills/
├── analysis/          # Code analysis and quality checking
│   ├── dependency-tree.ts
│   └── code-metrics.ts
├── testing/           # Testing automation and validation
│   ├── test-runner.ts
│   └── coverage-reporter.ts
├── security/          # Security scanning and audit
│   ├── vulnerability-scan.ts
│   └── secret-detection.ts
└── deployment/        # Deployment automation and CI/CD
    ├── build-pipeline.ts
    └── release-manager.ts
```

---

## State Persistence

**Principle:** Save intermediate results to files for resumable multi-session workflows.

### Directory Structure

```
docs/implementation/current/[feature]/
├── .mcp-state/              # MCP execution state
│   ├── session-YYYYMMDD-HHMMSS.json  # Session snapshots
│   ├── tool-results/        # Cached tool outputs
│   └── progress.json        # Execution checkpoint
```

### State File Format

```json
{
  "sessionId": "uuid",
  "timestamp": "2025-11-30T10:15:30Z",
  "lastTool": "scan_vulnerabilities",
  "checkpoint": {
    "phase": "implementation",
    "completedSteps": ["setup", "analysis"],
    "nextStep": "remediation"
  },
  "cachedResults": {
    "scan_vulnerabilities": {
      "result": { "critical": 2, "high": 5 },
      "timestamp": "2025-11-30T10:10:00Z"
    }
  }
}
```

### Rules

- Save state after each significant MCP operation
- Clear stale state older than 7 days
- Document state schema in `technical-design.md`
- Gitignore `.mcp-state/` (unless needed for audit)

---

## Security Checklist

### Sandboxing & Isolation

- [ ] MCP servers run in isolated environments (containers, VMs, sandboxes)
- [ ] Principle of least privilege for file system access
- [ ] Network access restricted to required endpoints only
- [ ] Separate sandboxes for untrusted code execution
- [ ] Resource quotas per MCP server instance

### PII Tokenization Pattern

```typescript
// Before sending to MCP
const sanitized = tokenizePII(userData);
// userData: { name: "John Doe", email: "john@example.com" }
// sanitized: { name: "[USER_123]", email: "[EMAIL_456]" }

const result = await mcpServer.callTool('analyze_user', sanitized);

// After receiving from MCP, detokenize if needed
const detokenized = detokenizePII(result);
```

### Resource Limits

- [ ] Memory limits set (prevent DoS)
- [ ] Timeouts for long-running operations (default: 30-60s)
- [ ] CPU monitoring and termination of runaway processes
- [ ] Rate limiting (per-user and per-server)
- [ ] Alerts on unusual resource consumption

### Secrets Management

- [ ] Never pass secrets as plain text to MCP tools
- [ ] Use secret references: `${SECRET_NAME}` (resolved server-side)
- [ ] Rotate MCP server access tokens (e.g., every 90 days)
- [ ] Audit MCP tool calls for accidental secret exposure
- [ ] Store credentials in secret managers (Vault, AWS Secrets Manager)

### Code Execution Safety

- [ ] Code runs in isolated sandbox
- [ ] Network access disabled or restricted
- [ ] File system access restricted to specific directories
- [ ] Memory and CPU limits enforced
- [ ] Execution timeout set (default: 30s)
- [ ] Static analysis passed
- [ ] Audit log entry created

---

## Multi-Agent Coordination

**Principle:** Parent agent discovers once, shares with all sub-agents.

### Coordination Pattern

```
Parent Agent:
1. Discovers available MCP tools (once)
2. Allocates tools to sub-agents (exclusive or shared)
3. Monitors resource usage and rate limits
4. Aggregates results

Sub-Agent A: Uses MCP tools [tool1, tool2]
Sub-Agent B: Uses MCP tools [tool3, tool4]
Sub-Agent C: Shares access to [tool5] with rate limiting
```

### State Isolation

```
.mcp-state/
├── parent-session.json         # Parent's orchestration state
├── agent-a/
│   └── session.json            # Sub-agent A's isolated state
├── agent-b/
│   └── session.json            # Sub-agent B's isolated state
└── agent-c/
    └── session.json            # Sub-agent C's isolated state
```

**Rules:**
- Each sub-agent gets isolated state directory
- Parent merges state snapshots after all agents complete
- Avoid concurrent writes to same MCP state file

### Token Budget

```
Parent discovery: ~100-200 tokens (once)
Per-agent briefing: ~50-100 tokens each
Savings vs. independent discovery: (N-1) × discovery_cost

Example with 5 agents:
- Traditional: 5 × 200 = 1,000 tokens
- Coordinated: 200 + (5 × 50) = 450 tokens
- Savings: 55%
```

### Rate Limit Budget

```
Total MCP server limit: 50 calls/min
Allocate:
- agent-a: 15 calls/min
- agent-b: 15 calls/min
- agent-c: 10 calls/min
- parent:  10 calls/min (orchestration, retries)
```

---

## Where to Find Detailed Guidance

| Topic | File | Section |
|-------|------|---------|
| **Progressive Disclosure** | `10-ai-context-guide.md` | Progressive Disclosure (MCP Pattern) |
| **Code-First Interaction** | `00-core-behavior.md` | MCP Tool Interaction Principles |
| **Skill Development** | `07-code-quality.md` | MCP Skill Development |
| **Security & Privacy** | `05-security-standards.md` | MCP Security & Privacy |
| **State Persistence** | `06-development-workflow.md` | MCP State Management |
| **Multi-Agent Coordination** | `08-multi-agent.md` | MCP Server Coordination |
| **Planning with MCP** | `prompt-plan.txt` | EXPLORE THE CONTEXT, DESIGN THE SOLUTION |
| **Implementation** | `prompt-continue.txt` | REFLECT BEFORE CONTINUING, IMPLEMENT INCREMENTALLY |
| **KB Authoring** | `prompt-kb-authoring.txt` | Step 10 – MCP Tool Usage Patterns |

---

## Quick Start Examples

### Example 1: Progressive Discovery in Action

```typescript
// Step 1: Explore (minimal tokens)
const servers = await listMCPServers();  // ~10 tokens
// Returns: ['analysis-server', 'security-server', 'testing-server']

// Step 2: Target specific server
const tools = await listTools('security-server');  // ~20 tokens
// Returns: ['scan_vulnerabilities', 'check_secrets', 'audit_permissions']

// Step 3: Load schema for specific tool
const schema = await getToolSchema('scan_vulnerabilities');  // ~100 tokens

// Step 4: Use the tool
const result = await callTool('scan_vulnerabilities', { path: './src' });

// Total: ~130 tokens vs. 10,000 tokens for loading all schemas
```

### Example 2: Resumable Workflow with State

```typescript
// Session 1: Start analysis
const state = {
  sessionId: generateUUID(),
  timestamp: new Date().toISOString(),
  checkpoint: { phase: 'analysis', completedSteps: [], nextStep: 'scan' }
};

const scanResult = await mcpServer.callTool('scan_vulnerabilities', params);
state.cachedResults = { scan_vulnerabilities: scanResult };
state.checkpoint.completedSteps.push('scan');
state.checkpoint.nextStep = 'remediation';

await saveState('.mcp-state/session.json', state);

// Session 2: Resume from state
const state = await loadState('.mcp-state/session.json');
const scanResult = state.cachedResults.scan_vulnerabilities;  // Reuse cached result
// Continue with remediation using cached data
```

### Example 3: Multi-Agent with MCP

```typescript
// Parent discovers once
const mcpTools = await mcpServer.listTools();
const toolSchemas = await Promise.all(
  ['tool1', 'tool2', 'tool3'].map(name => mcpServer.getToolSchema(name))
);

// Parent spawns agents with shared discovery
const agentA = spawnAgent({
  task: 'Security analysis',
  mcpTools: { available: toolSchemas, allocated: ['scan_vulnerabilities'] },
  stateDir: '.mcp-state/agent-a/'
});

const agentB = spawnAgent({
  task: 'Code quality analysis',
  mcpTools: { available: toolSchemas, allocated: ['analyze_complexity'] },
  stateDir: '.mcp-state/agent-b/'
});

// Wait for completion and merge
const [resultA, resultB] = await Promise.all([agentA, agentB]);
const merged = mergeStates([
  loadState('.mcp-state/agent-a/session.json'),
  loadState('.mcp-state/agent-b/session.json')
]);
```

---

## Common Patterns Summary

| Pattern | When to Use | Key Benefit |
|---------|-------------|-------------|
| **Progressive Disclosure** | Always (default) | 98.7% token savings |
| **Code-First Interaction** | Multi-step workflows | Composability, testability |
| **State Persistence** | Multi-session work | Resumability, caching |
| **PII Tokenization** | Handling sensitive data | Privacy protection |
| **Multi-Agent Coordination** | Parallel MCP usage | Prevent conflicts, optimize resources |
| **Resource Budgeting** | High-volume MCP usage | Cost control, rate limit compliance |

---

## Anti-Patterns to Avoid

**❌ Don't:**
- Let sub-agents discover same tools independently (wastes N × discovery tokens)
- Share state files between concurrent sub-agents (race conditions)
- Ignore MCP rate limits (cascading failures)
- Load all tool schemas upfront (defeats progressive disclosure)
- Skip error handling in MCP skill functions
- Persist raw PII in MCP state files

**✅ Do:**
- Centralize discovery in parent agent
- Isolate state directories per sub-agent
- Coordinate MCP access via parent
- Explore tools on-demand, load schemas as needed
- Include comprehensive error handling
- Tokenize PII before sending to MCP servers

---

**Last Updated:** 2025-11-30
**Source:** Anthropic article "Code Execution with MCP" (2025)
**Related:** GPTPrompts repository prompt pack standards
