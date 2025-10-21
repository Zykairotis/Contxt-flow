# Claude-Flow Available Agents - Quick Reference

## 📊 Summary: 74+ Agents Available

### ✅ Now in Hive-Mind Wizard (16 agents)

#### 🎯 Core Development
- `planner` - Task breakdown & coordination
- `coder` - Implementation & coding
- `researcher` - Information gathering
- `tester` - Testing & QA
- `reviewer` - Code review

#### 🏗️ Analysis & Architecture
- `code-analyzer` - Code quality analysis
- `system-architect` - Architecture design
- `perf-analyzer` - Performance optimization

#### 💼 Specialized Development
- `backend-dev` - Backend API development
- `ml-developer` - Machine learning
- `mobile-dev` - Mobile app development

#### 🚀 DevOps & Documentation
- `cicd-engineer` - CI/CD automation
- `api-docs` - API documentation

#### 🌐 Coordination (Advanced)
- `task-orchestrator` - Multi-agent coordination
- `mesh-coordinator` - Distributed coordination

---

## 📚 All Other Available Agents (58+)

### Coordination & Orchestration
- `adaptive-coordinator` - Adaptive coordination strategy
- `hierarchical-coordinator` - Hierarchical swarm coordination
- `queen-coordinator` - Queen-led coordination
- `sparc-coord` - SPARC methodology coordinator
- `sync-coordinator` - Synchronization coordinator
- `collective-intelligence-coordinator` - CI coordination
- `memory-coordinator` - Memory management coordination
- `swarm-init` - Swarm initialization coordinator
- `smart-agent` - Smart automation agent

### Consensus & Synchronization
- `byzantine-coordinator` - Byzantine fault tolerance
- `crdt-synchronizer` - CRDT synchronization
- `gossip-coordinator` - Gossip protocol coordination
- `quorum-manager` - Quorum management
- `raft-manager` - Raft consensus algorithm
- `security-manager` - Security management
- `consensus-builder` - Consensus building

### Analysis & Monitoring
- `analyze-code-quality` - Deep code quality analysis
- `performance-benchmarker` - Performance benchmarking
- `performance-monitor` - Real-time monitoring
- `resource-allocator` - Resource allocation
- `topology-optimizer` - Topology optimization
- `load-balancer` - Load balancing

### GitHub Integration
- `github-modes` - GitHub operational modes
- `pr-manager` - Pull request management
- `issue-tracker` - Issue tracking
- `project-board-sync` - Project board synchronization
- `release-manager` - Release management
- `release-swarm` - Release management swarm
- `code-review-swarm` - Code review swarm
- `multi-repo-swarm` - Multi-repository swarm
- `repo-architect` - Repository architecture planning
- `swarm-pr` - PR swarm operations
- `swarm-issue` - Issue tracking swarm
- `workflow-automation` - Workflow automation

### Development Methodologies
- `sparc-coder` - SPARC implementation
- `implementer-sparc-coder` - SPARC coder implementation
- `code-goal-planner` - Goal-oriented coding
- `goal-planner` - General goal planning
- `sublinear-goal-planner` - Sublinear goal planning
- `pseudocode` - Pseudocode generation
- `specification` - Specification writing
- `refinement` - Code refinement
- `tdd-london-swarm` - TDD London-style swarm

### Swarm Management
- `swarm-memory-manager` - Swarm memory manager
- `scout-explorer` - Exploration and discovery
- `worker-specialist` - Worker specialization

### Specialized Architecture
- `arch-system-design` - Architecture system design

### DevOps & Operations
- `ops-cicd-github` - GitHub CI/CD operations
- `production-validator` - Production validation
- `migration-planner` - Migration planning
- `benchmark-suite` - Benchmark suite execution

### Data & Machine Learning
- `data-ml-model` - ML model development
- `safla-neural` - Neural network agent

### Flow-Nexus Platform Integration
- `flow-nexus-app-store` - App store management
- `flow-nexus-auth` - Authentication handling
- `flow-nexus-challenges` - Challenge management
- `flow-nexus-neural` - Neural network operations
- `flow-nexus-payments` - Payment processing
- `flow-nexus-sandbox` - Sandbox environment
- `flow-nexus-swarm` - Swarm operations
- `flow-nexus-user-tools` - User tool management
- `flow-nexus-workflow` - Workflow management

### Templates & Utilities
- `base-template-generator` - Template generation
- `spec-mobile-react-native` - React Native specs

---

## 🚫 Deprecated Agent Names (DO NOT USE)

These will cause "Agent type not found" errors:

| ❌ Deprecated | ✅ Use Instead |
|--------------|---------------|
| `analyst` | `code-analyzer` |
| `coordinator` | `task-orchestrator`, `adaptive-coordinator`, or `mesh-coordinator` |
| `optimizer` | `perf-analyzer` |
| `architect` | `system-architect` |
| `documenter` | `api-docs` |
| `monitor` | `performance-benchmarker` |
| `specialist` | `system-architect` |

---

## 🎯 How to Use Agents

### From Command Line
```bash
# Interactive wizard (16 agents available)
claude-flow hive-mind spawn --wizard

# Direct spawning with specific agents
claude-flow hive-mind spawn "Build API" \
  --worker-types planner,coder,backend-dev,tester

# Advanced coordination
claude-flow hive-mind spawn "Complex task" \
  --worker-types task-orchestrator,mesh-coordinator,researcher,planner
```

### From MCP Tools
```javascript
// Spawn individual agents
mcp__claude-flow__agent_spawn({
  type: "code-analyzer",
  name: "Quality Agent"
})

// Task orchestration
mcp__claude-flow__agent_spawn({
  type: "task-orchestrator",
  name: "SwarmLead"
})
```

### Programmatically (TypeScript/JavaScript)
```typescript
import { getAgent, isValidAgentType } from './agents/agent-loader.js';

// Check if valid
const isValid = await isValidAgentType('code-analyzer'); // true

// Get agent definition
const agent = await getAgent('backend-dev');
```

---

## 💡 Recommended Agent Combinations

### Full-Stack Development
```bash
--worker-types planner,backend-dev,coder,tester,reviewer,api-docs
```

### Code Quality Audit
```bash
--worker-types code-analyzer,perf-analyzer,system-architect,reviewer
```

### Machine Learning Project
```bash
--worker-types researcher,ml-developer,code-analyzer,tester,api-docs
```

### DevOps & CI/CD
```bash
--worker-types cicd-engineer,production-validator,workflow-automation,tester
```

### Large-Scale Coordination
```bash
--worker-types task-orchestrator,mesh-coordinator,adaptive-coordinator,planner
```

### Mobile App Development
```bash
--worker-types planner,mobile-dev,coder,tester,reviewer,api-docs
```

---

## 📖 Finding More Information

### List All Agents
```bash
claude-flow agents list
```

### Search by Capability
```typescript
import { searchAgents } from './agents/agent-loader.js';
const results = await searchAgents('performance');
```

### Agent Definitions
All agents are defined in `.claude/agents/` directory as Markdown files with YAML frontmatter.

Example structure:
```
.claude/agents/
├── core/
│   ├── coder.md
│   ├── planner.md
│   ├── researcher.md
│   ├── reviewer.md
│   └── tester.md
├── analysis/
│   └── code-analyzer.md
├── coordination/
│   ├── task-orchestrator.md
│   └── mesh-coordinator.md
└── ... (many more)
```

---

## 🔄 Agent Loader Features

### Automatic Legacy Resolution
The agent loader automatically maps deprecated names to modern ones:
```javascript
const LEGACY_AGENT_MAPPING = {
  analyst: 'code-analyzer',
  coordinator: 'task-orchestrator',
  optimizer: 'perf-analyzer',
  // ... etc
}
```

### Caching
Agent definitions are cached for 1 minute for performance.

### Validation
All agent types are validated against available definitions before spawning.

---

## 📊 Statistics

- **Total Agents:** 74+
- **Categories:** ~15 major categories
- **In Hive-Mind Wizard:** 16 (most commonly used)
- **Coordination Specialists:** 10+
- **GitHub Integration:** 8+
- **Development Specialists:** 8+

---

## 🎉 Quick Tips

1. **Start Simple:** Use default 4 agents (planner, coder, researcher, tester)
2. **Add Specialists:** Add backend-dev or ml-developer for specific tasks
3. **Scale Up:** Add coordination agents for complex multi-agent tasks
4. **Quality Focus:** Add code-analyzer and reviewer for quality
5. **Full Automation:** Add cicd-engineer for deployment pipelines

---

**Last Updated:** 2025
**Source:** Claude-Flow v2.7.0
**Total Available:** 74+ agents and growing!
