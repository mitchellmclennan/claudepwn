---
name: code-style
description: Naming, structure, and style rules enforced on every edit.
---

# Code Style Rules

## Naming

Stack-specific naming conventions are in the stack overlay. These are universal:

- Functions: verb_noun pattern (what it does, to what)
- Classes/types: PascalCase nouns
- Constants: SCREAMING_SNAKE_CASE
- Boolean variables: prefix with `is_`, `has_`, `should_`, `can_`
- No abbreviations unless universally understood (id, url, api, db)

## Structure

- **Max function length:** 40 lines. Break into helpers if longer.
- **Max file length:** 300 lines. Split by concern if longer.
- **Max nesting depth:** 3 levels. Use early returns to flatten.
- **One concept per file.** Don't mix unrelated functions.

## Types

- No `any` (TypeScript) or implicit `Any` (Python)
- All public functions have type annotations
- All API boundaries have explicit types/schemas

## Error Handling

- No bare `except:` or `catch {}` — always specify the exception type
- No swallowed errors — log or propagate, never silently ignore
- All error paths return meaningful messages
- External calls (HTTP, DB, file IO) always have error handling

## Comments

- Don't comment what the code does — write clearer code
- DO comment why non-obvious decisions were made
- No commented-out code — delete it (git has history)
- No TODO comments — log tasks to DISPATCH.md or BOARD.md
