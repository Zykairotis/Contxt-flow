# Deprecated Agent Names Still Present in Code

## Search Results Summary

Found **multiple occurrences** of deprecated agent names in the codebase:

### 🔴 CRITICAL - Must Fix (User-Facing)

#### 1. **CLI Commands & Examples** (High Priority)
**File: `src/cli/simple-commands/swarm.js`** - Multiple hardcoded deprecated names in example prompts
- Line: Multiple instances of `"coordinator"`, `"analyst"`, `"architect"` in spawn examples
- Impact: Users copy these examples and get errors
- Fix: Replace with modern names or add note about auto-resolution

**File: `src/cli/simple-commands/hive-mind.js`**
- Uses `"analyst"` in Task examples
- Impact: Users copy-paste broken examples

**File: `src/cli/simple-commands/automation.js`**
- Multiple references to deprecated `'analyst'` and `'coordinator'` types
- Impact: Automation workflows might fail

**File: `src/cli/commands/help.ts`**
- Documentation shows: `'{"id": "analyzer", "type": "analyst"}'`
- Impact: Help text teaches users wrong names

**File: `src/cli/commands/ruv-swarm.ts`**
- Lists: `'Valid types: researcher, coder, analyst, optimizer, coordinator'`
- Impact: Misleading error messages

#### 2. **Template Files** (Medium Priority)
**File: `src/cli/simple-commands/init/templates/sparc-modes.js`**
- Contains: `mode: "architect"`
- Impact: Generated templates use deprecated names

**File: `src/cli/simple-commands/init/claude-commands/sparc-commands.js`**
- Contains: `mode: "architect"`
- Impact: Init command creates broken configurations

### 🟡 MEDIUM - Should Fix (Internal Code)

#### 3. **Agent Class Files** (Keep for backward compatibility)
**Files:**
- `src/cli/agents/analyst.ts` - Actual Analyst class
- `src/cli/agents/architect.ts` - Actual Architect class  
- `src/cli/agents/coordinator.ts` - Actual Coordinator class

**Status:** These are LEGACY class implementations
**Action:** Keep but mark as deprecated, or refactor to use modern names

#### 4. **Agent Capabilities** 
**File: `src/cli/agents/capabilities.ts`**
- Switch cases for: `'analyst'`, `'architect'`, `'coordinator'`
- Impact: Capability detection might fail for modern names
- Fix: Add cases for modern names OR apply legacy resolution

#### 5. **Agent Manager Templates**
**File: `src/agents/agent-manager.ts`**
- Creates template: `this.templates.set('analyst', {...})`
- Impact: Internal template system uses old names
- Fix: Either update or ensure it uses legacy resolution

#### 6. **Hive Mind System**
**File: `src/cli/agents/hive-agents.ts`**
- Type: `'queen' | 'worker' | 'scout' | 'guardian' | 'architect'`
- Uses: `super(id, 'coordinator', ...)` and `super(id, 'architect', ...)`
- Impact: Hive agents might not spawn correctly
- Fix: Update to modern equivalents or apply resolution

### 🟢 LOW - Test/Debug Only

#### 7. **Test Files** (Low Priority - Expected)
**Files:**
- `src/__tests__/integration/swarm-sdk-integration.test.ts`
- `src/__tests__/regression/backward-compatibility.test.ts`
- `src/__tests__/session-forking.test.ts`

**Status:** Tests should include deprecated names to verify backward compatibility
**Action:** Keep but add tests for modern names too

#### 8. **Documentation/Help Files**
**Files:**
- `src/cli/help-text.js` - Shows deprecated agent types in examples
- `src/cli/command-registry.js` - Example commands use `coordinator`
- `src/cli/repl.ts` - Mock data uses `'coordinator'`

**Status:** Educational/example content
**Action:** Update examples to use modern names with deprecation notices

### 🔵 TypeScript Type Definition

#### 9. **Core Type Definition** (Already Noted)
**File: `src/swarm/types.ts`**
```typescript
export type AgentType =
  | 'coordinator' // ⚠️ Deprecated
  | 'analyst'     // ⚠️ Deprecated
  | 'architect'   // ⚠️ Deprecated
  | 'optimizer'   // ⚠️ Deprecated
  | 'documenter'  // ⚠️ Deprecated
  | 'monitor'     // ⚠️ Deprecated
  | 'specialist'  // ⚠️ Deprecated
  ...
```

**Status:** Should be updated or converted to dynamic string type
**Action:** Option 1: Mark as deprecated with JSDoc comments
           Option 2: Remove and use `type AgentType = string;`

## Summary Statistics

| Category | Files Affected | Priority | Status |
|----------|---------------|----------|---------|
| CLI Commands & Examples | 8 files | 🔴 Critical | Needs Fix |
| Template Files | 2 files | 🟡 Medium | Needs Fix |
| Agent Classes | 3 files | 🟡 Medium | Keep/Refactor |
| Test Files | 3 files | 🟢 Low | Keep |
| Type Definitions | 1 file | 🔵 Info | Already Noted |
| **TOTAL** | **17+ files** | - | - |

## Recommended Actions

### Phase 1: User-Facing (Critical) - Do Now ✅
1. ✅ Fix MCP tool handlers (DONE)
2. ⬜ Update CLI command examples in:
   - `swarm.js`
   - `hive-mind.js`
   - `automation.js`
   - `help.ts`
3. ⬜ Update template files:
   - `sparc-modes.js`
   - `sparc-commands.js`

### Phase 2: Internal Code (Medium) - Next Sprint
4. ⬜ Update agent capability detection
5. ⬜ Refactor agent manager templates
6. ⬜ Update hive agent types

### Phase 3: Documentation (Low) - When Time Permits
7. ⬜ Add deprecation notices to help text
8. ⬜ Update example commands
9. ⬜ Add migration guide

### Phase 4: Type System (Optional) - Future
10. ⬜ Update TypeScript types with deprecation hints
11. ⬜ Consider dynamic type system

## Impact Assessment

### Current Status After MCP Fix
- ✅ **MCP Tools**: Fixed - Users can use deprecated names in API calls
- ❌ **Examples**: Broken - Users copy-paste broken code from docs
- ❌ **Help Text**: Misleading - Shows deprecated names as valid
- ⚠️ **Internal Systems**: Mixed - Some parts might fail with modern names

### Risk Level
- **High**: Users following documentation will fail
- **Medium**: Internal agent spawning might have issues
- **Low**: Tests and type hints are just warnings

## Files That Need Updates

### Priority 1 (User Impact)
```
src/cli/simple-commands/swarm.js
src/cli/simple-commands/hive-mind.js  
src/cli/simple-commands/automation.js
src/cli/commands/help.ts
src/cli/commands/ruv-swarm.ts
src/cli/simple-commands/init/templates/sparc-modes.js
src/cli/simple-commands/init/claude-commands/sparc-commands.js
```

### Priority 2 (Internal Logic)
```
src/cli/agents/capabilities.ts
src/agents/agent-manager.ts
src/cli/agents/hive-agents.ts
```

### Priority 3 (Documentation)
```
src/cli/help-text.js
src/cli/command-registry.js
src/cli/repl.ts
```

## Next Steps

Would you like me to:
1. **Fix Priority 1 files** (examples and documentation)?
2. **Fix Priority 2 files** (internal agent logic)?
3. **Create a migration script** to update all at once?
4. **Add deprecation warnings** when old names are used?
