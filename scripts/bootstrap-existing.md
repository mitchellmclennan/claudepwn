You are setting up Claude Code automation on an EXISTING codebase. Code already exists. Your job is to audit what's here, understand it, then build the sprint/roadmap structure around what needs to happen next.

Read these files first:
- CLAUDE.md (your project config — you will update this)
- AGENTS.md (your agent roster)
- .claude/rules/ (all rule files — the standards you enforce)
- PRD.md (if it exists — the product requirements for what to build NEXT)

Then execute ALL of the following phases. Do not stop between phases.

---

## PHASE 0: AUDIT THE EXISTING CODEBASE

### 0.1 — Map the codebase
- Read the full directory structure
- Run `git log --oneline -30` to understand recent history
- Identify: language, framework, database, testing, deployment
- Count files, modules, lines of code
- Map the architecture: what modules exist, how they connect, entry points

### 0.2 — Run the test suite
- Find and run the test command (check package.json, pyproject.toml, Cargo.toml, go.mod, Makefile)
- Record: total tests, passing, failing, skipped, coverage percentage
- If no tests exist, note that as a critical finding

### 0.3 — Security scan
- Scan for hardcoded secrets (follow patterns in .claude/rules/security-rules.md)
- Check for dependency vulnerabilities (npm audit / pip audit / cargo audit / govulncheck)
- Check for injection vectors, unvalidated inputs, auth bypass risks
- Check .env handling — are secrets properly managed?

### 0.4 — Code quality assessment
- Check for code style consistency
- Identify dead code, unused imports, commented-out blocks
- Check error handling patterns
- Assess documentation state (README, comments, API docs)

### 0.5 — Write audit findings
Post ALL findings to BOARD.md under ## Architect Notes:
```
[AUDIT] Codebase audit complete
Language: [X]
Framework: [X]
Files: [N] | Modules: [N]
Tests: [N passing / N total] | Coverage: [X]%
Security issues: [N HIGH, N MEDIUM, N LOW]
Tech debt items: [N]
Missing: [tests / docs / error handling / etc.]
```

---

## PHASE 1: UPDATE PROJECT CONFIG

### 1.1 — Fill in CLAUDE.md
Update "What This Is" with a real description of what this project does (inferred from code).
Fill in the Tech Stack section with the actual stack you discovered.
Add project-specific critical rules based on patterns you found.

### 1.2 — Write architecture documentation
Create `docs/architecture.md` (or `vault/01-Architecture/system-overview.md`):
- Component diagram based on what you found
- Data flow
- External integrations
- Key patterns in use

### 1.3 — Write ADRs for existing decisions
For every non-obvious architectural choice you discover (why this database? why this auth pattern? why this file structure?), write an ADR documenting it.

---

## PHASE 2: BUILD SPRINT 0 — FIX AUDIT FINDINGS

### 2.1 — Create Sprint 0 in DISPATCH.md
Convert every audit finding into a concrete task:
- HIGH security issues → P0 tasks
- Missing tests for critical paths → P0 tasks
- Medium security issues → P1 tasks
- Tech debt → P2 tasks
- Documentation gaps → P2 tasks

### 2.2 — Execute Sprint 0
Pick up Sprint 0 tasks in priority order. Fix them:
- Patch security vulnerabilities
- Add missing tests for critical paths
- Fix broken tests
- Remove hardcoded secrets
- Update dependencies with known CVEs

### 2.3 — Run /harden on Sprint 0
Execute the hardening gate. All waves must pass before moving on.

---

## PHASE 3: PLAN FORWARD (if PRD.md exists)

### 3.1 — Read PRD.md
Understand what needs to be built NEXT, on top of the existing codebase.

### 3.2 — Populate ROADMAP.md
Break the PRD into Epics → Sprints, accounting for:
- What already exists (don't re-build)
- What needs to change (refactors, migrations)
- What's net new (features to add)

### 3.3 — Write Sprint 1 tasks to DISPATCH.md
Decompose Sprint 1 into tasks with acceptance criteria, dependencies, and assigned agents.

### 3.4 — Populate vault (if vault/ exists)
- Update vault index with all new notes
- Write API docs for existing endpoints
- Write data model docs for existing schemas
- Document discovered patterns

### 3.5 — Post summary to BOARD.md
```
[BOOTSTRAP] Existing project onboarded
Audit: [N] findings ([N] fixed in Sprint 0)
Hardening: [PASS/FAIL]
Epics planned: [N]
Sprint 1 tasks: [N]
Ready for: /sprint-start
```

### 3.6 — Kick off Sprint 1
Run /sprint-start for Sprint 1.

---

## If no PRD.md exists

Post to BOARD.md:
```
[BOOTSTRAP] BLOCKER: No PRD.md found.
Audit complete. Sprint 0 executed. Codebase is hardened.
To continue: create PRD.md with your product requirements, then run /sprint-start.
```

---

Operate fully autonomously. Do not stop for confirmation unless a BLOCKER arises. Post all blockers to BOARD.md and continue with the next available task.
