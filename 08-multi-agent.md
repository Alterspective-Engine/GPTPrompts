# 08 - Multi-Agent Orchestration

Rules for spawning, coordinating, and governing sub-agents in complex tasks.

## When to Use Sub-Agents

**Good candidates:**
- Parallel independent tasks (e.g., reviewing multiple files simultaneously)
- Specialized checks (security review, accessibility audit, performance analysis)
- Cross-cutting concerns that don't block each other
- Large refactoring across many files
- Comprehensive testing with different focus areas

**Avoid sub-agents when:**
- Tasks have sequential dependencies
- Context sharing is critical (sub-agents have isolated context)
- Simple tasks that don't benefit from parallelization
- Coordination overhead exceeds time saved

## Agent Limits

- **Maximum:** 10 sub-agents per orchestration
- **Recommended:** 3-5 for most tasks (easier coordination)
- **Minimum viable:** Use sub-agents only when 2+ independent tasks exist

## Governance Rules

### All Sub-Agents Must:
1. **Follow the same prompt pack rules** — Load relevant standards from `C:\GitHub\GPTPrompts`
2. **Operate within defined scope** — No drift beyond assigned task
3. **Report findings consistently** — Use standardized output formats
4. **Respect boundaries** — Don't modify files outside their scope
5. **Surface blockers immediately** — Don't silently fail

### Parent Agent Must:
1. **Define clear scope for each sub-agent** — Explicit boundaries
2. **Specify expected outputs** — What format, what content
3. **Set success criteria** — How to know task is complete
4. **Coordinate results** — Merge findings, resolve conflicts
5. **Handle failures** — Retry logic, fallback strategies

## Sub-Agent Briefing Template

When spawning a sub-agent, provide:

```
## Task
[Specific, bounded task description]

## Scope
**Files:** [Which files/folders to work on]
**Boundaries:** [What NOT to touch]

## Standards
Load from C:\GitHub\GPTPrompts:
- 00-core-behavior.md (always)
- [Other relevant standards]

## Expected Output
[Exact format and content expected]

## Success Criteria
[How to know the task is complete]

## Constraints
- [Time/effort limits if any]
- [Dependencies or blockers to note]
```

## Common Agent Roles

### Code Quality Agents
| Agent | Focus | Standards |
|-------|-------|-----------|
| TypeScript Checker | Type errors, strict mode violations | 07-code-quality.md |
| ESLint Agent | Linting rules, code style | 07-code-quality.md |
| SOLID Reviewer | Design principles, coupling | 07-code-quality.md |
| Security Auditor | Vulnerabilities, OWASP | 05-security-standards.md |

### Testing Agents
| Agent | Focus | Standards |
|-------|-------|-----------|
| E2E Tester | User flow validation | 04-testing-standards.md |
| API Tester | Endpoint contracts, responses | 04-testing-standards.md |
| Accessibility Checker | WCAG, keyboard nav, ARIA | 01-brand-kit.md |
| Performance Profiler | Load times, bundle size | 03-quality-guardrails.md |

### Documentation Agents
| Agent | Focus | Standards |
|-------|-------|-----------|
| Doc Validator | Accuracy vs. implementation | 03-quality-guardrails.md |
| KB Contributor | Extract reusable knowledge | prompt-kb-authoring.txt |

## Coordination Patterns

### Pattern 1: Fan-Out / Fan-In
```
Parent spawns N agents → Each works independently → Parent merges results

Use for: Code review, multi-file refactoring, comprehensive testing
```

### Pattern 2: Pipeline
```
Agent A completes → Output feeds Agent B → Output feeds Agent C

Use for: Sequential validation (lint → type-check → test → security)
```

### Pattern 3: Specialist Teams
```
UI Agent + API Agent + DB Agent work in parallel on different layers

Use for: Full-stack feature implementation
```

## Output Consolidation

Sub-agents should return structured results:

```markdown
## Agent: [Role Name]
**Scope:** [What was checked]
**Status:** Pass / Fail / Partial

### Findings
| Severity | Location | Issue | Recommendation |
|----------|----------|-------|----------------|
| High | file.ts:45 | [Issue] | [Fix] |
| Medium | file.ts:120 | [Issue] | [Fix] |

### Summary
- Checked: X items
- Issues: Y found
- Blockers: [Any critical issues]
```

Parent agent consolidates into single report.

## Error Handling

### Sub-Agent Failures
- **Timeout:** Set reasonable limits; retry once; then report partial results
- **Scope creep:** Reject results outside defined boundaries
- **Conflicting findings:** Parent agent resolves; document decision
- **Missing context:** Sub-agent should ask rather than assume

### Conflict Resolution
When sub-agents report conflicting recommendations:
1. Prefer higher-severity findings
2. Prefer findings with evidence over assumptions
3. Defer architectural decisions to parent agent
4. Document conflicts in final report

## Anti-Patterns

**Don't:**
- Spawn agents for trivially small tasks
- Let sub-agents make architectural decisions
- Skip result validation from sub-agents
- Spawn agents without clear scope boundaries
- Ignore sub-agent blockers or failures
- Create circular dependencies between agents

**Do:**
- Define explicit scope and outputs
- Use agents for parallelizable work
- Validate and merge results carefully
- Maintain single source of truth (parent decides)
- Document which agent contributed what

## Context Window Considerations

Sub-agents have isolated context:
- They don't see parent's full conversation history
- They need explicit briefing with relevant context
- Keep briefings focused; don't dump entire history
- Reference files directly rather than summarizing
- Use ai-memory.md for context that spans sessions

## Example: Multi-Agent Code Review

```
Parent Agent Orchestration:

1. Spawn TypeScript Agent
   Scope: Check all .ts/.tsx files for type errors
   Output: List of type violations with file:line

2. Spawn ESLint Agent
   Scope: Run linting on src/
   Output: List of lint violations by severity

3. Spawn Security Agent
   Scope: Check for OWASP Top 10 vulnerabilities
   Standards: 05-security-standards.md
   Output: Security findings with risk ratings

4. Spawn SOLID Agent
   Scope: Review architecture for SOLID violations
   Focus: Files over 200 lines, classes with multiple responsibilities
   Output: Design improvement recommendations

5. Parent consolidates:
   - Merge all findings
   - Deduplicate overlapping issues
   - Prioritize by severity
   - Create unified action plan
```

## MCP Server Coordination

When sub-agents use MCP servers:

### Shared MCP Resources
- **Problem:** Multiple agents accessing same MCP server can cause conflicts, rate limiting, and resource contention.
- **Solution:** Coordinate access via parent agent.

**Pattern:**
```
Parent Agent:
1. Discovers available MCP tools
2. Allocates tools to sub-agents (exclusive or shared)
3. Monitors resource usage and rate limits
4. Aggregates results

Sub-Agent A: Uses MCP tools [tool1, tool2]
Sub-Agent B: Uses MCP tools [tool3, tool4]
Sub-Agent C: Shares access to [tool5] with rate limiting
```

**Allocation Strategy:**
- Exclusive allocation for write operations or stateful tools
- Shared allocation for read-only operations with rate limiting
- Parent tracks which agent is using which tool to prevent conflicts

### State Isolation
- Each sub-agent gets isolated state directory to prevent race conditions
- Parent merges state snapshots after all agents complete
- Avoid concurrent writes to same MCP state file

**Directory Structure:**
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

**Parent Merge Logic:**
```typescript
// After all sub-agents complete
const mergedState = {
  sessionId: parentSessionId,
  timestamp: new Date().toISOString(),
  subAgents: [
    { id: 'agent-a', state: readState('.mcp-state/agent-a/session.json') },
    { id: 'agent-b', state: readState('.mcp-state/agent-b/session.json') },
    { id: 'agent-c', state: readState('.mcp-state/agent-c/session.json') }
  ],
  consolidatedResults: mergeResults(...)
};
```

### MCP Tool Discovery
- **Parent agent discovers tools once** to avoid redundant token usage
- Shares tool schemas with sub-agents via briefing
- Sub-agents don't re-discover (avoids N × discovery_cost token waste)

**Briefing Template Addition:**
```markdown
## MCP Tools Available
**Server:** [server-name]
**Tools Assigned:** [tool1, tool2, tool3]
**Tool Schemas:** [link to cached schema file or inline]
**Rate Limits:** [X calls per minute]
**State Directory:** `.mcp-state/[agent-name]/`

## MCP Usage Rules
- Save state after each tool call
- Respect rate limits (max X calls/min)
- Report tool failures immediately
- Cache tool results in your state directory
```

**Example Parent Discovery:**
```typescript
// Parent discovers once
const mcpTools = await mcpServer.listTools();
const toolSchemas = await Promise.all(
  ['tool1', 'tool2', 'tool3'].map(name => mcpServer.getToolSchema(name))
);

// Parent shares in briefing
const briefing = {
  task: '...',
  mcpTools: {
    available: toolSchemas,
    allocated: ['tool1', 'tool2'],
    stateDir: '.mcp-state/agent-a/'
  }
};
```

### Error Handling
- **MCP server failures** should surface to parent immediately (don't silently fail)
- Parent retries with backoff or reassigns work to different agent
- Document MCP failures in consolidated report with context

**Failure Scenarios:**
| Scenario | Parent Action | Communication |
|----------|---------------|---------------|
| Tool timeout | Retry once with longer timeout | Log in consolidated report |
| Rate limit hit | Queue request, retry after delay | Coordinate across agents |
| Auth failure | Refresh credentials, retry | Alert user if persists |
| Tool unavailable | Reassign to agent with alternative tool | Document in final report |

**Error Reporting Format:**
```markdown
### MCP Errors Encountered
| Agent | Tool | Error | Resolution | Impact |
|-------|------|-------|------------|--------|
| agent-a | scan_vulnerabilities | Timeout after 30s | Retried with 60s timeout, succeeded | Delayed by 1min |
| agent-b | analyze_code | Rate limit (10/min) | Queued, retried after 60s | Delayed by 1min |
```

### Coordination Anti-Patterns

**Don't:**
- Let sub-agents each discover same tools independently (wastes N × discovery tokens)
- Share state files between concurrent sub-agents (causes race conditions)
- Ignore MCP rate limits (leads to cascading failures)
- Let sub-agents retry MCP failures indefinitely (wastes resources)
- Skip documenting MCP tool allocation in briefing

**Do:**
- Centralize discovery in parent agent (discovers once, shares with all)
- Isolate state directories per sub-agent
- Coordinate MCP access via parent (rate limiting, queueing)
- Set retry limits (e.g., max 2 retries, then escalate to parent)
- Document which agent used which MCP tools in final report

### Multi-Agent MCP Example

```markdown
Parent Agent Orchestration with MCP:

1. Parent discovers MCP tools
   - Lists available tools from analysis-server
   - Caches tool schemas
   - Allocates tools to sub-agents

2. Spawn Security Analyzer (agent-a)
   Task: Scan for vulnerabilities in src/
   MCP Tools: ['scan_vulnerabilities', 'check_dependencies']
   State Dir: .mcp-state/agent-a/
   Rate Limit: 10 calls/min

3. Spawn Code Quality Analyzer (agent-b)
   Task: Analyze code metrics and complexity
   MCP Tools: ['analyze_complexity', 'check_duplication']
   State Dir: .mcp-state/agent-b/
   Rate Limit: 15 calls/min

4. Spawn Documentation Analyzer (agent-c)
   Task: Validate docs accuracy vs. implementation
   MCP Tools: ['extract_signatures', 'compare_docs']
   State Dir: .mcp-state/agent-c/
   Rate Limit: 5 calls/min

5. Parent monitors progress
   - Tracks MCP tool usage across all agents
   - Enforces rate limits globally
   - Handles MCP failures (retries, reassignment)

6. Parent consolidates results
   - Merges MCP state from all agents
   - Deduplicates findings across tool outputs
   - Creates unified report with MCP tool attribution
```

### Resource Budget Management

When coordinating multiple agents with MCP:

**Token Budget:**
- Parent discovery: ~100-200 tokens (once)
- Per-agent briefing: ~50-100 tokens each
- Savings vs. independent discovery: (N-1) × discovery_cost

**Rate Limit Budget:**
```
Total MCP server limit: 50 calls/min
Allocate:
- agent-a: 15 calls/min
- agent-b: 15 calls/min
- agent-c: 10 calls/min
- parent:  10 calls/min (orchestration, retries)
```

**Time Budget:**
- Set per-agent timeouts: 5-10 minutes
- Set total orchestration timeout: 30 minutes
- Account for MCP tool latency in planning
