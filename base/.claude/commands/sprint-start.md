---
name: sprint-start
description: Sprint kickoff sequence. Run once at the beginning of each sprint.
---

Sprint kickoff:

1. **Architect phase**: Read PRD.md and ROADMAP.md for the current Epic. Decompose into tasks and write them to DISPATCH.md. Write any required ADRs. Post architectural risks to BOARD.md.

2. **Context prep**: Ensure all notes/docs needed for this sprint's tasks exist. Create stubs for anything missing.

3. **Sprint checklist** (if checklists/ exists): Copy `checklists/sprint-template.md` to `checklists/active/sprint-[N].md`. Fill in sprint name, goals, and task list.

4. **Announce**: Post to BOARD.md:
```
[SPRINT START] Sprint [N]: [Sprint Name]
Epic: [Epic name]
Tasks: [N total]
Assigned to: [list agents and tasks]
Definition of Done: [what makes this sprint complete]
```

5. **Begin**: Implementer picks up first PENDING task from DISPATCH.md.
