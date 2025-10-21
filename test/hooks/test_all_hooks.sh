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