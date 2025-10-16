# Claude-Flow Supported Agents (v2.5.0-alpha.140)

## ⚠️ Important: Deprecated Agent Names

**DO NOT USE these generic names - they will fail:**
- ❌ `analyst` → ✅ Use `code-analyzer`
- ❌ `coordinator` → ✅ Use `task-orchestrator`, `adaptive-coordinator`, `mesh-coordinator`, or `hierarchical-coordinator`
- ❌ `optimizer` → ✅ Use `perf-analyzer`
- ❌ `architect` → ✅ Use `system-architect`
- ❌ `documenter` → ✅ Use `api-docs`
- ❌ `monitor` → ✅ Use `performance-benchmarker`
- ❌ `specialist` → ✅ Use `system-architect`

## Legacy Agent Mapping

The system has built-in legacy mapping in `src/agents/agent-loader.ts`:

```typescript
const LEGACY_AGENT_MAPPING = {
  analyst: 'code-analyzer',
  coordinator: 'task-orchestrator', 
  optimizer: 'perf-analyzer',
  documenter: 'api-docs',
  monitor: 'performance-benchmarker',
  specialist: 'system-architect',
  architect: 'system-architect',
}
```

## All Supported Agents (72 total)

**Organized by category with actual file paths:**

### Core Development Agents
- `coder` - Core development and implementation
- `planner` - Project planning and task breakdown
- `researcher` - Research and information gathering
- `reviewer` - Code review and validation
- `tester` - Testing and quality assurance

### Analysis Agents
- `code-analyzer` - Code quality analysis (replaces "analyst")
- `analyze-code-quality` - Deep code quality analysis
- `performance-analyzer` - Performance analysis and optimization

### Architecture Agents
- `system-architect` - System architecture design (replaces "architect")
- `arch-system-design` - Architecture system design
- `repo-architect` - Repository architecture planning

### Coordination Agents
- `task-orchestrator` - Task orchestration (replaces generic "coordinator")
- `adaptive-coordinator` - Adaptive coordination strategy
- `hierarchical-coordinator` - Hierarchical swarm coordination
- `mesh-coordinator` - Mesh network coordination
- `queen-coordinator` - Queen-led coordination
- `sparc-coordinator` - SPARC methodology coordinator
- `sync-coordinator` - Synchronization coordinator
- `collective-intelligence-coordinator` - CI coordination
- `memory-coordinator` - Memory management coordination
- `coordinator-swarm-init` - Swarm initialization coordinator

### Swarm Management
- `swarm` - General swarm operations
- `swarm-issue` - Issue tracking swarm
- `swarm-pr` - Pull request swarm
- `swarm-memory-manager` - Swarm memory manager
- `multi-repo-swarm` - Multi-repository swarm
- `release-swarm` - Release management swarm
- `code-review-swarm` - Code review swarm
- `tdd-london-swarm` - TDD London-style swarm

### GitHub Integration
- `github-modes` - GitHub operational modes
- `github-pr-manager` - PR management
- `pr-manager` - Generic PR manager
- `issue-tracker` - Issue tracking
- `project-board-sync` - Project board synchronization
- `release-manager` - Release management

### Performance & Monitoring
- `performance-benchmarker` - Performance benchmarking (replaces "monitor")
- `performance-monitor` - Real-time monitoring
- `benchmark-suite` - Benchmark suite execution
- `load-balancer` - Load balancing
- `topology-optimizer` - Topology optimization

### Consensus & Synchronization
- `byzantine-coordinator` - Byzantine fault tolerance
- `crdt-synchronizer` - CRDT synchronization
- `gossip-coordinator` - Gossip protocol coordination
- `quorum-manager` - Quorum management
- `raft-manager` - Raft consensus
- `security-manager` - Security management

### Development Methodologies
- `implementer-sparc-coder` - SPARC implementation
- `code-goal-planner` - Goal-oriented coding
- `goal-planner` - General goal planning
- `safla-neural` - Neural network agent
- `pseudocode` - Pseudocode generation
- `specification` - Specification writing
- `refinement` - Code refinement

### Documentation
- `docs-api-openapi` - OpenAPI documentation (replaces "documenter")
- `api-docs` - API documentation

### DevOps & CI/CD
- `ops-cicd-github` - GitHub CI/CD operations
- `automation-smart-agent` - Automation agent
- `workflow-automation` - Workflow automation
- `production-validator` - Production validation
- `migration-plan` - Migration planning

### Data & ML
- `data-ml-model` - ML model development

### Backend Development
- `dev-backend-api` - Backend API development

### Specialized Agents
- `worker-specialist` - Worker specialization
- `scout-explorer` - Exploration and discovery
- `resource-allocator` - Resource allocation
- `orchestrator-task` - Task orchestration

### Flow-Nexus Platform
- `app-store` - App store management
- `authentication` - Authentication handling
- `challenges` - Challenge management
- `neural-network` - Neural network operations
- `payments` - Payment processing
- `sandbox` - Sandbox environment
- `user-tools` - User tool management
- `workflow` - Workflow management

### Templates & Utilities
- `base-template-generator` - Template generation
- `spec-mobile-react-native` - React Native specs

## How to Use

### From TypeScript/JavaScript
```typescript
import { getAgent, isValidAgentType, resolveLegacyAgentType } from './agents/agent-loader.js';

// Check if agent type is valid
const isValid = await isValidAgentType('code-analyzer'); // true
const isInvalid = await isValidAgentType('analyst'); // false (but will auto-resolve)

// Get agent definition
const agent = await getAgent('code-analyzer');

// Resolve legacy names
const modern = resolveLegacyAgentType('analyst'); // returns 'code-analyzer'
```

### From MCP Tools
Use the correct agent names in MCP tool calls:

```typescript
// CORRECT ✅
agent_spawn({ type: "code-analyzer", name: "Code Quality Agent" })
agent_spawn({ type: "adaptive-coordinator", name: "Swarm Coordinator" })

// INCORRECT ❌ (will fail in some versions)
agent_spawn({ type: "analyst", name: "Code Quality Agent" })
agent_spawn({ type: "coordinator", name: "Swarm Coordinator" })
```

## Agent Discovery

List all available agents:
```bash
claude-flow agents list
```

Search agents by capability:
```typescript
import { searchAgents } from './agents/agent-loader.js';
const results = await searchAgents('performance');
```

## Notes

- Total: **74 agent definitions**
- Categories: **~15 categories**
- All agents are defined in `.claude/agents/` directory as Markdown files with YAML frontmatter
- Agent loader has 1-minute cache for performance
- Legacy mapping provides backward compatibility but should not be relied upon
