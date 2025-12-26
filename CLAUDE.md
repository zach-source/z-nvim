# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Build & Test Commands

```bash
# Quick test with nix (isolated, no home-manager switch needed)
nix run .#test              # Interactive test session
nix run .#test -- --check   # Headless syntax check only

# Build config to inspect
nix build .#config          # Outputs to ./result with nvim config files

# Apply to your real config (requires home-manager)
home-manager switch

# Run keymap integration tests
cd tests && ./run-tests.sh

# Watch logs while testing
tail -f ~/.local/state/nvim/debug.log
```

## Architecture

This is a Nix flake providing two Home Manager modules for declarative Neovim configuration.

### LazyVim Module (`modules/lazyvim/default.nix`)

The primary module generates **all Lua configuration inline** via Nix's `xdg.configFile`. The single 1500+ line `default.nix` contains:

- `init.lua` text block: Bootstrap lazy.nvim, plugin specs, LSP config
- `lua/config/*.lua` text blocks: Options, keymaps, autocmds, layouts
- `programs.neovim.plugins`: Nix-packaged plugins preinstalled to avoid runtime downloads

**Key design decisions:**
- Mason is completely disabled - LSP servers come from `home.packages` in the consuming flake
- LazyVim itself is NOT preinstalled (Nix version can lag) - lazy.nvim downloads it
- Plugins specified inline in lazy.nvim spec, not in separate `lua/plugins/` files
- Snacks.nvim replaces telescope, neo-tree, indent-blankline, and noice

### NixVim Module (`modules/nixvim/`)

Alternative pure-Nix approach using the nixvim flake. Requires `nixvim` input in consuming flake. Config split across:
- `default.nix`: Entry point, colorscheme, autocmds
- `options.nix`, `keymaps.nix`: Standard vim settings
- `plugins/*.nix`: LSP, completion, UI, etc.
- `plugins/languages/*.nix`: Language-specific configs

## Development Workflow

Uses [Jujutsu (jj)](https://github.com/martinvonz/jj) for version control:

```bash
jj status          # Check status
jj log             # View history
jj describe -m ""  # Set commit message
jj new             # New change
jj squash          # Fold into parent
jj git push        # Push to remote
```

## Debugging

```bash
# Log locations
~/.local/state/nvim/lsp.log     # LSP protocol messages
~/.local/state/nvim/debug.log   # Custom logger output

# In Neovim
:messages          # Recent notifications
:LspInfo           # LSP status
:Lazy              # Plugin manager
:lua logger.info("test")  # Manual logging
```

## Making Changes

1. Edit `modules/lazyvim/default.nix` for LazyVim changes
2. Run `nvim --headless -c 'qall'` to verify syntax
3. Run `home-manager switch` to apply
4. Test in nvim, check `:messages` and logs for errors
