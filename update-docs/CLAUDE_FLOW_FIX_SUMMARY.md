# Claude-Flow Agent Type Fix Summary

## How Many Need Fixing?

### ❌ **NOT 74 agents** - The 74 agents are CORRECT and don't need fixing!

### ✅ **Only 7 legacy names** need to be handled:

1. `analyst` → `code-analyzer`
2. `coordinator` → `task-orchestrator`
3. `optimizer` → `perf-analyzer`
4. `documenter` → `api-docs`
5. `monitor` → `performance-benchmarker`
6. `specialist` → `system-architect`
7. `architect` → `system-architect`

## What Actually Needs Fixing?

### **Just 3 Functions** in 1 file:

File: `src/mcp/claude-flow-tools.ts`

#### 1. **createSpawnAgentTool** (line ~160)
```typescript
// Current (BROKEN):
type: input.type,

// Fixed:
type: resolveLegacyAgentType(input.type),
```

#### 2. **createSpawnParallelAgentsTool** (line ~1365)
```typescript
// Current (BROKEN):
agentType: agent.type,

// Fixed:
agentType: resolveLegacyAgentType(agent.type),
```

#### 3. **createAssignTaskTool** (line ~431)
```typescript
// Current (BROKEN):
type: input.type,

// Fixed - This is TASK type, not AGENT type, so NO FIX NEEDED
// (This is for task assignment, not agent spawning)
```

## Actually Just 2 Places to Fix!

**File: `/home/mewtwo/claude-flow-source/src/mcp/claude-flow-tools.ts`**

### Fix #1: Line ~160 (Single Agent Spawn)
```typescript
type: resolveLegacyAgentType(input.type),
systemPrompt: input.systemPrompt || getDefaultSystemPrompt(resolveLegacyAgentType(input.type)),
```

### Fix #2: Line ~1365 (Parallel Agent Spawn)
```typescript
agentType: resolveLegacyAgentType(agent.type),
```

Plus add 1 import at the top of the file:
```typescript
import { resolveLegacyAgentType } from '../agents/agent-loader.js';
```

## Total Changes Required:

- **Files to modify:** 1 file
- **Functions to fix:** 2 functions
- **Lines to change:** 3 lines total (2 in spawn, 1 in parallel spawn)
- **New imports:** 1 import statement
- **Legacy names handled:** 7 automatically resolved

## Verification After Fix:

These should all work:
```bash
# Old deprecated names (will auto-resolve)
claude-flow agent spawn analyst "Test Analyst"         # → code-analyzer
claude-flow agent spawn coordinator "Test Coord"       # → task-orchestrator
claude-flow agent spawn architect "Test Architect"     # → system-architect

# Modern correct names (work as-is)
claude-flow agent spawn code-analyzer "Analyzer"
claude-flow agent spawn task-orchestrator "Orchestrator"
claude-flow agent spawn system-architect "Architect"
```

## Why Only 3 Lines?

The actual agent definitions (74 agents) in `.claude/agents/` are already correct!

The problem is only in the **MCP tool handlers** that receive user input. When users type deprecated names, these handlers need to map them to modern names before spawning.

The mapping logic already exists in `agent-loader.ts` - we just need to USE it in the MCP handlers!
