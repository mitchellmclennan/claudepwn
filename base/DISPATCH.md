# Task Dispatch Log — __PROJECT_NAME__

> Dispatcher owns this file. Architect writes tasks. Agents read assignments.
> Never reorder tasks — dependency order matters.

---

## Dispatch Rules

1. Tasks are ordered by dependency — complete prerequisites before dependents
2. An agent may only claim a task if its dependencies are all DONE
3. Status transitions: PENDING → ASSIGNED → IN_PROGRESS → DONE | BLOCKED
4. Blocked tasks get a BLOCKER entry in BOARD.md immediately

---

## Current Sprint: Sprint 1 — [Sprint Name]

<!-- Architect: decompose your PRD epics into tasks using this template -->

### Task Template

```
## Task [EPIC]-[SPRINT]-[TASK]: [Title]

**Agent:** [Architect | Implementer | Tester | Reviewer | SecurityAgent | DocsAgent]
**Priority:** [P0 | P1 | P2]
**Status:** PENDING
**Dependencies:** [Task IDs that must be DONE first, or NONE]

### Description
[What needs to be done]

### Acceptance Criteria
- [ ] [Specific, testable criterion 1]
- [ ] [Specific, testable criterion 2]
- [ ] [Specific, testable criterion 3]

### Context
- Relevant vault notes: [paths]
- Related ADR: [path]

### Completion Notes
[Filled by agent when DONE]
```

---

## Backlog

<!-- Future sprint tasks live here until promoted to active sprint -->

---

## Completed

<!-- DONE tasks move here for historical reference -->
