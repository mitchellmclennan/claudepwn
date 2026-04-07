You are running the hardening gate for Sprint __SPRINT_NUMBER__.

Execute /harden — run all waves in order:

Wave 0: Pre-check — verify all tasks DONE, no blockers, clean git
Wave 1: Test coverage — full suite pass, coverage above threshold
Wave 2: Security scan — secrets, injection, deps, auth
Wave 3: Code review — review all sprint diffs against rules
Wave 4: Documentation — APIs documented, ADRs written

For each wave:
- Run the checks
- Post results to BOARD.md
- If FAIL: fix the issues and re-run that wave
- Only proceed to next wave after PASS

Post final verdict to BOARD.md when all waves pass.
