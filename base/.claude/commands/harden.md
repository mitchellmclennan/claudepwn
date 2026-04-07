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

## Wave 4: Dependency & Impact Analysis

- [ ] Run dependency analysis on all modified modules (if GitNexus enabled: `gitnexus impact`)
- [ ] Check for circular dependencies introduced this sprint
- [ ] Verify no orphaned modules (dead code with no callers)
- [ ] Confirm all modified call chains are covered by tests
- [ ] If no dependency tool: manually trace imports of every modified file

Post result to BOARD.md.

---

## Wave 5: Documentation & Vault Sync

- [ ] All new/changed APIs documented (vault/04-APIs/ or docs/)
- [ ] ADRs written for non-obvious design decisions
- [ ] Sprint retrospective written (vault/09-Retrospectives/ or docs/)
- [ ] README updated if user-facing behavior changed
- [ ] Vault notes updated for any new patterns, models, or infrastructure
- [ ] Research notes freshness check: flag any in vault/08-Research/ older than 14 days
- [ ] Vault index rebuilt (vault/_meta/vault-index.md)
- [ ] No broken wikilinks in vault

Post result to BOARD.md.

---

## Wave 6: Domain Safety (Optional — project-specific)

If your project has domain-specific safety requirements (e.g., financial precision, live-trade lockout, PII handling, deployment gates), add them here:

- [ ] [Domain-specific check 1]
- [ ] [Domain-specific check 2]
- [ ] [Domain-specific check 3]

> Edit this wave to match your project's risk profile. Delete if not applicable.

---

## Wave 7: Plugin PR Review (if using GitHub PRs)

- [ ] Create a PR from the sprint branch if one doesn't exist:
  `gh pr create --title "[sprint-N] Sprint N: implementation + hardening" --body "All waves 0-6 passed."`
- [ ] Trigger Code Review plugin: comment `@claude review once` on the PR
- [ ] Wait for review completion: `gh pr checks`
- [ ] Read all inline comments — address every finding with confidence >= 80:
  - RED findings: fix immediately
  - YELLOW findings: fix or document why acceptable
  - GRAY (pre-existing): log to BOARD.md for future sprint
- [ ] Push fixes and verify review threads auto-resolve

If NOT using GitHub PRs: Wave 7 is auto-PASS. Document: "Wave 7: SKIP (no GitHub PR workflow)"

---

## Final Verdict

Post to BOARD.md:
```
[HARDENING] Sprint [N] — [PASS | FAIL]
Wave 0 (Pre-Check): [PASS/FAIL]
Wave 1 (Tests): [PASS/FAIL] — Tests: X passed, Coverage: Y%
Wave 2 (Security): [PASS/FAIL] — Issues: N (+ Security Review plugin active during impl: YES/NO)
Wave 3 (Review): [PASS/FAIL] — Verdict: APPROVED/NEEDS_CHANGES (two-stage: spec + quality)
Wave 4 (Dependencies): [PASS/FAIL]
Wave 5 (Docs/Vault): [PASS/FAIL] — Notes updated: N, created: N
Wave 6 (Domain Safety): [PASS/FAIL or N/A]
Wave 7 (Plugin PR Review): [PASS/FAIL or SKIP] — PR #N, findings addressed: X/Y
```

If ALL waves PASS → sprint is clear to close. Run `/sprint-end`.
If ANY wave FAILS → fix issues and re-run `/harden`.
