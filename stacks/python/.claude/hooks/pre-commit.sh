#!/usr/bin/env bash
# Pre-commit hook for Python projects
# Blocks secrets + runs ruff on staged .py files

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

# 3. Lint staged Python files
DIRTY_PY=$(git diff --cached --name-only | grep '\.py$' || true)
if [ -n "$DIRTY_PY" ]; then
    cd "$(git rev-parse --show-toplevel)"
    if command -v uv &>/dev/null; then
        uv run ruff check $DIRTY_PY --quiet 2>/dev/null || {
            echo "PRE-COMMIT BLOCKED: ruff failed. Run: uv run ruff check --fix ." >&2
            exit 1
        }
    elif command -v ruff &>/dev/null; then
        ruff check $DIRTY_PY --quiet 2>/dev/null || {
            echo "PRE-COMMIT BLOCKED: ruff failed. Run: ruff check --fix ." >&2
            exit 1
        }
    fi
fi

exit 0
