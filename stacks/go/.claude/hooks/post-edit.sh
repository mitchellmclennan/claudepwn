#!/usr/bin/env bash
# Post-edit hook for Go projects
# Runs gofmt on edited .go files

set -euo pipefail

EDITED_FILE="${CLAUDE_TOOL_OUTPUT:-}"

if [[ "$EDITED_FILE" == *.go ]]; then
    if command -v gofmt &>/dev/null; then
        gofmt -w "$EDITED_FILE" 2>/dev/null || true
    fi
fi

exit 0
