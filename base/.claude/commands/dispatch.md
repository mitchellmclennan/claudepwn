---
name: dispatch
description: Re-run task assignment. Picks up the next available task.
---

Task dispatch:

1. Read DISPATCH.md for all tasks in current sprint
2. Find tasks with status=PENDING whose dependencies are all DONE
3. Assign the highest priority unblocked task to yourself
4. Update DISPATCH.md: set status to IN_PROGRESS
5. Post to BOARD.md: `[DISPATCHER] Assigned Task [ID] to [AGENT]`
6. Begin executing the task
