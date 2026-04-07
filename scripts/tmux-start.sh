#!/usr/bin/env bash
# TMUX orchestration for headless sprint runs
# Creates a multi-pane session for monitoring long-running Claude Code work
#
# Usage: ./scripts/tmux-start.sh [session-name]
#
# Layout:
#   Window 1 (Main):
#     ┌──────────────┬──────────────┐
#     │              │   BOARD.md   │
#     │  Sprint Run  │   watcher    │
#     │              ├──────────────┤
#     │              │   git log    │
#     └──────────────┴──────────────┘
#
#   Window 2 (Logs): Sprint log tail

set -euo pipefail

PROJECT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
SESSION_NAME="${1:-claude-sprint}"

# Kill existing session if present
tmux kill-session -t "$SESSION_NAME" 2>/dev/null || true

# Create session with main window
tmux new-session -d -s "$SESSION_NAME" -c "$PROJECT_DIR" -x 200 -y 50

# Main pane (left): sprint runner
tmux send-keys -t "$SESSION_NAME" "echo 'Ready. Run: ./scripts/run-sprints.sh N'" Enter

# Split right: BOARD.md watcher
tmux split-window -h -t "$SESSION_NAME" -c "$PROJECT_DIR"
tmux send-keys -t "$SESSION_NAME" "watch -n 5 'head -60 BOARD.md 2>/dev/null || echo \"No BOARD.md yet\"'" Enter

# Split bottom-right: git status
tmux split-window -v -t "$SESSION_NAME" -c "$PROJECT_DIR"
tmux send-keys -t "$SESSION_NAME" "watch -n 10 'git log --oneline -10 2>/dev/null; echo \"---\"; git status -s 2>/dev/null'" Enter

# Create log window
tmux new-window -t "$SESSION_NAME" -n "logs" -c "$PROJECT_DIR"
tmux send-keys -t "$SESSION_NAME:logs" "echo 'Waiting for sprint logs...'; tail -f logs/sprints/*.log 2>/dev/null || echo 'No logs yet. Run a sprint first.'" Enter

# Focus on main pane
tmux select-window -t "$SESSION_NAME:0"
tmux select-pane -t "$SESSION_NAME:0.0"

echo "TMUX session '$SESSION_NAME' created."
echo ""
echo "  Attach:   tmux attach -t $SESSION_NAME"
echo "  Detach:   Ctrl+B, D (session keeps running)"
echo "  Kill:     ./scripts/tmux-stop.sh $SESSION_NAME"
echo ""
echo "  Window 0: Main (sprint runner + BOARD.md watcher + git status)"
echo "  Window 1: Logs (sprint log tail)"
