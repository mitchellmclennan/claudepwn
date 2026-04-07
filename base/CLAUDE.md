# Project: __PROJECT_NAME__

## What This Is

> Drop your PRD.md in this directory. Claude reads it automatically at session start.
> Edit this section to describe your project once you have your PRD.

## Tech Stack

- **Stack:** __STACK__
- **Framework:** [fill in]
- **Database:** [fill in]
- **Testing:** [see .claude/rules/test-first.md for commands]
- **Infra:** [fill in]

## Agent Configuration

- Active agents: Architect, Implementer, Tester, Reviewer, SecurityAgent, DocsAgent, VaultKeeper, Dispatcher
- Communication protocol: See BOARD.md
- Dispatch log: See DISPATCH.md
- Roadmap: See ROADMAP.md

## Session Bootstrap

At the start of every session, run `/session-start` or follow this sequence:

1. Read BOARD.md — check for open blockers or messages from other agents
2. Read DISPATCH.md — find your current task assignment
3. If PRD.md exists, read it for project requirements and context
4. Read the relevant vault/ notes for your assigned task (if vault exists)
5. Execute your tasks
6. Run `/session-end` before exiting

## Core Behavior

- NEVER ask for permission for actions covered by .claude/settings.json
- NEVER explain what you are about to do — execute, then report results
- NEVER leave TODO comments — complete every task or log it to BOARD.md as a blocker
- ALWAYS check BOARD.md before starting any task to avoid duplicate work
- ALWAYS run the test suite after any code change
- ALWAYS commit at natural checkpoints (feature complete, tests passing)
- Use /compact when context exceeds 60%

## Critical Rules for This Project

- All code standards in `.claude/rules/code-style.md`
- Git protocol in `.claude/rules/git-protocol.md`
- Security rules in `.claude/rules/security-rules.md`
- Design-before-code: No implementation without an approved design (`.claude/rules/design-before-code.md`)
- Research protocol: If confidence <80% on any API, error, or library, WebSearch first (`.claude/rules/research-protocol.md`)

## Active Plugins

The following plugins fire automatically — do not disable them:

- **Security Review** (`security-guidance`) — PreToolUse hook scans every Write/Edit for vulnerabilities (injection, XSS, eval, pickle, SQLi) BEFORE edits land. Real-time defense layer. Complements SecurityAgent's Wave 2 audit.
- **Code Review** (`code-review`) — 5-agent parallel PR review triggered at Wave 7 of hardening. Posts inline GitHub comments with confidence scores.
- **Frontend Design** (`frontend-design`) — Activates automatically on frontend tasks. Enforces distinctive design (anti-generic-AI-aesthetic).
- **claude-mem** — Captures all session activity, injects relevant prior observations at session start. Gives you memory across sessions. Vault = project knowledge, claude-mem = session knowledge.

## Do Not Touch

- `.env` files (never commit, never read secrets)
- `node_modules/`, `__pycache__/`, `target/`, `vendor/` (build artifacts)
- Any file listed in `.gitignore`
