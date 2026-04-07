---
name: harden
description: Run the multi-wave hardening gate
---

# Hardening Gate Skill

Execute the hardening gate defined in `.claude/commands/harden.md`.

This skill runs through all waves sequentially:
- Wave 0: Pre-check (clean state, all tasks DONE)
- Wave 1: Test coverage (full suite, coverage threshold, known-failure search)
- Wave 2: Security scan (secrets, injection, deps, auth, CVE sweep)
- Wave 3: Code review (style, scope, spec compliance, two-stage review)
- Wave 4: Dependency & impact analysis (circular deps, orphans, call chain coverage)
- Wave 5: Documentation & vault sync (APIs, ADRs, retrospective, research freshness)
- Wave 6: Domain safety (project-specific checks — edit to match your risk profile)

Each wave must PASS before proceeding to the next.
Post results to BOARD.md after each wave.
If any wave FAILS, fix issues and re-run that wave before continuing.
