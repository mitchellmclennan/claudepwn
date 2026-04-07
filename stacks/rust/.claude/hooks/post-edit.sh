#!/usr/bin/env bash
# Post-edit hook for Rust projects
# Runs cargo fmt on edited .rs files

set -euo pipefail

EDITED_FILE="${CLAUDE_TOOL_OUTPUT:-}"

if [[ "$EDITED_FILE" == *.rs ]]; then
    if command -v cargo &>/dev/null; then
        cargo fmt -- "$EDITED_FILE" 2>/dev/null || true
    fi
fi

exit 0
