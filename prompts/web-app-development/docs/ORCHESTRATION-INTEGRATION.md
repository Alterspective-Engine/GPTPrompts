# Orchestration Integration Guide

**Version**: 1.0
**Date**: 2025-12-29
**Status**: Production Ready

This guide documents how the web-app-development framework integrates with multi-agent orchestration systems.

---

## Overview

The framework supports multiple orchestration approaches:

| Orchestrator | Status | Best For | Integration Level |
|--------------|--------|----------|-------------------|
| **AI-Office** | Production (v1.0.2) | Supervised agent coordination | Full |
| **Claude-Flow** | Experimental | DAG-based workflows | Planned |
| **Claude Squad** | Experimental | Real-time collaboration | Planned |
| **Manual Coordination** | Always Available | Small teams, learning | Built-in |

---

## AI-Office Integration (Primary)

### Installation

```bash
npm install github:alterspective/ai-office#v1.0.2
```

### Configuration

Create `ai-office.config.json` in project root:

```json
{
  "project": {
    "name": "your-project-name",
    "workspaceRoot": ".ai-office",
    "methodology": "alterspective-multi-agent",
    "grounding": {
      "coreValues": "docs/CORE-BEHAVIOR.md",
      "codeQuality": "docs/CODE-QUALITY.md",
      "projectRules": "CLAUDE.md",
      "agentProtocol": "AGENTS.md"
    }
  },
  "supervisor": {
    "heartbeatTimeout": 600000,
    "checkInterval": 30000,
    "maxConcurrentAgents": 3,
    "escalationStrategy": "notify-architect",
    "retryPolicy": {
      "maxRetries": 3,
      "backoffStrategy": "exponential",
      "baseDelay": 2000
    }
  },
  "agents": {
    "frontend": {
      "type": "claude-code",
      "area": "src/areas/frontend",
      "capabilities": ["typescript", "react", "testing"],
      "maxTokenBudget": 100000,
      "boundaries": {
        "canModify": ["src/areas/frontend/**"],
        "canRead": ["src/common/**", "CLAUDE.md", "AGENTS.md"],
        "cannotTouch": ["src/areas/api-service/**", "src/areas/analysis-service/**"]
      }
    },
    "api-service": {
      "type": "claude-code",
      "area": "src/areas/api-service",
      "capabilities": ["typescript", "nodejs", "express", "testing"],
      "maxTokenBudget": 100000,
      "boundaries": {
        "canModify": ["src/areas/api-service/**"],
        "canRead": ["src/common/**", "CLAUDE.md", "AGENTS.md"],
        "cannotTouch": ["src/areas/frontend/**", "src/areas/analysis-service/**"]
      }
    }
  },
  "coordination": {
    "stateSchema": "src/common/coordination/task-state.schema.json",
    "coordinationFile": "worktrees/coordination.json",
    "locksDirectory": "worktrees/locks"
  },
  "qualityGates": {
    "enforcePreQA": true,
    "minimumTestCoverage": 80,
    "securityChecks": ["no-hardcoded-secrets", "input-validation"],
    "accessibilityChecks": ["form-labels", "keyboard-navigation"]
  },
  "worktrees": {
    "enabled": true,
    "container": "../worktrees",
    "branchPattern": "feature/{agent-id}-agent"
  }
}
```

### Starting the Supervisor

```bash
# Initialize AI-Office
npx ai-office init

# Start supervisor (runs main event loop)
npx ai-office start

# Submit a job
npx ai-office submit --agent frontend --instruction "Implement FEAT-001 login component"

# Monitor status
npx ai-office status
```

### Integration Points

The framework provides these integration points for AI-Office:

1. **Structured State Schemas** (`schemas/`)
   - `task-state.schema.json` - Individual task state
   - `coordination-state.schema.json` - Global coordination state
   - `file-lock.schema.json` - File lock records

2. **Phase Validators** (`13-phase-validator.txt`)
   - Can be called as job validation step
   - Returns PASS/FAIL with blockers list

3. **File Locks** (`16-file-lock-protocol.txt`)
   - Lock acquisition before file modification
   - Lock release after commit
   - Expiry and override handling

4. **Completion Signals**
   - Outbox pattern for task completion
   - AI-Office monitors agent outbox folders

---

## Git Worktree Integration

### Setup (Architect runs once)

```bash
# From project root
mkdir -p ../worktrees/locks

# Create worktrees for each agent
git worktree add ../worktrees/ai-frontend feature/frontend-agent
git worktree add ../worktrees/ai-api feature/api-agent
git worktree add ../worktrees/ai-analysis feature/analysis-agent

# Initialize coordination state
cat > ../worktrees/coordination.json << 'EOF'
{
  "projectId": "your-project",
  "version": "1.0.0",
  "lastUpdated": "2025-12-29T00:00:00Z",
  "phases": { "current": 0 },
  "agents": {},
  "tasks": [],
  "locks": [],
  "features": [],
  "escalations": []
}
EOF
```

### Agent Workflow

Each agent works in their assigned worktree:

```bash
# Agent-Frontend workflow
cd ../worktrees/ai-frontend

# Sync before work
git fetch origin
git rebase origin/main

# Work on assigned task
# ... implement feature ...

# Commit with task reference
git add .
git commit -m "feat(FEAT-001): Implement login component

Task: TASK-20251229-ABC12345
Agent: agent-frontend"

# Update coordination state
# ... update ../worktrees/coordination.json with status: "review" ...
```

### Merging Protocol (Architect Only)

```bash
# Switch to main
cd main
git checkout main

# Merge agent's work
git merge feature/frontend-agent

# If conflicts, resolve manually
# ...

# Push to remote
git push origin main

# Update coordination state
# ... set task status to "completed" ...

# Notify dependent agents
# ... (AI-Office handles this automatically)
```

---

## Prompt Integration

### Modified Prompts

These prompts have been updated for orchestration support:

| Prompt | Changes |
|--------|---------|
| `00-seed-repository` | Creates coordination folder, schemas, config |
| `05-developer-agent` | Lock acquisition, state updates, boundary checks |
| `08-architect-review` | Lock release, merge coordination |
| `13-phase-validator` | Reads/validates coordination state |
| `15-implementation-orchestrator` | Uses JSON state instead of markdown |

### Calling Phase Validator from AI-Office

```javascript
// In AI-Office job queue
const job = {
  id: "JOB-20251229-VALIDATE",
  type: "phase-validator",
  params: {
    currentPhase: 2,
    targetPhase: 3,
    feature: "FEAT-001"
  }
};

// Agent runs prompt 13 with these params
// Returns: { status: "PASS" | "FAIL", blockers: [...] }
```

---

## Claude-Flow Integration (Planned)

Claude-Flow uses DAG-based orchestration. Future integration will:

1. **Wrap prompts as DAG nodes**
   - Each prompt becomes a node with inputs/outputs
   - Dependencies defined in graph edges

2. **Use coordination.json for state**
   - Same state schema works with Claude-Flow
   - Nodes read/write to coordination file

3. **Phase gates as validation nodes**
   - 13-phase-validator runs as validation step
   - Blocks downstream nodes on failure

### Example DAG Definition (Future)

```yaml
# claude-flow.yaml
nodes:
  - id: seed
    prompt: 00-seed-repository.txt
    outputs: [CLAUDE.md, AGENTS.md]

  - id: architecture
    prompt: 02-architecture-design.txt
    depends_on: [seed]
    gate: 13-phase-validator (0→1)

  - id: frontend-impl
    prompt: 05-developer-agent.txt
    area: frontend
    depends_on: [architecture]
    parallel_with: [api-impl]

  - id: api-impl
    prompt: 05-developer-agent.txt
    area: api-service
    depends_on: [architecture]
    parallel_with: [frontend-impl]

  - id: qa-review
    prompt: 07-qa-review.txt
    depends_on: [frontend-impl, api-impl]
    gate: 13-phase-validator (3→4)
```

---

## Claude Squad Integration (Planned)

Claude Squad enables real-time agent collaboration. Future integration will:

1. **Shared memory protocol**
   - Agents share context through memory blocks
   - Reduces context passing overhead

2. **Lock-free coordination**
   - Real-time conflict detection
   - Automatic resolution suggestions

3. **Live handoffs**
   - Agent A can hand task to Agent B mid-work
   - Seamless context transfer

---

## Seeding with Orchestration

When running `00-seed-repository.txt` with orchestration enabled:

### Created Files

```
project/
├── CLAUDE.md                           # Project rules
├── AGENTS.md                           # Agent boundaries
├── ai-office.config.json               # Orchestration config
├── src/
│   └── common/
│       └── coordination/
│           ├── task-state.schema.json  # Task schema
│           ├── coordination-state.schema.json
│           └── file-lock.schema.json
├── .ai-office/                         # Runtime (gitignored)
│   ├── queue/
│   │   ├── pending/
│   │   └── completed/
│   └── agents/
└── .gitignore                          # Excludes .ai-office/
```

### Continue Scripts

Seeded `continue.bat` and `continue.ps1` that:

1. Read `coordination.json` for current state
2. Identify incomplete tasks
3. Recommend next prompt to run
4. Check for lock conflicts
5. Display agent status

---

## Troubleshooting

### Common Issues

| Issue | Cause | Solution |
|-------|-------|----------|
| Lock conflict | Two agents need same file | Escalate to Architect |
| Stale heartbeat | Agent crashed or stuck | Check agent process, restart |
| Merge conflict | Parallel edits | Architect resolves manually |
| Phase validation fails | Missing artifacts | Read blockers, create missing items |
| Coordination state corrupt | Race condition | Restore from git, re-run jobs |

### Debug Mode

```bash
# Enable debug logging
DEBUG=ai-office:* npx ai-office start

# Check specific agent
npx ai-office doctor --agent frontend

# List all locks
ls -la ../worktrees/locks/

# View coordination state
cat ../worktrees/coordination.json | jq .
```

---

## Best Practices

1. **Start Small**: Use manual coordination first, add AI-Office when stable
2. **Clear Boundaries**: Ensure AGENTS.md boundaries are non-overlapping
3. **Frequent Commits**: Small commits reduce merge conflicts
4. **Monitor Tokens**: Track token usage to optimize costs
5. **Escalate Early**: Don't let agents spin on conflicts
6. **Regular Syncs**: Agents should rebase from main frequently
7. **Clean Locks**: Remove stale locks during housekeeping

---

## References

- [AI-Office Repository](https://github.com/alterspective/ai-office)
- [16-file-lock-protocol.txt](../16-file-lock-protocol.txt)
- [13-phase-validator.txt](../13-phase-validator.txt)
- [Schemas](../schemas/)
- [IMPROVEMENT-PLAN.md](../IMPROVEMENT-PLAN.md) - Phase 6 details
