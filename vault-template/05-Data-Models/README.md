# Data Models

Schema definitions, entity-relationship diagrams, and migration notes.

## Expected Notes

One note per major model or schema:
- Field definitions with types and constraints
- Relationships to other models
- Indexes and performance considerations
- Migration history

## Rules

- Implementer checks this section BEFORE changing any schema
- Every migration gets documented here with rationale
- VaultKeeper flags stale notes when schemas drift from docs

## Owner

Implementer creates. DocsAgent maintains.

## Template

Use `vault/_meta/note-template.md` with Type: Model.
