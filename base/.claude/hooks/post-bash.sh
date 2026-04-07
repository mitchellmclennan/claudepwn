#!/usr/bin/env bash
# Post-bash hook: runs after any bash command
# Refreshes GitNexus graph when source files are newer than the index

set -euo pipefail

# Log bash command for session tracking
TIMESTAMP=$(date +"%Y-%m-%d %H:%M:%S")
echo "$TIMESTAMP | BASH | ${CLAUDE_TOOL_INPUT:-unknown}" >> .claude/session-bash-log.txt 2>/dev/null || true

# Refresh GitNexus graph if source is newer than the index
if command -v npx &> /dev/null && [ -f .gitnexus/meta.json ]; then
    NEWEST_SRC=$(find apps packages src 2>/dev/null -type f \( -name "*.ts" -o -name "*.tsx" -o -name "*.py" -o -name "*.rs" -o -name "*.go" \) -newer .gitnexus/meta.json | head -1)
    if [ -n "${NEWEST_SRC:-}" ]; then
        npx gitnexus analyze --skills --quiet 2>/dev/null || true
    fi
fi

exit 0
