---
name: research
description: Research a library, API, or technology before using it.
---

Research protocol for `$ARGUMENTS`:

1. **Check cache**: Look for vault/08-Research/$ARGUMENTS-reference.md (if vault exists) or docs/research/. If it exists and is <14 days old, use it.

2. **WebSearch**: Search for the authoritative documentation for $ARGUMENTS. Target official docs, not blog posts.

3. **WebFetch**: Fetch the top result. Extract:
   - Current version
   - Key API signatures you need
   - Known gotchas / breaking changes
   - License

4. **Distill**: Write a <100-line reference note with:
   - Version
   - Key symbols/functions used in this project
   - Gotchas
   - Source URLs

5. **Save**: Write to vault/08-Research/$ARGUMENTS-reference.md (or docs/research/) with today's date.

6. **Link**: Reference this note from any ADR or task that depends on it.

## Confidence Rule

If your confidence on any API signature, error message, or library behavior is below 80%, run this research command BEFORE writing code. Do not guess.
