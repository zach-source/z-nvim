# NixVim configuration - LazyVim-inspired declarative Neovim setup
{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:
{
  imports = [
    inputs.nixvim.homeManagerModules.nixvim
    ./options.nix
    ./keymaps.nix
    ./plugins/ui.nix
    ./plugins/mini.nix # Complete mini.nvim module suite
    ./plugins/editor.nix
    ./plugins/treesitter.nix
    ./plugins/lsp.nix
    ./plugins/completion.nix
    ./plugins/git.nix
    ./plugins/lazy-loading.nix # Lazy loading configuration
    ./plugins/languages/go.nix
    ./plugins/languages/nix.nix
    ./plugins/languages/typescript.nix
  ];

  programs.nixvim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;

    # Colorscheme - Tokyo Night like LazyVim default
    colorschemes.tokyonight = {
      enable = true;
      settings = {
        style = "night";
        transparent = false;
        terminal_colors = true;
        styles = {
          comments = {
            italic = true;
          };
          keywords = {
            italic = true;
          };
          sidebars = "dark";
          floats = "dark";
        };
      };
    };

    # Global settings
    globals = {
      mapleader = " ";
      maplocalleader = "\\";

      # Disable some built-in plugins for performance
      loaded_perl_provider = 0;
      loaded_ruby_provider = 0;
      loaded_python_provider = 0;
      loaded_node_provider = 0;
    };

    # Clipboard integration
    clipboard = {
      register = "unnamedplus";
      providers.wl-copy.enable = true;
    };

    # Auto commands
    autoCmd = [
      # Highlight on yank
      {
        event = "TextYankPost";
        pattern = "*";
        callback = {
          __raw = ''
            function()
              vim.highlight.on_yank({ higroup = 'Visual', timeout = 200 })
            end
          '';
        };
      }
      # Auto resize splits
      {
        event = "VimResized";
        pattern = "*";
        command = "tabdo wincmd =";
      }
      # Close some filetypes with <q>
      {
        event = "FileType";
        pattern = [
          "help"
          "lspinfo"
          "man"
          "notify"
          "qf"
          "query"
          "startuptime"
          "checkhealth"
        ];
        callback = {
          __raw = ''
            function(event)
              vim.bo[event.buf].buflisted = false
              vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
            end
          '';
        };
      }
    ];

    # Extra packages available to Neovim
    extraPackages = with pkgs; [
      # General tools
      fd
      ripgrep
      fzf
      gnumake
      gcc
      nodejs
      tree-sitter

      # Language tools installed via Nix (not Mason)
      # These are the actual binaries that LSP will use

      # Language Servers
      docker-language-server

      # Formatters
      stylua
      nodePackages.prettier
      black
      nixfmt-rfc-style
      gofumpt
      rustfmt
      shfmt

      # Linters and tools
      shellcheck
      ruff
      golangci-lint
      eslint_d

      # Debug adapters
      delve
      lldb
    ];

    # Extra Lua configuration for things not covered by NixVim modules
    extraConfigLua = ''
      -- Additional LazyVim-inspired settings
      vim.opt.pumblend = 10  -- Popup menu transparency
      vim.opt.winblend = 10  -- Window transparency

      -- Better search experience
      vim.opt.hlsearch = true
      vim.opt.incsearch = true

      -- LazyVim-style diagnostics
      vim.diagnostic.config({
        underline = true,
        update_in_insert = false,
        virtual_text = {
          spacing = 4,
          source = "if_many",
          prefix = "●",
        },
        severity_sort = true,
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = " ",
            [vim.diagnostic.severity.WARN] = " ",
            [vim.diagnostic.severity.HINT] = " ",
            [vim.diagnostic.severity.INFO] = " ",
          },
        },
      })
    '';
  };
}
