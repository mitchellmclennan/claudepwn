#!/usr/bin/env bash
# Multi-phase sprint runner for __PROJECT_NAME__
# Runs Plan → Implement → Harden → Close phases sequentially
#
# Usage:
#   ./scripts/run-sprints.sh 1         # Run sprint 1
#   ./scripts/run-sprints.sh 1 3       # Run sprints 1 through 3
#
# Each phase uses the appropriate prompt template from scripts/prompts/

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
LOG_DIR="$PROJECT_DIR/logs/sprints"

START_SPRINT="${1:?Usage: run-sprints.sh <start> [end]}"
END_SPRINT="${2:-$START_SPRINT}"

mkdir -p "$LOG_DIR"

for SPRINT in $(seq "$START_SPRINT" "$END_SPRINT"); do
    TIMESTAMP=$(date +%Y-%m-%d_%H-%M-%S)
    LOG_FILE="$LOG_DIR/sprint-${SPRINT}_${TIMESTAMP}.log"

    echo "═══════════════════════════════════════════════"
    echo "  Sprint $SPRINT — Starting"
    echo "═══════════════════════════════════════════════"
    echo ""

    # Phase 0: PLAN
    echo "[Phase 0] PLAN — reading PRD, decomposing tasks..." | tee -a "$LOG_FILE"
    PLAN_PROMPT=$(cat "$SCRIPT_DIR/prompts/plan.md" | sed "s/__SPRINT_NUMBER__/$SPRINT/g")
    echo "$PLAN_PROMPT" | claude --print 2>&1 | tee -a "$LOG_FILE" || true
    echo "" | tee -a "$LOG_FILE"

    # Phase 1: IMPLEMENT
    echo "[Phase 1] IMPLEMENT — executing sprint tasks..." | tee -a "$LOG_FILE"
    IMPL_PROMPT=$(cat "$SCRIPT_DIR/prompts/implement.md" | sed "s/__SPRINT_NUMBER__/$SPRINT/g")
    echo "$IMPL_PROMPT" | claude --print 2>&1 | tee -a "$LOG_FILE" || true
    echo "" | tee -a "$LOG_FILE"

    # Phase 2: HARDEN
    echo "[Phase 2] HARDEN — running hardening gates..." | tee -a "$LOG_FILE"
    HARDEN_PROMPT=$(cat "$SCRIPT_DIR/prompts/harden.md" | sed "s/__SPRINT_NUMBER__/$SPRINT/g")
    echo "$HARDEN_PROMPT" | claude --print 2>&1 | tee -a "$LOG_FILE" || true
    echo "" | tee -a "$LOG_FILE"

    # Phase 3: CLOSE
    echo "[Phase 3] CLOSE — writing retrospective, updating roadmap..." | tee -a "$LOG_FILE"
    CLOSE_PROMPT=$(cat "$SCRIPT_DIR/prompts/close.md" | sed "s/__SPRINT_NUMBER__/$SPRINT/g")
    echo "$CLOSE_PROMPT" | claude --print 2>&1 | tee -a "$LOG_FILE" || true
    echo "" | tee -a "$LOG_FILE"

    echo "═══════════════════════════════════════════════"
    echo "  Sprint $SPRINT — Complete"
    echo "  Log: $LOG_FILE"
    echo "═══════════════════════════════════════════════"
    echo ""
done
