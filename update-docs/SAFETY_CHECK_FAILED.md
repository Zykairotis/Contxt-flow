# ⚠️ SAFETY CHECK FAILED - Cannot Proceed with Replacements

## Critical Issues Discovered

### 🔴 Problem 1: Replacement Agent Names DON'T EXIST

The legacy mapping in `agent-loader.ts` maps to agent types that **don't actually exist** in `.claude/agents/`:

| Legacy Name | Maps To | Status |
|-------------|---------|--------|
| analyst | code-analyzer | ✅ EXISTS |
| coordinator | **task-orchestrator** | ❌ MISSING |
| optimizer | **perf-analyzer** | ❌ MISSING |
| documenter | api-docs | ✅ EXISTS |
| monitor | **performance-benchmarker** | ❌ MISSING |
| specialist | system-architect | ✅ EXISTS |
| architect | system-architect | ✅ EXISTS |

### 🔴 Problem 2: Agent Definition Files Have Errors

Many agent definition files have YAML parsing errors:
- 2 files have YAML syntax errors (compact mapping issues)
- 60+ files missing required fields (name, metadata.description)

This explains why the agent loader is failing!

## What Actually Exists

### Coordinators that DO exist:
```
.claude/agents/swarm/adaptive-coordinator.md
.claude/agents/swarm/hierarchical-coordinator.md
.claude/agents/swarm/mesh-coordinator.md
.claude/agents/hive-mind/queen-coordinator.md
.claude/agents/consensus/gossip-coordinator.md
.claude/agents/consensus/byzantine-coordinator.md
.claude/agents/github/sync-coordinator.md
.claude/agents/hive-mind/collective-intelligence-coordinator.md
.claude/agents/templates/memory-coordinator.md
.claude/agents/templates/coordinator-swarm-init.md
.claude/agents/sparc/sparc-coordinator.md (in templates)
```

**BUT "task-orchestrator" DOES NOT EXIST!**

### Analyzers that DO exist:
```
.claude/agents/analysis/code-analyzer.md
.claude/agents/templates/performance-analyzer.md
```

**BUT "perf-analyzer" DOES NOT EXIST!**

### Benchmarkers that DO exist:
```
.claude/agents/consensus/performance-benchmarker.md
.claude/agents/optimization/benchmark-suite.md
```

**"performance-benchmarker" EXISTS but has missing required fields!**

## Root Cause Analysis

The `LEGACY_AGENT_MAPPING` in `src/agents/agent-loader.ts` is **incorrectly configured**:

```typescript
const LEGACY_AGENT_MAPPING = {
  analyst: 'code-analyzer',        // ✅ Correct
  coordinator: 'task-orchestrator', // ❌ Wrong - doesn't exist
  optimizer: 'perf-analyzer',       // ❌ Wrong - doesn't exist  
  documenter: 'api-docs',          // ✅ Correct
  monitor: 'performance-benchmarker', // ⚠️ Exists but has YAML errors
  specialist: 'system-architect',  // ✅ Correct
  architect: 'system-architect',   // ✅ Correct
}
```

## Correct Mapping Should Be

Based on actual files that exist:

```typescript
const LEGACY_AGENT_MAPPING = {
  analyst: 'code-analyzer',              // ✅ EXISTS
  coordinator: 'adaptive-coordinator',   // ✅ EXISTS (or mesh-coordinator, hierarchical-coordinator)
  optimizer: 'performance-analyzer',     // ✅ EXISTS (in templates)
  documenter: 'api-docs',               // ✅ EXISTS  
  monitor: 'performance-benchmarker',    // ⚠️ EXISTS (but needs YAML fix)
  specialist: 'system-architect',        // ✅ EXISTS
  architect: 'system-architect',         // ✅ EXISTS
}
```

## Impact Assessment

### Current Status:
- ❌ MCP tool fix we did is **partially broken** - it resolves to non-existent agent types
- ❌ Users using deprecated names will get "agent not found" errors for some types
- ⚠️ Our test passed because it only tested the mapping function, not actual agent existence

### What Works:
- ✅ `analyst` → `code-analyzer` (works)
- ✅ `architect` → `system-architect` (works)
- ✅ `specialist` → `system-architect` (works)
- ✅ `documenter` → `api-docs` (works)

### What's Broken:
- ❌ `coordinator` → `task-orchestrator` (target doesn't exist)
- ❌ `optimizer` → `perf-analyzer` (target doesn't exist)
- ⚠️ `monitor` → `performance-benchmarker` (target has YAML errors)

## Required Fixes

### Priority 1: Fix the Mapping (CRITICAL)
**File: `src/agents/agent-loader.ts`**

Change line 12-19:
```typescript
const LEGACY_AGENT_MAPPING = {
  analyst: 'code-analyzer',
  coordinator: 'adaptive-coordinator',      // CHANGED
  optimizer: 'performance-analyzer',        // CHANGED
  documenter: 'api-docs',
  monitor: 'performance-benchmarker',
  specialist: 'system-architect',
  architect: 'system-architect',
} as const;
```

### Priority 2: Fix Agent Definition Files (HIGH)
Many agent files have YAML errors or missing fields that prevent them from loading.

### Priority 3: Then Update Examples (MEDIUM)
Only after fixing the mapping should we update user-facing examples.

## Recommended Action Plan

1. **STOP** - Don't update examples yet
2. **FIX** - Correct the LEGACY_AGENT_MAPPING first
3. **FIX** - Fix YAML errors in agent definition files
4. **TEST** - Verify all mappings resolve to existing agents
5. **BUILD** - Rebuild and relink
6. **THEN** - Update user-facing examples

## Safety Recommendation

**DO NOT PROCEED** with replacing deprecated names in examples until:
1. ✅ LEGACY_AGENT_MAPPING is corrected
2. ✅ Agent definition files are fixed
3. ✅ All mapped-to agents actually exist and load properly
4. ✅ Tests verify the complete chain works

Otherwise, we'll be replacing working (deprecated) names with broken references!
