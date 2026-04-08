You are integrating claudepwn automation into an EXISTING project. Code already exists. There may already be .claude/ files, agents, rules, skills, workflows, settings, hooks — or none of them. Your job is to UNDERSTAND what exists, PRESERVE what works, UPGRADE what's missing, and BUILD the sprint structure around the real state of this project.

DO NOT blindly overwrite. DO NOT ignore existing setup. READ EVERYTHING FIRST.

---

## PHASE -1: INVENTORY EXISTING SETUP

This is the most important phase. Skip nothing.

### -1.1 — Read ALL existing .claude/ files

Read every file in .claude/ if the directory exists. For each file found, record:
- What it does
- Whether it conflicts with or duplicates a claudepwn file
- Whether it should be KEPT (project-specific, valuable), MERGED (combine with claudepwn version), or REPLACED (generic/incomplete, claudepwn version is better)

Specifically check:
- `.claude/settings.json` — existing permissions, hooks, plugins, MCP servers. DO NOT lose any existing hooks or permissions. MERGE the claudepwn settings INTO the existing ones.
- `.claude/agents/` — existing agent files. If they have project-specific instructions (domain rules, safety constraints, custom workflows), PRESERVE those and ADD claudepwn structure around them.
- `.claude/commands/` — existing slash commands. Keep all of them. Add claudepwn commands that don't conflict.
- `.claude/rules/` — existing rules. Keep ALL project-specific rules. Add claudepwn rules that don't duplicate existing ones.
- `.claude/hooks/` — existing hooks. DO NOT replace them. Append claudepwn hook logic to existing scripts, or add new hook files alongside.
- `.claude/skills/` — existing skills. Keep all of them. Add claudepwn skills in new directories.

### -1.2 — Read existing root markdown files

Check for existing versions of: CLAUDE.md, BOARD.md, DISPATCH.md, ROADMAP.md, REVIEW.md, AGENTS.md, PRD.md
- If CLAUDE.md exists: READ it. Understand the existing project description, stack, rules. UPDATE it by adding claudepwn sections that are missing, not by replacing it.
- If BOARD.md exists: READ it. Preserve all existing messages and state. Add claudepwn sections if missing.
- If ROADMAP.md exists: READ it. Preserve existing roadmap. Build new sprints BELOW existing content.
- If DISPATCH.md exists: READ it. Preserve all existing tasks. Add new tasks below.

### -1.3 — Read existing project config

Check for: package.json, pyproject.toml, Cargo.toml, go.mod, Makefile, docker-compose.yml, .env.example, CI/CD configs (.github/workflows/, .gitlab-ci.yml)

Record the ACTUAL:
- Language and version
- Framework
- Database
- Test runner and test command
- Lint command
- Build command
- Deploy target

### -1.4 — Post inventory to BOARD.md

```
[BOOTSTRAP] Existing setup inventory
Existing .claude/ files: [list everything found]
Existing agents: [list with status: KEEP/MERGE/ADD]
Existing commands: [list]
Existing rules: [list]
Existing hooks: [list]
Existing skills: [list]
Settings.json: [summary of existing config]
Root markdown files: [which exist, which are new]
Conflicts detected: [list any claudepwn files that conflict with existing]
Integration plan: [how each conflict will be resolved]
```

---

## PHASE 0: INTELLIGENT MERGE

### 0.1 — Merge settings.json

Read the existing .claude/settings.json. Read the claudepwn version. Produce a MERGED version that:
- KEEPS all existing permissions (allow AND deny)
- ADDS any claudepwn permissions not already present
- KEEPS all existing hooks
- ADDS claudepwn hooks that don't duplicate existing matchers
- KEEPS all existing MCP servers
- ADDS plugin config if not present
- PRESERVES any custom config keys

Write the merged settings.json.

### 0.2 — Merge agent files

For each claudepwn agent file (.claude/agents/*.md):
- If NO existing agent file: write the claudepwn version as-is
- If existing agent file with SAME role: READ both. Write a MERGED version that keeps ALL project-specific instructions from the existing file and adds claudepwn structure (loops, research gate, plugin awareness, board communication protocol) where missing
- If existing agent file with DIFFERENT role: KEEP the existing file, ADD the claudepwn file alongside

### 0.3 — Merge commands

For each claudepwn command (.claude/commands/*.md):
- If no existing command with same name: write it
- If existing command with same name: READ both. If the existing version has project-specific customization, KEEP IT. If it's generic/basic, REPLACE with the claudepwn version. If both have valuable content, MERGE.

### 0.4 — Merge rules

For each claudepwn rule (.claude/rules/*.md):
- If no existing rule with same name: write it
- If existing rule with same name: READ both. KEEP the MORE SPECIFIC version. If the existing rule has domain-specific constraints (e.g., trading safety rules, financial precision rules, PII handling), ALWAYS keep those and append claudepwn additions.
- NEVER remove a project-specific rule

### 0.5 — Merge hooks

For each claudepwn hook (.claude/hooks/*.sh):
- If no existing hook with same name: write it
- If existing hook: READ it. APPEND claudepwn logic to the END of the existing script. Do not replace the existing logic. Add a comment block: `# --- claudepwn additions ---`

### 0.6 — Add skills (non-destructive)

Copy all claudepwn skills to .claude/skills/ — these go in new subdirectories so they never conflict with existing skills.

### 0.7 — Update root markdown files

- CLAUDE.md: If exists, ADD missing claudepwn sections (Active Plugins, Agent Configuration, Session Bootstrap, etc.) without replacing existing content. If not, write fresh.
- AGENTS.md: If exists, MERGE agent roster (add new agents, keep existing descriptions). If not, write fresh.
- BOARD.md: If exists, ADD claudepwn sections (if missing). If not, write fresh.
- DISPATCH.md: If exists, keep all content. If not, write fresh.
- ROADMAP.md: If exists, keep all content. If not, write fresh.
- REVIEW.md: If exists, MERGE (add missing check categories). If not, write fresh.

### 0.8 — Post merge report to BOARD.md

```
[BOOTSTRAP] Merge complete
Files merged: [N] (existing + claudepwn combined)
Files added: [N] (new claudepwn files, no conflict)
Files preserved: [N] (existing files kept as-is)
Settings.json: [merged — N permissions added, N hooks added]
Agent files: [N merged, N added, N preserved]
Commands: [N merged, N added, N preserved]
Rules: [N merged, N added, N preserved]
Hooks: [N appended to, N added]
```

---

## PHASE 1: AUDIT THE CODEBASE

### 1.1 — Map the codebase
- Read the full directory structure
- Run `git log --oneline -30` to understand recent history
- Identify: language, framework, database, testing, deployment
- Map the architecture: what modules exist, how they connect, entry points

### 1.2 — Run the test suite
- Find and run the test command (use the ACTUAL command from the project, not a guess)
- Record: total tests, passing, failing, skipped, coverage percentage
- If no tests exist, note as critical finding

### 1.3 — Security scan
- Scan for hardcoded secrets (follow .claude/rules/security-rules.md)
- Run dependency audit (npm audit / pip audit / cargo audit / govulncheck)
- Check for injection vectors, unvalidated inputs, auth bypass risks

### 1.4 — Code quality assessment
- Check error handling consistency
- Identify dead code, unused imports
- Assess documentation state

### 1.5 — Post audit findings to BOARD.md

```
[AUDIT] Codebase audit complete
Language: [X] | Framework: [X]
Files: [N] | Modules: [N]
Tests: [N passing / N total] | Coverage: [X]%
Security: [N HIGH, N MEDIUM, N LOW]
Tech debt: [N items]
Missing: [tests / docs / error handling / etc.]
```

---

## PHASE 2: BUILD SPRINT 0 — FIX AUDIT FINDINGS

### 2.1 — Create Sprint 0 in DISPATCH.md

Convert audit findings into tasks (APPEND to existing DISPATCH.md content):
- HIGH security issues → P0 tasks
- Missing tests for critical paths → P0 tasks
- Medium security issues → P1 tasks
- Tech debt → P2 tasks
- Documentation gaps → P2 tasks

### 2.2 — Execute Sprint 0

Fix tasks in priority order:
- Patch security vulnerabilities
- Add missing tests for critical paths
- Fix broken tests
- Remove hardcoded secrets
- Update vulnerable dependencies

### 2.3 — Run /harden on Sprint 0

Execute the hardening gate. All waves must pass.

---

## PHASE 3: PLAN FORWARD

### 3.1 — Read PRD.md (if it exists)

Understand what needs to be built NEXT. If no PRD.md exists, post a BLOCKER and stop here — the codebase is audited and hardened, user needs to provide a PRD for forward planning.

### 3.2 — Populate ROADMAP.md

Break the PRD into Epics → Sprints, accounting for:
- What already exists (DON'T rebuild)
- What needs to change (refactors, migrations)
- What's net new (features to add)

APPEND to existing ROADMAP.md content, don't replace.

### 3.3 — Write Sprint 1 tasks to DISPATCH.md

Decompose Sprint 1 into tasks. APPEND below Sprint 0.

### 3.4 — Populate vault / docs

If vault/ exists: write notes for existing architecture, APIs, data models, patterns discovered during audit.
If no vault/: write to docs/ instead.

### 3.5 — Post summary

```
[BOOTSTRAP] Existing project fully onboarded
Existing setup: [preserved / merged / upgraded]
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

```
[BOOTSTRAP] Codebase audited and hardened. No PRD found.
Sprint 0 complete. Existing setup integrated with claudepwn.
To plan forward: create PRD.md with product requirements, then run /sprint-start.
```

---

CRITICAL RULES:
- NEVER delete existing project-specific configuration
- NEVER overwrite domain-specific rules (trading safety, financial precision, PII handling, etc.)
- ALWAYS read before writing — understand what exists before changing it
- MERGE intelligently — the goal is claudepwn's structure + the project's existing knowledge
- When in doubt, PRESERVE the existing file and ADD claudepwn content alongside it

Operate fully autonomously. Post blockers to BOARD.md.
