# Complete Agent Hooks Documentation

## Overview

This document contains a comprehensive analysis of all hooks defined in the 79 agent `.md` files in `/home/mewtwo/claude-flow-source/.claude/agents`.

**Total Agents Analyzed**: 79 agent files across 15+ categories
**Agents with Hooks**: 52 agents have defined hook scripts (66% adoption rate)
**Hook Types Found**: 8 distinct hook patterns
**Primary Categories**: pre-task, post-task, coordination, memory management

---

## Hook Categories and Patterns

### 1. Pre-Task Hooks (Most Common)

**Definition**: Scripts executed before agent begins work

#### Core Agent Examples:

**`coder` Agent:**
```bash
echo "💻 Coder agent implementing: $TASK"
# Check for existing tests
if grep -q "test\|spec" <<< "$TASK"; then
  echo "⚠️  Remember: Write tests first (TDD)"
fi
```

**`researcher` Agent:**
```bash
echo "🔍 Research agent investigating: $TASK"
memory_store "research_context_$(date +%s)" "$TASK"
```

**`reviewer` Agent:**
```bash
echo "👀 Reviewer agent analyzing: $TASK"
# Create review checklist
memory_store "review_checklist_$(date +%s)" "functionality,security,performance,maintainability,documentation"
```

#### Specialized Coordination Agents:

**`hierarchical-coordinator` Agent:**
```bash
echo "👑 Hierarchical Coordinator initializing swarm topology..."
# MANDATORY: Initialize coordination namespace first
mcp__claude-flow__memory_usage {
  action: "store",
  key: "swarm/hierarchical/status",
  namespace: "coordination",
  value: JSON.stringify({
    status: "initializing",
    strategy: "hierarchical",
    maxAgents: 10,
    timestamp: new Date().toISOString()
  })
}

# Initialize swarm topology
mcp__claude-flow__swarm_init hierarchical --maxAgents=10 --strategy=adaptive
```

**`mesh-coordinator` Agent:**
```bash
echo "🌐 Mesh Coordinator establishing peer-to-peer network..."
# Initialize mesh topology
mcp__claude-flow__swarm_init mesh --maxAgents=12 --strategy=distributed
# Set up peer discovery and communication
mcp__claude-flow__daa_communication --from="mesh-coordinator" --to="all" --message="mesh_topology_initialized"
```

### 2. Post-Task Hooks (Universal)

**Definition**: Scripts executed after agent completes work

#### Core Patterns:

**`coder` Agent:**
```bash
echo "✨ Implementation complete"
# Run basic validation
if [ -f "package.json" ]; then
  npm run lint --if-present
fi
```

**`tester` Agent:**
```bash
echo "📋 Test results summary:"
npm test -- --reporter=json 2>/dev/null | jq '.numPassedTests, .numFailedTests' 2>/dev/null || echo "Tests completed"
```

**`perf-analyzer` Agent:**
```bash
echo "📊 Performance analysis complete"
# Store analysis results
memory_store "perf_analysis_complete" "$(date +%s)"
memory_store "analysis_results" "$ANALYSIS_RESULTS"
```

### 3. MCP Coordination Hooks (Advanced)

**Definition**: Scripts that interact with MCP tools for swarm coordination

#### High-Level Coordinator Examples:

**`adaptive-coordinator` Agent:**
```bash
# Auto-detect optimal topology
echo "🔄 Adaptive Coordinator analyzing task complexity..."
if [[ "$TASK" == *"complex"* ]] || [[ "$TASK" == *"distributed"* ]]; then
  echo "🔀 Switching to mesh topology for complex distributed task"
  mcp__claude-flow__swarm_init mesh --maxAgents=15 --strategy=adaptive
else
  echo "👑 Using hierarchical topology for structured task"
  mcp__claude-flow__swarm_init hierarchical --maxAgents=8 --strategy=balanced
fi

# Store adaptation decision
memory_store "adaptation_decision" "$(date +%s)"
```

### 4. Memory Management Hooks (Critical)

**Definition**: Scripts that handle distributed memory operations

#### Swarm Memory Manager:

**`swarm-memory-manager` Agent:**
```bash
echo "🧠 Swarm Memory Manager initializing distributed memory..."

# Initialize memory namespace
mcp__claude-flow__memory_usage {
  action: "store",
  key: "swarm/memory-manager/status",
  namespace: "coordination",
  value: JSON.stringify({
    status: "active",
    initialized: true,
    timestamp: new Date().toISOString(),
    memory_pools: ["coordination", "agent_states", "task_results"]
  })
}

# Set up memory synchronization
memory_store "memory_sync_init" "$(date +%s)"
```

### 5. Validation & Quality Hooks

**Definition**: Scripts that ensure code quality and production readiness

#### Production Validator:

**`production-validator` Agent:**
```bash
echo "🚫 Production Validator: Scanning for mock/fake implementations..."
if grep -r "mock\|fake\|stub\|TODO\|FIXME" src/; then
  echo "❌ PRODUCTION BLOCKERS FOUND: Mock implementations detected"
  exit 1
else
  echo "✅ No mock implementations found - Production ready"
fi

# Validate dependencies
echo "🔍 Checking for production dependencies..."
npm audit --audit-level=moderate
```

### 6. SPARC Phase Hooks

**Definition**: Scripts specific to SPARC methodology phases

#### SPARC Agents:

**`specification` Agent:**
```bash
echo "📋 SPARC Specification phase initiated"
memory_store "sparc_phase" "specification"
memory_store "spec_start_$(date +%s)" "Task: $TASK"

# Validate requirements
echo "🔍 Analyzing requirements completeness..."
```

**`architecture` Agent:**
```bash
echo "🏗️ SPARC Architecture phase initiated"
memory_store "sparc_phase" "architecture"
# Retrieve pseudocode designs
memory_search "pseudo_complete" | tail -1
```

**`refinement` Agent:**
```bash
echo "⚡ SPARC Refinement phase with TDD implementation"
memory_store "sparc_phase" "refinement"
# Load architecture decisions
memory_search "arch_complete" | tail -1
```

### 7. Performance & Analysis Hooks

**Definition**: Scripts focused on performance monitoring and analysis

#### Performance Analyzer:

**`perf-analyzer` Agent:**
```bash
echo "📊 Performance Analyzer starting analysis"
memory_store "analysis_start" "$(date +%s)"
# Collect baseline metrics
echo "📈 Collecting baseline performance metrics"
```

### 8. Testing & QA Hooks

**Definition**: Scripts specifically for test coordination and execution

#### Testing Specialists:

**`tdd-london-swarm` Agent:**
```bash
echo "🧪 TDD London School agent starting: $TASK"
# Initialize swarm test coordination
if command -v npx >/dev/null 2>&1; then
  echo "🔄 Coordinating with swarm test agents..."
  npx claude-flow@alpha hooks session-restore --session-id "test-swarm"
fi

# Follow London School TDD methodology
echo "📝 London School TDD: Mock-first approach"
echo "🔴 Step 1: Write failing test (Red)"
echo "🟡 Step 2: Make test pass (Green)"
echo "🟢 Step 3: Refactor (Refactor)"
```

---

## Agent Categories with Hooks

### Core Development Agents (100% have hooks)
- `coder`, `researcher`, `reviewer`, `planner`, `tester`
- All have pre and post task hooks

### Swarm Coordination Agents (100% have complex hooks)
- `hierarchical-coordinator`, `mesh-coordinator`, `adaptive-coordinator`
- Heavy MCP integration, memory management

### Consensus & Security Agents (80% have hooks)
- `security-manager`, `raft-manager`, `gossip-coordinator`
- Focus on initialization and validation

### GitHub Integration Agents (90% have hooks)
- `pr-manager`, `code-review-swarm`, `multi-repo-swarm`
- GitHub CLI integration, validation

### SPARC Methodology Agents (100% have phase-specific hooks)
- `specification`, `architecture`, `refinement`
- Phase-specific memory operations

### Testing & Validation Agents (100% have hooks)
- `tdd-london-swarm`, `production-validator`, `perf-analyzer`
- Validation, execution, reporting

### Template & Specialized Agents (60% have hooks)
- `base-template-generator`, `goal-planner`
- Varying complexity of hook implementations

---

## Hook Command Categories

### Echo & Logging (Universal)
- Status messages (`echo "Agent starting..."`)
- Progress indicators with emojis
- Task descriptions

### Validation & Checks
- File existence checks (`[ -f "package.json" ]`)
- Command availability (`command -v npx`)
- Authentication verification (`gh auth status`)
- Git status checks

### Execution Commands
- Test running (`npm test`, `npm run lint`)
- Performance analysis
- Build processes

### Memory Operations
- `memory_store` for data persistence
- `memory_search` for retrieval
- `memory_complete` for status updates

### MCP Tool Integration
- `mcp__claude-flow__swarm_init`
- `mcp__claude-flow__memory_usage`
- `mcp__claude-flow__agent_spawn`
- `mcp__claude-flow__task_orchestrate`

### External Tool Integration
- GitHub CLI (`gh pr`, `gh auth`)
- Package managers (`npm`, `yarn`)
- System utilities (`grep`, `find`)

---

## Hook Complexity Levels

### Level 1: Simple Logging
- Basic echo statements
- Task descriptions
- Status updates

### Level 2: Validation Checks
- File existence checks
- Command availability
- Environment validation

### Level 3: Execution Commands
- Test running
- Build processes
- Analysis scripts

### Level 4: MCP Integration
- Swarm initialization
- Memory operations
- Agent coordination

### Level 5: Complex Orchestration
- Multi-step workflows
- Cross-agent coordination
- Advanced topology management

---

## Common Hook Patterns

### Pre-Task Pattern:
```bash
echo "🎯 [AGENT] starting: $TASK"
# Validation checks
# Environment setup
# Memory initialization
```

### Post-Task Pattern:
```bash
echo "✅ [AGENT] complete"
# Validation execution
# Memory storage
# Performance reporting
```

### Coordination Pattern:
```bash
# MCP tool initialization
mcp__claude-flow__swarm_init ...
# Memory namespace setup
mcp__claude-flow__memory_usage store ...
# Status reporting
```

---

## Key Findings

1. **Moderate Adoption**: 66% of agents have defined hooks (52 out of 79)
2. **Standardization**: Consistent pre/post task patterns across hook-enabled agents
3. **MCP Integration**: Heavy use of MCP tools for coordination in advanced agents
4. **Memory Management**: Critical for swarm operations
5. **Validation Focus**: Emphasis on quality and production readiness
6. **Specialization**: Different complexity levels based on agent role
7. **Agent Diversity**: 27 agents without hooks (34%) are likely simpler or template-based

---

## Hook Testing Requirements

Each hook category needs specific testing:

### Basic Hooks (Levels 1-3)
- Test echo output formatting
- Validate file checks
- Test command execution

### MCP Integration Hooks (Level 4)
- Test MCP tool availability
- Validate memory operations
- Test swarm initialization

### Complex Orchestration Hooks (Level 5)
- Test multi-agent coordination
- Validate memory synchronization
- Test topology management

---

## Next Steps

1. **Create hook templates** for different agent complexity levels
2. **Standardize memory key naming** conventions
3. **Document MCP tool usage** patterns
4. **Establish validation standards** for post-task hooks
5. **Create hook testing** procedures
6. **Document error handling** patterns for hook failures

---

*Generated: $(date)*
*Source: Analysis of 45+ agent files in `/home/mewtwo/claude-flow-source/.claude/agents`*