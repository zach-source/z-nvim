# LazyVim configuration module for Nix
# This module sets up LazyVim to work with Nix-managed language servers
{
  config,
  pkgs,
  lib,
  ...
}:
{
  # Create LazyVim configuration inline (avoiding external path dependencies)
  xdg.configFile."nvim/init.lua".text = ''
    -- LazyVim initialization
    -- This configuration provides LazyVim functionality while using Nix-managed tools

    -- Bootstrap lazy.nvim
    local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
    if not (vim.uv or vim.loop).fs_stat(lazypath) then
      local lazyrepo = "https://github.com/folke/lazy.nvim.git"
      local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
      if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
          { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
          { out, "WarningMsg" },
          { "\nPress any key to exit..." },
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
      end
    end
    vim.opt.rtp:prepend(lazypath)

    -- Leader keys
    vim.g.mapleader = " "
    vim.g.maplocalleader = "\\"

    -- ============================================================
    -- COMPREHENSIVE LOGGING CONFIGURATION
    -- ============================================================
    -- Based on Neovim dev_tools and logger.nvim best practices

    -- 1. LSP logging (all LSP server communication)
    -- Log file: ~/.local/state/nvim/lsp.log
    vim.lsp.set_log_level("info")  -- Options: "trace", "debug", "info", "warn", "error"

    -- 2. Load custom logger module
    -- The logger.lua file will be deployed alongside init.lua
    package.path = package.path .. ";" .. vim.fn.stdpath("config") .. "/?.lua"
    local logger = require("logger")

    -- Configure logger
    logger.set_level("info")        -- Change to "debug" for verbose output
    logger.set_echo(true)           -- Also output to :messages
    logger.set_file(vim.fn.stdpath("state") .. "/debug.log")

    -- Log startup
    logger.info("Neovim starting up")

    -- 3. Diagnostic logging disabled to prevent "Press ENTER" prompts
    -- Diagnostics are shown inline via virtual_text and in trouble.nvim

    -- 4. Global error handler
    vim.api.nvim_create_autocmd("VimEnter", {
      callback = function()
        -- Wrap vim.notify to capture all notifications
        local original_notify = vim.notify
        vim.notify = function(msg, level, opts)
          -- Log to our custom logger
          if level == vim.log.levels.ERROR then
            logger.error("Notification:", msg)
          elseif level == vim.log.levels.WARN then
            logger.warn("Notification:", msg)
          elseif level == vim.log.levels.INFO then
            logger.info("Notification:", msg)
          else
            logger.debug("Notification:", msg)
          end

          -- Call original notify
          return original_notify(msg, level, opts)
        end
      end,
    })

    -- 5. Make logger globally available for manual logging
    _G.logger = logger

    -- Setup LazyVim with proper plugin specification
    require("lazy").setup({
      spec = {
        -- Add LazyVim and import its plugins (proper structure)
        -- Pinned to v15.13.0 for reproducibility (FR-010)
        {
          "LazyVim/LazyVim",
          version = "15.*", -- Pin to 15.x series for stability
          import = "lazyvim.plugins",
          opts = {
            -- Ensure LSP utilities are available before other plugins load
            defaults = {
              autocmds = true,
              keymaps = true,
            },
          },
        },

        -- Completely disable all Mason-related plugins (renamed from williamboman to mason-org)
        {
          "mason-org/mason.nvim",
          enabled = false,
          init = function()
            vim.g.mason_disabled = true
          end,
        },
        {
          "mason-org/mason-lspconfig.nvim",
          enabled = false,
        },
        {
          "jay-babu/mason-nvim-dap.nvim",
          enabled = false,
        },
        {
          "jayp0521/mason-null-ls.nvim",
          enabled = false,
        },

        -- Disable DAP Mason integration
        {
          "mfussenegger/nvim-dap",
          optional = true,
          opts = {
            adapters = {}, -- Empty adapters, use Nix-managed ones if needed
          },
        },

        -- Core requested languages: rust, go, typescript, java, javascript, python
        { import = "lazyvim.plugins.extras.lang.go" },
        { import = "lazyvim.plugins.extras.lang.typescript" },
        { import = "lazyvim.plugins.extras.lang.python" },
        { import = "lazyvim.plugins.extras.lang.rust" },
        { import = "lazyvim.plugins.extras.lang.java" },

        -- Additional commonly used languages
        { import = "lazyvim.plugins.extras.lang.nix" },
        { import = "lazyvim.plugins.extras.lang.json" },
        { import = "lazyvim.plugins.extras.lang.yaml" },
        { import = "lazyvim.plugins.extras.lang.docker" },
        { import = "lazyvim.plugins.extras.lang.terraform" },
        { import = "lazyvim.plugins.extras.lang.markdown" },
        { import = "lazyvim.plugins.extras.lang.sql" },
        { import = "lazyvim.plugins.extras.lang.git" },

        -- Completion engine (ensure blink.cmp is properly configured)
        { import = "lazyvim.plugins.extras.coding.blink" },
        { import = "lazyvim.plugins.extras.coding.yanky" },

        -- Formatting and linting
        { import = "lazyvim.plugins.extras.formatting.prettier" },
        { import = "lazyvim.plugins.extras.formatting.black" },
        { import = "lazyvim.plugins.extras.linting.eslint" },

        -- Explicit conform.nvim config for Nix-managed formatters
        {
          "stevearc/conform.nvim",
          opts = {
            formatters_by_ft = {
              python = { "black" },
              javascript = { "prettier" },
              javascriptreact = { "prettier" },
              typescript = { "prettier" },
              typescriptreact = { "prettier" },
              json = { "prettier" },
              jsonc = { "prettier" },
              yaml = { "prettier" },
              markdown = { "prettier" },
              html = { "prettier" },
              css = { "prettier" },
              scss = { "prettier" },
              lua = { "stylua" },
              nix = { "nixfmt" },
              go = { "gofmt", "goimports" },
              rust = { "rustfmt" },
              sh = { "shfmt" },
              bash = { "shfmt" },
              terraform = { "terraform_fmt" },
            },
            format_on_save = {
              timeout_ms = 3000,
              lsp_fallback = true,
            },
          },
        },

        -- Editor enhancements (Snacks replaces telescope, neo-tree, indent-blankline)
        { import = "lazyvim.plugins.extras.editor.leap" },
        { import = "lazyvim.plugins.extras.editor.illuminate" },
        { import = "lazyvim.plugins.extras.editor.snacks_picker" },
        { import = "lazyvim.plugins.extras.editor.snacks_explorer" },
        -- Removed duplicate/incorrect editor.blink (coding.blink is the correct path)
        -- Removed harpoon2 (conflicts with smooth scrolling)

        -- UI enhancements (Snacks handles dashboard, animations, indentation)
        -- Disabled mini-animate to fix smooth scrolling
        -- { import = "lazyvim.plugins.extras.ui.mini-animate" },
        { import = "lazyvim.plugins.extras.ui.treesitter-context" },

        -- AI assistance (LazyVim extras)
        -- DISABLED: Copilot causing excessive LSP errors
        -- { import = "lazyvim.plugins.extras.ai.copilot" },
        -- { import = "lazyvim.plugins.extras.ai.copilot-chat" },
        { import = "lazyvim.plugins.extras.ai.sidekick" },

        -- Claude Code follow mode - watch Claude edit files in real-time
        {
          "zach-source/claude-follow-hook.nvim",
          version = "v1.0.2",
          lazy = true,
          event = "VeryLazy",
          opts = {
            setup_keymaps = true,
            keymap_prefix = "<leader>af",  -- AI follow mode
          },
        },

        -- Session persistence (direct plugin, not a LazyVim extra)
        {
          "folke/persistence.nvim",
          event = "BufReadPre",
          opts = {
            options = vim.opt.sessionoptions:get(),
          },
          keys = {
            { "<leader>qs", function() require("persistence").load() end, desc = "Restore Session" },
            { "<leader>qS", function() require("persistence").select() end, desc = "Select Session" },
            { "<leader>ql", function() require("persistence").load({ last = true }) end, desc = "Restore Last Session" },
            { "<leader>qd", function() require("persistence").stop() end, desc = "Don't Save Current Session" },
          },
        },

        -- Zellij integration for seamless navigation
        {
          "swaits/zellij-nav.nvim",
          lazy = true,
          event = "VeryLazy",
          keys = {
            { "<c-h>", "<cmd>ZellijNavigateLeftTab<cr>", silent = true, desc = "navigate left or tab" },
            { "<c-j>", "<cmd>ZellijNavigateDown<cr>", silent = true, desc = "navigate down" },
            { "<c-k>", "<cmd>ZellijNavigateUp<cr>", silent = true, desc = "navigate up" },
            { "<c-l>", "<cmd>ZellijNavigateRightTab<cr>", silent = true, desc = "navigate right or tab" },
          },
          opts = {},
        },

        -- Sidekick AI overrides (base config from lazyvim.plugins.extras.ai.sidekick)
        {
          "folke/sidekick.nvim",
          opts = {
            mux = {
              enabled = true,
              backend = "zellij",
            },
            prompts = {
              refactor = "Please refactor {this} to be more maintainable",
              security = "Review {file} for security vulnerabilities",
              createNewMr = "I have a change I've made; 1. create a new branch 2. commit my change with a detailed message 3. git fetch all, rebase origin/main, solve any merge conflicts 4. push and create pr/mr",
              pushToEnv = "changes have been merged, pull latest main, create a new tag using svu, push tag, change env/* branches to new tag; start with dev first, wait to proceed",
            },
            cli = {
              watch = true,
              win = {
                layout = "right",
                split = { width = 80 },
              },
              tools = {
                claude = {
                  cmd = { "claude-smart" },
                  url = "https://github.com/anthropics/claude-code",
                },
                copilot = {
                  cmd = { "copilot", "--banner" },
                },
              },
            },
            copilot = {
              status = { enabled = true },
            },
          },
          keys = {
            -- Extra keymap for direct Claude toggle (LazyVim extra provides the rest)
            { "<leader>ac", function() require("sidekick.cli").toggle({ name = "claude", focus = true }) end, desc = "Sidekick Claude" },
          },
        },

        -- Fix which-key configuration issues
        {
          "folke/which-key.nvim",
          opts = {
            preset = "modern",
            delay = 300,
            spec = {
              { "<leader>l", group = "language" },
              { "<leader>f", group = "file" },
              { "<leader>s", group = "search" },
              { "<leader>t", group = "test" },
              { "<leader>d", group = "debug" },
              { "<leader>q", group = "session" },
              { "<leader>a", group = "ai" },
              { "<leader>c", group = "copilot" },
              { "<leader>b", group = "buffer" },
              { "<leader>w", group = "window" },
              { "<leader>W", group = "workspace" },
            },
            triggers = {
              { "<leader>", mode = { "n", "v" } },
            },
          },
          keys = {
            {
              "<leader>?",
              function()
                require("which-key").show({ global = false })
              end,
              desc = "Buffer Local Keymaps (which-key)",
            },
          },
        },

        -- Complete Snacks.nvim suite (replaces multiple plugins)
        {
          "folke/snacks.nvim",
          priority = 1000,
          lazy = false,
          opts = {
            -- Enable all Snacks modules for comprehensive functionality
            bigfile = { enabled = true },
            bufdelete = { enabled = true },
            dashboard = {
              enabled = true,
              preset = "compact",
              sections = {
                { section = "header" },
                { section = "keys", gap = 1, padding = 1 },
                { section = "startup" },
              },
            },
            debug = { enabled = true },
            dim = { enabled = true },
            explorer = {
              enabled = true, -- Use Snacks explorer instead of neo-tree
              width = 35,
              filter = {
                hidden = true, -- Show hidden files by default
              },
            },
            git = { enabled = true },
            gitbrowse = { enabled = true },
            indent = { enabled = true },
            input = { enabled = true },
            notifier = {
              enabled = true,
              timeout = 3000,
              width = { min = 40, max = 0.4 },
              height = { min = 1, max = 0.6 },
              margin = { top = 0, right = 1, bottom = 0 },
            },
            picker = {
              enabled = true, -- Use Snacks picker instead of telescope
              win = { border = "rounded" },
              layout = {
                preset = "bottom",
              },
              formatters = {
                file = {
                  prompt = false, -- Hide search bar when not searching
                },
              },
            },
            quickfile = { enabled = true },
            rename = { enabled = true },
            scope = { enabled = true },
            scroll = {
              enabled = true,
              animate = {
                enabled = false,  -- Disable scroll animation for smooth scrolling
              },
            },
            statuscolumn = { enabled = true },
            terminal = {
              enabled = true,
              win = {
                position = "float",
                width = 0.8,
                height = 0.8,
                border = "rounded",
                wo = {
                  winblend = 30,  -- 30% transparency (0=opaque, 100=fully transparent)
                },
              },
            },
            toggle = { enabled = true },
            win = { enabled = true },
            words = { enabled = true },
            zen = { enabled = true },
          },
          config = function(_, opts)
            -- Setup Snacks first
            local snacks = require("snacks")
            snacks.setup(opts)

            -- Set correct function references for checkhealth compatibility
            vim.ui.input = snacks.input.input  -- The actual input function
            vim.ui.select = snacks.picker.select  -- The picker select function

            -- Ensure dashboard is properly initialized
            if snacks.dashboard then
              snacks.dashboard.setup()
            end

            -- Dashboard already initialized by snacks.dashboard.setup() above
          end,
          keys = {
            { "<C-/>", function() Snacks.terminal.toggle() end, desc = "Toggle Terminal", mode = { "n", "t" } },
            { "<leader>tt", function() Snacks.terminal.toggle() end, desc = "Toggle Terminal" },
            { "<leader>tT", function() Snacks.terminal() end, desc = "New Terminal" },
          },
        },

        -- Configure treesitter to use Nix-managed parsers (no auto-install)
        {
          "nvim-treesitter/nvim-treesitter",
          branch = "main", -- Required by LazyVim
          lazy = false, -- Load immediately to ensure highlighting works
          config = function(_, opts)
            -- Add runtime/queries to rtp for main branch structure
            local ts_runtime = vim.fn.stdpath("data") .. "/lazy/nvim-treesitter/runtime"
            if vim.uv.fs_stat(ts_runtime) then
              vim.opt.rtp:prepend(ts_runtime)
            end

            -- Fix vim highlights query - nvim-treesitter main branch has incompatible queries
            -- (substitute, heredoc patterns, etc. don't exist in bundled parser)
            -- Use vim.treesitter.query.set() to forcefully override the broken query
            local vim_highlights_query = vim.fn.readfile(vim.fn.stdpath("config") .. "/queries/vim/highlights.scm")
            if #vim_highlights_query > 0 then
              vim.treesitter.query.set("vim", "highlights", table.concat(vim_highlights_query, "\n"))
            end

            -- Setup nvim-treesitter with provided opts
            require("nvim-treesitter").setup(opts)
          end,
          opts = {
            -- Parsers provided by Nix (nvim-treesitter.withAllGrammars)
            auto_install = false,
            -- ensure_installed removed: Nix provides all parsers via withAllGrammars
            highlight = {
              enable = true,
              additional_vim_regex_highlighting = false,
            },
            indent = { enable = true },
            folds = { enable = true },
          },
        },
        {
          "nvim-treesitter/nvim-treesitter-textobjects",
          dependencies = { "nvim-treesitter/nvim-treesitter" },
        },

        -- Disable plugins that Snacks replaces
        {
          "nvim-telescope/telescope.nvim",
          enabled = false, -- Replaced by snacks.picker
        },
        {
          "nvim-neo-tree/neo-tree.nvim",
          enabled = false, -- Replaced by snacks.explorer
        },
        {
          "lukas-reineke/indent-blankline.nvim",
          enabled = false, -- Replaced by snacks.indent
        },
        {
          "folke/noice.nvim",
          enabled = false, -- Replaced by snacks.notifier
        },
        {
          "akinsho/bufferline.nvim",
          enabled = false, -- Snacks provides better buffer management
        },

        -- Override leap.nvim to fix deprecated add_default_mappings() warning
        -- Uses new <Plug> mapping approach per leap.nvim README
        {
          "ggandor/leap.nvim",
          keys = {
            { "s", mode = { "n", "x", "o" }, desc = "Leap Forward to" },
            { "S", mode = { "n", "x", "o" }, desc = "Leap Backward to" },
            { "gs", mode = { "n", "x", "o" }, desc = "Leap from Windows" },
          },
          config = function(_, opts)
            local leap = require("leap")
            for k, v in pairs(opts) do
              leap.opts[k] = v
            end
            -- Use new <Plug> mappings instead of deprecated add_default_mappings()
            vim.keymap.set({ "n", "x", "o" }, "s", "<Plug>(leap)")
            vim.keymap.set({ "n", "x", "o" }, "S", "<Plug>(leap-backward)")
            vim.keymap.set("n", "gs", "<Plug>(leap-from-window)")
          end,
        },

        -- Lualine statusline (LazyVim default)
        {
          "nvim-lualine/lualine.nvim",
          event = "VeryLazy",
          opts = {
            options = {
              theme = "catppuccin",
              globalstatus = true,
              disabled_filetypes = { statusline = { "dashboard", "alpha", "ministarter", "snacks_dashboard" } },
            },
            sections = {
              lualine_a = { "mode" },
              lualine_b = { "branch" },
              lualine_c = {
                { "diagnostics" },
                { "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
                { "filename", path = 1 },
              },
              lualine_x = {
                { "diff", symbols = { added = " ", modified = " ", removed = " " } },
              },
              lualine_y = {
                { "progress", separator = " ", padding = { left = 1, right = 0 } },
                { "location", padding = { left = 0, right = 1 } },
              },
              lualine_z = {
                function()
                  return " " .. os.date("%R")
                end,
              },
            },
            extensions = { "lazy" },
          },
        },

        -- Explicitly configure LSP servers to use Nix-managed ones
        {
          "neovim/nvim-lspconfig",
          opts = function()
            return {
              -- Diagnostics configuration
              diagnostics = {
                underline = true,
                update_in_insert = false,
                virtual_text = {
                  spacing = 4,
                  source = "if_many",
                  prefix = "●",
                },
                severity_sort = true,
                -- Disable modal/focused diagnostic float windows
                float = {
                  focusable = false,  -- Don't steal focus
                  focus = false,      -- Don't auto-focus
                  border = "rounded",
                  source = "if_many",
                  header = "",
                  prefix = "",
                },
              },
              -- Inlay hints
              inlay_hints = {
                enabled = true,
                exclude = {}, -- filetypes to exclude from inlay hints
              },
              -- Code lens (required by LazyVim)
              codelens = {
                enabled = false, -- disabled by default per LazyVim
              },
              -- Folding configuration (required by LazyVim)
              folds = {
                enabled = true,
              },
              -- Capabilities setup
              capabilities = {
                workspace = {
                  fileOperations = {
                    didRename = true,
                    willRename = true,
                  },
                },
              },
              -- Formatting options
              format = {
                formatting_options = nil,
                timeout_ms = nil,
              },
              -- LSP servers
              servers = {
              -- Explicitly configure each language server
              gopls = {}, -- Go
              rust_analyzer = {}, -- Rust
              vtsls = {}, -- TypeScript/JavaScript (Vue TypeScript Language Service)
              tsserver = nil, -- Disable tsserver (using vtsls instead)
              pyright = {}, -- Python
              marksman = {}, -- Markdown
              nil_ls = {}, -- Nix
              yamlls = {}, -- YAML
              dockerls = {}, -- Docker
              docker_compose_language_service = {}, -- Docker Compose
              terraformls = {}, -- Terraform
              lua_ls = {}, -- Lua
              bashls = {}, -- Bash
              clojure_lsp = {}, -- Clojure
              eslint = {}, -- ESLint (from vscode-langservers-extracted)
              jsonls = {}, -- JSON (from vscode-langservers-extracted)
            },
              -- Custom setup handlers (required by LazyVim)
              setup = {},
            }
          end,
        },

        -- Catppuccin colorscheme (default theme)
        {
          "catppuccin/nvim",
          name = "catppuccin",
          lazy = false,
          priority = 1000,
          opts = {
            flavour = "mocha", -- latte, frappe, macchiato, mocha
            transparent_background = false,
            term_colors = true,
            integrations = {
              cmp = true,
              gitsigns = true,
              nvimtree = false,
              treesitter = true,
              notify = true,
              mini = {
                enabled = true,
                indentscope_color = "",
              },
              native_lsp = {
                enabled = true,
                virtual_text = {
                  errors = { "italic" },
                  hints = { "italic" },
                  warnings = { "italic" },
                  information = { "italic" },
                },
                underlines = {
                  errors = { "underline" },
                  hints = { "underline" },
                  warnings = { "underline" },
                  information = { "underline" },
                },
              },
              telescope = { enabled = false },
              snacks = { enabled = true },
              which_key = true,
            },
          },
          config = function(_, opts)
            require("catppuccin").setup(opts)
            vim.cmd.colorscheme("catppuccin")
          end,
        },

        -- Add Gruvbox colorscheme (alternative)
        {
          "ellisonleao/gruvbox.nvim",
          lazy = true,
          opts = {
            terminal_colors = true,
            undercurl = true,
            underline = true,
            bold = true,
            italic = {
              strings = true,
              emphasis = true,
              comments = true,
              operators = false,
              folds = true,
            },
            strikethrough = true,
            invert_selection = false,
            invert_signs = false,
            invert_tabline = false,
            invert_intend_guides = false,
            inverse = true,
            contrast = "", -- can be "hard", "soft" or empty string
            palette_overrides = {},
            overrides = {},
            dim_inactive = false,
            transparent_mode = false,
          },
        },

        -- Fix Copilot authentication integration
        -- DISABLED: Causing excessive LSP errors
        {
          "zbirenbaum/copilot.lua",
          enabled = false,
          cmd = "Copilot",
          event = "InsertEnter",
          opts = {
            suggestion = {
              enabled = true,
              auto_trigger = true,
              debounce = 75,
              keymap = {
                accept = "<M-l>",
                accept_word = false,
                accept_line = false,
                next = "<M-]>",
                prev = "<M-[>",
                dismiss = "<C-]>",
              },
            },
            panel = {
              enabled = true,
              auto_refresh = false,
              keymap = {
                jump_prev = "[[",
                jump_next = "]]",
                accept = "<CR>",
                refresh = "gr",
                open = "<M-CR>",
              },
              layout = {
                position = "bottom",
                ratio = 0.4,
              },
            },
            server_opts_overrides = {},
          },
          keys = {
            { "<leader>cp", "<cmd>Copilot panel<cr>", desc = "Copilot Panel" },
            { "<leader>cs", "<cmd>Copilot status<cr>", desc = "Copilot Status" },
            { "<leader>ce", "<cmd>Copilot enable<cr>", desc = "Copilot Enable" },
            { "<leader>cd", "<cmd>Copilot disable<cr>", desc = "Copilot Disable" },
            { "<leader>ca", "<cmd>Copilot auth<cr>", desc = "Copilot Auth" },
          },
        },

        -- Custom plugins can be added here as needed
        -- No separate plugins/ directory - all plugins defined inline above
      },
      defaults = {
        lazy = true,
        version = false,
      },
      checker = { enabled = false }, -- Disable update checking
      rocks = {
        enabled = false, -- Disable luarocks to eliminate warnings
      },
      performance = {
        rtp = {
          disabled_plugins = {
            "gzip",
            "tarPlugin",
            "tohtml",
            "tutor",
            "zipPlugin",
          },
        },
      },
    })

    -- Apply diagnostic config to prevent modal/focused float windows
    vim.diagnostic.config({
      float = {
        focusable = false,
        focus = false,
        border = "rounded",
        source = "if_many",
      },
    })
  '';

  # Custom layouts for workspace management
  xdg.configFile."nvim/lua/config/layouts.lua".text = ''
    -- Custom workspace layouts using Snacks
    local M = {}

    -- Development workspace: Explorer + Editor + Claude (fresh session)
    M.dev_with_claude = function()
      -- Close any existing windows to start fresh
      vim.cmd("only")

      -- Open explorer on left (35 cols)
      Snacks.explorer({ width = 35 })

      -- Focus main editor window (middle)
      vim.cmd("wincmd l")

      -- Open Sidekick Claude on right (fresh session)
      vim.schedule(function()
        require("sidekick.cli").toggle({
          name = "claude",
          focus = false  -- Keep focus on editor
        })
      end)
    end

    -- Development workspace: Explorer + Editor + Claude Continue
    M.dev_with_claude_continue = function()
      -- Close any existing windows to start fresh
      vim.cmd("only")

      -- Open explorer on left (35 cols)
      Snacks.explorer({ width = 35 })

      -- Focus main editor window (middle)
      vim.cmd("wincmd l")

      -- Open Sidekick Claude on right (uses claude-smart continue)
      vim.schedule(function()
        require("sidekick.cli").toggle({
          name = "claude",
          focus = false  -- Keep focus on editor
        })
      end)
    end

    -- Focus layout: Fullscreen editor (zen mode)
    M.focus = function()
      vim.cmd("only")
      Snacks.zen()
    end

    -- Explorer-only layout
    M.explorer_focus = function()
      vim.cmd("only")
      Snacks.explorer({ width = 50 })
    end

    return M
  '';

  # Claude Code Follow Mode - Now using published plugin: zach-source/claude-follow-hook.nvim
  # The inline implementation below is commented out in favor of the plugin
  /*
    xdg.configFile."nvim/lua/config/follow-mode.lua".text = ''
      -- Claude Code Follow Mode: Watch Claude edit files via Unix socket
      local M = {}
      M.name = "ClaudeCodeFollowMode"

      -- Generate socket path based on current working directory
      M.get_socket_path = function()
        local cwd = vim.fn.getcwd()
        -- Hash the CWD for a deterministic socket name
        local hash = vim.fn.sha256(cwd):sub(1, 12)
        return "/tmp/nvim-follow-" .. vim.env.USER .. "-" .. hash .. ".sock"
      end

      M.socket_path = nil
      M.server_id = nil
      M.enabled = false

      -- Find or create follow buffer
      M.get_or_create_follow_buffer = function()
        -- Check if follow buffer already exists
        for _, buf in ipairs(vim.api.nvim_list_bufs()) do
          if vim.api.nvim_buf_is_valid(buf) then
            local bufname = vim.api.nvim_buf_get_name(buf)
            if bufname:match("%[Claude Follow%]") then
              return buf
            end
          end
        end

        -- Create new follow buffer (listed, not scratch)
        local buf = vim.api.nvim_create_buf(true, false)
        vim.api.nvim_buf_set_name(buf, "[Claude Follow]")
        vim.api.nvim_buf_set_option(buf, "bufhidden", "hide")
        vim.api.nvim_buf_set_option(buf, "buftype", "")  -- Normal buffer (not nofile)
        vim.api.nvim_buf_set_option(buf, "modifiable", true)

        -- Add helpful text
        vim.api.nvim_buf_set_lines(buf, 0, -1, false, {
          "Claude Follow Mode Active",
          "",
          "Files that Claude edits will appear here in your main editor.",
          "",
          "Commands:",
          "  :FollowModeOff  - Disable follow mode",
          "  <leader>WF      - Toggle follow mode",
          "",
          "Waiting for Claude to edit files...",
        })

        -- Mark as not modified (so it doesn't ask to save)
        vim.api.nvim_buf_set_option(buf, "modified", false)

        return buf
      end

      -- Enable follow mode
      M.enable = function()
        if M.enabled then
          -- Already enabled, just refocus the follow buffer
          local buf = M.get_or_create_follow_buffer()
          vim.api.nvim_set_current_buf(buf)
          vim.notify("Follow mode already enabled (refocused buffer)", vim.log.levels.INFO)
          return
        end

        -- Get CWD-based socket path
        M.socket_path = M.get_socket_path()

        -- Start socket server
        M.server_id = vim.fn.serverstart(M.socket_path)

        if M.server_id then
          M.enabled = true
          vim.g.follow_mode_enabled = true
          vim.g.follow_mode_socket = M.socket_path

          -- Get or create follow buffer
          local buf = M.get_or_create_follow_buffer()

          -- Set the buffer in current window
          vim.api.nvim_set_current_buf(buf)

          -- Set up autocmd to handle remote commands
          vim.api.nvim_create_autocmd("VimLeave", {
            callback = function()
              M.disable()
            end,
          })

          local cwd = vim.fn.getcwd()
          vim.notify("Follow mode enabled\nCWD: " .. vim.fn.fnamemodify(cwd, ":~") .. "\nSocket: " .. M.socket_path, vim.log.levels.INFO)
        else
          vim.notify("Failed to start follow mode server", vim.log.levels.ERROR)
        end
      end

      -- Disable follow mode
      M.disable = function()
        if not M.enabled then
          vim.notify("Follow mode not enabled", vim.log.levels.INFO)
          return
        end

        -- Stop server
        if M.server_id and M.socket_path then
          vim.fn.serverstop(M.socket_path)
          M.server_id = nil
        end

        M.enabled = false
        vim.g.follow_mode_enabled = false
        vim.g.follow_mode_socket = nil

        -- Clean up socket file if it exists
        if M.socket_path then
          vim.fn.delete(M.socket_path)
          M.socket_path = nil
        end

        -- Note: We keep the buffer alive so it can be re-enabled
        -- User can manually delete it with :bd [Claude Follow]

        vim.notify("Follow mode disabled (buffer kept for re-enable)", vim.log.levels.INFO)
      end

      -- Toggle follow mode
      M.toggle = function()
        if M.enabled then
          M.disable()
        else
          M.enable()
        end
      end

      -- Get status
      M.status = function()
        if M.enabled then
          vim.notify("Follow mode: ENABLED\nSocket: " .. M.socket_path, vim.log.levels.INFO)
        else
          vim.notify("Follow mode: DISABLED", vim.log.levels.INFO)
        end
      end

      -- Get the main editor window (not sidekick/terminal/floating)
      M.get_main_editor_window = function()
        -- Find first normal window that's not special
        for _, win in ipairs(vim.api.nvim_list_wins()) do
          local buf = vim.api.nvim_win_get_buf(win)
          local buftype = vim.api.nvim_buf_get_option(buf, "buftype")
          local bufname = vim.api.nvim_buf_get_name(buf)

          -- Skip terminal and special buffers
          if buftype ~= "terminal" and buftype ~= "prompt" then
            -- Check it's not a floating window
            local win_config = vim.api.nvim_win_get_config(win)
            if win_config.relative == "" then
              -- Not sidekick CLI window (check buffer name)
              if not bufname:match("term://") and not bufname:match("sidekick") then
                return win
              end
            end
          end
        end

        -- Fallback to window 1
        return vim.fn.win_getid(1)
      end

      -- Define highlight for changed lines
      M.setup_highlights = function()
        -- Define sign for changed lines
        vim.fn.sign_define("ClaudeFollowChange", {
          text = "●",
          texthl = "DiagnosticInfo",
          linehl = "DiffAdd",
        })
      end

      -- Clear previous highlights
      M.clear_highlights = function(buf)
        -- Clear all ClaudeFollowChange signs from buffer
        vim.fn.sign_unplace("claude_follow", { buffer = buf })
      end

      -- Highlight changed lines
      M.highlight_lines = function(buf, start_line, line_count)
        M.clear_highlights(buf)

        -- Place signs on changed lines
        for i = 0, line_count - 1 do
          local line = start_line + i
          vim.fn.sign_place(0, "claude_follow", "ClaudeFollowChange", buf, {
            lnum = line,
            priority = 10,
          })
        end

        -- Auto-clear after 5 seconds
        vim.defer_fn(function()
          if vim.api.nvim_buf_is_valid(buf) then
            M.clear_highlights(buf)
          end
        end, 5000)
      end

      -- Open file (called via RPC)
      M.open_file = function(file_path, line_num, line_count, tool_name)
        if not M.enabled then
          return
        end

        -- Default parameters
        line_num = line_num or 1
        line_count = line_count or 1
        tool_name = tool_name or "unknown"

        -- Setup highlights if not done yet
        M.setup_highlights()

        -- Expand path
        local expanded_path = vim.fn.expand(file_path)

        -- Get the main editor window (skip sidekick/terminal)
        local main_win = M.get_main_editor_window()

        -- First, focus the main window
        vim.api.nvim_set_current_win(main_win)

        -- Disable swap file warnings for follow mode
        local old_shortmess = vim.o.shortmess
        vim.o.shortmess = vim.o.shortmess .. "A"  -- Suppress ATTENTION message

        -- Use edit! to skip swap file prompts
        vim.cmd("edit! " .. vim.fn.fnameescape(expanded_path))
        local buf = vim.api.nvim_get_current_buf()

        -- Restore shortmess
        vim.o.shortmess = old_shortmess

        -- Ensure buffer is modifiable
        vim.api.nvim_buf_set_option(buf, "modifiable", true)

        -- Jump to line if provided
        if line_num and line_num > 0 then
          vim.cmd(":" .. line_num)
          vim.cmd("normal! zz") -- Center screen
        end

        -- Explicitly redraw to ensure focus
        vim.cmd("redraw")

        -- Highlight changed lines
        if buf and line_num > 0 and line_count > 0 then
          M.highlight_lines(buf, line_num, line_count)
        end

        -- Visual feedback with operation type
        local operation = tool_name == "Edit" and "edited" or tool_name == "Write" and "created" or "modified"
        vim.notify(
          string.format("Following: %s:%d (%s %d line%s)",
            vim.fn.fnamemodify(expanded_path, ":~:."),
            line_num,
            operation,
            line_count,
            line_count > 1 and "s" or ""
          ),
          vim.log.levels.INFO
        )
      end

      return M
    '';
  */

  # Simplified custom keymaps - Lean and intuitive
  xdg.configFile."nvim/lua/config/keymaps.lua".text = ''
    -- Simplified keymaps - focusing on essential, frequently-used actions
    -- Philosophy: Less is more. Use LazyVim defaults when they work well.

    -- === CORE ACTIONS (single key shortcuts) ===
    vim.keymap.set("n", "<leader>e", function() Snacks.explorer() end, { desc = "Explorer" })
    vim.keymap.set("n", "<leader>,", function() Snacks.picker.buffers() end, { desc = "Buffers" })

    -- === FILES ===
    vim.keymap.set("n", "<leader>ff", function() Snacks.picker.files() end, { desc = "Find Files" })
    vim.keymap.set("n", "<leader>fr", function() Snacks.picker.recent() end, { desc = "Recent Files" })

    -- === SEARCH ===
    vim.keymap.set("n", "<leader>sg", function() Snacks.picker.grep() end, { desc = "Grep" })
    vim.keymap.set("n", "<leader>sw", function() Snacks.picker.grep_word() end, { desc = "Word Under Cursor" })

    -- === BUFFERS ===
    vim.keymap.set("n", "<leader>bd", function() Snacks.bufdelete() end, { desc = "Delete Buffer" })
    vim.keymap.set("n", "<leader>bo", function() Snacks.bufdelete.other() end, { desc = "Delete Other Buffers" })
    vim.keymap.set("n", "[b", "<cmd>bprevious<cr>", { desc = "Previous Buffer" })
    vim.keymap.set("n", "]b", "<cmd>bnext<cr>", { desc = "Next Buffer" })

    -- === WINDOWS ===
    -- Navigation
    vim.keymap.set("n", "<leader>ww", "<C-W>p", { desc = "Other Window" })
    vim.keymap.set("n", "<leader>wd", "<C-W>c", { desc = "Close Window" })

    -- Splits (LazyVim convention)
    vim.keymap.set("n", "<leader>w-", "<C-W>s", { desc = "Split Below" })
    vim.keymap.set("n", "<leader>w|", "<C-W>v", { desc = "Split Right" })

    -- Resizing
    vim.keymap.set("n", "<leader>w=", "<C-W>=", { desc = "Balance Windows" })
    vim.keymap.set("n", "<leader>wm", function() Snacks.toggle.zoom() end, { desc = "Toggle Maximize" })
    vim.keymap.set("n", "<leader>wH", "<cmd>resize -5<cr>", { desc = "Decrease Height" })
    vim.keymap.set("n", "<leader>wJ", "<cmd>resize +5<cr>", { desc = "Increase Height" })
    vim.keymap.set("n", "<leader>wK", "<cmd>vertical resize -5<cr>", { desc = "Decrease Width" })
    vim.keymap.set("n", "<leader>wL", "<cmd>vertical resize +5<cr>", { desc = "Increase Width" })

    -- === WORKSPACE LAYOUTS ===
    local layouts = require("config.layouts")
    vim.keymap.set("n", "<leader>Wd", layouts.dev_with_claude, { desc = "Dev + Claude" })
    vim.keymap.set("n", "<leader>Wf", layouts.focus, { desc = "Focus Mode" })

    -- === TOGGLES ===
    vim.keymap.set("n", "<leader>us", function()
      vim.opt.spell = not vim.o.spell
      vim.notify("Spell: " .. (vim.o.spell and "ON" or "OFF"), vim.log.levels.INFO)
    end, { desc = "Toggle Spell Check" })

    -- === GROUP LABELS (for which-key) ===
    vim.keymap.set("n", "<leader>f", "+find", { desc = "Find" })
    vim.keymap.set("n", "<leader>s", "+search", { desc = "Search" })
    vim.keymap.set("n", "<leader>b", "+buffer", { desc = "Buffer" })
    vim.keymap.set("n", "<leader>w", "+window", { desc = "Window" })
    vim.keymap.set("n", "<leader>W", "+workspace", { desc = "Workspace" })
    vim.keymap.set("n", "<leader>u", "+ui/toggle", { desc = "UI/Toggle" })
  '';

  # Auto-launch dev layout on startup (optional)
  xdg.configFile."nvim/lua/config/autocmds.lua".text = ''
    -- Custom autocommands for workspace management

    -- Enable spell checking for text-heavy filetypes
    vim.api.nvim_create_autocmd("FileType", {
      pattern = { "markdown", "text", "gitcommit", "NeogitCommitMessage" },
      callback = function()
        vim.opt_local.spell = true
        vim.opt_local.spelllang = "en"
      end,
      desc = "Enable spell checking for text files",
    })

    -- Return Zellij to normal mode on exit (required for zellij-nav.nvim)
    vim.api.nvim_create_autocmd("VimLeave", {
      pattern = "*",
      callback = function()
        vim.fn.system("zellij action switch-mode normal")
      end,
    })

    -- Optionally auto-launch dev layout on startup
    -- Set vim.g.auto_dev_layout = true in your local config to enable
    vim.api.nvim_create_autocmd("VimEnter", {
      callback = function()
        -- Only auto-launch if:
        -- 1. User enabled it with vim.g.auto_dev_layout
        -- 2. No files were opened on command line
        -- 3. Not in a git commit or similar special mode
        if vim.g.auto_dev_layout and vim.fn.argc() == 0 and vim.bo.buftype == "" then
          -- Delay to let everything load
          vim.defer_fn(function()
            require("config.layouts").dev_with_claude()
          end, 100)
        end
      end,
    })

    -- Command to enable auto-launch
    vim.api.nvim_create_user_command("DevLayoutAuto", function()
      vim.g.auto_dev_layout = true
      vim.notify("Dev layout will auto-launch on next nvim start", vim.log.levels.INFO)
    end, { desc = "Enable auto dev layout on startup" })

    -- Command to disable auto-launch
    vim.api.nvim_create_user_command("DevLayoutNoAuto", function()
      vim.g.auto_dev_layout = false
      vim.notify("Dev layout auto-launch disabled", vim.log.levels.INFO)
    end, { desc = "Disable auto dev layout on startup" })

    -- Follow Mode commands now provided by claude-follow-hook.nvim plugin
    -- Available commands: :FollowModeOn, :FollowModeOff, :FollowModeToggle, :FollowModeStatus
    -- Keybindings: <leader>WF (toggle), <leader>WFe (enable), <leader>WFd (disable), <leader>WFs (status)

    -- Ctrl+Space: Launch Zellij room plugin for quick tab switching
    vim.keymap.set("n", "<C-Space>", function()
      -- Trigger autolock check, then launch room plugin
      vim.fn.system("zellij action write-chars '\\u{0020}'")  -- Trigger autolock via space
      vim.fn.system("zellij action launch-plugin --floating https://github.com/rvcas/room/releases/latest/download/room.wasm")
    end, { desc = "Zellij: Quick Tab Switcher", silent = true })
  '';

  # Fix treesitter vim query compatibility issue
  # nvim-treesitter main branch has queries incompatible with Neovim's bundled vim parser
  # Using queries/ (not after/queries/) to REPLACE rather than extend
  xdg.configFile."nvim/queries/vim/highlights.scm".text = ''
    ; Vim highlights query compatible with Neovim's bundled parser
    ; Replaces nvim-treesitter main branch query which has incompatible nodes
    ; (substitute, heredoc patterns, etc.)

    ; Comments
    (comment) @comment

    ; Strings
    (string_literal) @string

    ; Numbers
    (integer_literal) @number
    (float_literal) @number.float

    ; Identifiers
    (identifier) @variable
    ((identifier) @constant
      (#lua-match? @constant "^[A-Z][A-Z_0-9]*$"))

    ; Function definitions
    (function_declaration
      name: (_) @function)
    (call_expression
      function: (identifier) @function.call)

    ; Keywords - conditional
    [
      "if"
      "else"
      "elseif"
      "endif"
    ] @keyword.conditional

    ; Keywords - loops
    [
      "for"
      "endfor"
      "while"
      "endwhile"
      "break"
      "continue"
    ] @keyword.repeat

    ; Keywords - exception
    [
      "try"
      "catch"
      "finally"
      "endtry"
      "throw"
    ] @keyword.exception

    ; Keywords - function
    [
      "function"
      "endfunction"
    ] @keyword.function

    ; Commands
    [
      "let"
      "unlet"
      "const"
      "call"
      "execute"
      "normal"
      "set"
      "setlocal"
      "silent"
      "echo"
      "echon"
      "echohl"
      "echomsg"
      "echoerr"
      "autocmd"
      "augroup"
      "return"
      "syntax"
      "filetype"
      "source"
      "lua"
      "highlight"
      "command"
      "colorscheme"
      "runtime"
      "edit"
      "enew"
      "global"
      "wincmd"
    ] @keyword

    ; Operators
    [
      "."
      ".."
      "+"
      "-"
      "*"
      "/"
      "%"
      "=="
      "!="
      ">"
      "<"
      ">="
      "<="
      "=~"
      "!~"
      "&&"
      "||"
      "!"
    ] @operator

    ; Punctuation
    [
      "("
      ")"
      "["
      "]"
      "{"
      "}"
    ] @punctuation.bracket

    [
      ","
      ":"
    ] @punctuation.delimiter

    ; Special
    (bang) @punctuation.special
    (spread) @punctuation.special

    ; Options
    [
      (no_option)
      (inv_option)
      (default_option)
      (option_name)
    ] @variable.builtin

    ; Scope
    (scope) @module

    ; Command names
    (command_name) @function.macro

    ; Map statements
    (map_statement
      cmd: _ @keyword)
  '';

  # Disable Mason globally and fix which-key configuration
  xdg.configFile."nvim/lua/config/options.lua".text = ''
    -- LazyVim options with Mason disabled
    vim.g.mason_disabled = true

    -- Standard LazyVim options
    vim.opt.autowrite = true
    vim.opt.clipboard = "unnamedplus"

    -- OSC 52 clipboard support (works over SSH, tmux, zellij, etc.)
    -- Neovim 0.10+ has built-in OSC 52 support
    if vim.fn.has("nvim-0.10") == 1 then
      local osc52 = require("vim.ui.clipboard.osc52")
      vim.g.clipboard = {
        name = "OSC 52",
        copy = {
          ["+"] = osc52.copy("+"),
          ["*"] = osc52.copy("*"),
        },
        paste = {
          ["+"] = osc52.paste("+"),
          ["*"] = osc52.paste("*"),
        },
      }
    end
    vim.opt.completeopt = "menu,menuone,noselect"
    vim.opt.conceallevel = 2
    vim.opt.confirm = true
    vim.opt.cursorline = true
    vim.opt.expandtab = true
    vim.opt.formatoptions = "jcroqlnt"
    vim.opt.grepformat = "%f:%l:%c:%m"
    vim.opt.grepprg = "rg --vimgrep"
    vim.opt.ignorecase = true
    vim.opt.inccommand = "nosplit"
    vim.opt.laststatus = 3
    vim.opt.list = true
    vim.opt.mouse = "a"
    vim.opt.number = true
    vim.opt.pumblend = 10
    vim.opt.pumheight = 10
    vim.opt.relativenumber = true
    vim.opt.scrolloff = 8  -- Increased from 4 for better context
    vim.opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp", "folds" }
    vim.opt.shiftround = true
    vim.opt.shiftwidth = 2
    vim.opt.shortmess:append({ W = true, I = true, c = true, C = true })
    vim.opt.showmode = false
    vim.opt.sidescrolloff = 8
    vim.opt.signcolumn = "yes"
    vim.opt.smartcase = true
    vim.opt.smartindent = true
    vim.opt.spelllang = { "en" }
    vim.opt.splitbelow = true
    vim.opt.splitkeep = "screen"
    vim.opt.splitright = true
    vim.opt.tabstop = 2
    vim.opt.termguicolors = true
    vim.opt.timeoutlen = 300
    vim.opt.undofile = true
    vim.opt.undolevels = 10000
    vim.opt.updatetime = 200
    vim.opt.virtualedit = "block"
    vim.opt.wildmode = "longest:full,full"
    vim.opt.winminwidth = 5
    vim.opt.wrap = false

    -- Enable smooth scrolling
    vim.opt.smoothscroll = true
  '';

  # Preinstall LazyVim plugins via Nix (eliminates runtime downloads)
  #
  # IMPORTANT: LazyVim itself is NOT preinstalled to avoid version conflicts.
  # The nixpkgs version can lag behind the latest LazyVim releases, causing
  # compatibility issues where newer config files (keymaps.lua) expect features
  # from newer util/init.lua (like Snacks.keymap.set support for `ft` option).
  # lazy.nvim will automatically download the correct version.
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;

    # Preinstall all LazyVim plugins to avoid runtime downloads
    plugins = with pkgs.vimPlugins; [
      # Core LazyVim framework
      # NOTE: LazyVim is NOT preinstalled to avoid version conflicts
      # The Nix-packaged version may be outdated and cause issues with newer config files
      # lazy.nvim will download the latest LazyVim automatically
      # LazyVim  # DISABLED - let lazy.nvim manage this
      lazy-nvim

      # Complete Snacks.nvim suite (folke's unified plugin collection)
      snacks-nvim

      # AI assistance - REMOVED: Copilot disabled due to LSP errors
      # copilot-lua      # Disabled in config
      # copilot-lsp      # Disabled in config

      # Essential LazyVim dependencies
      which-key-nvim
      nvim-treesitter # Base treesitter plugin for API
      nvim-treesitter.withAllGrammars # All language parsers
      # telescope-nvim           # Replaced by snacks.picker
      # telescope-fzf-native-nvim # Unused (telescope disabled)
      plenary-nvim
      nvim-web-devicons
      nui-nvim

      # Completion system
      nvim-lspconfig
      nvim-cmp
      cmp-nvim-lsp
      cmp-buffer
      cmp-path
      cmp-cmdline
      luasnip
      friendly-snippets

      # Editor enhancements
      leap-nvim
      vim-illuminate
      gitsigns-nvim
      blink-cmp

      # UI and visual
      mini-nvim # Complete mini.nvim suite
      # nvim-notify   # Replaced by snacks.notifier
      # dressing-nvim # Replaced by snacks.input

      # Colorschemes
      catppuccin-nvim # Catppuccin theme (default)
      gruvbox-nvim # Gruvbox theme (alternative)

      # Language-specific plugins that LazyVim extras expect
      nvim-dap # Debug adapter protocol
      conform-nvim # Formatting
      nvim-lint # Linting
      trouble-nvim # Diagnostics

      # Session management
      persistence-nvim # Session persistence

      # Note: zellij-nav.nvim not in nixpkgs, will be downloaded by lazy.nvim
    ];

    # Note: extraPackages (language servers, formatters, etc.) handled by parent config
  };

  # Create a script to help with LazyVim management
  home.file.".local/bin/lazyvim-info".text = ''
    #!/usr/bin/env bash
    echo "LazyVim Configuration Info"
    echo "========================="
    echo "Config location: ~/.config/nvim-lazyvim"
    echo "Mason status: DISABLED (using Nix tools)"
    echo "Language servers: Managed by Nix"
    echo
    echo "Available commands:"
    echo "  nvim                    # Use current active configuration"
    echo "  nvim-config status      # Check which config is active"
    echo "  nvim-config lazyvim     # Instructions to switch to LazyVim"
    echo
    echo "LazyVim-specific:"
    echo "  nvim -u ~/.config/nvim-lazyvim/init.lua  # Test LazyVim directly"
  '';

  home.file.".local/bin/lazyvim-info".executable = true;

  # Deploy logger.lua module
  xdg.configFile."nvim/logger.lua".source = ./logger.lua;
}
