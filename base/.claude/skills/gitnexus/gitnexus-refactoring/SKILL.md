---
name: gitnexus-refactoring
description: "Use when the user wants to rename, extract, split, move, or restructure code safely using the knowledge graph."
---

# GitNexus: Refactoring

## When to Use

- Rename a function/class/method across the codebase
- Extract a function or module
- Split a file into multiple files
- Move code between modules/clusters
- Merge related functions

## Workflow

### Rename
1. **Impact analysis:** `gitnexus impact({target: "oldName", direction: "both", depth: 3})`
2. **Coordinated rename:** `gitnexus rename({symbol: "oldName", newName: "newName"})`
   — Returns confidence-tagged edits across all files
3. **Review each edit** — apply high-confidence edits, manually verify low-confidence ones
4. **Run tests** — full suite must pass

### Extract / Split
1. **Identify cluster boundaries:** Read `gitnexus://repo/{name}/clusters`
2. **Impact analysis on each symbol** being moved
3. **Check for circular dependencies** the move would create
4. **Execute the move** — update imports everywhere
5. **Refresh graph:** `npx gitnexus analyze --skills --force`
6. **Verify:** Re-run impact analysis to confirm no broken edges

## Safety Checklist

- [ ] Impact analysis run before any rename/move
- [ ] All affected files identified (not just grep — graph catches dynamic references)
- [ ] Tests pass after each individual refactor step
- [ ] Graph refreshed after completion
- [ ] No new circular dependencies introduced
- [ ] Auto-generated skills refreshed to reflect new structure
