---
name: session-gate
description: Execute session start and end gate protocols
---

# Session Gate Skill

## Start Gate

Run at the beginning of every session:

1. Read BOARD.md — check blockers and agent status
2. Read DISPATCH.md — find assigned tasks
3. Load context (PRD.md, vault notes, relevant ADRs)
4. Orient: `git log --oneline -10 && git status`
5. Update BOARD.md agent status to ACTIVE
6. Begin first task

## End Gate

Run at the end of every session:

1. Commit or WIP-commit all changes
2. Run test suite
3. Update BOARD.md agent status to IDLE
4. Update DISPATCH.md task statuses
5. Post session summary to BOARD.md
