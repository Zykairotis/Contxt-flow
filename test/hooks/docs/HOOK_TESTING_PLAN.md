# Hook Functionality Testing Plan

## Overview

This document outlines a comprehensive testing plan to verify that all hooks defined in the 52 agent files (out of 79 total) work correctly. The plan covers 5 complexity levels and ensures proper functionality of each hook type.

**Note**: 27 agents (34%) do not have hooks and will be skipped during testing.

---

## Testing Strategy

### Phase 1: Environment Setup
1. **Memory Store Validation**
   - Verify SQLite database initialization at `.swarm/memory.db`
   - Test memory store operations (store, search, complete)
   - Validate namespace management

2. **MCP Tool Availability**
   - Check if MCP servers are running
   - Validate MCP tool connectivity
   - Test tool responses

3. **Agent File Validation**
   - Verify all 79 agent `.md` files are accessible
   - Validate YAML frontmatter parsing for 52 hook-enabled agents
   - Check hook syntax correctness

### Phase 2: Hook Level Testing

#### Level 1: Simple Logging Hooks
**Agents to Test**: `hello-agent`, basic core agents

**Test Cases**:
```bash
# Test basic echo functionality
claude-flow hooks pre-task --description "Test logging hook"

# Expected Output:
# 🔄 Executing pre-task hook...
# 📋 Task: Test logging hook
# 🆔 Task ID: task-xxxxx
#  💾 Saved to .swarm/memory.db
```

**Validation Criteria**:
- Hook executes without errors
- Proper echo output formatting
- Memory store integration works
- Task ID generation works

#### Level 2: Validation Hooks
**Agents to Test**: `coder`, `researcher`, `reviewer`

**Test Cases**:
```bash
# Test file existence checks
touch package.json
claude-flow hooks pre-task --description "test file checks" --agent-id coder

# Test command availability
claude-flow hooks pre-task --description "test npm availability"
```

**Validation Criteria**:
- File existence checks work correctly
- Command availability detection functions
- Environment validation passes
- Error handling for missing files/commands

#### Level 3: Execution Hooks
**Agents to Test**: `tester`, `perf-analyzer`, `production-validator`

**Test Cases**:
```bash
# Test npm command execution
claude-flow hooks post-task --task-id test-execution --agent-id tester

# Test grep/find operations
echo "TODO: fix this" > test-file.txt
claude-flow hooks pre-task --description "validate production ready"
```

**Validation Criteria**:
- External commands execute properly
- Output parsing works correctly
- Exit code handling functions
- Error messages display appropriately

#### Level 4: MCP Integration Hooks
**Agents to Test**: `hierarchical-coordinator`, `mesh-coordinator`, `swarm-memory-manager`

**Test Cases**:
```bash
# Test MCP tool integration
claude-flow hooks pre-task --description "initialize swarm" --agent-id hierarchical-coordinator

# Test memory namespace operations
claude-flow hooks pre-task --description "setup memory management" --agent-id swarm-memory-manager
```

**Validation Criteria**:
- MCP tools are accessible and responsive
- Memory namespace operations work
- Swarm initialization succeeds
- Coordination data is stored correctly

#### Level 5: Complex Orchestration Hooks
**Agents to Test**: `adaptive-coordinator`, `collective-intelligence-coordinator`

**Test Cases**:
```bash
# Test complex multi-step workflows
claude-flow hooks pre-task --description "complex distributed task" --agent-id adaptive-coordinator

# Test cross-agent coordination
claude-flow hooks pre-task --description "swarm intelligence task" --agent-id collective-intelligence-coordinator
```

**Validation Criteria**:
- Multi-step workflows execute sequentially
- Cross-agent communication works
- Topology adaptation functions
- Complex decision-making operates correctly

---

## Specific Hook Testing

### Pre-Task Hooks Testing

#### Core Development Agents
```bash
# Test coder agent hook
claude-flow hooks pre-task --description "implement user authentication" --agent-id coder

# Test researcher agent hook
claude-flow hooks pre-task --description "research database options" --agent-id researcher

# Test reviewer agent hook
claude-flow hooks pre-task --description "review API design" --agent-id reviewer
```

**Expected Behaviors**:
- Appropriate emoji and agent identification
- Task-specific preprocessing
- Memory initialization for agent context

#### Swarm Coordination Agents
```bash
# Test hierarchical coordinator
claude-flow hooks pre-task --description "coordinate microservices deployment" --agent-id hierarchical-coordinator

# Test mesh coordinator
claude-flow hooks pre-task --description "establish p2p communication" --agent-id mesh-coordinator

# Test adaptive coordinator
claude-flow hooks pre-task --description "adapt topology for complex task" --agent-id adaptive-coordinator
```

**Expected Behaviors**:
- Swarm topology initialization
- MCP tool integration
- Memory namespace setup
- Coordination status storage

### Post-Task Hooks Testing

#### Validation & Testing Agents
```bash
# Test production validator
claude-flow hooks post-task --task-id validate-prod --agent-id production-validator

# Test TDD London swarm
claude-flow hooks post-task --task-id test-complete --agent-id tdd-london-swarm

# Test performance analyzer
claude-flow hooks post-task --task-id analyze-perf --agent-id perf-analyzer
```

**Expected Behaviors**:
- Production readiness validation
- Test execution and reporting
- Performance metrics collection
- Memory storage of results

---

## Automated Test Script

### Hook Test Runner

Create `test/hooks/test_all_hooks.sh`:

```bash
#!/bin/bash

# Hook Functionality Test Suite
# Tests all agent hooks systematically

echo "🧪 Starting Agent Hook Functionality Tests"
echo "=========================================="

# Initialize test environment
TEST_DIR="test/hooks"
RESULTS_DIR="$TEST_DIR/results"
mkdir -p "$RESULTS_DIR"

# Test results file
RESULTS_FILE="$RESULTS_DIR/hook_test_results_$(date +%Y%m%d_%H%M%S).log"
echo "Hook Test Results - $(date)" > "$RESULTS_FILE"

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Test function
test_hook() {
    local hook_type="$1"
    local agent_id="$2"
    local description="$3"
    local expected_output="$4"

    echo "Testing: $hook_type for $agent_id"
    echo "Description: $description"

    # Execute hook command
    if command -v claude-flow >/dev/null 2>&1; then
        OUTPUT=$(claude-flow hooks "$hook_type" --description "$description" --agent-id "$agent_id" 2>&1)
        EXIT_CODE=$?

        if [ $EXIT_CODE -eq 0 ]; then
            echo -e "${GREEN}✅ PASS${NC}: $hook_type - $agent_id"
            echo "✅ PASS: $hook_type - $agent_id" >> "$RESULTS_FILE"
        else
            echo -e "${RED}❌ FAIL${NC}: $hook_type - $agent_id (Exit code: $EXIT_CODE)"
            echo "❌ FAIL: $hook_type - $agent_id (Exit code: $EXIT_CODE)" >> "$RESULTS_FILE"
            echo "Error output: $OUTPUT" >> "$RESULTS_FILE"
        fi
    else
        echo -e "${YELLOW}⚠️  SKIP${NC}: claude-flow command not found"
        echo "⚠️ SKIP: claude-flow command not found" >> "$RESULTS_FILE"
    fi

    echo "---" >> "$RESULTS_FILE"
}

# Level 1: Basic Logging Hooks
echo ""
echo "📝 Level 1: Basic Logging Hooks"
echo "==============================="

test_hook "pre-task" "hello-agent" "test greeting functionality" "Hello Agent activated"
test_hook "pre-task" "coder" "basic implementation task" "💻 Coder agent implementing"

# Level 2: Validation Hooks
echo ""
echo "🔍 Level 2: Validation Hooks"
echo "============================="

test_hook "pre-task" "researcher" "research task setup" "🔍 Research agent investigating"
test_hook "pre-task" "reviewer" "review task preparation" "👀 Reviewer agent analyzing"

# Level 3: Execution Hooks
echo ""
echo "⚡ Level 3: Execution Hooks"
echo "==========================="

test_hook "post-task" "tester" "test execution validation" "Test results summary"
test_hook "post-task" "production-validator" "production readiness check" "Production Validator"

# Level 4: MCP Integration Hooks
echo ""
echo "🔌 Level 4: MCP Integration Hooks"
echo "================================="

test_hook "pre-task" "hierarchical-coordinator" "swarm initialization" "Hierarchical Coordinator"
test_hook "pre-task" "swarm-memory-manager" "memory management setup" "Swarm Memory Manager"

# Level 5: Complex Orchestration Hooks
echo ""
echo "🎭 Level 5: Complex Orchestration Hooks"
echo "======================================"

test_hook "pre-task" "adaptive-coordinator" "topology adaptation" "Adaptive Coordinator"
test_hook "pre-task" "collective-intelligence-coordinator" "intelligence coordination" "Collective Intelligence"

# Summary
echo ""
echo "📊 Test Summary"
echo "==============="
TOTAL_TESTS=$(grep -c "PASS\|FAIL\|SKIP" "$RESULTS_FILE")
PASS_COUNT=$(grep -c "✅ PASS" "$RESULTS_FILE")
FAIL_COUNT=$(grep -c "❌ FAIL" "$RESULTS_FILE")
SKIP_COUNT=$(grep -c "⚠️ SKIP" "$RESULTS_FILE")

echo "Total Tests: $TOTAL_TESTS"
echo "Passed: $PASS_COUNT"
echo "Failed: $FAIL_COUNT"
echo "Skipped: $SKIP_COUNT"

if [ $FAIL_COUNT -eq 0 ]; then
    echo -e "${GREEN}🎉 All tests passed!${NC}"
else
    echo -e "${RED}⚠️  Some tests failed. Check $RESULTS_FILE for details.${NC}"
fi

echo ""
echo "Detailed results saved to: $RESULTS_FILE"
```

### Hook Validation Checklist

Create `test/hooks/hook_validation_checklist.md`:

```markdown
# Hook Validation Checklist

## Environment Setup
- [ ] SQLite database initialized at `.swarm/memory.db`
- [ ] Memory store operations functional
- [ ] MCP servers running (if available)
- [ ] Agent files accessible and parseable
- [ ] YAML frontmatter validation working

## Level 1: Basic Logging
- [ ] Hello agent hook executes
- [ ] Emoji formatting displays correctly
- [ ] Task description processing works
- [ ] Memory store integration functions

## Level 2: Validation Hooks
- [ ] File existence checks work
- [ ] Command availability detection functions
- [ ] Environment validation passes
- [ ] Error handling displays properly

## Level 3: Execution Hooks
- [ ] External commands execute
- [ ] Output parsing works correctly
- [ ] Exit code handling functions
- [ ] Performance metrics collection works

## Level 4: MCP Integration
- [ ] MCP tools are accessible
- [ ] Memory namespace operations work
- [ ] Swarm initialization succeeds
- [ ] Coordination data stores correctly

## Level 5: Complex Orchestration
- [ ] Multi-step workflows execute
- [ ] Cross-agent communication works
- [ ] Topology adaptation functions
- [ ] Complex decision-making operates

## Post-Hook Validation
- [ ] All test results documented
- [ ] Failed hooks analyzed
- [ ] Performance metrics collected
- [ ] Recommendations documented
```

---

## Manual Testing Procedures

### Individual Hook Testing

For each agent hook, follow this procedure:

1. **Pre-Test Setup**
   ```bash
   # Clean memory store
   rm -f .swarm/memory.db

   # Ensure agent file exists
   ls .claude/agents/[agent-name].md
   ```

2. **Execute Hook**
   ```bash
   # Pre-task hook
   claude-flow hooks pre-task --description "test task" --agent-id [agent-name]

   # Post-task hook
   claude-flow hooks post-task --task-id test-[agent-name] --agent-id [agent-name]
   ```

3. **Validate Results**
   - Check console output for expected messages
   - Verify memory store entries (`.swarm/memory.db`)
   - Validate MCP tool responses (if applicable)
   - Check for any error messages

4. **Document Results**
   - Pass/Fail status
   - Any error messages
   - Performance metrics
   - Recommendations

---

## Expected Outcomes

### Successful Hook Execution
- Hook executes without errors
- Expected output displays correctly
- Memory operations complete successfully
- MCP tools respond appropriately (for advanced hooks)

### Common Failure Points
- Missing MCP servers (Level 4+ hooks)
- Memory store permission issues
- Agent file parsing errors
- External tool dependencies missing

### Performance Benchmarks
- Level 1-3 hooks: < 2 seconds
- Level 4 hooks: < 5 seconds
- Level 5 hooks: < 10 seconds

---

## Next Steps

1. **Execute automated test suite**
2. **Document any failures**
3. **Fix identified issues**
4. **Re-test failed hooks**
5. **Update documentation**
6. **Create hook templates based on working examples**

---

*Created: $(date)*
*Purpose: Comprehensive testing of all agent hooks for functionality validation*