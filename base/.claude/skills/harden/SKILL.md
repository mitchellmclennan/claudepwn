---
name: harden
description: Run the multi-wave hardening gate
---

# Hardening Gate Skill

Execute the hardening gate defined in `.claude/commands/harden.md`.

This skill runs through all waves sequentially:
- Wave 0: Pre-check (clean state, all tasks DONE)
- Wave 1: Test coverage (full suite, coverage threshold)
- Wave 2: Security scan (secrets, injection, deps, auth)
- Wave 3: Code review (style, scope, spec compliance)
- Wave 4: Documentation (APIs, ADRs, retrospective)

Each wave must PASS before proceeding to the next.
Post results to BOARD.md after each wave.
