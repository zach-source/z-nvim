#!/usr/bin/env bash
# Run NeoVim keymap tests with plugin integration
# This will load actual plugins to test real functionality

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="$(dirname "$SCRIPT_DIR")"

echo "╔════════════════════════════════════════════════════════════╗"
echo "║         NeoVim Keymap Integration Tests                   ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo ""
echo "Config dir: $CONFIG_DIR"
echo "Test dir: $SCRIPT_DIR"
echo ""

# Check if lazy.nvim is installed
LAZY_PATH="$HOME/.local/share/nvim/lazy/lazy.nvim"
if [[ ! -d "$LAZY_PATH" ]]; then
    echo "⚠️  Warning: lazy.nvim not found at $LAZY_PATH"
    echo "The test runner will attempt to clone it..."
fi

# Check if snacks.nvim is installed
SNACKS_PATH="$HOME/.local/share/nvim/lazy/snacks.nvim"
if [[ ! -d "$SNACKS_PATH" ]]; then
    echo "⚠️  Warning: snacks.nvim not found at $SNACKS_PATH"
    echo "The test runner will attempt to install it..."
fi

# Check if plenary is installed
PLENARY_PATH="$HOME/.local/share/nvim/lazy/plenary.nvim"
if [[ ! -d "$PLENARY_PATH" ]]; then
    echo "⚠️  Warning: plenary.nvim not found at $PLENARY_PATH"
    echo "The test runner will attempt to install it..."
fi

echo ""
echo "🚀 Starting tests..."
echo ""

# Run the tests with increased timeout for plugin loading
nvim --headless \
    -u "$SCRIPT_DIR/minimal_init.lua" \
    -c "lua require('plenary.test_harness').test_directory('$SCRIPT_DIR', { minimal_init = '$SCRIPT_DIR/minimal_init.lua' })"

TEST_EXIT_CODE=$?

echo ""
if [[ $TEST_EXIT_CODE -eq 0 ]]; then
    echo "✅ All tests passed!"
else
    echo "❌ Some tests failed (exit code: $TEST_EXIT_CODE)"
fi

exit $TEST_EXIT_CODE
