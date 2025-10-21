# Tree-Style Agent Selection - Implementation Status

## ✅ Completed Steps

### 1. Package Installation
```bash
npm install enquirer --save --legacy-peer-deps
```
- ✅ Enquirer v2.x installed successfully
- Allows for more flexible interactive prompts

### 2. Data Structure Created
- ✅ Created `AGENT_TREE` array with all 74+ agents
- ✅ Organized into 15 categories
- ✅ Each category has:
  - `name`: Category ID  
  - `title`: Display name
  - `preview`: First few agent names (e.g., "planner, coder, researcher...")
  - `agents`: Array of agents with name, value, description

### 3. Imports Added
```javascript
import { Select } from 'enquirer';
```

## 🚧 Remaining Implementation

### Need to Implement: `selectAgentsWithTree()` Function

The function needs to:
1. Show all 15 categories in one view with previews
2. Allow → (right arrow) to expand a category
3. Show checkboxes for agents when expanded
4. Allow ← (left arrow) to collapse back
5. Track selected agents across categories
6. Return array of selected agent IDs

### Implementation Approach

**Option A: Custom Enquirer Prompt (Recommended)**

Create an interactive menu that:
- Shows: `> Category Name - preview...`
- On → : Expand to show agents with checkboxes
- On ← : Collapse back to summary
- On space: Toggle agent selection
- On enter: Confirm and continue

```javascript
async function selectAgentsWithTree() {
  console.log(chalk.cyan('\nAgent Selection\n'));
  console.log(chalk.gray('Use ↑↓ to navigate, → to expand category, ← to collapse'));
  console.log(chalk.gray('Space to select/deselect agents, Enter to continue\n'));
  
  const selectedAgents = new Set();
  const expandedCategories = new Set();
  let currentIndex = 0;
  let done = false;
  
  while (!done) {
    // Build choices based on expanded state
    const choices = [];
    
    AGENT_TREE.forEach((category, catIndex) => {
      if (expandedCategories.has(category.name)) {
        // Show expanded with agents
        choices.push({
          name: `▼ ${category.title}`,
          value: `collapse:${category.name}`,
          hint: '[← to collapse]'
        });
        
        category.agents.forEach(agent => {
          const checked = selectedAgents.has(agent.value) ? '☑' : '☐';
          choices.push({
            name: `  ${checked} ${agent.name}`,
            value: `toggle:${agent.value}`,
            hint: ''
          });
        });
      } else {
        // Show collapsed with preview
        choices.push({
          name: `> ${category.title}`,
          value: `expand:${category.name}`,
          hint: `- ${category.preview} [→ to expand]`
        });
      }
    });
    
    choices.push(new inquirer.Separator());
    choices.push({
      name: `Continue with ${selectedAgents.size} selected agents`,
      value: 'done'
    });
    
    const { action } = await inquirer.prompt([{
      type: 'list',
      name: 'action',
      message: `Selected: ${selectedAgents.size} agents`,
      choices: choices,
      pageSize: 20
    }]);
    
    if (action === 'done') {
      done = true;
    } else if (action.startsWith('expand:')) {
      const catName = action.replace('expand:', '');
      expandedCategories.add(catName);
    } else if (action.startsWith('collapse:')) {
      const catName = action.replace('collapse:', '');
      expandedCategories.delete(catName);
    } else if (action.startsWith('toggle:')) {
      const agentId = action.replace('toggle:', '');
      if (selectedAgents.has(agentId)) {
        selectedAgents.delete(agentId);
      } else {
        selectedAgents.add(agentId);
      }
    }
  }
  
  const result = Array.from(selectedAgents);
  
  if (result.length === 0) {
    console.log(chalk.yellow('No agents selected. Using defaults.'));
    return ['planner', 'coder', 'researcher', 'tester'];
  }
  
  console.log(chalk.green(`\n✓ Selected ${result.length} agents\n`));
  return result;
}
```

**Option B: Multi-Step Selection (Simpler)**

1. First prompt: Select which categories to configure
2. For each selected category: Show agents to select
3. Aggregate all selections

This is simpler but doesn't have the expand/collapse in one view.

### Visual Example

**Collapsed View:**
```
Agent Selection

Selected: 0 agents

> Core Development - planner, coder, researcher, tester...      [→ to expand]
> Analysis & Architecture - code-analyzer, system-architect...  [→ to expand]
> Specialized Development - backend-dev, ml-developer...         [→ to expand]
> Coordination & Orchestration - task-orchestrator, mesh...      [→ to expand]
(11 more categories...)

Continue with 0 selected agents
```

**Expanded View (Core Development):**
```
Agent Selection

Selected: 4 agents (planner, coder, researcher, tester)

▼ Core Development                                              [← to collapse]
  ☑ Planner - Task breakdown and coordination
  ☑ Coder - Implementation and coding
  ☑ Researcher - Information gathering and research
  ☑ Tester - Testing and quality assurance
  ☐ Reviewer - Code review and feedback

> Analysis & Architecture - code-analyzer, system-architect...  [→ to expand]
> Specialized Development - backend-dev, ml-developer...         [→ to expand]
(13 more categories...)

Continue with 4 selected agents
```

## Files Modified So Far

### ✅ src/cli/simple-commands/hive-mind.js
- Added `import { Select } from 'enquirer';`
- Created `AGENT_TREE` with all 74+ agents in 15 categories
- Kept `AGENT_CATALOG` for backward compatibility

### ⏳ Still Need To:
1. Implement `selectAgentsWithTree()` function  
2. Replace call to old `selectAgentsHierarchically()` with `selectAgentsWithTree()`
3. Test the interface
4. Apply same changes to `bin/hive-mind.js`

## Testing Plan

```bash
# Test the tree interface
claude-flow hive-mind spawn --wizard

# Expected behavior:
# 1. Shows all 15 categories collapsed with previews
# 2. Navigate with ↑↓ arrow keys
# 3. Press Enter on a category to expand
# 4. Shows agents with checkboxes
# 5. Select/deselect with space or enter
# 6. Can collapse back
# 7. Shows running count of selected agents
# 8. "Continue with X selected agents" at bottom
# 9. Enter to proceed with selections
```

## Alternative: Keyboard Navigation

Since inquirer's `list` type doesn't directly support → and ← for expand/collapse, we have options:

### Option 1: Use Enter to Expand/Collapse
- Simpler implementation
- Enter on "> Category" expands it
- Enter on "▼ Category" collapses it
- Space/Enter on agents to toggle selection

### Option 2: Use Custom Prompt Plugin
- More complex but matches exact requirements
- Would need to create custom inquirer prompt type
- Handles → and ← key events directly

### Option 3: Two-Step Process (Easiest)
- Step 1: Checkbox to select categories
- Step 2: For each category, checkbox to select agents
- Not a tree view but functionally equivalent

## Recommendation

**Implement Option 1** (Enter to expand/collapse) as it's:
- Simpler to implement
- Works with standard inquirer
- Still provides tree-like navigation
- No emojis, clean interface
- All 74+ agents accessible

Then if user wants actual → ← navigation, can enhance with custom prompt later.

## Next Steps

1. **Implement `selectAgentsWithTree()`** function
2. **Integrate with wizard** - Replace old selection
3. **Test** with `claude-flow hive-mind spawn --wizard`
4. **Mirror to bin/hive-mind.js**
5. **Document** the new interface

## Code Location

File: `/home/mewtwo/claude-flow-source/src/cli/simple-commands/hive-mind.js`

Need to add the `selectAgentsWithTree()` function around line 570 (before `spawnSwarmWizard()`)

Then modify `spawnSwarmWizard()` to call:
```javascript
const selectedAgents = await selectAgentsWithTree();
```

Instead of:
```javascript
const selectedAgents = await selectAgentsHierarchically();
```

---

**Status:** 40% Complete  
**Next:** Implement tree selection function  
**ETA:** ~30 minutes to complete
