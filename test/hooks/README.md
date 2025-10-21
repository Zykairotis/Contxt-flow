# Agent Hooks Testing Suite

## Overview

This directory contains a comprehensive testing suite for all hooks defined in the Claude Flow agent system. The testing framework validates hook functionality across 5 complexity levels for 52 hook-enabled agents (out of 79 total agents).

## Directory Structure

```
test/hooks/
├── docs/
│   ├── ALL_AGENT_HOOKS.md          # Complete hooks documentation
│   └── HOOK_TESTING_PLAN.md        # Detailed testing strategy
├── results/                         # Test results (auto-generated)
├── test_all_hooks.sh               # Automated test runner
└── README.md                       # This file
```

## Quick Start

### Run All Hook Tests
```bash
# Execute the complete test suite
./test/hooks/test_all_hooks.sh
```

### Run Individual Hook Tests
```bash
# Test basic logging hooks
claude-flow hooks pre-task --description "test functionality" --agent-id hello-agent

# Test swarm coordination hooks
claude-flow hooks pre-task --description "initialize swarm" --agent-id hierarchical-coordinator

# Test post-task validation
claude-flow hooks post-task --task-id test-validation --agent-id production-validator
```

## Hook Categories Tested

### Level 1: Basic Logging Hooks
- **Purpose**: Simple status messages and task identification
- **Agents**: hello-agent, basic core agents
- **Validation**: Echo output, emoji formatting, memory integration

### Level 2: Validation Hooks
- **Purpose**: Environment checks and command availability
- **Agents**: researcher, reviewer, planner
- **Validation**: File existence checks, command detection, error handling

### Level 3: Execution Hooks
- **Purpose**: External command execution and output processing
- **Agents**: tester, perf-analyzer, production-validator
- **Validation**: Command execution, output parsing, exit code handling

### Level 4: MCP Integration Hooks
- **Purpose**: MCP tool integration and swarm coordination
- **Agents**: hierarchical-coordinator, mesh-coordinator, swarm-memory-manager
- **Validation**: MCP tool connectivity, memory operations, swarm initialization

### Level 5: Complex Orchestration Hooks
- **Purpose**: Multi-agent coordination and complex workflows
- **Agents**: adaptive-coordinator, collective-intelligence-coordinator
- **Validation**: Cross-agent communication, topology adaptation, decision-making

## Test Results

After running tests, results are saved to:
```
test/hooks/results/hook_test_results_YYYYMMDD_HHMMSS.log
```

### Result Categories
- **✅ PASS**: Hook executed successfully
- **❌ FAIL**: Hook failed with error
- **⚠️ SKIP**: Test skipped (missing dependencies or agent has no hooks)

**Note**: 27 agents (34%) have no hooks and will be automatically skipped.

## Manual Testing

For manual hook validation:

1. **Check Environment Setup**
   ```bash
   # Verify memory store
   ls -la .swarm/memory.db

   # Check agent files
   ls .claude/agents/*.md
   ```

2. **Test Individual Hooks**
   ```bash
   # Replace [agent-name] with actual agent ID
   claude-flow hooks pre-task --description "test task" --agent-id [agent-name]
   ```

3. **Validate Memory Operations**
   ```bash
   # Check memory store entries
   sqlite3 .swarm/memory.db "SELECT * FROM memory_store ORDER BY timestamp DESC LIMIT 10;"
   ```

## Common Issues

### MCP Server Not Running
- **Symptom**: Level 4+ hooks fail with timeout
- **Solution**: Start MCP servers or skip advanced tests

### Memory Store Permissions
- **Symptom**: "Failed to open database" errors
- **Solution**: Check `.swarm/` directory permissions

### Agent File Not Found
- **Symptom**: "Unknown agent" errors
- **Solution**: Ensure agent files exist in `.claude/agents/`

### Command Dependencies Missing
- **Symptom**: External command failures
- **Solution**: Install required tools (npm, jq, etc.)

## Performance Benchmarks

Expected execution times:
- Level 1-3 hooks: < 2 seconds
- Level 4 hooks: < 5 seconds
- Level 5 hooks: < 10 seconds

## Continuous Integration

Add to CI pipeline:
```yaml
- name: Test Agent Hooks
  run: |
    cd test/hooks
    ./test_all_hooks.sh
    # Check results for failures
    if grep -q "❌ FAIL" results/hook_test_results_*.log; then
      echo "Hook tests failed"
      exit 1
    fi
```

## Documentation

- **Complete Hook Analysis**: See `docs/ALL_AGENT_HOOKS.md`
- **Detailed Testing Plan**: See `docs/HOOK_TESTING_PLAN.md`
- **Agent Hook Examples**: Available in individual agent files

## Support

For hook testing issues:
1. Check test results log files
2. Verify environment setup
3. Review hook documentation
4. Test with minimal hook set first

---

*Last Updated: $(date)*
*Claude Flow Hook Testing Suite v1.0*