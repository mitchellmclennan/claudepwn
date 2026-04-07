# claude-project-template

One command to set up a fully-configured Claude Code automation environment for any project.

8 agents. 10 slash commands. 7 rules. 4 hooks. 3 skills. Multi-wave hardening gate. Sprint runner. Vault. All wired up.

## Quick Start

```bash
# Clone this repo
git clone https://github.com/your-org/claude-project-template.git /tmp/cpt

# Run in your project directory
cd ~/my-project
/tmp/cpt/init.sh --name my-project --stack python
```

That's it. Drop your `PRD.md` in the root and run `claude` — Claude reads everything natively.

## Usage

```bash
# Interactive mode (prompts for name, stack, features)
./init.sh

# Fully specified
./init.sh --name my-api --stack python --features vault,checklists

# Auto-detect stack from existing files
./init.sh --name my-app

# All features
./init.sh --name my-saas --stack typescript --features all

# Minimal (agents + rules + hooks only)
./init.sh --name my-script --stack python --minimal

# Non-destructive (won't overwrite existing .claude/ files)
./init.sh --name existing-project --stack go

# Force overwrite (backs up originals as .bak)
./init.sh --name existing-project --stack go --force
```

## What You Get

### Always Included

| Component | Files | Purpose |
|-----------|-------|---------|
| **CLAUDE.md** | Root | Project briefing — Claude reads this first every session |
| **AGENTS.md** | Root | 8 agent definitions with roles and responsibilities |
| **BOARD.md** | Root | Agent communication board (shared state) |
| **DISPATCH.md** | Root | Task routing and assignment log |
| **ROADMAP.md** | Root | Epic → Sprint → Task breakdown |
| **REVIEW.md** | Root | Code review conventions |
| **Agents** | `.claude/agents/` | Architect, Implementer, Tester, Reviewer, Security, Docs, VaultKeeper, Dispatcher |
| **Commands** | `.claude/commands/` | `/session-start`, `/session-end`, `/sprint-start`, `/sprint-end`, `/checkpoint`, `/status`, `/dispatch`, `/sync-vault`, `/research`, `/harden` |
| **Rules** | `.claude/rules/` | code-style, git-protocol, no-regressions, security-rules, test-first, design-before-code, research-protocol |
| **Hooks** | `.claude/hooks/` | pre-edit (block .env), post-edit (auto-lint + drift queue), post-bash (GitNexus refresh), pre-commit (block secrets) |
| **Skills** | `.claude/skills/` | session-gate, sprint-review, harden + 6 GitNexus skills |
| **Settings** | `.claude/settings.json` | Permissions, hooks, plugins (stack-specific) |
| **Plugins** | `settings.json` | security-guidance, code-review, frontend-design, claude-mem (configured in settings, installed via `--features plugins`) |

### Optional Features (`--features`)

| Feature | Flag | What It Adds |
|---------|------|-------------|
| **Vault** | `vault` | Obsidian-compatible knowledge vault with 10 directories, READMEs, index, note template, conventions |
| **Checklists** | `checklists` | Epic, sprint, and session checklist templates |
| **Sprint Runner** | `sprints` | `scripts/run-sprints.sh` (Opus/Sonnet/Haiku model routing), prompt templates, TMUX orchestration (start/stop/snapshot) |
| **GitNexus** | `gitnexus` | Code knowledge graph, 6 GitNexus skills, auto-generated per-cluster skills, post-bash hook refresh |
| **Plugins** | `plugins` | Installs 4 Claude Code plugins: security-guidance (real-time PreToolUse scan), code-review (5-agent PR analysis), frontend-design (anti-slop UI), claude-mem (cross-session memory) |
| **Monorepo** | `monorepo` | pnpm-workspace.yaml, tsconfig.base.json, .node-version, .dockerignore, apps/ + packages/ directories |
| **Everything** | `all` | All of the above |

## Stacks

The `--stack` flag applies stack-specific overrides:

| Stack | Auto-detected by | Lint | Test | Format | Security |
|-------|-----------------|------|------|--------|----------|
| `python` | pyproject.toml, setup.py, requirements.txt | ruff | pytest | ruff format | bandit, pip audit |
| `typescript` | package.json, tsconfig.json | eslint | vitest/jest | prettier | npm audit |
| `rust` | Cargo.toml | clippy | cargo test | rustfmt | cargo audit |
| `go` | go.mod | golangci-lint | go test | gofmt | govulncheck |

Stack overlays provide:
- Stack-specific `.claude/settings.json` (permissions whitelist for that stack's tools)
- Stack-specific `.claude/rules/code-style.md` (naming, patterns, commands)
- Stack-specific `.claude/hooks/post-edit.sh` (auto-lint on save)
- Stack-specific `.claude/hooks/pre-commit.sh` (lint + secrets check)

## How It Works

There's no template engine. No Python. No YAML parser. Just files.

1. `init.sh` copies base files (agents, commands, rules, hooks, settings, root .md files)
2. Stack overlay copies override base files with stack-specific versions
3. `sed` replaces `__PROJECT_NAME__` and `__STACK__` placeholders
4. Optional features copy additional directories (vault, checklists, scripts)
5. Hooks get `chmod +x`, pre-commit gets symlinked to `.git/hooks/`

Claude reads everything natively. Your PRD.md goes in the root. The Architect agent reads it at sprint start. No parsing needed — Claude IS the parser.

## Workflow

```
1. Drop PRD.md in your project root
2. Run: claude
3. Run: /session-start
4. Claude reads PRD → Architect decomposes into tasks → Implementer builds → Tester verifies → Reviewer approves → Security scans → Docs updates
5. Run: /harden (multi-wave quality gate)
6. Run: /sprint-end
7. Repeat for next sprint
```

## Non-Destructive

If your project already has `.claude/` files, init.sh **skips existing files** by default. Use `--force` to overwrite (creates `.bak` backups).

## Directory Structure After Init

```
your-project/
├── CLAUDE.md                    ← Claude reads this first
├── AGENTS.md                    ← Agent roster
├── BOARD.md                     ← Agent communication
├── DISPATCH.md                  ← Task tracking
├── ROADMAP.md                   ← Sprint planning
├── REVIEW.md                    ← Review conventions
├── PRD.md                       ← YOUR product requirements (you create this)
├── .claude/
│   ├── settings.json            ← Permissions + hooks (stack-specific)
│   ├── agents/                  ← 8 agent instruction files
│   ├── commands/                ← 10 slash commands
│   ├── rules/                   ← 7 rule files
│   ├── hooks/                   ← 4 hook scripts
│   └── skills/                  ← 3 skill packs
├── vault/                       ← [optional] Knowledge vault
├── checklists/                  ← [optional] Templates
├── scripts/                     ← [optional] Sprint runner
└── src/                         ← Your code
```

## License

MIT
