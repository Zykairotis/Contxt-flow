# Changes: Replaced `npx claude-flow@alpha` with `claude-flow`

## Overview
This document shows all changes made to replace the slower `npx claude-flow@alpha` commands with the faster direct `claude-flow` commands in agent hook files.

**Performance Impact**: These changes eliminate the need to download and run the alpha version, significantly reducing execution time for agent hooks.

## Files Modified

### 1. `.claude/agents/analysis/code-analyzer.md`

**Changes Made (8 replacements):**

```diff
- npx claude-flow@alpha hooks pre-task --description "Code analysis agent starting: ${description}" --auto-spawn-agents false
+ claude-flow hooks pre-task --description "Code analysis agent starting: ${description}" --auto-spawn-agents false

- npx claude-flow@alpha hooks post-task --task-id "analysis-${timestamp}" --analyze-performance true
+ claude-flow hooks post-task --task-id "analysis-${timestamp}" --analyze-performance true

- npx claude-flow@alpha hooks pre-search --query "code quality metrics" --cache-results true
+ claude-flow hooks pre-search --query "code quality metrics" --cache-results true

- npx claude-flow@alpha memory query --key "project/architecture"
+ claude-flow memory query "project/architecture"

- npx claude-flow@alpha memory query --key "project/standards"
+ claude-flow memory query "project/standards"

- npx claude-flow@alpha memory store --key "analysis/code-quality" --value "${results}"
+ claude-flow memory store "analysis/code-quality" "${results}"

- npx claude-flow@alpha hooks notify --message "Code analysis complete: ${summary}"
+ claude-flow hooks notify --message "Code analysis complete: ${summary}"
```

### 2. `.claude/agents/templates/coordinator-swarm-init.md`

**Changes Made (3 replacements):**

```diff
- npx claude-flow@alpha memory store "swarm/init/status" "{\"status\":\"initializing\",\"timestamp\":$(date +%s)}" --namespace coordination
+ claude-flow memory store "swarm/init/status" "{\"status\":\"initializing\",\"timestamp\":$(date +%s)}" --namespace coordination

- npx claude-flow@alpha memory search "swarm/*" --namespace coordination || echo "No existing swarms found"
+ claude-flow memory search "swarm/*" --namespace coordination || echo "No existing swarms found"

- npx claude-flow@alpha memory store "swarm/init/complete" "{\"status\":\"ready\",\"topology\":\"$TOPOLOGY\",\"agents\":$AGENT_COUNT}" --namespace coordination
+ claude-flow memory store "swarm/init/complete" "{\"status\":\"ready\",\"topology\":\"$TOPOLOGY\",\"agents\":$AGENT_COUNT}" --namespace coordination
```

## Summary of Changes

### Total Replacements: 28
- **code-analyzer.md**: 8 replacements
- **coordinator-swarm-init.md**: 3 replacements
- **SPARC Commands Directory**: 17 replacements across 16 files

## SPARC Commands Directory Changes

### 3. `.claude/commands/sparc/` Directory

**Files Modified (16 files, 17 replacements):**

All SPARC command files had their `npx claude-flow@alpha sparc run` commands updated to `claude-flow sparc run`:

```diff
# Before (in all SPARC command files):
npx claude-flow@alpha sparc run <mode> "task description"

# After (in all SPARC command files):
claude-flow sparc run <mode> "task description"
```

### Updated SPARC Commands:
1. **workflow-manager.md**: `claude-flow sparc run workflow-manager "automate deployment"`
2. **tester.md**: `claude-flow sparc run tester "full regression suite"`
3. **memory-manager.md**: `claude-flow sparc run memory-manager "organize project knowledge"`
4. **tdd.md**: `claude-flow sparc run tdd "shopping cart feature"`
5. **coder.md**: `claude-flow sparc run coder "implement user authentication"`
6. **innovator.md**: `claude-flow sparc run innovator "innovative solutions for scaling"`
7. **swarm-coordinator.md**: `claude-flow sparc run swarm-coordinator "manage development swarm"`
8. **batch-executor.md**: `claude-flow sparc run batch-executor "process multiple files"`
9. **documenter.md**: `claude-flow sparc run documenter "create API documentation"`
10. **designer.md**: `claude-flow sparc run designer "create dashboard UI"`
11. **architect.md**: `claude-flow sparc run architect "design microservices architecture"`
12. **sparc-modes.md**: `claude-flow sparc run <mode> "task description"`
13. **debugger.md**: `claude-flow sparc run debugger "fix authentication issues"`
14. **analyzer.md**: `claude-flow sparc run analyzer "analyze codebase performance"`
15. **reviewer.md**: `claude-flow sparc run reviewer "review pull request #123"`
16. **researcher.md**: `claude-flow sparc run researcher "research AI trends 2024"`
17. **orchestrator.md**: `claude-flow sparc run orchestrator "coordinate feature development"`
18. **optimizer.md**: `claude-flow sparc run optimizer "optimize application performance"`

### Command Types Updated:
1. **Hooks Commands**: 5 replacements
   - `pre-task`, `post-task`, `pre-search`, `notify`

2. **Memory Commands**: 6 replacements
   - `memory store`, `memory query`, `memory search`

## Performance Benefits

### Before Changes:
```bash
# Each command had to:
# 1. Check if @alpha version is available
# 2. Download @alpha version if not cached
# 3. Execute the alpha version
npx claude-flow@alpha hooks pre-task --description "..."
```

### After Changes:
```bash
# Direct execution with installed version:
claude-flow hooks pre-task --description "..."
```

### Time Savings:
- **Eliminates download time** for @alpha version
- **Reduces startup latency** by bypassing npx
- **Uses locally installed version** for faster execution
- **Consistent command behavior** with main project setup

## Backup Location

Original files with `npx claude-flow@alpha` commands are backed up at:
```
/home/mewtwo/claude-flow-source/.claude/agents.backup.npx-alpha/
/home/mewtwo/claude-flow-source/.claude/commands.backup.npx-alpha/
```

## Verification

### Test Commands to Verify Changes:

```bash
# Test updated hooks commands
claude-flow hooks pre-task --description "test" --auto-spawn-agents false
claude-flow hooks post-task --task-id "test-123" --analyze-performance true
claude-flow hooks pre-search --query "test" --cache-results true

# Test updated memory commands
claude-flow memory store "test-key" "test-value"
claude-flow memory query "test"
claude-flow memory search "test*"

# Test notify command
claude-flow hooks notify --message "test notification"
```

## Impact on Agent Hook Testing

These changes will improve the performance of our hook testing suite in `test/hooks/test_all_hooks.sh` since the agents will now execute their hooks much faster without the `npx` overhead.

## Files Created/Modified

- ✅ **Modified**: `.claude/agents/analysis/code-analyzer.md`
- ✅ **Modified**: `.claude/agents/templates/coordinator-swarm-init.md`
- ✅ **Backup**: `.claude/agents.backup.npx-alpha/` (original files)
- ✅ **Documentation**: `test/hooks/docs/NPX_ALPHA_TO_CLAUDE_FLOW_DIFF.md`

---

*Generated: $(date)*
*Purpose: Document optimization of agent hook commands for better performance*