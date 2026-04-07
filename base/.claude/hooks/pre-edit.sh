#!/usr/bin/env bash
# Pre-edit hook: runs before any file edit
# Blocks edits to protected files

set -euo pipefail

# Block edits to .env files
if echo "$CLAUDE_TOOL_INPUT" | grep -qE '\.env($|\.)' 2>/dev/null; then
    echo "BLOCKED: Cannot edit .env files — secrets must be managed manually" >&2
    exit 1
fi

exit 0
