# Editor plugins - File explorer, fuzzy finding, which-key, etc.
{ pkgs, ... }:
{
  programs.nixvim.plugins = {
    # File explorer
    neo-tree = {
      enable = true;
      enableDiagnostics = true;
      enableGitStatus = true;
      closeIfLastWindow = true;
      popupBorderStyle = "rounded";

      window = {
        width = 30;
        mappings = {
          "<space>" = "none";
        };
      };

      defaultComponentConfigs = {
        indent = {
          indentSize = 2;
          padding = 1;
          withMarkers = true;
        };
      };
    };

    # Telescope - Fuzzy finder
    telescope = {
      enable = true;

      extensions = {
        fzf-native = {
          enable = true;
        };
        ui-select = {
          enable = true;
        };
        live-grep-args = {
          enable = true;
        };
      };

      settings = {
        defaults = {
          prompt_prefix = " ";
          selection_caret = " ";
          mappings = {
            i = {
              "<C-j>" = {
                __raw = "require('telescope.actions').move_selection_next";
              };
              "<C-k>" = {
                __raw = "require('telescope.actions').move_selection_previous";
              };
              "<C-f>" = {
                __raw = "require('telescope.actions').results_scrolling_down";
              };
              "<C-b>" = {
                __raw = "require('telescope.actions').results_scrolling_up";
              };
            };
          };
        };
      };

      keymaps = {
        # Find
        "<leader>ff" = {
          action = "find_files";
          options = {
            desc = "Find files";
          };
        };
        "<leader>fr" = {
          action = "oldfiles";
          options = {
            desc = "Recent files";
          };
        };
        "<leader>fb" = {
          action = "buffers";
          options = {
            desc = "Buffers";
          };
        };
        "<leader>fg" = {
          action = "live_grep";
          options = {
            desc = "Grep (Live)";
          };
        };
        "<leader>fG" = {
          action = "grep_string";
          options = {
            desc = "Grep String (word under cursor)";
          };
        };
        "<leader>fh" = {
          action = "help_tags";
          options = {
            desc = "Help";
          };
        };
        "<leader>fk" = {
          action = "keymaps";
          options = {
            desc = "Keymaps";
          };
        };
        "<leader>fc" = {
          action = "commands";
          options = {
            desc = "Commands";
          };
        };
        "<leader>fd" = {
          action = "diagnostics";
          options = {
            desc = "Diagnostics";
          };
        };
        "<leader>fs" = {
          action = "lsp_document_symbols";
          options = {
            desc = "Document symbols";
          };
        };
        "<leader>fw" = {
          action = "lsp_workspace_symbols";
          options = {
            desc = "Workspace symbols";
          };
        };

        # Git
        "<leader>gc" = {
          action = "git_commits";
          options = {
            desc = "Git commits";
          };
        };
        "<leader>gs" = {
          action = "git_status";
          options = {
            desc = "Git status";
          };
        };

        # Search
        "<leader>sa" = {
          action = "autocommands";
          options = {
            desc = "Auto commands";
          };
        };
        "<leader>sb" = {
          action = "current_buffer_fuzzy_find";
          options = {
            desc = "Buffer";
          };
        };
        "<leader>sg" = {
          action = "live_grep";
          options = {
            desc = "Grep (Live)";
          };
        };
        "<leader>sG" = {
          action = "grep_string";
          options = {
            desc = "Grep String (word under cursor)";
          };
        };
        "<leader>sw" = {
          action = "grep_string";
          options = {
            desc = "Word (grep current)";
          };
        };
        "<leader>sc" = {
          action = "command_history";
          options = {
            desc = "Command history";
          };
        };
        "<leader>sC" = {
          action = "commands";
          options = {
            desc = "Commands";
          };
        };
        "<leader>sd" = {
          action = "diagnostics";
          options = {
            desc = "Diagnostics";
          };
        };
        "<leader>sh" = {
          action = "help_tags";
          options = {
            desc = "Help pages";
          };
        };
        "<leader>sH" = {
          action = "highlights";
          options = {
            desc = "Highlights";
          };
        };
        "<leader>sk" = {
          action = "keymaps";
          options = {
            desc = "Keymaps";
          };
        };
        "<leader>sM" = {
          action = "man_pages";
          options = {
            desc = "Man pages";
          };
        };
        "<leader>sm" = {
          action = "marks";
          options = {
            desc = "Marks";
          };
        };
        "<leader>so" = {
          action = "vim_options";
          options = {
            desc = "Options";
          };
        };
        "<leader>sR" = {
          action = "resume";
          options = {
            desc = "Resume";
          };
        };
      };
    };

    # Which-key - Show keybindings
    which-key = {
      enable = true;
      settings = {
        plugins = {
          marks = true;
          registers = true;
          spelling = {
            enabled = true;
            suggestions = 20;
          };
          presets = {
            operators = false;
            motions = false;
            text_objects = false;
            windows = true;
            nav = true;
            z = true;
            g = true;
          };
        };
        spec = [
          {
            __unkeyed = "<leader>b";
            group = "buffer";
          }
          {
            __unkeyed = "<leader>c";
            group = "code";
          }
          {
            __unkeyed = "<leader>f";
            group = "file/find";
          }
          {
            __unkeyed = "<leader>g";
            group = "git";
          }
          {
            __unkeyed = "<leader>q";
            group = "quit/session";
          }
          {
            __unkeyed = "<leader>s";
            group = "search";
          }
          {
            __unkeyed = "<leader>u";
            group = "ui";
          }
          {
            __unkeyed = "<leader>w";
            group = "windows";
          }
          {
            __unkeyed = "<leader>x";
            group = "diagnostics/quickfix";
          }
          {
            __unkeyed = "<leader><tab>";
            group = "tabs";
          }
          {
            __unkeyed = "g";
            group = "goto";
          }
          {
            __unkeyed = "gs";
            group = "surround";
          }
          {
            __unkeyed = "]";
            group = "next";
          }
          {
            __unkeyed = "[";
            group = "prev";
          }
        ];
      };
    };

    # Trouble - Better diagnostics
    trouble = {
      enable = true;
      # v3 configuration - removed deprecated v2 options
      settings = { };
    };

    # Todo comments
    todo-comments = {
      enable = true;
      settings = {
        signs = true;
      };
    };

    # Flash - Jump anywhere
    flash = {
      enable = true;
      settings = {
        labels = "asdfghjklqwertyuiopzxcvbnm";
        search = {
          mode = "fuzzy";
        };
        label = {
          uppercase = false;
          rainbow = {
            enabled = true;
          };
        };
        highlight = {
          backdrop = true;
        };
        modes = {
          search = {
            enabled = true;
          };
          char = {
            enabled = true;
            keys = {
              __raw = ''{ "f", "F", "t", "T", ";", "," }'';
            };
          };
        };
      };
    };

    # Spectre - Project-wide search and replace
    spectre = {
      enable = true;
      # Spectre configuration handled via settings
    };

    # Illuminate - Highlight word under cursor
    illuminate = {
      enable = true;
      filetypesDenylist = [
        "dirvish"
        "fugitive"
        "alpha"
        "NvimTree"
        "neo-tree"
        "dashboard"
        "Trouble"
      ];
    };

    # Auto-session - Session management
    auto-session = {
      enable = true;
      settings = {
        auto_restore_enabled = true;
        auto_save_enabled = true;
        auto_create = true;
        auto_session_enabled = true;
        auto_session_use_git_branch = true;
        bypass_save_filetypes = [
          "dashboard"
          "neo-tree"
          "Trouble"
          "alpha"
        ];
        session_lens = {
          load_on_setup = false;
        };
      };
    };

    # Toggleterm - Terminal integration
    toggleterm = {
      enable = true;
      settings = {
        size = 20;
        open_mapping = "[[<c-\\>]]";
        hide_numbers = true;
        shade_terminals = true;
        shading_factor = 2;
        start_in_insert = true;
        insert_mappings = true;
        persist_size = true;
        direction = "float";
        close_on_exit = true;
        shell = {
          __raw = "vim.o.shell";
        };
        float_opts = {
          border = "curved";
          winblend = 0;
          highlights = {
            border = "Normal";
            background = "Normal";
          };
        };
      };
    };
  };

  # Additional keymaps
  programs.nixvim.keymaps = [
    {
      mode = "n";
      key = "<leader>e";
      action = "<cmd>Neotree toggle<cr>";
      options = {
        desc = "Explorer NeoTree";
      };
    }
    {
      mode = "n";
      key = "<leader>E";
      action = "<cmd>Neotree focus<cr>";
      options = {
        desc = "Focus NeoTree";
      };
    }
    # Additional grep search keybindings
    {
      mode = "n";
      key = "<leader>/";
      action = "<cmd>Telescope live_grep<cr>";
      options = {
        desc = "Grep (root dir)";
      };
    }
    {
      mode = "v";
      key = "<leader>sw";
      action = "<cmd>Telescope grep_string<cr>";
      options = {
        desc = "Selection (root dir)";
      };
    }
  ];
}
