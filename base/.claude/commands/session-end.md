---
name: session-end
description: Closing sequence for every Claude Code session. Run this last.
---

Execute the session wrap-up in this exact order:

1. **Complete or checkpoint**: If your current task is not done, commit progress with `WIP: [task ID] — [what's done / what remains]`. Post status to BOARD.md.

2. **Run tests**: Execute the test suite. If anything fails, fix before exiting or post a BLOCKER to BOARD.md.

3. **Commit**: Stage and commit your changes with a conventional commit message: `[sprint-N/task-ID] feat|fix|refactor: [description]`

4. **Vault sync** (if vault exists): Check if any files you modified need vault note updates. Post to BOARD.md: `[SESSION] Modified files: [list]`

5. **Update status**: Set your row in BOARD.md Agent Status to IDLE.

6. **Update DISPATCH.md**: Mark completed tasks as DONE, add completion notes.

7. **Session summary**: Post to BOARD.md:
```
[SESSION END] [AGENT] [TIMESTAMP]
Tasks completed: [list]
Tasks in progress: [list]
Blockers raised: [list]
Next session should: [what to pick up]
```
