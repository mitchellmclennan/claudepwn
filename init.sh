#!/usr/bin/env bash
set -euo pipefail

# ──────────────────────────────────────────────────────────────
# claudepwn
#
# Two modes:
#   npx claudepwn new  --prd PRD.md --features all    (new project)
#   npx claudepwn init --prd PRD.md --features all    (existing project)
#
# The PRD drives everything. Claude reads it, figures out the stack,
# populates ROADMAP/DISPATCH/vault, and kicks off Sprint 1.
# ──────────────────────────────────────────────────────────────

SCRIPT_DIR="${CLAUDEPWN_ROOT:-$(cd "$(dirname "$0")" && pwd)}"
TARGET_DIR="$(pwd)"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
BOLD='\033[1m'
NC='\033[0m'

# Defaults
MODE="new"
PROJECT_NAME=""
STACK=""
PRD_PATH=""
FEATURES=""
FORCE=false
MINIMAL=false
NO_GIT=false
NO_BOOTSTRAP=false
SKIP_CONFIRM=false

# ── Parse subcommand ──────────────────────────────────────────

usage() {
    cat <<'EOF'
claudepwn — Full Claude Code automation setup from a PRD

Usage:
  npx claudepwn new  [options]     Set up a NEW project (default)
  npx claudepwn init [options]     Add to an EXISTING project (audit first)

Options:
  --prd PATH            Path to your PRD (Claude reads it and sets up everything)
  --name, -n NAME       Project name (default: extracted from PRD or directory name)
  --stack, -s STACK     Tech stack: python, typescript, rust, go (default: detected from PRD or files)
  --features FEATURES   Comma-separated: vault, checklists, sprints, gitnexus, plugins, monorepo
                        Use 'all' to enable everything
  --minimal             Agents + rules + hooks only
  --force               Overwrite existing files (creates .bak backups)
  --no-git              Skip git init
  --no-bootstrap        Scaffold files only — don't launch Claude
  --yes, -y             Accept defaults without prompting
  --help, -h            Show this help

Examples:
  npx claudepwn new --prd ./PRD.md --features all
  npx claudepwn init --prd ./PRD.md --features all
  npx claudepwn new --name my-api --stack python
  npx claudepwn init --features vault,sprints
  npx claudepwn new --prd PRD.md --no-bootstrap

What happens:
  NEW mode:
    1. Scaffolds .claude/ (agents, commands, rules, hooks, skills, plugins)
    2. Copies your PRD.md, detects stack + name from it
    3. Launches Claude headless to read PRD and populate:
       ROADMAP.md (Epics/Sprints), DISPATCH.md (Sprint 1 tasks),
       ADRs, architecture docs, vault, then kicks off Sprint 1

  INIT mode (existing projects):
    1. Same scaffold (non-destructive — skips existing files)
    2. Launches Claude to audit the existing codebase first
    3. Creates Sprint 0 (fix audit findings), runs hardening
    4. Then reads PRD and plans forward sprints
EOF
    exit 0
}

if [[ $# -gt 0 && "$1" != -* ]]; then
    case "$1" in
        new)  MODE="new"; shift ;;
        init) MODE="init"; shift ;;
        *)    echo -e "${RED}Unknown command: $1. Use 'new' or 'init'.${NC}"; usage ;;
    esac
fi

while [[ $# -gt 0 ]]; do
    case $1 in
        --prd)          PRD_PATH="$2"; shift 2 ;;
        --name|-n)      PROJECT_NAME="$2"; shift 2 ;;
        --stack|-s)     STACK="$2"; shift 2 ;;
        --features)     FEATURES="$2"; shift 2 ;;
        --minimal)      MINIMAL=true; shift ;;
        --force)        FORCE=true; shift ;;
        --no-git)       NO_GIT=true; shift ;;
        --no-bootstrap) NO_BOOTSTRAP=true; shift ;;
        --yes|-y)       SKIP_CONFIRM=true; shift ;;
        --help|-h)      usage ;;
        *)              echo -e "${RED}Unknown option: $1${NC}"; usage ;;
    esac
done

# ── PRD-driven extraction ─────────────────────────────────────

if [[ -n "$PRD_PATH" ]]; then
    PRD_PATH="$(cd "$(dirname "$PRD_PATH")" && pwd)/$(basename "$PRD_PATH")"
    if [[ ! -f "$PRD_PATH" ]]; then
        echo -e "${RED}ERROR: PRD not found at $PRD_PATH${NC}"
        exit 1
    fi
fi

# Extract project name from PRD H1
if [[ -z "$PROJECT_NAME" && -n "$PRD_PATH" ]]; then
    PRD_NAME=$(grep -m1 "^# " "$PRD_PATH" | sed 's/^# //' | tr -d '\r' | sed 's/[^a-zA-Z0-9 _-]//g' | head -c 64)
    [[ -n "$PRD_NAME" ]] && PROJECT_NAME="$PRD_NAME" && echo -e "${GREEN}Project name from PRD: ${BOLD}$PROJECT_NAME${NC}"
fi

# Detect stack from PRD keywords
if [[ -z "$STACK" && -n "$PRD_PATH" ]]; then
    PRD_LOWER=$(tr '[:upper:]' '[:lower:]' < "$PRD_PATH")
    if echo "$PRD_LOWER" | grep -qE 'python|fastapi|django|flask|pytorch|pandas'; then
        STACK="python"
    elif echo "$PRD_LOWER" | grep -qE 'typescript|next\.js|react|node\.js|express|nestjs|deno|bun'; then
        STACK="typescript"
    elif echo "$PRD_LOWER" | grep -qE '\brust\b|actix|axum|tokio|cargo'; then
        STACK="rust"
    elif echo "$PRD_LOWER" | grep -qE '\bgo\b|golang|gin|echo|fiber'; then
        STACK="go"
    fi
    [[ -n "$STACK" ]] && echo -e "${GREEN}Stack from PRD: ${BOLD}$STACK${NC}"
fi

# ── Fallback: prompt or detect ────────────────────────────────

if [[ -z "$PROJECT_NAME" ]]; then
    DEFAULT_NAME="$(basename "$TARGET_DIR")"
    if [[ "$SKIP_CONFIRM" == true ]]; then
        PROJECT_NAME="$DEFAULT_NAME"
    else
        read -rp "Project name [$DEFAULT_NAME]: " PROJECT_NAME
        PROJECT_NAME="${PROJECT_NAME:-$DEFAULT_NAME}"
    fi
fi
PROJECT_NAME="$(echo "$PROJECT_NAME" | tr '[:upper:]' '[:lower:]' | tr ' _' '-' | sed 's/--*/-/g; s/^-//; s/-$//')"

if [[ -z "$STACK" ]]; then
    if [[ -f "$TARGET_DIR/pyproject.toml" || -f "$TARGET_DIR/setup.py" || -f "$TARGET_DIR/requirements.txt" ]]; then
        STACK="python"
    elif [[ -f "$TARGET_DIR/package.json" || -f "$TARGET_DIR/tsconfig.json" ]]; then
        STACK="typescript"
    elif [[ -f "$TARGET_DIR/Cargo.toml" ]]; then
        STACK="rust"
    elif [[ -f "$TARGET_DIR/go.mod" ]]; then
        STACK="go"
    fi
    if [[ -n "$STACK" ]]; then
        echo -e "${GREEN}Stack from files: ${BOLD}$STACK${NC}"
    elif [[ "$SKIP_CONFIRM" == true ]]; then
        STACK="python"
    else
        echo ""
        echo "Select tech stack:"
        echo "  1) python   2) typescript   3) rust   4) go"
        read -rp "Stack [1-4]: " SC
        case "$SC" in
            1|python) STACK="python" ;; 2|typescript) STACK="typescript" ;;
            3|rust) STACK="rust" ;; 4|go) STACK="go" ;;
            *) STACK="python" ;;
        esac
    fi
fi

[[ ! -d "$SCRIPT_DIR/stacks/$STACK" ]] && echo -e "${RED}Unknown stack '$STACK'${NC}" && exit 1

# ── Resolve features ──────────────────────────────────────────

FEAT_VAULT=false; FEAT_CHECKLISTS=false; FEAT_SPRINTS=false
FEAT_GITNEXUS=false; FEAT_PLUGINS=false; FEAT_MONOREPO=false

set_feat() {
    case "$1" in
        vault) FEAT_VAULT=true ;; checklists) FEAT_CHECKLISTS=true ;;
        sprints) FEAT_SPRINTS=true ;; gitnexus) FEAT_GITNEXUS=true ;;
        plugins) FEAT_PLUGINS=true ;; monorepo) FEAT_MONOREPO=true ;;
        all) FEAT_VAULT=true; FEAT_CHECKLISTS=true; FEAT_SPRINTS=true; FEAT_GITNEXUS=true; FEAT_PLUGINS=true; FEAT_MONOREPO=true ;;
    esac
}

if [[ "$MINIMAL" == true ]]; then
    :
elif [[ -n "$FEATURES" ]]; then
    IFS=',' read -ra FA <<< "$FEATURES"
    for f in "${FA[@]}"; do set_feat "$(echo "$f" | tr -d ' ')"; done
elif [[ "$SKIP_CONFIRM" == false ]]; then
    echo ""
    echo "Features (comma-separated, 'all', or Enter to skip):"
    echo "  vault  checklists  sprints  gitnexus  plugins  monorepo"
    read -rp "Features [none]: " FI
    if [[ -n "$FI" ]]; then
        IFS=',' read -ra FA <<< "$FI"
        for f in "${FA[@]}"; do set_feat "$(echo "$f" | tr -d ' ')"; done
    fi
fi

# ── Confirm ───────────────────────────────────────────────────

echo ""
echo -e "${BOLD}═══════════════════════════════════════════════${NC}"
echo -e "${BOLD}  claudepwn ${MODE}${NC}"
echo -e "${BOLD}═══════════════════════════════════════════════${NC}"
echo -e "  Project: ${GREEN}${PROJECT_NAME}${NC}  Stack: ${GREEN}${STACK}${NC}"
[[ -n "$PRD_PATH" ]] && echo -e "  PRD:     ${GREEN}$(basename "$PRD_PATH")${NC}"
echo -e "  Target:  ${BLUE}${TARGET_DIR}${NC}"
echo -e "  Features: vault=${FEAT_VAULT} checklists=${FEAT_CHECKLISTS} sprints=${FEAT_SPRINTS} gitnexus=${FEAT_GITNEXUS} plugins=${FEAT_PLUGINS} monorepo=${FEAT_MONOREPO}"
echo -e "${BOLD}═══════════════════════════════════════════════${NC}"

if [[ "$SKIP_CONFIRM" == false ]]; then
    read -rp "Proceed? [Y/n]: " CONFIRM
    [[ "$CONFIRM" =~ ^[Nn] ]] && echo "Aborted." && exit 0
fi

# ── Helpers ───────────────────────────────────────────────────

copied=0; skipped=0

safe_copy() {
    local src="$1" dst="$2"
    mkdir -p "$(dirname "$dst")"
    if [[ -f "$dst" && "$FORCE" == false ]]; then skipped=$((skipped+1)); return; fi
    [[ -f "$dst" && "$FORCE" == true ]] && cp "$dst" "${dst}.bak" 2>/dev/null || true
    cp "$src" "$dst"; copied=$((copied+1))
}

overlay_copy() {
    local src="$1" dst="$2"
    mkdir -p "$(dirname "$dst")"; cp "$src" "$dst"; copied=$((copied+1))
}

fill_placeholders() {
    [[ -f "$1" ]] || return
    sed -i '' -e "s|__PROJECT_NAME__|${PROJECT_NAME}|g" -e "s|__STACK__|${STACK}|g" "$1" 2>/dev/null || \
    sed -i -e "s|__PROJECT_NAME__|${PROJECT_NAME}|g" -e "s|__STACK__|${STACK}|g" "$1" 2>/dev/null || true
}

# ── Copy base ─────────────────────────────────────────────────

echo -e "\n${BLUE}Copying base .claude/ structure...${NC}"
while IFS= read -r src; do
    safe_copy "$src" "$TARGET_DIR/${src#$SCRIPT_DIR/base/}"
done < <(find "$SCRIPT_DIR/base/.claude" -type f)

for md in CLAUDE.md AGENTS.md BOARD.md DISPATCH.md ROADMAP.md REVIEW.md .gitignore .env.example; do
    [[ -f "$SCRIPT_DIR/base/$md" ]] && safe_copy "$SCRIPT_DIR/base/$md" "$TARGET_DIR/$md"
done

# ── Stack overlay ─────────────────────────────────────────────

echo -e "${BLUE}Applying ${STACK} overlay...${NC}"
while IFS= read -r src; do
    overlay_copy "$src" "$TARGET_DIR/${src#$SCRIPT_DIR/stacks/$STACK/}"
done < <(find "$SCRIPT_DIR/stacks/$STACK" -type f)

# ── Copy PRD ──────────────────────────────────────────────────

if [[ -n "$PRD_PATH" ]]; then
    echo -e "${BLUE}Copying PRD...${NC}"
    cp "$PRD_PATH" "$TARGET_DIR/PRD.md"; copied=$((copied+1))
fi

# ── Fill placeholders ─────────────────────────────────────────

echo -e "${BLUE}Filling placeholders...${NC}"
while IFS= read -r f; do fill_placeholders "$f"; done < <(find "$TARGET_DIR/.claude" -type f \( -name "*.md" -o -name "*.json" -o -name "*.sh" \))
for md in CLAUDE.md AGENTS.md BOARD.md DISPATCH.md ROADMAP.md REVIEW.md; do fill_placeholders "$TARGET_DIR/$md"; done

# ── Features ──────────────────────────────────────────────────

if [[ "$FEAT_VAULT" == true ]]; then
    echo -e "${BLUE}Creating vault/...${NC}"
    for d in 00-Inbox 01-Architecture 02-Domain 03-Decisions 04-APIs 05-Data-Models 06-Patterns 07-Ops 08-Research 09-Retrospectives _meta; do mkdir -p "$TARGET_DIR/vault/$d"; done
    if [[ -d "$SCRIPT_DIR/vault-template" ]]; then
        while IFS= read -r src; do
            safe_copy "$src" "$TARGET_DIR/vault/${src#$SCRIPT_DIR/vault-template/}"
            fill_placeholders "$TARGET_DIR/vault/${src#$SCRIPT_DIR/vault-template/}"
        done < <(find "$SCRIPT_DIR/vault-template" -type f)
    fi
fi

[[ "$FEAT_CHECKLISTS" == true ]] && {
    echo -e "${BLUE}Creating checklists/...${NC}"
    mkdir -p "$TARGET_DIR/checklists/active"
    while IFS= read -r src; do
        safe_copy "$src" "$TARGET_DIR/checklists/${src#$SCRIPT_DIR/checklists/}"
        fill_placeholders "$TARGET_DIR/checklists/${src#$SCRIPT_DIR/checklists/}"
    done < <(find "$SCRIPT_DIR/checklists" -type f)
}

[[ "$FEAT_SPRINTS" == true ]] && {
    echo -e "${BLUE}Creating scripts/...${NC}"
    mkdir -p "$TARGET_DIR/scripts/prompts"
    while IFS= read -r src; do
        safe_copy "$src" "$TARGET_DIR/scripts/${src#$SCRIPT_DIR/scripts/}"
        fill_placeholders "$TARGET_DIR/scripts/${src#$SCRIPT_DIR/scripts/}"
    done < <(find "$SCRIPT_DIR/scripts" -type f)
    chmod +x "$TARGET_DIR/scripts/"*.sh 2>/dev/null || true
}

[[ "$FEAT_GITNEXUS" == true ]] && {
    echo -e "${BLUE}Setting up GitNexus...${NC}"
    mkdir -p "$TARGET_DIR/.gitnexus" "$TARGET_DIR/.claude/skills/generated"
    command -v npx &>/dev/null && (cd "$TARGET_DIR" && npx gitnexus analyze --skills --force 2>/dev/null) || true
}

[[ "$FEAT_MONOREPO" == true ]] && {
    echo -e "${BLUE}Creating monorepo scaffold...${NC}"
    mkdir -p "$TARGET_DIR/apps" "$TARGET_DIR/packages"
    while IFS= read -r src; do
        safe_copy "$src" "$TARGET_DIR/${src#$SCRIPT_DIR/monorepo/}"
    done < <(find "$SCRIPT_DIR/monorepo" -type f)
}

# ── Hooks + git ───────────────────────────────────────────────

chmod +x "$TARGET_DIR/.claude/hooks/"*.sh 2>/dev/null || true

if [[ "$NO_GIT" == false && ! -d "$TARGET_DIR/.git" ]]; then
    echo -e "${BLUE}Initializing git...${NC}"
    (cd "$TARGET_DIR" && git init -q)
    [[ -f "$TARGET_DIR/.claude/hooks/pre-commit.sh" ]] && {
        mkdir -p "$TARGET_DIR/.git/hooks"
        ln -sf "../../.claude/hooks/pre-commit.sh" "$TARGET_DIR/.git/hooks/pre-commit"
    }
fi

# ── Plugins ───────────────────────────────────────────────────

[[ "$FEAT_PLUGINS" == true ]] && {
    echo -e "${BLUE}Installing plugins...${NC}"
    if command -v claude &>/dev/null; then
        for p in security-guidance@anthropics-claude-code code-review@anthropics-claude-code frontend-design@anthropics-claude-code claude-mem@thedotmack; do
            claude plugin install "$p" 2>/dev/null || echo -e "${YELLOW}  $p: install manually${NC}"
        done
    else
        echo -e "${YELLOW}  Claude CLI not found. Install plugins after installing Claude Code.${NC}"
    fi
}

# ── Summary ───────────────────────────────────────────────────

echo ""
echo -e "${BOLD}${GREEN}═══════════════════════════════════════════════${NC}"
echo -e "${BOLD}${GREEN}  Scaffold complete! ${copied} files.${NC}"
[[ $skipped -gt 0 ]] && echo -e "${YELLOW}  ${skipped} skipped (already exist)${NC}"
echo -e "${BOLD}${GREEN}═══════════════════════════════════════════════${NC}"

# ── Launch Claude bootstrap ───────────────────────────────────

BOOTSTRAP="$TARGET_DIR/scripts/bootstrap-${MODE}.md"

if [[ "$NO_BOOTSTRAP" == true ]]; then
    echo ""
    echo -e "${BOLD}Scaffold only (--no-bootstrap). To bootstrap later:${NC}"
    [[ -z "$PRD_PATH" ]] && echo -e "  1. Create ${BOLD}PRD.md${NC} in project root"
    echo -e "  Run: ${BLUE}cd $TARGET_DIR && claude -p \"\$(cat scripts/bootstrap-${MODE}.md)\"${NC}"

elif [[ -f "$BOOTSTRAP" ]] && command -v claude &>/dev/null && { [[ -n "$PRD_PATH" ]] || [[ "$MODE" == "init" ]]; }; then
    echo ""
    echo -e "${BOLD}${BLUE}Launching Claude (${MODE} mode)...${NC}"
    echo -e "${BLUE}Claude will read your PRD and populate everything. This may take a few minutes.${NC}"
    echo ""
    cd "$TARGET_DIR"
    claude --model claude-opus-4-6 --print -p "$(cat "$BOOTSTRAP")" || {
        echo ""
        echo -e "${YELLOW}Claude interrupted. Run manually:${NC}"
        echo -e "  ${BLUE}cd $TARGET_DIR && claude -p \"\$(cat scripts/bootstrap-${MODE}.md)\"${NC}"
    }
else
    echo ""
    [[ -z "$PRD_PATH" ]] && echo -e "  1. Create ${BOLD}PRD.md${NC} in project root"
    echo -e "  2. Run: ${BLUE}cd $TARGET_DIR && claude -p \"\$(cat scripts/bootstrap-${MODE}.md)\"${NC}"
    echo -e "  Claude reads PRD → populates ROADMAP, DISPATCH, vault → kicks off Sprint 1."
fi
echo ""
