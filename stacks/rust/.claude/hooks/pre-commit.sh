#!/usr/bin/env bash
# Pre-commit hook for Rust projects
# Blocks secrets + runs cargo clippy

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
    exit 1
fi

# 3. Check + clippy on staged Rust files
DIRTY_RS=$(git diff --cached --name-only | grep '\.rs$' || true)
if [ -n "$DIRTY_RS" ]; then
    cargo check 2>/dev/null || {
        echo "PRE-COMMIT BLOCKED: cargo check failed" >&2
        exit 1
    }
    cargo clippy -- -D warnings 2>/dev/null || {
        echo "PRE-COMMIT BLOCKED: clippy warnings found. Run: cargo clippy --fix" >&2
        exit 1
    }
fi

exit 0
