---
name: session-start
description: Bootstrap sequence for every new Claude Code session. Run this first.
---

Execute the session bootstrap in this exact order:

1. **Board check**: Read BOARD.md. List any open blockers or messages. If a BLOCKER exists for your current task, skip to step 5 and find an unblocked task.

2. **Dispatch check**: Read DISPATCH.md. Find your current assigned task(s). If nothing is assigned, read ROADMAP.md and self-assign the next unstarted task.

3. **Context load**: Read relevant project context:
   - If PRD.md exists, scan it for current requirements
   - If vault/ exists, read notes relevant to your current task
   - Check docs/ADR/ for any decisions affecting your work

4. **Codebase orient**: Run `git log --oneline -10` and `git status`. Know the current state before writing anything.

5. **Update status**: In BOARD.md Agent Status table, set your row to ACTIVE with current task ID.

6. **Model strategy**: For planning/architecture tasks, prefer Opus. For implementation/hardening, Sonnet is sufficient. For cleanup/docs, Haiku works fine. Use the cheapest model that can handle the task well.

7. **Begin**: Execute your first task. Report start to BOARD.md: `[AGENT] Starting Task [ID]`
