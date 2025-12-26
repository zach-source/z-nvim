# Lazy loading configuration for NixVim plugins
{ ... }:
{
  programs.nixvim = {
    # Enable lazy loading globally
    globals = {
      # Similar to lazy.nvim's behavior
      lazy_did_setup = true;
    };

    # Autocommands for lazy loading specific plugins
    autoCmd = [
      # Load certain plugins only for specific filetypes
      {
        event = "FileType";
        pattern = [
          "go"
          "gomod"
          "gowork"
          "gotmpl"
        ];
        callback = {
          __raw = ''
            function()
              -- Go-specific plugins get loaded here
              vim.cmd('packadd vim-go') -- if using additional go plugins
            end
          '';
        };
      }

      # Load completion plugins on InsertEnter
      {
        event = "InsertEnter";
        pattern = "*";
        once = true;
        callback = {
          __raw = ''
            function()
              -- Trigger loading of completion-related plugins
              -- Most are already lazy-loaded by NixVim's cmp module
            end
          '';
        };
      }

      # Load UI enhancements after startup
      {
        event = "UIEnter";
        pattern = "*";
        once = true;
        callback = {
          __raw = ''
            function()
              -- Load UI plugins that aren't needed immediately
              vim.schedule(function()
                -- UI plugins are loaded here
              end)
            end
          '';
        };
      }
    ];

    # Extra configuration for lazy loading patterns
    extraConfigLua = ''
      -- Lazy loading utilities similar to lazy.nvim
      local lazy_load = function(plugin)
        vim.api.nvim_create_autocmd("User", {
          pattern = "VeryLazy",
          callback = function()
            vim.cmd("packadd " .. plugin)
          end,
        })
      end

      -- Create VeryLazy event (fires after startup)
      vim.api.nvim_create_autocmd("User", {
        pattern = "LazyDone",
        callback = function()
          vim.schedule(function()
            vim.api.nvim_exec_autocmds("User", { pattern = "VeryLazy" })
          end)
        end,
      })

      -- Trigger LazyDone after UI enters
      vim.api.nvim_create_autocmd("UIEnter", {
        once = true,
        callback = function()
          vim.schedule(function()
            vim.api.nvim_exec_autocmds("User", { pattern = "LazyDone" })
          end)
        end,
      })

      -- Lazy load helper for keymaps
      _G.lazy_keymap = function(mode, lhs, rhs, opts)
        opts = opts or {}
        opts.noremap = opts.noremap == nil and true or opts.noremap
        opts.silent = opts.silent == nil and true or opts.silent
        
        vim.keymap.set(mode, lhs, function()
          -- Remove the keymap
          vim.keymap.del(mode, lhs)
          -- Execute the original action
          if type(rhs) == "function" then
            rhs()
          else
            vim.cmd(rhs)
          end
          -- Replay the keys
          vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(lhs, true, false, true), 'n', false)
        end, opts)
      end
    '';

    # Performance optimizations similar to LazyVim
    performance = {
      # These are NixVim's performance options
      byteCompileLua = {
        enable = true;
        configs = true;
        plugins = true;
      };
    };
  };
}
