#!/usr/bin/env bash
# Test nvim config locally without affecting your real setup
#
# Usage:
#   ./scripts/test-local.sh          # Build and test interactively
#   ./scripts/test-local.sh --build  # Force rebuild before testing
#   ./scripts/test-local.sh --check  # Headless syntax check only
#   ./scripts/test-local.sh file.lua # Open specific file in test nvim

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(dirname "$SCRIPT_DIR")"
TEST_DIR="/tmp/nvim-config-test-$$"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

cleanup() {
    if [[ -d "$TEST_DIR" ]]; then
        rm -rf "$TEST_DIR"
    fi
}

# Cleanup on exit unless --keep is passed
KEEP_DIR=false
for arg in "$@"; do
    if [[ "$arg" == "--keep" ]]; then
        KEEP_DIR=true
    fi
done
if [[ "$KEEP_DIR" == false ]]; then
    trap cleanup EXIT
fi

usage() {
    echo "Usage: $0 [OPTIONS] [FILES...]"
    echo ""
    echo "Options:"
    echo "  --build    Force home-manager build before testing"
    echo "  --check    Headless syntax check only (no interactive session)"
    echo "  --keep     Keep test directory after exit (for debugging)"
    echo "  --help     Show this help message"
    echo ""
    echo "Examples:"
    echo "  $0                    # Test interactively"
    echo "  $0 --check            # Quick syntax verification"
    echo "  $0 --build            # Rebuild and test"
    echo "  $0 README.md          # Open file in test nvim"
}

# Parse arguments
BUILD=false
CHECK_ONLY=false
FILES=()

for arg in "$@"; do
    case "$arg" in
        --build)
            BUILD=true
            ;;
        --check)
            CHECK_ONLY=true
            ;;
        --keep)
            # Already handled above
            ;;
        --help|-h)
            usage
            exit 0
            ;;
        -*)
            echo -e "${RED}Unknown option: $arg${NC}"
            usage
            exit 1
            ;;
        *)
            FILES+=("$arg")
            ;;
    esac
done

echo -e "${GREEN}=== z-nvim Local Test ===${NC}"
echo "Test dir: $TEST_DIR"
echo ""

# Check if home-manager result exists or build requested
RESULT_DIR=""
if [[ -L "$REPO_DIR/result" ]] && [[ "$BUILD" == false ]]; then
    RESULT_DIR="$REPO_DIR/result"
    echo -e "${YELLOW}Using existing build: $RESULT_DIR${NC}"
elif [[ -d "$HOME/.config/nvim" ]] && [[ "$BUILD" == false ]]; then
    # Fallback to current user config
    echo -e "${YELLOW}Using current config from ~/.config/nvim${NC}"
    RESULT_DIR=""
else
    echo -e "${YELLOW}Building home-manager config...${NC}"
    if ! command -v home-manager &> /dev/null; then
        echo -e "${RED}Error: home-manager not found${NC}"
        echo "Install home-manager or run from a nix shell with it available"
        exit 1
    fi

    cd "$REPO_DIR"
    if home-manager build; then
        RESULT_DIR="$REPO_DIR/result"
        echo -e "${GREEN}Build successful${NC}"
    else
        echo -e "${RED}Build failed${NC}"
        exit 1
    fi
fi

# Setup isolated test environment
mkdir -p "$TEST_DIR"/{config/nvim,data,state,cache}

# Copy config to test directory
if [[ -n "$RESULT_DIR" ]] && [[ -d "$RESULT_DIR/home-files/.config/nvim" ]]; then
    cp -rL "$RESULT_DIR/home-files/.config/nvim/"* "$TEST_DIR/config/nvim/"
elif [[ -d "$HOME/.config/nvim" ]]; then
    cp -rL "$HOME/.config/nvim/"* "$TEST_DIR/config/nvim/"
else
    echo -e "${RED}Error: No nvim config found${NC}"
    echo "Run 'home-manager switch' or 'home-manager build' first"
    exit 1
fi

echo "Config copied to: $TEST_DIR/config/nvim"
echo ""

# Set environment for isolated testing
export XDG_CONFIG_HOME="$TEST_DIR/config"
export XDG_DATA_HOME="$TEST_DIR/data"
export XDG_STATE_HOME="$TEST_DIR/state"
export XDG_CACHE_HOME="$TEST_DIR/cache"

if [[ "$CHECK_ONLY" == true ]]; then
    echo -e "${YELLOW}Running headless check...${NC}"
    if nvim --headless -c 'qall' 2>&1; then
        echo -e "${GREEN}✓ Config loads successfully${NC}"
        exit 0
    else
        echo -e "${RED}✗ Config has errors${NC}"
        exit 1
    fi
else
    echo -e "${GREEN}Starting nvim in isolated environment...${NC}"
    echo "(Your real config is unaffected)"
    echo ""

    # Run nvim with any files passed as arguments
    nvim "${FILES[@]}"
fi
