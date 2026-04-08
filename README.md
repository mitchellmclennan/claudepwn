# claudepwn

One command. PRD in, fully-automated Claude Code project out.

8 agents. 10 commands. 7 rules. 4 hooks. 9 skills. 8-wave hardening. Sprint runner. Vault. 4 plugins. All wired. Claude reads your PRD and populates everything.

## Quick Start

```bash
# New project from a PRD
npx claudepwn new --prd ./PRD.md --features all

# Add to an existing project
cd ~/existing-project
npx claudepwn init --prd ./PRD.md --features all
```

That's it. Claude reads the PRD, detects the stack, populates ROADMAP/DISPATCH/vault, writes ADRs, and kicks off Sprint 1.

## Two Modes

### `new` — Start a project from scratch

```bash
npx claudepwn new --prd ./PRD.md --features all
```

1. Scaffolds entire `.claude/` structure (agents, commands, rules, hooks, skills)
2. Extracts project name and tech stack from your PRD automatically
3. Launches Claude headless to:
   - Fill CLAUDE.md with real project description and stack
   - Decompose PRD into Epics → Sprints in ROADMAP.md
   - Write Sprint 1 tasks to DISPATCH.md with acceptance criteria
   - Write ADRs for design decisions
   - Populate vault with architecture docs
   - Kick off Sprint 1

### `init` — Add to an existing codebase

```bash
cd ~/my-existing-project
npx claudepwn init --prd ./PRD.md --features all
```

1. Same scaffold (non-destructive — skips existing files)
2. Launches Claude to:
   - **Audit** the existing codebase (tests, security, architecture, tech debt)
   - Create **Sprint 0** with audit fix tasks
   - Run hardening gate on Sprint 0
   - Then read the PRD and plan forward sprints

## Options

```
--prd PATH          Your PRD file (Claude reads it, extracts name + stack)
--name, -n NAME     Override project name (default: from PRD or directory)
--stack, -s STACK   Override stack: python, typescript, rust, go (default: detected)
--features FEAT     vault, checklists, sprints, gitnexus, plugins, monorepo, or 'all'
--minimal           Agents + rules + hooks only
--force             Overwrite existing files (creates .bak backups)
--no-bootstrap      Scaffold files only — don't launch Claude
--no-git            Skip git init
--yes, -y           Accept defaults
```

## What You Get

### Always Included (base scaffold)

| Component | Count | Description |
|-----------|-------|-------------|
| **Agents** | 8 | Architect, Implementer, Tester, Reviewer, Security, Docs, VaultKeeper, Dispatcher |
| **Commands** | 10 | /session-start, /session-end, /sprint-start, /sprint-end, /checkpoint, /status, /dispatch, /sync-vault, /research, /harden |
| **Rules** | 7 | code-style, git-protocol, no-regressions, security-rules, test-first, design-before-code, research-protocol |
| **Hooks** | 4 | pre-edit, post-edit (auto-lint + drift queue), post-bash (GitNexus refresh), pre-commit (secrets block) |
| **Skills** | 9 | session-gate, sprint-review, harden + 6 GitNexus skills |
| **Hardening** | 8 waves | Pre-check → Tests → Security → Review → Dependencies → Docs → Domain → Plugin PR |
| **Plugins** | 4 | security-guidance (real-time), code-review (5-agent PR), frontend-design (anti-slop), claude-mem (cross-session memory) |
| **Root files** | 7 | CLAUDE.md, AGENTS.md, BOARD.md, DISPATCH.md, ROADMAP.md, REVIEW.md, .env.example |
| **Bootstrap** | 2 | bootstrap-new.md (PRD → plan), bootstrap-existing.md (audit → plan) |

### Optional Features (`--features`)

| Feature | What It Adds |
|---------|-------------|
| `vault` | 10-directory Obsidian vault with READMEs, note template, conventions, index |
| `checklists` | Epic, sprint, session checklist templates |
| `sprints` | Sprint runner (Opus/Sonnet/Haiku model routing), TMUX orchestration |
| `gitnexus` | Code knowledge graph, auto-generated per-cluster skills |
| `plugins` | Installs all 4 Claude Code plugins |
| `monorepo` | pnpm-workspace.yaml, tsconfig.base.json, .node-version, .dockerignore |
| `all` | Everything above |

### Stack Overlays

| Stack | Auto-detected by | Lint | Test | Format | Security |
|-------|-----------------|------|------|--------|----------|
| `python` | pyproject.toml, PRD keywords (fastapi, django, flask) | ruff | pytest | ruff format | bandit, pip audit |
| `typescript` | package.json, PRD keywords (next.js, react, node) | eslint | vitest/jest | prettier | npm audit |
| `rust` | Cargo.toml, PRD keywords (actix, axum, tokio) | clippy | cargo test | rustfmt | cargo audit |
| `go` | go.mod, PRD keywords (gin, echo, golang) | golangci-lint | go test | gofmt | govulncheck |

## The Flow

```
PRD.md → npx claudepwn new --prd PRD.md --features all
  ├── Scaffold 80+ files (.claude/, agents, commands, rules, hooks, skills)
  ├── Detect stack from PRD (python/typescript/rust/go)
  ├── Launch Claude (Opus) headless:
  │   ├── Read PRD
  │   ├── Fill CLAUDE.md with real stack + description
  │   ├── Decompose into ROADMAP.md (Mega → Epic → Sprint)
  │   ├── Write Sprint 1 tasks to DISPATCH.md
  │   ├── Write ADRs for design decisions
  │   ├── Populate vault with architecture docs
  │   └── /sprint-start → Sprint 1 begins
  └── Done. Run: scripts/run-sprints.sh 1
```

For existing projects, `init` mode audits first, creates Sprint 0 for fixes, hardens, then plans forward.

## Headless / Auto Claude

After bootstrap, run sprints headless:

```bash
# Run Sprint 1 (Plan → Implement → Harden → Close)
./scripts/run-sprints.sh 1

# Run Sprints 1-3
./scripts/run-sprints.sh 1 3

# With TMUX monitoring (detach with Ctrl+B, D)
./scripts/tmux-start.sh
```

Model routing: Opus plans, Sonnet implements + hardens, Haiku closes.

## License

MIT
