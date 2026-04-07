# Agent Roster — __PROJECT_NAME__

Last updated: [AUTO-UPDATED BY VaultKeeper]

---

## Agent Index

| Agent | Role | Primary Files | Can Spawn Sub-Agents | Status |
|-------|------|---------------|----------------------|--------|
| Architect | System design, ADRs, dependency graphs | vault/01-Architecture/, vault/03-Decisions/ | Yes | ACTIVE |
| Implementer | Feature coding, refactors, bug fixes | src/, tests/ | Yes | ACTIVE |
| Tester | Test writing, coverage, regression checks | tests/, coverage/ | No | ACTIVE |
| Reviewer | Code review, quality gates, PR summaries | All src/ | No | ACTIVE |
| SecurityAgent | Vulnerability scans, hardening waves | src/, configs | No | ACTIVE |
| DocsAgent | Vault updates, API docs, retrospectives | vault/, docs/ | No | ACTIVE |
| VaultKeeper | Vault sync, index maintenance | vault/ | No | ACTIVE |
| Dispatcher | Task routing, DISPATCH.md management | DISPATCH.md, ROADMAP.md | No | ACTIVE |

---

## How Agents Work

Each agent has an instruction file in `.claude/agents/`. When you assume a role (or Claude assigns one based on the task), read that agent's file for your specific loop, rules, and outputs.

**Agent communication is through BOARD.md.** Every status change, blocker, question, or completion gets posted there. Agents read BOARD.md before starting any task.

**Task assignment is through DISPATCH.md.** The Architect creates tasks, the Dispatcher assigns them, agents pick up their assignments.

---

## Agent Roles (Summary)

### Architect
Reads PRD and ROADMAP. Decomposes epics into sprint tasks. Writes ADRs for design decisions. Posts architectural risks to BOARD.md. Never writes implementation code.

### Implementer
Executes assigned tasks from DISPATCH.md. Writes code + tests together. Posts completion status to BOARD.md. Moves to next unblocked task if blocked.

### Tester
Triggered when implementation is complete. Runs full test suite. Checks coverage thresholds. Writes integration tests. Posts QA report to BOARD.md.

### Reviewer
Reviews all code changes against standards in `.claude/rules/`. Checks for scope creep. Verifies no regressions. Posts APPROVED or NEEDS_CHANGES to BOARD.md.

### SecurityAgent
Scans for hardcoded secrets, injection vectors, unsafe deps. Runs dependency audit. Checks auth paths. Posts security report to BOARD.md.

### DocsAgent
Updates vault notes for new patterns, APIs, data models. Writes sprint retrospectives. Keeps vault in sync with code.

### VaultKeeper
Maintains vault index. Resolves broken wikilinks. Detects stale notes. Runs at every session end.

### Dispatcher
Routes tasks from ROADMAP.md to DISPATCH.md. Manages priority and dependency ordering. Reassigns blocked tasks.
