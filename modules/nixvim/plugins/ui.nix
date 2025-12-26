# UI plugins configuration - Status line, bufferline, and visual enhancements
{ pkgs, ... }:
{
  programs.nixvim.plugins = {
    # Status line
    lualine = {
      enable = true;
      settings = {
        options = {
          theme = "tokyonight";
          globalstatus = true;
          disabled_filetypes.statusline = [
            "dashboard"
            "alpha"
            "starter"
          ];
        };
        sections = {
          lualine_a = [ "mode" ];
          lualine_b = [ "branch" ];
          lualine_c = [
            {
              __raw = ''
                {
                  "diagnostics",
                  symbols = {
                    error = " ",
                    warn = " ",
                    info = " ",
                    hint = " ",
                  },
                }
              '';
            }
            { __raw = ''{ "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } }''; }
            {
              __raw = ''{ "filename", path = 1, symbols = { modified = "  ", readonly = "", unnamed = "" } }'';
            }
          ];
          lualine_x = [
            {
              __raw = ''{ function() return require("noice").api.status.command.get() end, cond = function() return package.loaded["noice"] and require("noice").api.status.command.has() end }'';
            }
            {
              __raw = ''{ function() return require("noice").api.status.mode.get() end, cond = function() return package.loaded["noice"] and require("noice").api.status.mode.has() end }'';
            }
            {
              __raw = ''{ function() return "  " .. require("dap").status() end, cond = function() return package.loaded["dap"] and require("dap").status() ~= "" end }'';
            }
            "diff"
          ];
          lualine_y = [
            { __raw = ''{ "progress", separator = " ", padding = { left = 1, right = 0 } }''; }
            { __raw = ''{ "location", padding = { left = 0, right = 1 } }''; }
          ];
          lualine_z = [
            { __raw = ''{ function() return " " .. os.date("%R") end }''; }
          ];
        };
        extensions = [
          "neo-tree"
          "lazy"
        ];
      };
    };

    # Buffer line (tabs)
    bufferline = {
      enable = true;
      settings = {
        options = {
          close_command = {
            __raw = ''function(n) require("mini.bufremove").delete(n, false) end'';
          };
          right_mouse_command = {
            __raw = ''function(n) require("mini.bufremove").delete(n, false) end'';
          };
          diagnostics = "nvim_lsp";
          always_show_bufferline = false;
          offsets = [
            {
              filetype = "neo-tree";
              text = "Neo-tree";
              highlight = "Directory";
              text_align = "left";
            }
          ];
        };
      };
    };

    # Icons
    web-devicons = {
      enable = true;
    };

    # Indent guides
    indent-blankline = {
      enable = true;
      settings = {
        indent = {
          char = "│";
          tab_char = "│";
        };
        scope = {
          enabled = false;
        };
        exclude = {
          filetypes = [
            "help"
            "alpha"
            "dashboard"
            "neo-tree"
            "Trouble"
            "trouble"
            "lazy"
            "mason"
            "notify"
            "toggleterm"
            "lazyterm"
          ];
        };
      };
    };

    # Mini modules are configured in mini.nix

    # Noice - UI improvements
    noice = {
      enable = true;
      settings = {
        lsp = {
          override = {
            "vim.lsp.util.convert_input_to_markdown_lines" = true;
            "vim.lsp.util.stylize_markdown" = true;
            "cmp.entry.get_documentation" = true;
          };
        };
        routes = [
          {
            filter = {
              event = "msg_show";
              any = [
                { find = "%d+L, %d+B"; }
                { find = "; after #%d+"; }
                { find = "; before #%d+"; }
              ];
            };
            view = "mini";
          }
        ];
        presets = {
          bottom_search = true;
          command_palette = true;
          long_message_to_split = true;
          inc_rename = true;
        };
      };
    };

    # Notifications
    notify = {
      enable = true;
      settings = {
        timeout = 3000;
        max_height = {
          __raw = ''function() return math.floor(vim.o.lines * 0.75) end'';
        };
        max_width = {
          __raw = ''function() return math.floor(vim.o.columns * 0.75) end'';
        };
      };
    };

    # Dashboard
    dashboard = {
      enable = true;
      settings = {
        theme = "doom";
        config = {
          header = [
            ""
            ""
            "███╗   ██╗██╗██╗  ██╗██╗   ██╗██╗███╗   ███╗"
            "████╗  ██║██║╚██╗██╔╝██║   ██║██║████╗ ████║"
            "██╔██╗ ██║██║ ╚███╔╝ ██║   ██║██║██╔████╔██║"
            "██║╚██╗██║██║ ██╔██╗ ╚██╗ ██╔╝██║██║╚██╔╝██║"
            "██║ ╚████║██║██╔╝ ██╗ ╚████╔╝ ██║██║ ╚═╝ ██║"
            "╚═╝  ╚═══╝╚═╝╚═╝  ╚═╝  ╚═══╝  ╚═╝╚═╝     ╚═╝"
            ""
            ""
          ];
          center = [
            {
              icon = "  ";
              desc = "Find file       ";
              key = "f";
              action = "Telescope find_files";
            }
            {
              icon = "  ";
              desc = "Recent files    ";
              key = "r";
              action = "Telescope oldfiles";
            }
            {
              icon = "  ";
              desc = "Find text       ";
              key = "g";
              action = "Telescope live_grep";
            }
            {
              icon = "  ";
              desc = "Config          ";
              key = "c";
              action = "e ~/.config/nvim/init.lua";
            }
            {
              icon = "  ";
              desc = "New file        ";
              key = "n";
              action = "ene | startinsert";
            }
            {
              icon = "  ";
              desc = "Quit            ";
              key = "q";
              action = "qa";
            }
          ];
          footer = [ "" ];
        };
      };
    };
  };
}
