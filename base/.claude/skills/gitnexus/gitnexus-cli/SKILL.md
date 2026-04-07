---
name: gitnexus-cli
description: "Use when the user needs to run GitNexus CLI commands — analyze, refresh, status, clean, wiki."
---

# GitNexus CLI Reference

## Commands

### Analyze (full index rebuild)
```bash
npx gitnexus analyze --skills --force
```
- Rebuilds the full knowledge graph from source
- Generates `.gitnexus/meta.json` with stats
- Creates/updates `.claude/skills/generated/` with per-cluster skills
- Use `--quiet` to suppress output in hooks

### Status
```bash
cat .gitnexus/meta.json
```
- Shows last indexed commit, node/edge counts, staleness

### Refresh (incremental)
```bash
npx gitnexus analyze --skills --quiet
```
- Only re-indexes files changed since last run
- Safe to run in post-bash hooks

### Clean
```bash
rm -rf .gitnexus/
```
- Removes all graph data. Re-run `analyze` to rebuild.

## When to Run

- **After `git pull`** — index may be stale
- **After major refactors** — graph structure changed
- **Sprint start** — ensure fresh graph for planning
- **Hardening Wave 4** — verify graph is current before audit
- **Automatically** — post-bash hook triggers refresh when source is newer than index
