---
name: sync-vault
description: Synchronize vault notes with codebase. Only active if vault/ exists.
---

Vault synchronization (skip if no vault/ directory):

1. **Find modified files**: `git diff --name-only HEAD~5` (or since last sync)
2. **For each modified source file**:
   - New pattern introduced? → Write/update vault/06-Patterns/
   - API contract changed? → Update vault/04-APIs/
   - Data model changed? → Update vault/05-Data-Models/
   - New infra/config? → Update vault/07-Ops/
3. **Rebuild index**: Update vault/_meta/vault-index.md with all notes
4. **Broken links**: Search all vault .md files for [[wikilinks]] with no target, fix or remove
5. **Log**: Append to vault/_meta/update-log.md:
```
## [YYYY-MM-DD] Sync
Files modified: [N]
Notes updated: [list]
Notes created: [list]
Broken links resolved: [N]
```
