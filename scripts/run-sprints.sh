#!/usr/bin/env bash
# Multi-phase sprint runner for __PROJECT_NAME__
# Runs Plan → Implement → Harden → Close phases sequentially
# Each phase uses the appropriate model: Opus plans, Sonnet builds, Haiku closes
#
# Usage:
#   ./scripts/run-sprints.sh 1         # Run sprint 1
#   ./scripts/run-sprints.sh 1 3       # Run sprints 1 through 3
#
# Model strategy (override with env vars):
#   PLAN_MODEL=claude-opus-4-6          # Opus for planning (expensive thinking)
#   CODE_MODEL=claude-sonnet-4-6        # Sonnet for implementation + hardening
#   CLOSE_MODEL=claude-haiku-4-5        # Haiku for closeout (cheap, fast)

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
LOG_DIR="$PROJECT_DIR/logs/sprints"

START_SPRINT="${1:?Usage: run-sprints.sh <start> [end]}"
END_SPRINT="${2:-$START_SPRINT}"

# Model defaults (override via environment)
PLAN_MODEL="${PLAN_MODEL:-claude-opus-4-6}"
CODE_MODEL="${CODE_MODEL:-claude-sonnet-4-6}"
CLOSE_MODEL="${CLOSE_MODEL:-claude-haiku-4-5}"

mkdir -p "$LOG_DIR"

for SPRINT in $(seq "$START_SPRINT" "$END_SPRINT"); do
    TIMESTAMP=$(date +%Y-%m-%d_%H-%M-%S)
    LOG_FILE="$LOG_DIR/sprint-${SPRINT}_${TIMESTAMP}.log"

    echo "═══════════════════════════════════════════════"
    echo "  Sprint $SPRINT — Starting"
    echo "  Models: Plan=$PLAN_MODEL | Code=$CODE_MODEL | Close=$CLOSE_MODEL"
    echo "═══════════════════════════════════════════════"
    echo ""

    # Phase 0: PLAN (Opus — expensive thinking, cheap output)
    echo "[Phase 0] PLAN — reading PRD, decomposing tasks..." | tee -a "$LOG_FILE"
    PLAN_PROMPT=$(sed "s/__SPRINT_NUMBER__/$SPRINT/g" "$SCRIPT_DIR/prompts/plan.md")
    echo "$PLAN_PROMPT" | claude --model "$PLAN_MODEL" --print 2>&1 | tee -a "$LOG_FILE" || true
    echo "" | tee -a "$LOG_FILE"

    # Phase 1: IMPLEMENT (Sonnet — fast, capable, cost-effective)
    echo "[Phase 1] IMPLEMENT — executing sprint tasks..." | tee -a "$LOG_FILE"
    IMPL_PROMPT=$(sed "s/__SPRINT_NUMBER__/$SPRINT/g" "$SCRIPT_DIR/prompts/implement.md")
    echo "$IMPL_PROMPT" | claude --model "$CODE_MODEL" --print 2>&1 | tee -a "$LOG_FILE" || true
    echo "" | tee -a "$LOG_FILE"

    # Phase 2: HARDEN (Sonnet — thorough review and fixing)
    echo "[Phase 2] HARDEN — running hardening gates..." | tee -a "$LOG_FILE"
    HARDEN_PROMPT=$(sed "s/__SPRINT_NUMBER__/$SPRINT/g" "$SCRIPT_DIR/prompts/harden.md")
    echo "$HARDEN_PROMPT" | claude --model "$CODE_MODEL" --print 2>&1 | tee -a "$LOG_FILE" || true
    echo "" | tee -a "$LOG_FILE"

    # Phase 3: CLOSE (Haiku — fast and cheap for retrospective + cleanup)
    echo "[Phase 3] CLOSE — writing retrospective, updating roadmap..." | tee -a "$LOG_FILE"
    CLOSE_PROMPT=$(sed "s/__SPRINT_NUMBER__/$SPRINT/g" "$SCRIPT_DIR/prompts/close.md")
    echo "$CLOSE_PROMPT" | claude --model "$CLOSE_MODEL" --print 2>&1 | tee -a "$LOG_FILE" || true
    echo "" | tee -a "$LOG_FILE"

    echo "═══════════════════════════════════════════════"
    echo "  Sprint $SPRINT — Complete"
    echo "  Log: $LOG_FILE"
    echo "═══════════════════════════════════════════════"
    echo ""
done
