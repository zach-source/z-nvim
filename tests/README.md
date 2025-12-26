# LazyVim Keymap Integration Tests

This directory contains comprehensive integration tests for custom NeoVim keybindings that load actual plugins to verify functionality.

## Prerequisites

- NeoVim 0.9+ with LazyVim installed
- Plugins installed via lazy.nvim (automatically handled by test runner)

## Running Tests

```bash
# From the tests directory
./run-tests.sh

# Or from anywhere
bash ~/dotfiles/nix/home/ztaylor/features/dev/lazyvim/tests/run-tests.sh
```

## Test Structure

- `keymaps_spec.lua` - Comprehensive test suite with integration tests
- `minimal_init.lua` - Test config that loads real plugins (Snacks, Zellij nav, etc.)
- `run-tests.sh` - Enhanced test runner with plugin loading support

## What's Tested

### Keymap Registration

### Window Management
- `<leader>ww` - Switch to other window
- `<leader>wd` - Close window
- `<leader>ws` - Split below
- `<leader>wv` - Split right
- `<leader>w=` - Balance windows
- `<leader>wm` - Maximize window
- `<leader>w+` - Increase height
- `<leader>w-` - Decrease height
- `<leader>w>` - Increase width
- `<leader>w<` - Decrease width

### Buffer Navigation
- `[b` - Previous buffer
- `]b` - Next buffer

### Zellij Navigation
- `<C-h>` - Navigate left or previous tab
- `<C-j>` - Navigate down
- `<C-k>` - Navigate up
- `<C-l>` - Navigate right or next tab

### Descriptions
- Verifies all custom keymaps have descriptions for which-key

### Plugin Integration Tests

**Snacks.nvim**
- Verifies Snacks global is loaded
- Tests explorer functionality exists and is callable
- Tests picker functions (files, buffers, grep) are available
- Tests bufdelete functionality exists

**Zellij Navigation**
- Verifies all ZellijNavigate commands are registered
- Tests integration with zellij-nav.nvim plugin

**Layout Functions**
- Tests config.layouts module loads correctly
- Verifies dev_with_claude function exists and is callable
- Verifies focus function exists and is callable

### Functional Tests

**Buffer Operations**
- Tests buffer navigation actually works
- Verifies buffer switching functionality

**Window Operations**
- Tests window splitting (horizontal and vertical)
- Verifies split commands create new windows

## Adding New Tests

To test additional functionality:

1. Add new test cases to `keymaps_spec.lua`
2. If testing new plugins, add them to `minimal_init.lua` lazy.nvim setup
3. Add integration tests to verify plugin functions exist and work
4. Run `./run-tests.sh` to verify

## Test Output

The test runner provides:
- ✅ Success indicators for passed tests
- ❌ Failure indicators with detailed error messages
- Plugin loading status checks
- Exit code (0 = success, non-zero = failure)

## Troubleshooting

**Tests fail with plugin not found**
- Run NeoVim normally first to let lazy.nvim install plugins
- The test runner will auto-install missing plugins on first run

**Snacks functions not available**
- Wait time increased to 2s for plugin loading
- Check `minimal_init.lua` has Snacks properly configured

**Keymap not found in tests**
- Verify keymap exists in `lua/config/keymaps.lua`
- Check keymap format (leader = space character in tests)

**Integration tests fail**
- Ensure plugins are actually installed in `~/.local/share/nvim/lazy/`
- Check plugin configuration in `minimal_init.lua` matches main config

**Timeout errors**
- Tests have 10s timeout for plugin loading
- Slow systems may need timeout adjustment in `run-tests.sh`
