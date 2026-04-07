---
name: code-style
description: Python-specific naming, structure, and style rules.
---

# Code Style Rules — Python

## Naming

- Functions: `snake_case` — verb_noun pattern
- Classes: `PascalCase` nouns
- Constants: `SCREAMING_SNAKE_CASE`
- Modules/files: `snake_case.py`
- Test files: `test_<module>.py`
- Boolean variables: prefix with `is_`, `has_`, `should_`, `can_`

## Structure

- **Max function length:** 40 lines
- **Max file length:** 300 lines
- **Max nesting depth:** 3 levels — use early returns
- One class per file (unless tightly coupled helpers)

## Types

- All public functions must have type annotations
- Use Pydantic v2 models for all API boundaries and data validation
- No implicit `Any` — run mypy in strict mode
- Use `from __future__ import annotations` for modern type syntax

## Error Handling

- No bare `except:` — always specify exception type
- Use custom exception classes for domain errors
- `raise` not `raise Exception("msg")` — use specific types
- Log errors with structured logging (not print)

## Patterns

- Use `async/await` for IO-bound operations
- Use dependency injection (FastAPI `Depends()`) not global state
- Use `pathlib.Path` not `os.path`
- Use f-strings not `.format()` or `%`

## Commands

- **Test:** `uv run pytest` or `python -m pytest`
- **Lint:** `uv run ruff check src/ tests/`
- **Format:** `uv run ruff format src/ tests/`
- **Type check:** `uv run mypy src/`
- **Security:** `uv run bandit -r src/` or `pip audit`
