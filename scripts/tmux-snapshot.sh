#!/usr/bin/env bash
# Capture all TMUX panes to a log file
# Usage: ./scripts/tmux-snapshot.sh [session-name]

set -euo pipefail

PROJECT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
SESSION_NAME="${1:-claude-sprint}"
TIMESTAMP=$(date +%Y-%m-%d_%H-%M-%S)
SNAPSHOT_FILE="$PROJECT_DIR/logs/tmux-snapshot_${TIMESTAMP}.log"

mkdir -p "$PROJECT_DIR/logs"

echo "=== TMUX Snapshot: $SESSION_NAME @ $TIMESTAMP ===" > "$SNAPSHOT_FILE"
echo "" >> "$SNAPSHOT_FILE"

# Capture each pane
for pane in $(tmux list-panes -s -t "$SESSION_NAME" -F '#{window_index}.#{pane_index}' 2>/dev/null); do
    echo "--- Pane $pane ---" >> "$SNAPSHOT_FILE"
    tmux capture-pane -t "$SESSION_NAME:$pane" -p >> "$SNAPSHOT_FILE" 2>/dev/null || echo "(empty)" >> "$SNAPSHOT_FILE"
    echo "" >> "$SNAPSHOT_FILE"
done

echo "Snapshot saved: $SNAPSHOT_FILE"
