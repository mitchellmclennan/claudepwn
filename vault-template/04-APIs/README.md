# APIs

API contracts and endpoint documentation. Source of truth for all service interfaces.

## Expected Notes

One note per service or API group:
- Endpoint paths, methods, request/response schemas
- Authentication requirements
- Rate limits
- Error codes
- Example requests/responses

## Rules

- Implementer checks this section BEFORE implementing any API endpoint
- DocsAgent updates after every API change
- VaultKeeper flags stale notes when code drifts from docs

## Owner

Implementer creates. DocsAgent maintains. VaultKeeper audits.

## Template

Use `vault/_meta/note-template.md` with Type: API.
