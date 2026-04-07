#!/usr/bin/env bash
# Post-edit hook: runs after any file edit
# Logs edits and populates vault drift queue for VaultKeeper

set -euo pipefail

EDITED_FILE="${CLAUDE_TOOL_OUTPUT:-}"
TIMESTAMP=$(date +"%Y-%m-%d %H:%M:%S")

# Log the edit for session tracking
echo "$TIMESTAMP | EDIT | $EDITED_FILE" >> .claude/session-edit-log.txt 2>/dev/null || true

# Queue for vault drift detection (VaultKeeper picks this up)
if [ -n "$EDITED_FILE" ]; then
    echo "$EDITED_FILE" >> .claude/vault-drift-queue.txt 2>/dev/null || true
fi

# Stack-specific linting is in the stack overlay version of this file

exit 0
