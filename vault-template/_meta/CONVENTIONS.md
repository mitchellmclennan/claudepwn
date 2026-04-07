# Vault Conventions

## Note Template

Every vault note should follow this structure:

```markdown
# [Title]

Created: [YYYY-MM-DD]
Updated: [YYYY-MM-DD]
Tags: #tag1 #tag2

## Summary
[One paragraph]

## Details
[Main content]

## Related
- [[link-to-related-note]]
```

## Wikilinks

Use `[[note-name]]` to link between vault notes. VaultKeeper resolves broken links at every session end.

## Naming

- Use kebab-case for file names: `api-auth-flow.md`
- Prefix ADRs with number: `ADR-001-database-choice.md`
- Prefix retrospectives with sprint: `sprint-01-retro.md`
