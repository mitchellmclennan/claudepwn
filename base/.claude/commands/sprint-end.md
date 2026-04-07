---
name: sprint-end
description: Sprint closeout sequence. Run after all sprint tasks are DONE.
---

Sprint closeout:

1. **Final test run**: Full test suite must pass. Coverage must meet threshold. Zero exceptions.

2. **Hardening gate**: Run `/harden` — all waves must pass before sprint closes.

3. **Code review**: Reviewer reads all diffs from this sprint. Posts verdict to BOARD.md.

4. **Documentation**: DocsAgent writes sprint summary and updates any relevant docs/vault notes.

5. **Checklist** (if exists): Mark `checklists/active/sprint-[N].md` as COMPLETE.

6. **ROADMAP update**: Mark sprint as COMPLETE in ROADMAP.md. Populate next sprint if applicable.

7. **Announce**: Post to BOARD.md:
```
[SPRINT END] Sprint [N]: [Sprint Name]
Tasks completed: [N/N]
Test coverage: [X]%
Hardening: [PASS/FAIL]
Review: [APPROVED/NEEDS_CHANGES]
Next sprint: [Sprint N+1 name or NONE]
```
