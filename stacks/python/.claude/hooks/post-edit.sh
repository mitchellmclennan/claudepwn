#!/usr/bin/env bash
# Post-edit hook for Python projects
# Runs ruff check on edited Python files

set -euo pipefail

# Extract edited file path from tool output
EDITED_FILE="${CLAUDE_TOOL_OUTPUT:-}"

if [[ "$EDITED_FILE" == *.py ]]; then
    # Auto-fix lint issues
    if command -v uv &>/dev/null; then
        uv run ruff check --fix "$EDITED_FILE" 2>/dev/null || true
        uv run ruff format "$EDITED_FILE" 2>/dev/null || true
    elif command -v ruff &>/dev/null; then
        ruff check --fix "$EDITED_FILE" 2>/dev/null || true
        ruff format "$EDITED_FILE" 2>/dev/null || true
    fi
fi

exit 0
