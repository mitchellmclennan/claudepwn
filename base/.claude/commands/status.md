---
name: status
description: Full project status report.
---

Generate a project status report:

1. **Git status**: `git log --oneline -5`, `git status`, current branch
2. **Sprint progress**: Read DISPATCH.md — count tasks by status (PENDING, IN_PROGRESS, DONE, BLOCKED)
3. **Blockers**: Read BOARD.md ## Open Blockers — list all unresolved
4. **Test health**: Run the test suite, report pass/fail/coverage
5. **Open questions**: Read BOARD.md ## Open Questions — list all unanswered

Format as a concise summary table.
