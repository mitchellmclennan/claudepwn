# Code Review Conventions — __PROJECT_NAME__

> Read by the Reviewer agent and Code Review plugin.
> Define what always gets checked and what can be skipped.

---

## Always Check

- Security: injection vectors, hardcoded secrets, unvalidated inputs
- Error handling: no bare except/catch, no swallowed errors
- Test coverage: new code has tests, coverage doesn't drop
- API contracts: changes match documented interfaces
- Data validation: all external inputs validated at boundaries
- Naming: follows project conventions in `.claude/rules/code-style.md`

## Skip

- Formatting — handled by automated formatters
- Import ordering — handled by linters
- Generated files (migrations, lock files, compiled output)
- Vendor/third-party code

## Review Protocol

1. Read the diff in full before commenting
2. Categorize issues: MUST_FIX (blocks merge) vs SUGGESTION (optional)
3. Every MUST_FIX includes a specific fix recommendation
4. Post verdict to BOARD.md: APPROVED or NEEDS_CHANGES with file:line references
5. Re-review after fixes — don't approve without verifying

## Scope Creep Detection

Flag any change that:
- Modifies files outside the current sprint scope
- Introduces new dependencies not in the ADR
- Changes public API signatures without an ADR update
- Touches configuration or infrastructure without Architect approval
