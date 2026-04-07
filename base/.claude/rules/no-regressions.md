---
name: no-regressions
description: Prevent regressions in test suite and functionality.
---

# No Regressions Rule

## Test Baseline

At sprint start, record the test baseline:
- Number of passing tests
- Coverage percentage
- Performance benchmarks (if applicable)

## During Sprint

- Test count must only go up (new tests added, none removed without justification)
- Coverage must not drop below the baseline
- Previously passing tests must not start failing
- If a test needs to be modified, the original behavior must still be verified

## Scope Control

- Do not modify files outside the current sprint scope without Architect approval
- Do not change public API signatures without an ADR
- Do not remove or rename exports/functions used by other modules without impact analysis

## If a Regression is Detected

1. Stop current work immediately
2. Post BLOCKER to BOARD.md: `[AGENT] REGRESSION: [test name] — was passing, now failing`
3. Fix the regression before continuing with other tasks
4. Add a regression test to prevent recurrence
