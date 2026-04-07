---
name: harden
description: Run the multi-wave hardening gate. All waves must pass before sprint closes.
---

# Hardening Gate — __PROJECT_NAME__

Execute each wave in order. If any wave FAILS, fix the issues before proceeding.

---

## Wave 0: Pre-Check

- [ ] All tasks in DISPATCH.md are DONE (no IN_PROGRESS or BLOCKED)
- [ ] No open BLOCKERs in BOARD.md
- [ ] Git working tree is clean (`git status` shows nothing)
- [ ] On the correct branch for this sprint

---

## Wave 1: Test Coverage (Owner: Tester)

- [ ] Full test suite passes: run the project's test command
- [ ] Coverage meets threshold (see .claude/rules/test-first.md)
- [ ] Zero skipped tests without documented justification
- [ ] No flaky tests (run suite twice if suspect)

Post result to BOARD.md under ## QA Reports.

---

## Wave 2: Security Scan (Owner: SecurityAgent)

- [ ] No hardcoded secrets in staged files (pattern: `(?i)(secret|token|key|password|api_key)\s*=\s*['"][^'"]{8,}`)
- [ ] No SQL injection vectors (raw string interpolation in queries)
- [ ] No command injection (unsanitized input in shell calls)
- [ ] Dependency audit passes (run stack-specific audit command)
- [ ] All auth paths verified
- [ ] No unvalidated external inputs at API boundaries

Post result to BOARD.md under ## Security Reports.

---

## Wave 3: Code Review (Owner: Reviewer)

- [ ] All sprint diffs reviewed against .claude/rules/code-style.md
- [ ] No scope creep (changes outside sprint scope)
- [ ] Stage 1: Spec compliance — code matches task description and acceptance criteria
- [ ] Stage 2: Code quality — clean, tested, secure, maintainable
- [ ] All MUST_FIX items resolved

Post verdict to BOARD.md.

---

## Wave 4: Documentation

- [ ] All new/changed APIs documented
- [ ] ADRs written for non-obvious design decisions
- [ ] Sprint retrospective written
- [ ] README updated if user-facing behavior changed

---

## Final Verdict

Post to BOARD.md:
```
[HARDENING] Sprint [N] — [PASS | FAIL]
Wave 0 (Pre-Check): [PASS/FAIL]
Wave 1 (Tests): [PASS/FAIL]
Wave 2 (Security): [PASS/FAIL]
Wave 3 (Review): [PASS/FAIL]
Wave 4 (Docs): [PASS/FAIL]
```

If ALL waves PASS → sprint is clear to close. Run `/sprint-end`.
If ANY wave FAILS → fix issues and re-run `/harden`.
