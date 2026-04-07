---
name: git-protocol
description: Git commit, branch, and workflow rules.
---

# Git Protocol

## Commit Format

Use conventional commits:
```
<type>(<scope>): <description>

[optional body]
```

Types: `feat`, `fix`, `refactor`, `test`, `docs`, `chore`, `perf`, `ci`

Examples:
- `feat(auth): add JWT refresh token rotation`
- `fix(api): handle null response from payment gateway`
- `refactor(db): extract query builder from repository`

## Commit Cadence

- Commit after every completed task
- Commit before switching to a different task
- Commit before running `/session-end`
- WIP commits are fine: `WIP: [task-ID] — [what's done]`

## Branching

- `main` — production-ready code only
- `sprint-N` — active sprint work
- Feature branches off sprint branch if needed

## Rules

- Never force push to main
- Never commit .env files or secrets
- Never commit with failing tests (WIP commits exempt if clearly marked)
- Always pull before push
- Squash WIP commits before merging to main
