# Agent Communication Board — __PROJECT_NAME__

> This file is the single shared state for all agents.
> Read it before starting any task. Write to it after any status change.
> Entries are append-only. Never delete entries — only add RESOLVED tags.

---

## Open Blockers

<!-- Format: [AGENT] BLOCKER on Task [ID]: [description] -->
<!-- Add RESOLVED: [AGENT] [TIMESTAMP] when fixed -->

---

## Open Questions

<!-- Format: [AGENT] QUESTION: [description] | Waiting for: [who] -->

---

## Completed This Sprint

<!-- Format: [AGENT] Task [ID] DONE — [one-line summary] [TIMESTAMP] -->

---

## QA Reports

<!-- Tester posts here after each sprint -->

---

## Security Reports

<!-- SecurityAgent posts here after each hardening gate -->

---

## Architect Notes

<!-- Architect posts risks, ADR refs, design decisions here -->

---

## Agent Status

| Agent | Last Active | Current Task | Status |
|-------|-------------|--------------|--------|
| Architect | — | — | IDLE |
| Implementer | — | — | IDLE |
| Tester | — | — | IDLE |
| Reviewer | — | — | IDLE |
| SecurityAgent | — | — | IDLE |
| DocsAgent | — | — | IDLE |
| VaultKeeper | — | — | IDLE |
| Dispatcher | — | — | IDLE |

---

## Message Log

<!-- All inter-agent messages in chronological order -->
