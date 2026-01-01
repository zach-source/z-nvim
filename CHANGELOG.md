# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.1.0] - 2026-01-01

### Added
- add semantic release workflow and bump to v1.1.0

### Changed
- clean up config and add improvements

## [Unreleased]

## [1.1.0] - 2025-12-31

### Added
- Explicit conform.nvim configuration for Nix-managed formatters
- Spell check toggle keymap (`<leader>us`)
- Auto-enable spell checking for markdown, gitcommit filetypes
- Semantic release GitHub Action for automated versioning
- UI/Toggle keymap group (`<leader>u`)

### Changed
- Removed unused preinstalled plugins (telescope, nvim-notify, dressing-nvim)
- Removed Copilot plugins from preinstall (disabled in config)
- Removed treesitter `ensure_installed` (Nix provides all parsers)
- Updated CLAUDE.md with semantic commit guidelines

## [1.0.0] - 2025-12-25

### Added
- Initial stable release
- LazyVim module (`homeManagerModules.lazyvim`) with inline Lua configuration
- NixVim module (`homeManagerModules.nixvim`) for pure-Nix configuration
- Semantic versioning with `version` and `versionInfo` flake outputs
- Version checking utilities via `lib.versionAtLeast`
- Local testing via `nix run .#test` (isolated environment)
- Build-only output via `nix build .#config`
- Catppuccin Mocha theme as default colorscheme
- Snacks.nvim replacing telescope, neo-tree, indent-blankline, noice
- Custom logging system (`logger.lua`) with file rotation
- Zellij integration for pane navigation
- Claude Code follow mode via `claude-follow-hook.nvim`
- Sidekick AI integration
- Comprehensive LSP support via Nix-managed servers (Mason disabled)

### Supported Languages
- Go, Rust, TypeScript, JavaScript, Python, Java
- Nix, JSON, YAML, Docker, Terraform, Markdown, SQL, Git

### Target Versions
- LazyVim: 15.x (currently v15.13.0)
- Neovim: 0.10+

## Versioning Policy

This project uses semantic versioning:

- **MAJOR**: Breaking changes to module interface or configuration structure
- **MINOR**: New features, language support, or plugin additions (backward compatible)
- **PATCH**: Bug fixes, dependency updates, documentation (backward compatible)

### Using a Specific Version

Pin to a version in your `flake.nix`:

```nix
{
  inputs = {
    z-nvim = {
      url = "github:zach-source/z-nvim/v1.0.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}
```

### Version Checking

Check version compatibility in your configuration:

```nix
{ inputs, ... }:
{
  assertions = [
    {
      assertion = inputs.z-nvim.lib.versionAtLeast "1.0.0";
      message = "z-nvim >= 1.0.0 required";
    }
  ];
}
```

[Unreleased]: https://github.com/zach-source/z-nvim/compare/v1.1.0...HEAD
[1.1.0]: https://github.com/zach-source/z-nvim/compare/v1.0.0...v1.1.0
[1.0.0]: https://github.com/zach-source/z-nvim/releases/tag/v1.0.0
