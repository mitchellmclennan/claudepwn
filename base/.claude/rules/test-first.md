---
name: test-first
description: Testing requirements and coverage thresholds.
---

# Test-First Rules

## Coverage Thresholds

- **Critical paths** (auth, payments, data mutations): 95%
- **General code**: 80%
- **Overall minimum**: 80%

## Test Cadence

- Write tests alongside implementation — never after
- Minimum per function: 1 happy path + 2 edge cases
- Integration tests for every cross-component flow
- Run full suite after every task completion

## Test Categories

1. **Unit tests**: Isolated, fast, test one function/method
2. **Integration tests**: Test component interactions, may use real DB
3. **E2E tests**: Full user flow, run before sprint close

## Test Commands

Stack-specific test commands are defined in the stack overlay and CLAUDE.md.
When in doubt, check the project's package.json, pyproject.toml, Cargo.toml, or go.mod.

## Rules

- Never skip tests with `@skip` or `.skip()` without a linked issue
- Never mock what you can test with real dependencies (prefer integration over unit for DB access)
- Flaky tests are bugs — fix them immediately
- Test names describe the behavior, not the implementation: `test_returns_404_when_user_not_found` not `test_get_user`
