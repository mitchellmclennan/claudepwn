#!/usr/bin/env bash
set -euo pipefail

# ──────────────────────────────────────────────────────────────
# claude-project-template — init.sh
#
# Sets up a fully-configured Claude Code automation environment.
# Clone this repo, run init.sh in your project, Claude does the rest.
#
# Usage:
#   /path/to/init.sh                          # interactive
#   /path/to/init.sh --name my-api --stack python
#   /path/to/init.sh --name my-app --stack typescript --features vault,checklists
#   /path/to/init.sh --name my-svc --stack rust --minimal
# ──────────────────────────────────────────────────────────────

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
TARGET_DIR="$(pwd)"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
BOLD='\033[1m'
NC='\033[0m'

# Defaults
PROJECT_NAME=""
STACK=""
FEATURES=""
FORCE=false
MINIMAL=false
NO_GIT=false
SKIP_CONFIRM=false

# ── Parse args ────────────────────────────────────────────────

usage() {
    cat <<'EOF'
claude-project-template — Set up Claude Code automation for any project

Usage: init.sh [options]

Options:
  --name, -n NAME       Project name (default: directory name)
  --stack, -s STACK     Tech stack: python, typescript, rust, go (default: detect or ask)
  --features FEATURES   Comma-separated: vault, checklists, sprints, gitnexus, plugins
  --minimal             Agents + rules + hooks only (no vault, checklists, scripts)
  --force               Overwrite existing files (backs up originals as .bak)
  --no-git              Skip git init
  --yes, -y             Accept defaults without prompting
  --help, -h            Show this help

Examples:
  init.sh --name my-api --stack python
  init.sh --name my-app --stack typescript --features vault,checklists
  init.sh --minimal --stack go
  init.sh  # interactive mode

What this does:
  1. Copies .claude/ folder (agents, commands, rules, hooks, skills)
  2. Creates CLAUDE.md, AGENTS.md, BOARD.md, DISPATCH.md, ROADMAP.md, REVIEW.md
  3. Applies stack-specific overrides (Python/TS/Rust/Go lint, test, format commands)
  4. Optionally creates vault/, checklists/, scripts/
  5. You drop your PRD.md in the root — Claude reads it natively
EOF
    exit 0
}

while [[ $# -gt 0 ]]; do
    case $1 in
        --name|-n)    PROJECT_NAME="$2"; shift 2 ;;
        --stack|-s)   STACK="$2"; shift 2 ;;
        --features)   FEATURES="$2"; shift 2 ;;
        --minimal)    MINIMAL=true; shift ;;
        --force)      FORCE=true; shift ;;
        --no-git)     NO_GIT=true; shift ;;
        --yes|-y)     SKIP_CONFIRM=true; shift ;;
        --help|-h)    usage ;;
        *)            echo -e "${RED}Unknown option: $1${NC}"; usage ;;
    esac
done

# ── Detect / prompt for missing values ────────────────────────

if [[ -z "$PROJECT_NAME" ]]; then
    DEFAULT_NAME="$(basename "$TARGET_DIR")"
    if [[ "$SKIP_CONFIRM" == true ]]; then
        PROJECT_NAME="$DEFAULT_NAME"
    else
        read -rp "Project name [$DEFAULT_NAME]: " PROJECT_NAME
        PROJECT_NAME="${PROJECT_NAME:-$DEFAULT_NAME}"
    fi
fi

# Normalize project name
PROJECT_NAME="$(echo "$PROJECT_NAME" | tr '[:upper:]' '[:lower:]' | tr ' _' '-' | sed 's/--*/-/g; s/^-//; s/-$//')"

if [[ -z "$STACK" ]]; then
    # Try auto-detect
    if [[ -f "$TARGET_DIR/pyproject.toml" ]] || [[ -f "$TARGET_DIR/setup.py" ]] || [[ -f "$TARGET_DIR/requirements.txt" ]]; then
        STACK="python"
    elif [[ -f "$TARGET_DIR/package.json" ]] || [[ -f "$TARGET_DIR/tsconfig.json" ]]; then
        STACK="typescript"
    elif [[ -f "$TARGET_DIR/Cargo.toml" ]]; then
        STACK="rust"
    elif [[ -f "$TARGET_DIR/go.mod" ]]; then
        STACK="go"
    fi

    if [[ -n "$STACK" ]]; then
        echo -e "${GREEN}Auto-detected stack: ${BOLD}$STACK${NC}"
    elif [[ "$SKIP_CONFIRM" == true ]]; then
        STACK="python"
    else
        echo ""
        echo "Select your tech stack:"
        echo "  1) python      (FastAPI, Django, Flask, scripts)"
        echo "  2) typescript   (Next.js, Node, React, Deno)"
        echo "  3) rust         (Actix, Axum, CLI tools)"
        echo "  4) go           (Gin, Echo, CLI tools)"
        echo ""
        read -rp "Stack [1-4]: " STACK_CHOICE
        case "$STACK_CHOICE" in
            1|python)     STACK="python" ;;
            2|typescript) STACK="typescript" ;;
            3|rust)       STACK="rust" ;;
            4|go)         STACK="go" ;;
            *)            echo -e "${RED}Invalid choice. Defaulting to python.${NC}"; STACK="python" ;;
        esac
    fi
fi

# Validate stack
if [[ ! -d "$SCRIPT_DIR/stacks/$STACK" ]]; then
    echo -e "${RED}ERROR: Unknown stack '$STACK'. Available: python, typescript, rust, go${NC}"
    exit 1
fi

# Resolve features
FEAT_VAULT=false
FEAT_CHECKLISTS=false
FEAT_SPRINTS=false
FEAT_GITNEXUS=false
FEAT_PLUGINS=false

if [[ "$MINIMAL" == true ]]; then
    : # all features off
elif [[ -n "$FEATURES" ]]; then
    IFS=',' read -ra FEAT_ARRAY <<< "$FEATURES"
    for feat in "${FEAT_ARRAY[@]}"; do
        feat="$(echo "$feat" | tr -d ' ')"
        case "$feat" in
            vault)      FEAT_VAULT=true ;;
            checklists) FEAT_CHECKLISTS=true ;;
            sprints)    FEAT_SPRINTS=true ;;
            gitnexus)   FEAT_GITNEXUS=true ;;
            plugins)    FEAT_PLUGINS=true ;;
            all)        FEAT_VAULT=true; FEAT_CHECKLISTS=true; FEAT_SPRINTS=true; FEAT_GITNEXUS=true; FEAT_PLUGINS=true ;;
            *)          echo -e "${YELLOW}Warning: unknown feature '$feat', skipping${NC}" ;;
        esac
    done
elif [[ "$SKIP_CONFIRM" == false ]]; then
    echo ""
    echo "Optional features (comma-separated, or 'all', or press Enter to skip):"
    echo "  vault       — Obsidian-compatible knowledge vault"
    echo "  checklists  — Epic/sprint/session checklists"
    echo "  sprints     — Multi-phase sprint runner + prompt templates"
    echo "  gitnexus    — Code knowledge graph integration"
    echo "  plugins     — Plugin ecosystem (security-review, code-review, etc.)"
    echo ""
    read -rp "Features [none]: " FEATURES_INPUT
    if [[ -n "$FEATURES_INPUT" ]]; then
        IFS=',' read -ra FEAT_ARRAY <<< "$FEATURES_INPUT"
        for feat in "${FEAT_ARRAY[@]}"; do
            feat="$(echo "$feat" | tr -d ' ')"
            case "$feat" in
                vault)      FEAT_VAULT=true ;;
                checklists) FEAT_CHECKLISTS=true ;;
                sprints)    FEAT_SPRINTS=true ;;
                gitnexus)   FEAT_GITNEXUS=true ;;
                plugins)    FEAT_PLUGINS=true ;;
                all)        FEAT_VAULT=true; FEAT_CHECKLISTS=true; FEAT_SPRINTS=true; FEAT_GITNEXUS=true; FEAT_PLUGINS=true ;;
            esac
        done
    fi
fi

# ── Confirm ───────────────────────────────────────────────────

echo ""
echo -e "${BOLD}═══════════════════════════════════════════════${NC}"
echo -e "${BOLD}  Claude Code Project Setup${NC}"
echo -e "${BOLD}═══════════════════════════════════════════════${NC}"
echo -e "  Project:    ${GREEN}${PROJECT_NAME}${NC}"
echo -e "  Stack:      ${GREEN}${STACK}${NC}"
echo -e "  Target:     ${BLUE}${TARGET_DIR}${NC}"
echo -e "  Features:   vault=${FEAT_VAULT} checklists=${FEAT_CHECKLISTS} sprints=${FEAT_SPRINTS}"
echo -e "              gitnexus=${FEAT_GITNEXUS} plugins=${FEAT_PLUGINS}"
echo -e "${BOLD}═══════════════════════════════════════════════${NC}"

if [[ "$SKIP_CONFIRM" == false ]]; then
    read -rp "Proceed? [Y/n]: " CONFIRM
    if [[ "$CONFIRM" =~ ^[Nn] ]]; then
        echo "Aborted."
        exit 0
    fi
fi

# ── Helper: safe copy ─────────────────────────────────────────

copied=0
skipped=0

safe_copy() {
    local src="$1"
    local dst="$2"

    mkdir -p "$(dirname "$dst")"

    if [[ -f "$dst" && "$FORCE" == false ]]; then
        skipped=$((skipped + 1))
        return
    fi

    if [[ -f "$dst" && "$FORCE" == true ]]; then
        cp "$dst" "${dst}.bak" 2>/dev/null || true
    fi

    cp "$src" "$dst"
    copied=$((copied + 1))
}

# Stack overlay always overwrites base files (that's the point of overlays)
overlay_copy() {
    local src="$1"
    local dst="$2"

    mkdir -p "$(dirname "$dst")"
    cp "$src" "$dst"
    copied=$((copied + 1))
}

# Sed wrapper: replace placeholders in-place
fill_placeholders() {
    local file="$1"
    if [[ -f "$file" ]]; then
        sed -i '' \
            -e "s|__PROJECT_NAME__|${PROJECT_NAME}|g" \
            -e "s|__STACK__|${STACK}|g" \
            "$file" 2>/dev/null || \
        sed -i \
            -e "s|__PROJECT_NAME__|${PROJECT_NAME}|g" \
            -e "s|__STACK__|${STACK}|g" \
            "$file" 2>/dev/null || true
    fi
}

# ── Copy base files ───────────────────────────────────────────

echo ""
echo -e "${BLUE}Copying base .claude/ structure...${NC}"

# Copy entire base/.claude/ tree
while IFS= read -r src; do
    relative="${src#$SCRIPT_DIR/base/}"
    safe_copy "$src" "$TARGET_DIR/$relative"
done < <(find "$SCRIPT_DIR/base/.claude" -type f)

# Copy root markdown files
for md in CLAUDE.md AGENTS.md BOARD.md DISPATCH.md ROADMAP.md REVIEW.md .gitignore .env.example; do
    if [[ -f "$SCRIPT_DIR/base/$md" ]]; then
        safe_copy "$SCRIPT_DIR/base/$md" "$TARGET_DIR/$md"
    fi
done

# ── Apply stack overlay ───────────────────────────────────────

echo -e "${BLUE}Applying ${STACK} stack overlay...${NC}"

while IFS= read -r src; do
    relative="${src#$SCRIPT_DIR/stacks/$STACK/}"
    overlay_copy "$src" "$TARGET_DIR/$relative"
done < <(find "$SCRIPT_DIR/stacks/$STACK" -type f)

# ── Fill placeholders ─────────────────────────────────────────

echo -e "${BLUE}Filling project placeholders...${NC}"

while IFS= read -r f; do
    fill_placeholders "$f"
done < <(find "$TARGET_DIR/.claude" -type f \( -name "*.md" -o -name "*.json" -o -name "*.sh" \))

for md in CLAUDE.md AGENTS.md BOARD.md DISPATCH.md ROADMAP.md REVIEW.md; do
    fill_placeholders "$TARGET_DIR/$md"
done

# ── Optional features ─────────────────────────────────────────

if [[ "$FEAT_VAULT" == true ]]; then
    echo -e "${BLUE}Creating vault/ structure...${NC}"
    for dir in 00-Inbox 01-Architecture 02-Domain 03-Decisions 04-APIs 05-Data-Models 06-Patterns 07-Ops 08-Research 09-Retrospectives _meta; do
        mkdir -p "$TARGET_DIR/vault/$dir"
    done
    if [[ -d "$SCRIPT_DIR/vault-template" ]]; then
        while IFS= read -r src; do
            relative="${src#$SCRIPT_DIR/vault-template/}"
            safe_copy "$src" "$TARGET_DIR/vault/$relative"
            fill_placeholders "$TARGET_DIR/vault/$relative"
        done < <(find "$SCRIPT_DIR/vault-template" -type f)
    fi
fi

if [[ "$FEAT_CHECKLISTS" == true ]]; then
    echo -e "${BLUE}Creating checklists/...${NC}"
    mkdir -p "$TARGET_DIR/checklists/active"
    while IFS= read -r src; do
        relative="${src#$SCRIPT_DIR/checklists/}"
        safe_copy "$src" "$TARGET_DIR/checklists/$relative"
        fill_placeholders "$TARGET_DIR/checklists/$relative"
    done < <(find "$SCRIPT_DIR/checklists" -type f)
fi

if [[ "$FEAT_SPRINTS" == true ]]; then
    echo -e "${BLUE}Creating scripts/ (sprint runner + prompts)...${NC}"
    mkdir -p "$TARGET_DIR/scripts/prompts"
    while IFS= read -r src; do
        relative="${src#$SCRIPT_DIR/scripts/}"
        safe_copy "$src" "$TARGET_DIR/scripts/$relative"
        fill_placeholders "$TARGET_DIR/scripts/$relative"
    done < <(find "$SCRIPT_DIR/scripts" -type f)
    chmod +x "$TARGET_DIR/scripts/"*.sh 2>/dev/null || true
fi

# ── Make hooks executable ─────────────────────────────────────

chmod +x "$TARGET_DIR/.claude/hooks/"*.sh 2>/dev/null || true

# ── Git init ──────────────────────────────────────────────────

if [[ "$NO_GIT" == false && ! -d "$TARGET_DIR/.git" ]]; then
    echo -e "${BLUE}Initializing git repository...${NC}"
    cd "$TARGET_DIR"
    git init -q
    # Symlink pre-commit hook if we have one
    if [[ -f "$TARGET_DIR/.claude/hooks/pre-commit.sh" ]]; then
        mkdir -p "$TARGET_DIR/.git/hooks"
        ln -sf "../../.claude/hooks/pre-commit.sh" "$TARGET_DIR/.git/hooks/pre-commit"
    fi
fi

# ── Summary ───────────────────────────────────────────────────

echo ""
echo -e "${BOLD}${GREEN}═══════════════════════════════════════════════${NC}"
echo -e "${BOLD}${GREEN}  Setup complete!${NC}"
echo -e "${BOLD}${GREEN}═══════════════════════════════════════════════${NC}"
echo -e "  Files created:  ${GREEN}${copied}${NC}"
[[ $skipped -gt 0 ]] && echo -e "  Files skipped:  ${YELLOW}${skipped}${NC} (already exist, use --force to overwrite)"
echo ""
echo -e "${BOLD}Next steps:${NC}"
echo -e "  1. Drop your ${BOLD}PRD.md${NC} in the project root"
echo -e "  2. Open Claude Code: ${BLUE}cd $TARGET_DIR && claude${NC}"
echo -e "  3. Run ${BLUE}/session-start${NC} to kick off the pipeline"
echo ""
echo -e "  Claude will read your PRD, CLAUDE.md, and all agent files automatically."
echo -e "  No config needed — just start working."
echo ""
