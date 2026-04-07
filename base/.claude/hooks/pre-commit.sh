#!/usr/bin/env bash
# Pre-commit hook: blocks secrets and .env files from being committed
# Symlinked to .git/hooks/pre-commit by init.sh

set -euo pipefail

# 1. Block staged .env files
STAGED_ENV=$(git diff --cached --name-only | grep -E '\.env$|\.env\.' | grep -v '\.env\.example' || true)
if [ -n "$STAGED_ENV" ]; then
    echo "PRE-COMMIT BLOCKED: .env file(s) in staged changes:" >&2
    echo "$STAGED_ENV" >&2
    exit 1
fi

# 2. Scan for hardcoded secrets
SECRETS_PATTERN='(PRIVATE_KEY|API_SECRET|PASSPHRASE|MNEMONIC|sk-[A-Za-z0-9]{20,}|0x[a-fA-F0-9]{64})'
FOUND=$(git diff --cached | grep -E "^\+" | grep -Ev "^\+\+\+" | grep -Ei "$SECRETS_PATTERN" || true)
if [ -n "$FOUND" ]; then
    echo "PRE-COMMIT BLOCKED: Possible hardcoded secret detected:" >&2
    echo "$FOUND" | head -5 >&2
    echo "" >&2
    echo "If this is a false positive, use: git commit --no-verify" >&2
    exit 1
fi

exit 0
