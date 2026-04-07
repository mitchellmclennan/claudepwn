#!/usr/bin/env bash
# Kill a TMUX sprint session
# Usage: ./scripts/tmux-stop.sh [session-name]

SESSION_NAME="${1:-claude-sprint}"
tmux kill-session -t "$SESSION_NAME" 2>/dev/null && echo "Session '$SESSION_NAME' killed." || echo "No session '$SESSION_NAME' found."
