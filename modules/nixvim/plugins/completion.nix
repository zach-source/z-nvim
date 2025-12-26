# Completion and snippets configuration
{ pkgs, ... }:
{
  programs.nixvim.plugins = {
    # nvim-cmp - Completion engine
    cmp = {
      enable = true;

      settings = {
        snippet = {
          expand = {
            __raw = ''
              function(args)
                require('luasnip').lsp_expand(args.body)
              end
            '';
          };
        };

        mapping = {
          "<C-Space>" = "cmp.mapping.complete()";
          "<C-d>" = "cmp.mapping.scroll_docs(-4)";
          "<C-f>" = "cmp.mapping.scroll_docs(4)";
          "<C-e>" = "cmp.mapping.close()";
          "<C-n>" = "cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert })";
          "<C-p>" = "cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert })";
          "<CR>" = "cmp.mapping.confirm({ select = true })";
          "<Tab>" = {
            __raw = ''
              cmp.mapping(function(fallback)
                if cmp.visible() then
                  cmp.select_next_item()
                elseif require('luasnip').expand_or_jumpable() then
                  require('luasnip').expand_or_jump()
                else
                  fallback()
                end
              end, { 'i', 's' })
            '';
          };
          "<S-Tab>" = {
            __raw = ''
              cmp.mapping(function(fallback)
                if cmp.visible() then
                  cmp.select_prev_item()
                elseif require('luasnip').jumpable(-1) then
                  require('luasnip').jump(-1)
                else
                  fallback()
                end
              end, { 'i', 's' })
            '';
          };
        };

        sources = [
          {
            name = "nvim_lsp";
            priority = 1000;
          }
          {
            name = "luasnip";
            priority = 750;
          }
          {
            name = "buffer";
            priority = 500;
          }
          {
            name = "path";
            priority = 300;
          }
          {
            name = "nvim_lua";
            priority = 200;
          }
        ];

        formatting = {
          format = {
            __raw = ''
              function(entry, vim_item)
                local kind_icons = {
                  Text = " ",
                  Method = " ",
                  Function = " ",
                  Constructor = " ",
                  Field = " ",
                  Variable = " ",
                  Class = " ",
                  Interface = " ",
                  Module = " ",
                  Property = " ",
                  Unit = " ",
                  Value = " ",
                  Enum = " ",
                  Keyword = " ",
                  Snippet = " ",
                  Color = " ",
                  File = " ",
                  Reference = " ",
                  Folder = " ",
                  EnumMember = " ",
                  Constant = " ",
                  Struct = " ",
                  Event = " ",
                  Operator = " ",
                  TypeParameter = " ",
                }
                vim_item.kind = string.format('%s %s', kind_icons[vim_item.kind], vim_item.kind)
                vim_item.menu = ({
                  nvim_lsp = "[LSP]",
                  luasnip = "[Snippet]",
                  buffer = "[Buffer]",
                  path = "[Path]",
                  nvim_lua = "[Lua]",
                })[entry.source.name]
                return vim_item
              end
            '';
          };
        };

        window = {
          completion = {
            __raw = ''cmp.config.window.bordered()'';
          };
          documentation = {
            __raw = ''cmp.config.window.bordered()'';
          };
        };

        experimental = {
          ghost_text = true;
        };
      };
    };

    # cmp sources
    cmp-nvim-lsp = {
      enable = true;
    };

    cmp-buffer = {
      enable = true;
    };

    cmp-path = {
      enable = true;
    };

    cmp-nvim-lua = {
      enable = true;
    };

    cmp_luasnip = {
      enable = true;
    };

    cmp-cmdline = {
      enable = true;
    };

    # LuaSnip - Snippet engine
    luasnip = {
      enable = true;
      settings = {
        enable_autosnippets = true;
        store_selection_keys = "<Tab>";
      };
      fromVscode = [
        {
          lazyLoad = true;
          paths = {
            __raw = ''vim.fn.stdpath("config") .. "/snippets"'';
          };
        }
      ];
    };

    # Friendly snippets - Collection of snippets
    friendly-snippets = {
      enable = true;
    };

    # Copilot - AI completion (optional)
    copilot-vim = {
      enable = false; # Set to true if you want GitHub Copilot
    };

    # Alternative: copilot-lua with copilot-cmp
    copilot-lua = {
      enable = false; # Set to true for more control over Copilot
      settings = {
        suggestion = {
          enabled = false; # We'll use copilot-cmp instead
        };
        panel = {
          enabled = false;
        };
      };
    };

    copilot-cmp = {
      enable = false; # Set to true if using copilot-lua
    };

    # LSP signature help
    lsp-signature = {
      enable = true;
      settings = {
        bind = true;
        handler_opts = {
          border = "rounded";
        };
        hint_prefix = " ";
      };
    };

    # Autopairs
    nvim-autopairs = {
      enable = true;
      settings = {
        disable_filetype = [
          "TelescopePrompt"
          "vim"
        ];
        check_ts = true;
      };
    };
  };

  # Configure cmp to work with autopairs
  programs.nixvim.extraConfigLua = ''
    -- Setup cmp with autopairs
    local cmp_autopairs = require('nvim-autopairs.completion.cmp')
    local cmp = require('cmp')
    cmp.event:on(
      'confirm_done',
      cmp_autopairs.on_confirm_done()
    )
  '';
}
