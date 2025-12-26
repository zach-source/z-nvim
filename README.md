# z-nvim

[![Version](https://img.shields.io/badge/version-1.0.0-blue.svg)](CHANGELOG.md)
[![LazyVim](https://img.shields.io/badge/LazyVim-15.x-green.svg)](https://github.com/LazyVim/LazyVim)

Declarative Neovim configuration as a Home Manager module.

## Features

- **LazyVim Module**: Full LazyVim setup with Nix-managed LSP servers
- **NixVim Module**: Alternative pure-Nix configuration using NixVim
- **Catppuccin Theme**: Mocha flavor by default
- **Comprehensive Logging**: Debug logging for LSP and plugins
- **Nix Integration**: LSP servers managed by Nix, not Mason
- **Semantic Versioning**: Pin to stable releases

## Installation

Add to your `flake.nix`:

```nix
{
  inputs = {
    z-nvim = {
      url = "github:zach-source/z-nvim";  # Latest
      # url = "github:zach-source/z-nvim/v1.0.0";  # Pinned version
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}
```

Import in your Home Manager configuration:

```nix
{ inputs, ... }:
{
  imports = [
    inputs.z-nvim.homeManagerModules.lazyvim
  ];
}
```

### Version Checking

Optionally assert minimum version in your config:

```nix
{ inputs, ... }:
{
  assertions = [{
    assertion = inputs.z-nvim.lib.versionAtLeast "1.0.0";
    message = "z-nvim >= 1.0.0 required";
  }];
}
```

## Modules

### LazyVim (`homeManagerModules.lazyvim`)

Full LazyVim configuration with:
- LazyVim v15.x pinned for stability
- Catppuccin Mocha theme
- Nix-managed LSP servers (gopls, rust-analyzer, lua-ls, etc.)
- Which-key integration
- Telescope, Treesitter, completion
- Custom logger for debugging

### NixVim (`homeManagerModules.nixvim`)

Pure NixVim configuration (requires nixvim input):
- Declarative plugin configuration
- Mini.nvim plugin suite
- LSP with Nix-managed servers

## Structure

```
z-nvim/
├── flake.nix              # Flake with Home Manager modules
├── modules/
│   ├── lazyvim/
│   │   ├── default.nix    # Main LazyVim module (inline Lua)
│   │   ├── logger.lua     # Custom logger
│   │   └── LOGGING.md     # Logging documentation
│   └── nixvim/
│       ├── default.nix    # NixVim entry point
│       ├── keymaps.nix    # Key mappings
│       ├── options.nix    # Vim options
│       └── plugins/       # Plugin configurations
└── tests/                 # Keymap and config tests
```

## Testing

Test the configuration without affecting your real setup:

```bash
# Interactive test session (isolated environment)
nix run .#test

# Headless syntax check
nix run .#test -- --check

# Build config files to inspect
nix build .#config
ls result/
```

## Development

This project uses [Jujutsu (jj)](https://github.com/martinvonz/jj) for version control.

```bash
jj status              # Check status
jj log                 # View history
jj describe -m "msg"   # Set commit message
jj new                 # New change
jj git push            # Push to remote
```

## Debugging

Check logs at:
- `~/.local/state/nvim/lsp.log` - LSP communication
- `~/.local/state/nvim/debug.log` - Custom debug log

Use `:messages` in Neovim to see recent notifications.

## License

MIT
