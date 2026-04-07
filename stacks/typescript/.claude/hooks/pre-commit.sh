#!/usr/bin/env bash
# Pre-commit hook for TypeScript projects
# Blocks secrets + runs eslint on staged TS files

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

# 3. Lint staged TS/JS files
DIRTY_TS=$(git diff --cached --name-only | grep -E '\.(ts|tsx|js|jsx)$' || true)
if [ -n "$DIRTY_TS" ]; then
    cd "$(git rev-parse --show-toplevel)"
    npx eslint $DIRTY_TS --quiet 2>/dev/null || {
        echo "PRE-COMMIT BLOCKED: eslint failed. Run: npx eslint --fix ." >&2
        exit 1
    }
fi

exit 0
