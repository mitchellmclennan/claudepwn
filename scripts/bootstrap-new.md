You are bootstrapping a brand new project. Your job is to read the PRD and set up EVERYTHING so development can begin immediately.

Read these files first:
- PRD.md (the product requirements — this is your source of truth)
- CLAUDE.md (your project config — you will update this)
- AGENTS.md (your agent roster)
- ROADMAP.md (you will populate this)
- DISPATCH.md (you will populate this)
- REVIEW.md (review conventions)
- .claude/rules/ (all rule files — understand the standards)

Then execute ALL of the following in order. Do not stop between steps.

---

## Step 1: Update CLAUDE.md

Fill in the "What This Is" section with a real description from the PRD. Fill in the Tech Stack section with the actual language, framework, database, testing, and infra from the PRD. Add any project-specific critical rules from the PRD's constraints section.

## Step 2: Architect — Decompose PRD into Epics and Sprints

Read every feature, requirement, and user story in the PRD. Break them down into:

1. **Mega Goal** — one sentence describing what the project achieves when complete
2. **Epics** — major feature areas (each Epic = 1-3 sprints of work)
3. **Sprints** — ordered chunks of work within each Epic (each Sprint = 1-5 days of work)

Write all of this to ROADMAP.md using the existing template structure.

## Step 3: Write Sprint 1 Tasks to DISPATCH.md

Take the first Sprint from ROADMAP.md and decompose it into concrete, implementable tasks:

For each task, write:
- Task ID (EPIC-SPRINT-TASK format)
- Title
- Assigned agent (Implementer for code, Tester for tests, etc.)
- Priority (P0/P1/P2)
- Status: PENDING
- Dependencies (which tasks must be DONE first)
- Description (what needs to be built)
- Acceptance criteria (specific, testable conditions for DONE)
- Context (relevant docs, ADRs, API contracts)

Order tasks by dependency — things that must exist first come first.

## Step 4: Write Architecture Decision Records

For every non-obvious design decision implied by the PRD (database choice, auth strategy, API architecture, deployment target, etc.), write an ADR:

File: `docs/ADR/ADR-NNN-short-title.md` (or `vault/03-Decisions/` if vault exists)

Use the ADR template from the Architect agent file.

## Step 5: Write System Architecture Overview

Create `docs/architecture.md` (or `vault/01-Architecture/system-overview.md` if vault exists):
- High-level component diagram (text/mermaid)
- Data flow description
- External integrations
- Module boundaries

## Step 6: Write Initial API Contracts and Data Models

If the PRD describes APIs or data models:
- Write API contracts to `vault/04-APIs/` or `docs/api/`
- Write data model schemas to `vault/05-Data-Models/` or `docs/models/`

## Step 7: Populate Vault (if vault/ exists)

If a vault/ directory exists:
- Update vault/_meta/vault-index.md with all new notes
- Create stub notes for each component in the architecture
- Write domain glossary to vault/02-Domain/glossary.md

## Step 8: Post to BOARD.md

Post a summary:
```
[BOOTSTRAP] Project __PROJECT_NAME__ initialized from PRD
Epics: [N]
Sprints planned: [N]
Sprint 1 tasks: [N]
ADRs written: [N]
Architecture: docs/architecture.md
Ready for: /sprint-start
```

## Step 9: Kick Off Sprint 1

Run /sprint-start to begin Sprint 1.

---

Operate fully autonomously. Do not stop for confirmation unless a BLOCKER arises (e.g., PRD is ambiguous, missing critical requirement). Post all blockers to BOARD.md and skip to the next step.
