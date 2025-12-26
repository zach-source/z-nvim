# LSP configuration - Language servers and formatting
{ pkgs, ... }:
{
  programs.nixvim.plugins = {
    # Native LSP
    lsp = {
      enable = true;

      servers = {
        # Nix
        nil_ls = {
          enable = true;
          settings = {
            formatting = {
              command = [ "nixfmt" ];
            };
          };
        };

        # Lua
        lua_ls = {
          enable = true;
          settings = {
            telemetry.enable = false;
            diagnostics = {
              globals = [ "vim" ];
            };
            workspace = {
              library = {
                __raw = ''vim.api.nvim_get_runtime_file("", true)'';
              };
              checkThirdParty = false;
            };
          };
        };

        # TypeScript/JavaScript
        ts_ls = {
          enable = true;
          filetypes = [
            "javascript"
            "javascriptreact"
            "typescript"
            "typescriptreact"
          ];
        };

        # Python
        pyright = {
          enable = true;
        };

        # Rust
        rust_analyzer = {
          enable = true;
          installCargo = false;
          installRustc = false;
          settings = {
            checkOnSave = true;
            check.command = "clippy";
            inlayHints = {
              enable = true;
            };
          };
        };

        # Go
        gopls = {
          enable = true;
          settings = {
            analyses = {
              unusedparams = true;
              nilness = true;
              unusedwrite = true;
              useany = true;
            };
            staticcheck = true;
            gofumpt = true;
            usePlaceholders = true;
            completeUnimported = true;
            hints = {
              assignVariableTypes = true;
              compositeLiteralFields = true;
              compositeLiteralTypes = true;
              constantValues = true;
              functionTypeParameters = true;
              parameterNames = true;
              rangeVariableTypes = true;
            };
          };
        };

        # Bash
        bashls = {
          enable = true;
        };

        # Docker - temporarily disabled due to package compatibility issues in new nixpkgs
        # dockerls = {
        #   enable = true;
        #   package = pkgs.docker-language-server;
        # };

        # YAML
        yamlls = {
          enable = true;
          settings = {
            yaml = {
              schemas = {
                "https://json.schemastore.org/github-workflow.json" = "/.github/workflows/*";
                "https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json" =
                  "docker-compose*.yml";
                "https://json.schemastore.org/kustomization.json" = "kustomization.yaml";
              };
            };
          };
        };

        # JSON
        jsonls = {
          enable = true;
        };

        # HTML/CSS
        html = {
          enable = true;
        };

        cssls = {
          enable = true;
        };

        # Tailwind CSS
        tailwindcss = {
          enable = true;
        };

        # Terraform
        terraformls = {
          enable = true;
        };

        # Markdown
        marksman = {
          enable = true;
        };
      };

      keymaps = {
        diagnostic = {
          "<leader>cd" = "open_float";
          "[d" = "goto_prev";
          "]d" = "goto_next";
        };
        lspBuf = {
          "gd" = "definition";
          "gD" = "declaration";
          "gi" = "implementation";
          "go" = "type_definition";
          "gr" = "references";
          "gs" = "signature_help";
          "K" = "hover";
          "<leader>ca" = "code_action";
          "<leader>cr" = "rename";
          "<leader>cf" = "format";
        };
      };
    };

    # LSP lines - Show diagnostics as virtual lines
    lsp-lines = {
      enable = false; # Can be toggled on demand
    };

    # Fidget - LSP progress
    fidget = {
      enable = true;
      settings = {
        logger = {
          level = "warn";
        };
        notification = {
          window = {
            winblend = 0;
          };
        };
      };
    };

    # None-ls (null-ls replacement) for additional formatting/linting
    # Note: The exact structure of none-ls sources varies by nixvim version
    # For now, just enable the plugin without specific sources
    none-ls = {
      enable = true;
      enableLspFormat = false; # We'll use LSP's built-in formatting
    };

    # Conform - Alternative formatter
    conform-nvim = {
      enable = false; # Using none-ls instead
    };

    # Linting
    lint = {
      enable = true;
      lintersByFt = {
        python = [ "ruff" ];
        sh = [ "shellcheck" ];
        go = [ "golangcilint" ];
        javascript = [ "eslint" ];
        typescript = [ "eslint" ];
        javascriptreact = [ "eslint" ];
        typescriptreact = [ "eslint" ];
      };
    };
  };

  # Additional LSP keymaps
  programs.nixvim.keymaps = [
    {
      mode = "n";
      key = "<leader>cl";
      action.__raw = ''
        function()
          vim.lsp.codelens.run()
        end
      '';
      options = {
        desc = "Code Lens";
      };
    }
    {
      mode = "n";
      key = "<leader>cL";
      action.__raw = ''
        function()
          vim.lsp.codelens.refresh()
        end
      '';
      options = {
        desc = "Refresh Code Lens";
      };
    }
  ];
}
