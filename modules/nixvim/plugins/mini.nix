# Mini.nvim modules - Collection of small independent plugins
{ pkgs, ... }:
{
  programs.nixvim.plugins = {
    # Mini modules configuration
    mini = {
      enable = true;
      modules = {
        # AI - Better text objects
        ai = {
          n_lines = 500;
          custom_textobjects = { };
        };

        # Animate - Smooth scrolling and animations
        animate = {
          cursor = {
            enable = true;
            timing = {
              __raw = "require('mini.animate').gen_timing.linear({ duration = 100, unit = 'total' })";
            };
          };
          scroll = {
            enable = true;
            timing = {
              __raw = "require('mini.animate').gen_timing.linear({ duration = 150, unit = 'total' })";
            };
          };
          resize = {
            enable = true;
            timing = {
              __raw = "require('mini.animate').gen_timing.linear({ duration = 100, unit = 'total' })";
            };
          };
          open = {
            enable = false; # Can be jarring
          };
          close = {
            enable = false; # Can be jarring
          };
        };

        # Bracketed - Go forward/backward with square brackets
        bracketed = {
          buffer = {
            suffix = "b";
          };
          comment = {
            suffix = "c";
          };
          conflict = {
            suffix = "x";
          };
          diagnostic = {
            suffix = "d";
          };
          file = {
            suffix = "f";
          };
          indent = {
            suffix = "i";
          };
          jump = {
            suffix = "j";
          };
          location = {
            suffix = "l";
          };
          oldfile = {
            suffix = "o";
          };
          quickfix = {
            suffix = "q";
          };
          treesitter = {
            suffix = "t";
          };
          undo = {
            suffix = "u";
          };
          window = {
            suffix = "w";
          };
          yank = {
            suffix = "y";
          };
        };

        # Bufremove - Better buffer deletion (already configured in ui.nix)
        bufremove = { };

        # Comment - Better commenting
        comment = {
          options = {
            custom_commentstring = {
              __raw = ''
                function()
                  return require("ts_context_commentstring.internal").calculate_commentstring() or vim.bo.commentstring
                end
              '';
            };
          };
          mappings = {
            comment = "gc";
            comment_line = "gcc";
            comment_visual = "gc";
            textobject = "gc";
          };
        };

        # Cursorword - Highlight word under cursor
        cursorword = {
          delay = 100;
        };

        # Diff - Show diff indicators in sign column
        diff = {
          view = {
            style = "sign";
            signs = {
              add = "▎";
              change = "▎";
              delete = "";
            };
          };
        };

        # Files - File explorer
        files = {
          content = {
            filter = {
              __raw = ''
                function(entry)
                  return entry.name ~= '.DS_Store' and entry.name ~= '.git' and entry.name ~= '.direnv'
                end
              '';
            };
          };
          windows = {
            preview = true;
            width_focus = 30;
            width_preview = 60;
          };
          options = {
            use_as_default_explorer = false; # We're using neo-tree
          };
        };

        # Hipatterns - Highlight patterns in text
        hipatterns = {
          highlighters = {
            # Highlight hex colors
            hex_color = {
              __raw = ''
                require('mini.hipatterns').gen_highlighter.hex_color()
              '';
            };
            # Highlight TODO, FIXME, etc
            fixme = {
              pattern = "%f[%w]()FIXME()%f[%W]";
              group = "MiniHipatternsFixme";
            };
            hack = {
              pattern = "%f[%w]()HACK()%f[%W]";
              group = "MiniHipatternsHack";
            };
            todo = {
              pattern = "%f[%w]()TODO()%f[%W]";
              group = "MiniHipatternsTodo";
            };
            note = {
              pattern = "%f[%w]()NOTE()%f[%W]";
              group = "MiniHipatternsNote";
            };
          };
        };

        # Indentscope - Show indent scope (already configured in ui.nix)
        indentscope = {
          symbol = "│";
          options = {
            try_as_border = true;
          };
        };

        # Jump - Jump to any location
        jump = {
          mappings = {
            forward = "f";
            backward = "F";
            forward_till = "t";
            backward_till = "T";
            repeat_jump = ";";
          };
        };

        # Move - Move lines and selections
        move = {
          mappings = {
            # Move visual selection
            left = "<M-h>";
            right = "<M-l>";
            down = "<M-j>";
            up = "<M-k>";
            # Move line
            line_left = "<M-h>";
            line_right = "<M-l>";
            line_down = "<M-j>";
            line_up = "<M-k>";
          };
        };

        # Pairs - Auto pairs (already configured in ui.nix)
        pairs = { };

        # Sessions - Session management
        sessions = {
          autoread = false;
          autowrite = true;
          directory = {
            __raw = "vim.fn.stdpath('data') .. '/sessions'";
          };
          file = "Session.vim";
        };

        # Splitjoin - Split and join arguments
        splitjoin = {
          mappings = {
            toggle = "gS";
            split = "";
            join = "";
          };
        };

        # Starter - Start screen (using dashboard instead)
        # starter = { };

        # Surround - Surround text objects
        surround = {
          mappings = {
            add = "gsa";
            delete = "gsd";
            find = "gsf";
            find_left = "gsF";
            highlight = "gsh";
            replace = "gsr";
            update_n_lines = "gsn";
          };
        };

        # Tabline - Tab line (using bufferline instead)
        # tabline = { };

        # Trailspace - Highlight trailing whitespace
        trailspace = {
          only_in_normal_buffers = true;
        };
      };
    };
  };

  # Define highlight groups for hipatterns
  programs.nixvim.highlight = {
    MiniHipatternsFixme = {
      bg = "#ff5555";
      fg = "#1e1e2e";
      bold = true;
    };
    MiniHipatternsHack = {
      bg = "#ffb86c";
      fg = "#1e1e2e";
      bold = true;
    };
    MiniHipatternsTodo = {
      bg = "#50fa7b";
      fg = "#1e1e2e";
      bold = true;
    };
    MiniHipatternsNote = {
      bg = "#8be9fd";
      fg = "#1e1e2e";
      bold = true;
    };
  };
}

