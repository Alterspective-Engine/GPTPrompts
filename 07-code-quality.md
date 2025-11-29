# 07 - Code Quality Standards

Standards for maintainable, readable, and robust code.

## SOLID Principles

### Single Responsibility
- Each class/module has one reason to change.
- One component per file.
- Separate concerns: data access, business logic, UI, state.

### Open/Closed
- Open for extension, closed for modification.
- Use composition over inheritance.
- Design for extensibility without changing existing code.

### Liskov Substitution
- Subtypes must be substitutable for base types.
- Honor contracts defined by parent classes/interfaces.

### Interface Segregation
- Many specific interfaces over one general interface.
- Clients should not depend on methods they don't use.

### Dependency Inversion
- Depend on abstractions, not concretions.
- Inject dependencies; avoid hard-coded instantiation.
- Use interfaces for external services.

## File Size Management

| Element | Maximum | Preferred |
|---------|---------|-----------|
| Files | 200-300 lines | <150 lines |
| Functions | 20-30 lines | <20 lines |
| Components | 150 lines | <100 lines |

**When limits exceeded:**
- Extract complex logic into separate modules.
- Break large components into smaller sub-components.
- Create utility files for reusable functions.
- Split by responsibility, not arbitrary line counts.

## Separation of Concerns

```
src/
├── components/     # UI components (presentation)
├── stores/         # Shared state management
├── services/       # API calls, external integrations
├── lib/            # Utilities, helpers, types
├── hooks/          # Reusable logic (React/Svelte)
└── routes/         # Page components, routing
```

**Rules:**
- Separate data access from business logic.
- Separate UI from state management.
- Keep API calls in service modules.
- Use stores for shared state.
- Components should be primarily presentational.

## TypeScript Standards

- **Strict mode:** Always; no `any` types without justification.
- **Type imports:** Centralize in `types.ts` files.
- **Interfaces:** Define for all data structures.
- **Type guards:** Use for runtime type checking.
- **Generics:** Use for reusable, type-safe code.

```typescript
// Good
interface User {
  id: string;
  name: string;
  email: string;
}

function getUser(id: string): Promise<User> { ... }

// Bad
function getUser(id: any): Promise<any> { ... }
```

## Naming Conventions

| Element | Convention | Example |
|---------|------------|---------|
| Components | PascalCase | `UserProfile.svelte` |
| Files (logic) | camelCase | `validateInput.ts` |
| Folders | kebab-case | `user-auth/` |
| Constants | UPPER_SNAKE_CASE | `MAX_RETRIES` |
| Interfaces | PascalCase | `UserProfile` |
| Types | PascalCase | `ApiResponse` |
| Functions | camelCase | `fetchUserData` |
| Variables | camelCase | `currentUser` |

## Function Design

- **Single responsibility:** One purpose per function.
- **Descriptive names:** Verb + noun (`getUserById`, `validateEmail`).
- **Small and focused:** Max 20-30 lines; prefer smaller.
- **Avoid deep nesting:** Extract complex logic; use early returns.
- **Pure when possible:** Same input = same output; no side effects.

```typescript
// Good: Small, focused, descriptive
function calculateTotalPrice(items: CartItem[]): number {
  return items.reduce((sum, item) => sum + item.price * item.quantity, 0);
}

// Bad: Too many responsibilities, vague name
function processData(data: any) {
  // validates, transforms, saves, and notifies - too much
}
```

## Error Handling

- Handle all errors appropriately; never swallow silently.
- Use try-catch for async operations.
- Provide user-friendly error messages.
- Log errors with context for debugging.
- Fail fast on unrecoverable errors.

```typescript
// Good
try {
  const user = await fetchUser(id);
  return user;
} catch (error) {
  logger.error('Failed to fetch user', { id, error });
  throw new UserNotFoundError(`User ${id} not found`);
}

// Bad
try {
  return await fetchUser(id);
} catch (e) {
  // silently ignored
}
```

## Documentation Standards

- **JSDoc:** For all exported functions and complex internal ones.
- **Inline comments:** Explain "why," not "what."
- **README:** For each major module explaining purpose and usage.
- **Type annotations:** Self-documenting; avoid redundant comments.

```typescript
/**
 * Calculates the discount for a user based on their membership tier.
 * @param user - The user to calculate discount for
 * @param basePrice - The original price before discount
 * @returns The discounted price
 */
function calculateDiscount(user: User, basePrice: number): number {
  // Premium users get 20% off during promotional periods
  if (user.tier === 'premium' && isPromotionalPeriod()) {
    return basePrice * 0.8;
  }
  return basePrice;
}
```

## Code Review Checklist

Before submitting code:
- [ ] Follows SOLID principles
- [ ] Files under size limits
- [ ] Functions small and focused
- [ ] No `any` types without justification
- [ ] Errors handled appropriately
- [ ] Tests written for new functionality
- [ ] Documentation updated
- [ ] No hardcoded secrets or credentials
- [ ] Naming conventions followed

## MCP Skill Development

When building reusable capabilities with MCP servers:

### Skill Structure

**Higher-level functions that compose MCP tool calls.**
Skills are documented, tested, and reusable across sessions.

```typescript
/**
 * Analyzes dependency tree for security vulnerabilities and licensing issues.
 * @param projectPath - Root path of the project to analyze
 * @returns Analysis results with dependencies, vulnerabilities, and summary
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

### Skill Documentation Standards

**Required for all skills:**
- **Purpose:** One-line summary of what the skill does.
- **Parameters:** Type-safe interfaces with descriptions.
- **Returns:** Structured result type with clear schema.
- **Error handling:** Document failure modes and recovery patterns.
- **Examples:** Show typical usage patterns and edge cases.

```typescript
/**
 * @example
 * const result = await analyzeDependencyTree('/path/to/project');
 * if (result.vulnerabilities.critical > 0) {
 *   console.error('Critical vulnerabilities found:', result.vulnerabilities.list);
 * }
 */
```

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

**Organization principles:**
- Group by domain, not by MCP server.
- One skill per file for maintainability.
- Export skills with clear, discoverable names.
- Include SKILL.md in each domain folder documenting available skills.

### Anti-Patterns

**Don't:**
- Create one-off scripts without documentation.
- Skip error handling in skill functions.
- Build skills that tightly couple to specific projects.
- Use `any` types for MCP tool results.
- Duplicate logic across multiple skills.

**Do:**
- Create reusable, documented, tested functions.
- Use TypeScript for type safety in skills.
- Version skills and track breaking changes.
- Extract common patterns into utility functions.
- Write integration tests for MCP skill compositions.
