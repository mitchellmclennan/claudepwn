---
name: checkpoint
description: Mid-session save point. Commit progress and update state.
---

Quick checkpoint:

1. Run tests — confirm current state is green (or note what's failing)
2. `git add -A && git commit -m "checkpoint: [brief description of progress]"`
3. Update BOARD.md with current status
4. Update DISPATCH.md task progress if applicable
5. Run `/compact` if context is getting large
