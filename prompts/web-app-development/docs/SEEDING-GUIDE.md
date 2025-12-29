# Seeding Guide: New Project Setup with 2025 Features

**Version**: 1.0
**Date**: 2025-12-29
**Purpose**: Clear implementation path for seeding new projects with multi-agent coordination

---

## Overview

When running `00-seed-repository.txt` on a new project, the following 2025 cutting-edge features are automatically configured:

| Feature | Created By | Location |
|---------|------------|----------|
| Structured State Schemas | 00-seed-repository | `src/common/coordination/` |
| Git Worktree Structure | 00-seed-repository | `../worktrees/` |
| File Locking Directory | 00-seed-repository | `../worktrees/locks/` |
| Orchestration Config | 00-seed-repository | `ai-office.config.json` |
| Continue Scripts | 00-seed-repository | `continue.bat`, `continue.ps1` |

---

## Quick Start

### 1. Run Seed Repository Prompt

```
Use prompt: 00-seed-repository.txt
Project name: your-project-name
Areas: frontend, api-service, analysis-service
```

### 2. Verify Created Structure

After seeding, your project will have:

```
your-project/
├── CLAUDE.md                           # AI rules (500+ chars)
├── AGENTS.md                           # Multi-agent coordination (800+ chars)
├── ai-office.config.json               # Orchestration configuration
├── continue.bat                        # Windows resume script
├── continue.ps1                        # PowerShell resume script
│
├── src/
│   ├── areas/
│   │   ├── frontend/
│   │   │   └── src/, tests/, implementation/
│   │   ├── api-service/
│   │   │   └── src/, tests/, implementation/
│   │   └── analysis-service/
│   │       └── src/, tests/, implementation/
│   └── common/
│       ├── interfaces/
│       │   └── handoffs/
│       │       ├── _template.ts
│       │       ├── api-to-frontend.ts
│       │       └── api-to-analysis.ts
│       └── coordination/               # NEW: 2025 features
│           ├── task-state.schema.json
│           ├── coordination-state.schema.json
│           └── file-lock.schema.json
│
├── project/
│   ├── CURRENT_STATE.md
│   ├── features/
│   │   └── INDEX.md
│   ├── roadmap/
│   ├── debt/
│   └── housekeeping/
│
├── docs/
│   ├── schematic/
│   ├── architecture/
│   ├── database/
│   └── decisions/
│
├── demos/
│   ├── frontend/
│   ├── api-service/
│   └── analysis-service/
│
├── AIFeedback/
│   ├── frontend/
│   ├── api-service/
│   └── analysis-service/
│
├── .ai-office/                         # Runtime (gitignored)
│   ├── queue/
│   │   ├── pending/
│   │   └── completed/
│   ├── agents/
│   └── logs/
│
└── .gitignore                          # Excludes .ai-office/, locks, etc.
```

### 3. (Optional) Setup Worktrees

If using parallel AI agents:

```bash
# From project root
mkdir -p ../worktrees/locks

# Create worktrees for each area
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

---

## File Details

### ai-office.config.json

```json
{
  "$schema": "https://raw.githubusercontent.com/alterspective/ai-office/main/schema/config.schema.json",
  "configVersion": "2.0",
  "project": {
    "name": "your-project",
    "workspaceRoot": ".ai-office",
    "methodology": "alterspective-multi-agent",
    "grounding": {
      "projectRules": "CLAUDE.md",
      "agentProtocol": "AGENTS.md"
    }
  },
  "agents": {
    "frontend": {
      "type": "claude-code",
      "area": "src/areas/frontend",
      "boundaries": {
        "canModify": ["src/areas/frontend/**"],
        "canRead": ["src/common/**"],
        "cannotTouch": ["src/areas/api-service/**", "src/areas/analysis-service/**"]
      }
    }
    // ... other agents
  },
  "coordination": {
    "structuredState": {
      "enabled": true,
      "schemaPath": "src/common/coordination/task-state.schema.json",
      "coordinationFile": "worktrees/coordination.json"
    }
  },
  "worktrees": {
    "enabled": true,
    "container": "../worktrees",
    "branchPattern": "feature/{agent-id}-agent"
  },
  "fileLocking": {
    "enabled": true,
    "locksDirectory": "../worktrees/locks"
  }
}
```

### continue.bat (Windows)

```batch
@echo off
REM Resume script for multi-agent development
REM Checks current state and recommends next steps

echo ===================================
echo AI-Office Project Resume
echo ===================================

REM Check for coordination state
if exist "..\worktrees\coordination.json" (
    echo [OK] Coordination state found
) else (
    echo [WARN] No coordination state - run setup first
)

REM Check for active locks
dir /b "..\worktrees\locks\*.lock.json" 2>nul >nul
if %errorlevel%==0 (
    echo [WARN] Active file locks found:
    dir /b "..\worktrees\locks\*.lock.json"
) else (
    echo [OK] No active file locks
)

REM Check AI-Office status
npx ai-office status 2>nul
if %errorlevel% neq 0 (
    echo [INFO] AI-Office not running. Start with: npx ai-office start
)

echo.
echo Recommended next steps:
echo 1. npx ai-office status    - Check current state
echo 2. npx ai-office doctor    - Run health checks
echo 3. npx ai-office submit    - Create new job
echo ===================================
```

### continue.ps1 (PowerShell)

```powershell
# Resume script for multi-agent development
# Checks current state and recommends next steps

Write-Host "===================================" -ForegroundColor Cyan
Write-Host "AI-Office Project Resume" -ForegroundColor Cyan
Write-Host "===================================" -ForegroundColor Cyan

# Check for coordination state
if (Test-Path "..\worktrees\coordination.json") {
    Write-Host "[OK] Coordination state found" -ForegroundColor Green
    $state = Get-Content "..\worktrees\coordination.json" | ConvertFrom-Json

    # Show current phase
    Write-Host "  Current Phase: $($state.phases.current)" -ForegroundColor Gray

    # Show incomplete tasks
    $incomplete = $state.tasks | Where-Object { $_.status -ne "completed" }
    if ($incomplete.Count -gt 0) {
        Write-Host "  Incomplete Tasks: $($incomplete.Count)" -ForegroundColor Yellow
        foreach ($task in $incomplete) {
            Write-Host "    - $($task.taskId): $($task.status)" -ForegroundColor Gray
        }
    }
} else {
    Write-Host "[WARN] No coordination state - run setup first" -ForegroundColor Yellow
}

# Check for active locks
$locks = Get-ChildItem "..\worktrees\locks\*.lock.json" -ErrorAction SilentlyContinue
if ($locks) {
    Write-Host "[WARN] Active file locks found:" -ForegroundColor Yellow
    foreach ($lock in $locks) {
        $lockData = Get-Content $lock.FullName | ConvertFrom-Json
        Write-Host "  - $($lockData.path) by $($lockData.lockedBy)" -ForegroundColor Gray
    }
} else {
    Write-Host "[OK] No active file locks" -ForegroundColor Green
}

# Recommend next steps
Write-Host ""
Write-Host "Recommended next steps:" -ForegroundColor White
Write-Host "1. npx ai-office status    - Check current state" -ForegroundColor Gray
Write-Host "2. npx ai-office doctor    - Run health checks" -ForegroundColor Gray
Write-Host "3. npx ai-office submit    - Create new job" -ForegroundColor Gray
Write-Host "===================================" -ForegroundColor Cyan
```

---

## Workflow After Seeding

### Single Agent Development

1. Run seed repository
2. Use prompts 01-08 sequentially
3. Run phase validator at each transition

### Multi-Agent Development

1. Run seed repository
2. Setup git worktrees
3. Start AI-Office supervisor: `npx ai-office start`
4. Submit jobs for each agent: `npx ai-office submit`
5. Monitor progress: `npx ai-office status`
6. Architect merges completed work

---

## Validation Checklist

After seeding, verify:

- [ ] CLAUDE.md exists (>500 chars)
- [ ] AGENTS.md exists (>800 chars)
- [ ] ai-office.config.json is valid JSON
- [ ] src/common/coordination/ has all 3 schemas
- [ ] Area folders have correct structure
- [ ] .gitignore excludes .ai-office/ and locks

### Quick Validation Script

```bash
# Run after seeding
echo "Validating seeded project..."

# Check required files
[ -f "CLAUDE.md" ] && echo "✓ CLAUDE.md" || echo "✗ CLAUDE.md missing"
[ -f "AGENTS.md" ] && echo "✓ AGENTS.md" || echo "✗ AGENTS.md missing"
[ -f "ai-office.config.json" ] && echo "✓ ai-office.config.json" || echo "✗ config missing"

# Check schemas
[ -f "src/common/coordination/task-state.schema.json" ] && echo "✓ task-state schema" || echo "✗ schema missing"

# Validate JSON
node -e "JSON.parse(require('fs').readFileSync('ai-office.config.json'))" 2>/dev/null && echo "✓ config is valid JSON" || echo "✗ config is invalid"

# Check gitignore
grep -q ".ai-office" .gitignore && echo "✓ .gitignore configured" || echo "✗ .gitignore missing .ai-office"

echo "Validation complete!"
```

---

## Troubleshooting

| Issue | Cause | Solution |
|-------|-------|----------|
| Schema validation fails | Invalid JSON | Check schema syntax, run through JSON validator |
| Worktree creation fails | Branch exists | Delete existing branch or use different name |
| Lock conflicts | Agent crashed | Check lock expiry, override if expired |
| Coordination state corrupt | Race condition | Restore from git, re-run jobs |

---

## References

- [00-seed-repository.txt](../00-seed-repository.txt) - Seeding prompt
- [IMPROVEMENT-PLAN.md](../IMPROVEMENT-PLAN.md) - Phase 6-7 details
- [ORCHESTRATION-INTEGRATION.md](./ORCHESTRATION-INTEGRATION.md) - AI-Office integration
- [schemas/](../schemas/) - JSON schemas for validation
