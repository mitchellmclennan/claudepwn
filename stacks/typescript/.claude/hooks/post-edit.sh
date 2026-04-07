#!/usr/bin/env bash
# Post-edit hook for TypeScript projects
# Runs eslint + prettier on edited TS/TSX files

set -euo pipefail

EDITED_FILE="${CLAUDE_TOOL_OUTPUT:-}"

if [[ "$EDITED_FILE" == *.ts || "$EDITED_FILE" == *.tsx || "$EDITED_FILE" == *.js || "$EDITED_FILE" == *.jsx ]]; then
    if command -v npx &>/dev/null; then
        npx eslint --fix "$EDITED_FILE" 2>/dev/null || true
        npx prettier --write "$EDITED_FILE" 2>/dev/null || true
    fi
fi

exit 0
