# Git integration plugins
{ pkgs, ... }:
{
  programs.nixvim.plugins = {
    # Gitsigns - Git decorations
    gitsigns = {
      enable = true;
      settings = {
        signs = {
          add = {
            text = "▎";
          };
          change = {
            text = "▎";
          };
          delete = {
            text = "";
          };
          topdelete = {
            text = "";
          };
          changedelete = {
            text = "▎";
          };
          untracked = {
            text = "▎";
          };
        };

        on_attach = {
          __raw = ''
            function(buffer)
              local gs = package.loaded.gitsigns
              
              local function map(mode, l, r, desc)
                vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc })
              end
              
              -- Navigation
              map("n", "]h", gs.next_hunk, "Next hunk")
              map("n", "[h", gs.prev_hunk, "Prev hunk")
              
              -- Actions
              map("n", "<leader>hs", gs.stage_hunk, "Stage hunk")
              map("n", "<leader>hr", gs.reset_hunk, "Reset hunk")
              map("v", "<leader>hs", function() gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") }) end, "Stage hunk")
              map("v", "<leader>hr", function() gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") }) end, "Reset hunk")
              map("n", "<leader>hS", gs.stage_buffer, "Stage buffer")
              map("n", "<leader>hR", gs.reset_buffer, "Reset buffer")
              map("n", "<leader>hu", gs.undo_stage_hunk, "Undo stage hunk")
              map("n", "<leader>hp", gs.preview_hunk, "Preview hunk")
              map("n", "<leader>hb", function() gs.blame_line({ full = true }) end, "Blame line")
              map("n", "<leader>hB", gs.toggle_current_line_blame, "Toggle line blame")
              map("n", "<leader>hd", gs.diffthis, "Diff this")
              map("n", "<leader>hD", function() gs.diffthis("~") end, "Diff this ~")
              
              -- Text object
              map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "Gitsigns select hunk")
            end
          '';
        };
      };
    };

    # Lazygit integration
    lazygit = {
      enable = true;
    };

    # Fugitive - Git commands
    fugitive = {
      enable = true;
    };

    # Diffview - Better diff viewer
    diffview = {
      enable = true;
    };

    # Git worktree
    git-worktree = {
      enable = true;
    };

    # Neogit - Magit-like interface
    neogit = {
      enable = false; # Optional alternative to lazygit
      settings = {
        integrations = {
          telescope = true;
          diffview = true;
        };
      };
    };
  };

  # Git keymaps
  programs.nixvim.keymaps = [
    # Lazygit
    {
      mode = "n";
      key = "<leader>gg";
      action = "<cmd>LazyGit<cr>";
      options = {
        desc = "LazyGit";
      };
    }
    {
      mode = "n";
      key = "<leader>gf";
      action = "<cmd>LazyGitFilter<cr>";
      options = {
        desc = "LazyGit filter";
      };
    }
    {
      mode = "n";
      key = "<leader>gF";
      action = "<cmd>LazyGitFilterCurrentFile<cr>";
      options = {
        desc = "LazyGit current file";
      };
    }

    # Fugitive
    {
      mode = "n";
      key = "<leader>gb";
      action = "<cmd>Git blame<cr>";
      options = {
        desc = "Git blame";
      };
    }
    {
      mode = "n";
      key = "<leader>gB";
      action = "<cmd>GBrowse<cr>";
      options = {
        desc = "Git browse";
      };
    }
    {
      mode = "n";
      key = "<leader>gd";
      action = "<cmd>Gvdiffsplit<cr>";
      options = {
        desc = "Git diff split";
      };
    }
    {
      mode = "n";
      key = "<leader>gl";
      action = "<cmd>Git log<cr>";
      options = {
        desc = "Git log";
      };
    }

    # Diffview
    {
      mode = "n";
      key = "<leader>gD";
      action = "<cmd>DiffviewOpen<cr>";
      options = {
        desc = "Diffview open";
      };
    }
    {
      mode = "n";
      key = "<leader>gh";
      action = "<cmd>DiffviewFileHistory<cr>";
      options = {
        desc = "File history";
      };
    }
    {
      mode = "n";
      key = "<leader>gH";
      action = "<cmd>DiffviewFileHistory %<cr>";
      options = {
        desc = "Current file history";
      };
    }
  ];
}
