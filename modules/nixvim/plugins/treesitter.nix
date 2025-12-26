# Treesitter configuration for syntax highlighting and code understanding
{ pkgs, ... }:
{
  programs.nixvim.plugins = {
    treesitter = {
      enable = true;

      nixGrammars = true;

      settings = {
        highlight = {
          enable = true;
          additional_vim_regex_highlighting = false;
        };

        indent = {
          enable = true;
        };

        ensure_installed = [
          "bash"
          "c"
          "css"
          "dockerfile"
          "fish"
          "gitignore"
          "go"
          "gomod"
          "gosum"
          "html"
          "javascript"
          "json"
          "jsonc"
          "lua"
          "luadoc"
          "luap"
          "markdown"
          "markdown_inline"
          "nix"
          "python"
          "query"
          "regex"
          "rust"
          "toml"
          "tsx"
          "typescript"
          "vim"
          "vimdoc"
          "yaml"
        ];

        incremental_selection = {
          enable = true;
          keymaps = {
            init_selection = "<C-space>";
            node_incremental = "<C-space>";
            scope_incremental = false;
            node_decremental = "<bs>";
          };
        };
      };

      folding = true;
    };

    # Treesitter context - Show code context at top of screen
    treesitter-context = {
      enable = true;
      settings = {
        max_lines = 3;
      };
    };

    # Treesitter textobjects
    treesitter-textobjects = {
      enable = true;
      select = {
        enable = true;
        lookahead = true;
        keymaps = {
          "af" = "@function.outer";
          "if" = "@function.inner";
          "ac" = "@class.outer";
          "ic" = "@class.inner";
          "aa" = "@parameter.outer";
          "ia" = "@parameter.inner";
        };
      };
      move = {
        enable = true;
        setJumps = true;
        gotoNextStart = {
          "]f" = "@function.outer";
          "]c" = "@class.outer";
          "]a" = "@parameter.inner";
        };
        gotoNextEnd = {
          "]F" = "@function.outer";
          "]C" = "@class.outer";
          "]A" = "@parameter.inner";
        };
        gotoPreviousStart = {
          "[f" = "@function.outer";
          "[c" = "@class.outer";
          "[a" = "@parameter.inner";
        };
        gotoPreviousEnd = {
          "[F" = "@function.outer";
          "[C" = "@class.outer";
          "[A" = "@parameter.inner";
        };
      };
      swap = {
        enable = true;
        swapNext = {
          "<leader>a" = "@parameter.inner";
        };
        swapPrevious = {
          "<leader>A" = "@parameter.inner";
        };
      };
    };

    # Auto tag - Auto close and rename HTML tags
    ts-autotag = {
      enable = true;
    };

    # Context commentstring - Better comments
    ts-context-commentstring = {
      enable = true;
    };
  };
}
