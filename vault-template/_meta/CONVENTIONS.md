# Vault Conventions

## Philosophy

Each vault note is:
- **Atomic** — one concept per note
- **Implementable** — has a "Code Location" and "Code Notes" section
- **Linked** — every note connects to at least 2 others via [[wikilinks]]
- **Verifiable** — has a "Last verified against code" date

## Note Template

Use `vault/_meta/note-template.md` as the starting point for every new note.

## Naming

- Use `kebab-case` for file names: `api-auth-flow.md`
- ADRs: `ADR-NNN-short-title.md` (e.g., `ADR-001-database-choice.md`)
- Retrospectives: `sprint-NN-retro.md` (e.g., `sprint-01-retro.md`)
- Research: `library-name-reference.md` (e.g., `fastapi-reference.md`)

## Wikilinks

Use `[[note-name]]` to link between notes. VaultKeeper resolves broken links at every session end.

Wikilinks should appear in the **Connections** section of each note:
- **Related to** — notes about the same topic area
- **Depends on** — notes this concept requires
- **Used by** — notes that depend on this concept

## Freshness

- Notes checked against code at least once per sprint
- Research notes expire after 14 days — re-run `/research` to refresh
- VaultKeeper flags stale notes in BOARD.md
- Deprecated notes get `Status: DEPRECATED` and a pointer to their replacement

## Vault Sections

| Section | What Goes Here | Owner |
|---------|---------------|-------|
| 00-Inbox | Unsorted notes, quick captures | Anyone |
| 01-Architecture | System design, component diagrams, dependency graphs | Architect |
| 02-Domain | Business logic, domain models, glossary | Architect |
| 03-Decisions | Architecture Decision Records (ADRs) | Architect |
| 04-APIs | API contracts, endpoint documentation | Implementer / DocsAgent |
| 05-Data-Models | Schema definitions, ERDs, migration notes | Implementer / DocsAgent |
| 06-Patterns | Code patterns in use, design patterns applied | Reviewer / DocsAgent |
| 07-Ops | Infrastructure, deployment, monitoring, known issues | SecurityAgent / DocsAgent |
| 08-Research | Library references, API evaluations, tech research | Anyone (via /research) |
| 09-Retrospectives | Sprint and epic retrospectives | DocsAgent |
