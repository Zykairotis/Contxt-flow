# Claude-Flow Agent Type Fix Guide

## The Problem

Users are getting "Agent type 'analyst' not found" errors when spawning agents with generic names like:
- `analyst` (should be `code-analyzer`)
- `coordinator` (should be `task-orchestrator`, `adaptive-coordinator`, etc.)
- `architect` (should be `system-architect`)

## Root Cause

1. **TypeScript types allow deprecated names** - `src/swarm/types.ts` still defines `'analyst' | 'coordinator' | 'architect'`
2. **MCP tools don't resolve legacy names** - The spawn handler in `src/mcp/claude-flow-tools.ts` uses `input.type` directly
3. **Agent files use modern names** - Actual agent definitions in `.claude/agents/` use specific names like `code-analyzer`
4. **Legacy mapping exists but not applied** - `agent-loader.ts` has mapping, but MCP tools bypass it

## The Solution

We need to apply legacy agent name resolution in the MCP tool handlers.

### Fix 1: Update Agent Spawn Handler

File: `src/mcp/claude-flow-tools.ts`

```typescript
// At the top of the file, add import:
import { resolveLegacyAgentType, isValidAgentType } from '../agents/agent-loader.js';

// Then in createSpawnAgentTool handler (around line 151):
handler: async (input: any, context?: ClaudeFlowToolContext) => {
  logger.info('Spawning agent', { input, sessionId: context?.sessionId });

  if (!context?.orchestrator) {
    throw new Error('Orchestrator not available');
  }

  // NEW: Resolve legacy agent type names
  const resolvedType = resolveLegacyAgentType(input.type);
  
  // NEW: Validate the agent type exists
  const isValid = await isValidAgentType(resolvedType);
  if (!isValid) {
    throw new Error(
      `Invalid agent type: '${input.type}'. ` +
      (input.type !== resolvedType 
        ? `Note: '${input.type}' is deprecated, use '${resolvedType}' instead. `
        : '') +
      `Run 'claude-flow agents list' to see available types.`
    );
  }

  // Log if we resolved a legacy name
  if (input.type !== resolvedType) {
    logger.warn('Legacy agent type detected', {
      provided: input.type,
      resolved: resolvedType,
      message: `Agent type '${input.type}' is deprecated, using '${resolvedType}' instead`
    });
  }

  const profile: AgentProfile = {
    id: `agent_${Date.now()}_${Math.random().toString(36).substr(2, 9)}`,
    name: input.name,
    type: resolvedType, // CHANGED: Use resolved type instead of input.type
    capabilities: input.capabilities || [],
    systemPrompt: input.systemPrompt || getDefaultSystemPrompt(resolvedType), // CHANGED
    maxConcurrentTasks: input.maxConcurrentTasks || 3,
    priority: input.priority || 5,
    environment: input.environment,
    workingDirectory: input.workingDirectory,
  };

  const sessionId = await context.orchestrator.spawnAgent(profile);

  return {
    agentId: profile.id,
    sessionId,
    profile,
    status: 'spawned',
    timestamp: new Date().toISOString(),
    // NEW: Include warning if legacy type was used
    ...(input.type !== resolvedType && {
      warning: `Agent type '${input.type}' is deprecated. Please use '${resolvedType}' instead.`
    })
  };
},
```

### Fix 2: Update TypeScript Type Definitions

File: `src/swarm/types.ts`

Option A: Dynamic string type (current approach - already correct in constants/agent-types.ts)
```typescript
// Change from hardcoded enum to dynamic string
export type AgentType = string;

// Add deprecation comments
/**
 * @deprecated Use specific agent names from .claude/agents/ directory
 * Legacy names: analyst → code-analyzer, coordinator → task-orchestrator, architect → system-architect
 */
```

Option B: Keep enum but add modern names and deprecation warnings
```typescript
export type AgentType =
  // Core agents
  | 'coder'
  | 'planner'
  | 'researcher'
  | 'reviewer'
  | 'tester'
  // Analysis agents
  | 'code-analyzer'
  | 'performance-analyzer'
  // Coordination agents
  | 'task-orchestrator'
  | 'adaptive-coordinator'
  | 'hierarchical-coordinator'
  | 'mesh-coordinator'
  | 'queen-coordinator'
  // Architecture agents
  | 'system-architect'
  | 'design-architect'
  // ... add all 74 agent types
  // Legacy (deprecated)
  /** @deprecated Use 'code-analyzer' instead */
  | 'analyst'
  /** @deprecated Use 'task-orchestrator' or specific coordinator instead */
  | 'coordinator'
  /** @deprecated Use 'system-architect' instead */
  | 'architect'
  // ... other deprecated types
```

### Fix 3: Update Parallel Agent Spawn Tool

File: `src/mcp/claude-flow-tools.ts` (around line 180-220)

```typescript
function createSpawnParallelAgentsTool(logger: ILogger): MCPTool {
  return {
    name: 'agents/spawn-parallel',
    // ... existing schema ...
    handler: async (input: any, context?: ClaudeFlowToolContext) => {
      // ... existing validation ...

      const results = await Promise.all(
        input.agents.map(async (agentConfig: any, index: number) => {
          try {
            // NEW: Resolve legacy type
            const resolvedType = resolveLegacyAgentType(agentConfig.type);
            
            // NEW: Validate type
            const isValid = await isValidAgentType(resolvedType);
            if (!isValid) {
              throw new Error(`Invalid agent type: '${agentConfig.type}'`);
            }

            // NEW: Warn if legacy
            if (agentConfig.type !== resolvedType) {
              logger.warn('Legacy agent type in parallel spawn', {
                provided: agentConfig.type,
                resolved: resolvedType,
                agentIndex: index
              });
            }

            const profile: AgentProfile = {
              id: `agent_${Date.now()}_${index}_${Math.random().toString(36).substr(2, 9)}`,
              name: agentConfig.name,
              type: resolvedType, // CHANGED: Use resolved type
              // ... rest of config
            };

            // ... rest of spawn logic
          } catch (error) {
            // ... error handling
          }
        })
      );
      // ... return results
    }
  };
}
```

### Fix 4: Add Migration Warning Helper

File: `src/mcp/claude-flow-tools.ts` (add new function)

```typescript
/**
 * Get helpful migration message for deprecated agent types
 */
function getAgentTypeMigrationHelp(legacyType: string, modernType: string): string {
  const suggestions: Record<string, string> = {
    analyst: 'Use code-analyzer for code analysis, or performance-analyzer for performance metrics',
    coordinator: 'Use task-orchestrator for general coordination, adaptive-coordinator for adaptive strategies, or hierarchical-coordinator for hierarchical swarms',
    architect: 'Use system-architect for system design, or design-architect for UI/UX design',
    optimizer: 'Use performance-analyzer for performance optimization',
    documenter: 'Use api-docs for API documentation',
    monitor: 'Use performance-benchmarker for monitoring and benchmarking',
    specialist: 'Use system-architect or choose a specific specialized agent',
  };

  return suggestions[legacyType] || `Use ${modernType} instead of ${legacyType}`;
}
```

## Testing the Fix

### 1. Build and Link
```bash
cd /home/mewtwo/claude-flow-source
npm run build:ts
npm link --force
```

### 2. Test Legacy Agent Names
```bash
# Test with deprecated name (should work with warning)
claude-flow agents spawn analyst "Test Analyst"

# Test with correct name (should work without warning)
claude-flow agents spawn code-analyzer "Test Analyzer"
```

### 3. Verify Error Messages
Try spawning with invalid type:
```bash
claude-flow agents spawn invalid-type "Test"
# Should show helpful error with available types
```

## Implementation Steps

1. ✅ **Agent loader already has legacy mapping** - No changes needed
2. ⬜ **Update spawn handler** - Add legacy resolution
3. ⬜ **Update parallel spawn handler** - Add legacy resolution  
4. ⬜ **Update type definitions** - Add deprecation warnings
5. ⬜ **Add migration helpers** - Helpful error messages
6. ⬜ **Build and test** - Verify fix works
7. ⬜ **Update documentation** - Document correct agent names

## Alternative: Quick Fix (Just Update MCP Handler)

If you just want a quick fix without updating types, only modify the spawn handlers:

```typescript
// In createSpawnAgentTool, line ~151
const resolvedType = resolveLegacyAgentType(input.type);
const profile: AgentProfile = {
  // ... other fields
  type: resolvedType, // Changed from input.type
  systemPrompt: input.systemPrompt || getDefaultSystemPrompt(resolvedType), // Changed
};
```

This ensures the actual spawning uses the correct modern agent names, even if users provide legacy names.
