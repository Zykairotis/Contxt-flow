# .claude Directory - Deprecated Agent Names Findings

## Critical Discovery ⚠️

Found **656 instances** of deprecated agent names in the `.claude` directory!

## Breakdown

### Issue 1: Agent Definition YAML `type:` Field (14 files) 🔴

**CRITICAL:** Agent definition files have `type: coordinator/analyst/architect` in YAML frontmatter

**Files affected:**
1. `.claude/agents/consensus/byzantine-coordinator.md` - `type: coordinator`
2. `.claude/agents/consensus/gossip-coordinator.md` - `type: coordinator`
3. `.claude/agents/consensus/performance-benchmarker.md` - `type: analyst`
4. `.claude/agents/consensus/quorum-manager.md` - `type: coordinator`
5. `.claude/agents/consensus/raft-manager.md` - `type: coordinator`
6. `.claude/agents/core/planner.md` - `type: coordinator`
7. `.claude/agents/core/researcher.md` - `type: analyst`
8. `.claude/agents/github/repo-architect.md` - `type: architecture`
9. `.claude/agents/sparc/architecture.md` - `type: architect`
10. `.claude/agents/sparc/pseudocode.md` - `type: architect`
11. `.claude/agents/sparc/specification.md` - `type: analyst`
12. `.claude/agents/swarm/adaptive-coordinator.md` - `type: coordinator`
13. `.claude/agents/swarm/hierarchical-coordinator.md` - `type: coordinator`
14. `.claude/agents/swarm/mesh-coordinator.md` - `type: coordinator`

**Example:**
```yaml
---
name: planner
type: coordinator  # ⚠️ DEPRECATED - should be what?
color: "#4ECDC4"
description: Strategic planning and task orchestration agent
---
```

**Impact:**
- The `type` field is loaded by `agent-loader.ts`
- Used by `agent-manager.ts` for filtering
- Used by `agent-registry.ts` for tagging
- Stored in AgentDefinition interface

**Question:** What should these `type:` values be?
- Is `type:` a category field (separate from agent name)?
- Should it use modern names or is it meant to be a classification?

### Issue 2: Documentation/Examples (600+ instances) 🟡

**Widespread references** in agent documentation text:

#### Descriptive Text:
- "You are an expert **architect**..." (legitimate descriptions)
- "Design the **architecture**..." (legitimate technical terms)
- "Plan the **architecture**" (legitimate usage)

#### Code Examples:
**File:** `.claude/agents/flow-nexus/swarm.md`
```javascript
// Deploy Agents
mcp__flow-nexus__agent_spawn({
  type: "researcher", // coder, analyst, optimizer, coordinator  ⚠️
  name: "Lead Researcher",
  capabilities: ["web_search", "analysis", "summarization"]
})

Agent types you deploy:
- **researcher**: Information gathering and analysis specialists
- **coder**: Implementation and development experts
- **analyst**: Data processing and pattern recognition agents  ⚠️
- **optimizer**: Performance tuning and efficiency specialists
- **coordinator**: Workflow management and task orchestration leaders  ⚠️
```

**Impact:** Users copying these examples will use deprecated names

### Issue 3: Other Documentation Files

Found references in:
- `.claude/agents/core/planner.md` - Example: `{id: "2", task: "Design auth flow", assignee: "architect"}`
- `.claude/agents/github/code-review-swarm.md` - `--agents "security,performance,style,architecture,accessibility"`
- Many other files with "architect", "architecture", "coordinator", "analyst" in descriptive text

## Analysis

### What's Legitimate:
✅ **Descriptive language** - "you are an expert architect" (referring to profession)
✅ **Technical terms** - "design the architecture" (referring to system design)
✅ **General English** - "architectural patterns", "coordinate tasks"

### What's Problematic:
❌ **YAML `type:` field** - 14 agent files with deprecated type categories
❌ **Code examples** - flow-nexus/swarm.md shows deprecated agent types
❌ **Example configs** - Some examples use deprecated names

## Impact Assessment

### The `type:` Field Issue:

**Critical Questions:**
1. Is `type:` field used for agent selection/filtering?
2. Is `type:` separate from `name:` (category vs identifier)?
3. Should `type:` be updated or is it intentionally different?

**Code Analysis:**
```typescript
// agent-loader.ts loads the type field:
return {
  name: frontmatter.name,    // e.g., "planner"
  type: frontmatter.type,     // e.g., "coordinator" ⚠️
  description: frontmatter.metadata.description,
  // ...
}
```

**Usage in code:**
- `agent-manager.ts` - Uses `agent.type` for filtering: `filter((agent) => agent.type === type)`
- `agent-registry.ts` - Uses `agent.type` for tagging: `tags: [...tags, agent.type]`

**Potential Problem:**
If code tries to filter agents by `type: "coordinator"`, it might match the wrong agents OR fail because it expects modern names.

### The Examples Issue:

**File:** `.claude/agents/flow-nexus/swarm.md`

Users will copy these examples showing:
```javascript
type: "coordinator"  // Should be "task-orchestrator"
type: "analyst"      // Should be "code-analyzer"
```

This directly contradicts our fix in the main examples!

## Recommendations

### Priority 1: Understand `type:` Field (CRITICAL)

**Need to determine:**
1. Is `type:` field a category (keep as generic) or agent type (update)?
2. Is it used for agent selection in code?
3. What are the valid values for `type:`?

**Two Possible Interpretations:**

#### Interpretation A: `type:` is a Category Field
If `type:` is meant to be a general category/classification:
- ✅ **Keep as-is** - "coordinator", "analyst", "architect" are categories
- ✅ **These are NOT the same as agent names**
- Example: 
  - `name: task-orchestrator` (specific agent)
  - `type: coordinator` (general category)

#### Interpretation B: `type:` is an Agent Type
If `type:` should match modern agent names:
- ❌ **Must update** - Change to modern equivalents
- Update 14 files:
  - `type: coordinator` → `type: orchestration` or `type: coordination`?
  - `type: analyst` → `type: analysis`?
  - `type: architect` → `type: architecture`?

### Priority 2: Fix flow-nexus/swarm.md Examples (HIGH)

**File:** `.claude/agents/flow-nexus/swarm.md`

Update code examples to use modern names:
```javascript
// OLD:
type: "researcher", // coder, analyst, optimizer, coordinator

// NEW:
type: "researcher", // coder, code-analyzer, perf-analyzer, task-orchestrator
```

Update agent type list:
```markdown
Agent types you deploy:
- **researcher**: Information gathering and analysis specialists
- **coder**: Implementation and development experts
- **code-analyzer**: Data processing and pattern recognition agents
- **performance-analyzer**: Performance tuning and efficiency specialists  
- **task-orchestrator**: Workflow management and task orchestration leaders
```

### Priority 3: Review Other Examples (MEDIUM)

Check and update other agent files with example configs

## Immediate Action Required

### Step 1: Clarify `type:` Field Purpose

**Questions for codebase owner:**
1. What is the intended purpose of the `type:` field in agent YAML?
2. Is it a category (generic) or agent type (specific)?
3. Should it match the agent `name:` or be independent?

### Step 2: Based on Answer

**If category field (keep generic):**
- ✅ No changes needed to YAML `type:` fields
- ✅ Document that `type:` is a category, `name:` is identifier
- Consider renaming to `category:` for clarity

**If agent type (specific):**
- ❌ Update 14 agent YAML files
- Change to appropriate modern equivalents
- Update validation logic

### Step 3: Fix Examples Regardless

**Must update:** `.claude/agents/flow-nexus/swarm.md`
- Replace deprecated agent type examples
- Update documentation lists

## Risk Level

### For `type:` Field:
🔴 **UNKNOWN RISK** - Depends on how field is used

If `type:` is used for filtering:
- Could cause agent selection to fail
- Could match wrong agents
- Need to verify usage

### For Examples:
🟠 **MEDIUM RISK**
- Users copying examples will use deprecated names
- But MCP fix will auto-resolve them
- Creates inconsistency with main examples

## Verification Needed

```bash
# Check if type field is used for agent selection
cd /home/mewtwo/claude-flow-source
grep -r "\.type ==\|\.type ===" --include="*.ts" src/ | grep -v test

# Count files with deprecated type: fields
grep -c "^type: coordinator$\|^type: analyst$\|^type: architect$" .claude/agents/**/*.md
```

## Summary

- **Total references:** 656 in .claude directory
- **Critical issues:** 14 agent YAML files with `type:` field
- **Example issues:** 1 file (flow-nexus/swarm.md) with bad examples  
- **Descriptive text:** 600+ legitimate uses of terms
- **Action needed:** Clarify `type:` field purpose, then update accordingly
