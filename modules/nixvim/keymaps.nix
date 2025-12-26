# Keymaps configuration - LazyVim-style keybindings
{ ... }:
{
  programs.nixvim.keymaps = [
    # Better window navigation
    {
      mode = "n";
      key = "<C-h>";
      action = "<C-w>h";
      options = {
        desc = "Go to left window";
      };
    }
    {
      mode = "n";
      key = "<C-j>";
      action = "<C-w>j";
      options = {
        desc = "Go to lower window";
      };
    }
    {
      mode = "n";
      key = "<C-k>";
      action = "<C-w>k";
      options = {
        desc = "Go to upper window";
      };
    }
    {
      mode = "n";
      key = "<C-l>";
      action = "<C-w>l";
      options = {
        desc = "Go to right window";
      };
    }

    # Window navigation with leader key
    {
      mode = "n";
      key = "<leader>wh";
      action = "<C-w>h";
      options = {
        desc = "Go to left window";
      };
    }
    {
      mode = "n";
      key = "<leader>wj";
      action = "<C-w>j";
      options = {
        desc = "Go to lower window";
      };
    }
    {
      mode = "n";
      key = "<leader>wk";
      action = "<C-w>k";
      options = {
        desc = "Go to upper window";
      };
    }
    {
      mode = "n";
      key = "<leader>wl";
      action = "<C-w>l";
      options = {
        desc = "Go to right window";
      };
    }

    # Window management
    {
      mode = "n";
      key = "<leader>ww";
      action = "<C-w>p";
      options = {
        desc = "Other window";
      };
    }
    {
      mode = "n";
      key = "<leader>wd";
      action = "<C-w>c";
      options = {
        desc = "Delete window";
      };
    }
    {
      mode = "n";
      key = "<leader>ws";
      action = "<C-w>s";
      options = {
        desc = "Split window below";
      };
    }
    {
      mode = "n";
      key = "<leader>wv";
      action = "<C-w>v";
      options = {
        desc = "Split window right";
      };
    }
    {
      mode = "n";
      key = "<leader>w-";
      action = "<C-w>s";
      options = {
        desc = "Split window below";
      };
    }
    {
      mode = "n";
      key = "<leader>w|";
      action = "<C-w>v";
      options = {
        desc = "Split window right";
      };
    }

    # Resize windows
    {
      mode = "n";
      key = "<C-Up>";
      action = "<cmd>resize +2<cr>";
      options = {
        desc = "Increase window height";
      };
    }
    {
      mode = "n";
      key = "<C-Down>";
      action = "<cmd>resize -2<cr>";
      options = {
        desc = "Decrease window height";
      };
    }
    {
      mode = "n";
      key = "<C-Left>";
      action = "<cmd>vertical resize -2<cr>";
      options = {
        desc = "Decrease window width";
      };
    }
    {
      mode = "n";
      key = "<C-Right>";
      action = "<cmd>vertical resize +2<cr>";
      options = {
        desc = "Increase window width";
      };
    }

    # Buffer navigation
    {
      mode = "n";
      key = "<S-h>";
      action = "<cmd>bprevious<cr>";
      options = {
        desc = "Prev buffer";
      };
    }
    {
      mode = "n";
      key = "<S-l>";
      action = "<cmd>bnext<cr>";
      options = {
        desc = "Next buffer";
      };
    }
    {
      mode = "n";
      key = "[b";
      action = "<cmd>bprevious<cr>";
      options = {
        desc = "Prev buffer";
      };
    }
    {
      mode = "n";
      key = "]b";
      action = "<cmd>bnext<cr>";
      options = {
        desc = "Next buffer";
      };
    }
    {
      mode = "n";
      key = "<leader>bb";
      action = "<cmd>e #<cr>";
      options = {
        desc = "Switch to other buffer";
      };
    }
    {
      mode = "n";
      key = "<leader>`";
      action = "<cmd>e #<cr>";
      options = {
        desc = "Switch to other buffer";
      };
    }

    # Clear search highlighting
    {
      mode = "n";
      key = "<Esc>";
      action = "<cmd>nohlsearch<CR>";
      options = {
        desc = "Clear search highlight";
      };
    }

    # Save and quit
    {
      mode = "n";
      key = "<leader>w";
      action = "<cmd>w<cr>";
      options = {
        desc = "Save file";
      };
    }
    {
      mode = "n";
      key = "<leader>q";
      action = "<cmd>q<cr>";
      options = {
        desc = "Quit";
      };
    }
    {
      mode = "n";
      key = "<leader>Q";
      action = "<cmd>qa<cr>";
      options = {
        desc = "Quit all";
      };
    }

    # Better indenting
    {
      mode = "v";
      key = "<";
      action = "<gv";
      options = {
        desc = "Indent left";
      };
    }
    {
      mode = "v";
      key = ">";
      action = ">gv";
      options = {
        desc = "Indent right";
      };
    }

    # Move lines
    {
      mode = "n";
      key = "<A-j>";
      action = "<cmd>m .+1<cr>==";
      options = {
        desc = "Move down";
      };
    }
    {
      mode = "n";
      key = "<A-k>";
      action = "<cmd>m .-2<cr>==";
      options = {
        desc = "Move up";
      };
    }
    {
      mode = "i";
      key = "<A-j>";
      action = "<esc><cmd>m .+1<cr>==gi";
      options = {
        desc = "Move down";
      };
    }
    {
      mode = "i";
      key = "<A-k>";
      action = "<esc><cmd>m .-2<cr>==gi";
      options = {
        desc = "Move up";
      };
    }
    {
      mode = "v";
      key = "<A-j>";
      action = ":m '>+1<cr>gv=gv";
      options = {
        desc = "Move down";
      };
    }
    {
      mode = "v";
      key = "<A-k>";
      action = ":m '<-2<cr>gv=gv";
      options = {
        desc = "Move up";
      };
    }

    # Diagnostics
    {
      mode = "n";
      key = "]d";
      action = {
        __raw = "vim.diagnostic.goto_next";
      };
      options = {
        desc = "Next diagnostic";
      };
    }
    {
      mode = "n";
      key = "[d";
      action = {
        __raw = "vim.diagnostic.goto_prev";
      };
      options = {
        desc = "Prev diagnostic";
      };
    }
    {
      mode = "n";
      key = "]e";
      action.__raw = ''function() vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.ERROR }) end'';
      options = {
        desc = "Next error";
      };
    }
    {
      mode = "n";
      key = "[e";
      action.__raw = ''function() vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.ERROR }) end'';
      options = {
        desc = "Prev error";
      };
    }
    {
      mode = "n";
      key = "]w";
      action.__raw = ''function() vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.WARN }) end'';
      options = {
        desc = "Next warning";
      };
    }
    {
      mode = "n";
      key = "[w";
      action.__raw = ''function() vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.WARN }) end'';
      options = {
        desc = "Prev warning";
      };
    }

    # Session Management
    {
      mode = "n";
      key = "<leader>qs";
      action = "<cmd>SessionSave<cr>";
      options = {
        desc = "Save session";
      };
    }
    {
      mode = "n";
      key = "<leader>qr";
      action = "<cmd>SessionRestore<cr>";
      options = {
        desc = "Restore session";
      };
    }
    {
      mode = "n";
      key = "<leader>ql";
      action = "<cmd>SessionDelete<cr>";
      options = {
        desc = "Delete session";
      };
    }
    {
      mode = "n";
      key = "<leader>qd";
      action = "<cmd>Autosession delete<cr>";
      options = {
        desc = "Delete session";
      };
    }
    {
      mode = "n";
      key = "<leader>qf";
      action = "<cmd>Autosession search<cr>";
      options = {
        desc = "Find session";
      };
    }

    # Search and Replace (Spectre)
    {
      mode = "n";
      key = "<leader>sr";
      action = ''<cmd>lua require("spectre").toggle()<cr>'';
      options = {
        desc = "Replace in files (Spectre)";
      };
    }
    {
      mode = "n";
      key = "<leader>sw";
      action = ''<cmd>lua require("spectre").open_visual({select_word=true})<cr>'';
      options = {
        desc = "Search current word (Spectre)";
      };
    }
    {
      mode = "v";
      key = "<leader>sw";
      action = ''<esc><cmd>lua require("spectre").open_visual()<cr>'';
      options = {
        desc = "Search current word (Spectre)";
      };
    }
    {
      mode = "n";
      key = "<leader>sp";
      action = ''<cmd>lua require("spectre").open_file_search({select_word=true})<cr>'';
      options = {
        desc = "Search on current file (Spectre)";
      };
    }

    # Toggle options
    {
      mode = "n";
      key = "<leader>ul";
      action.__raw = ''function() vim.opt.relativenumber = not vim.opt.relativenumber:get() end'';
      options = {
        desc = "Toggle relative line numbers";
      };
    }
    {
      mode = "n";
      key = "<leader>uL";
      action.__raw = ''function() vim.opt.number = not vim.opt.number:get() end'';
      options = {
        desc = "Toggle line numbers";
      };
    }
    {
      mode = "n";
      key = "<leader>uw";
      action.__raw = ''function() vim.opt.wrap = not vim.opt.wrap:get() end'';
      options = {
        desc = "Toggle word wrap";
      };
    }
    {
      mode = "n";
      key = "<leader>us";
      action.__raw = ''function() vim.opt.spell = not vim.opt.spell:get() end'';
      options = {
        desc = "Toggle spelling";
      };
    }

    # LazyVim-style new file
    {
      mode = "n";
      key = "<leader>fn";
      action = "<cmd>enew<cr>";
      options = {
        desc = "New file";
      };
    }

    # Location and quickfix
    {
      mode = "n";
      key = "<leader>xl";
      action = "<cmd>lopen<cr>";
      options = {
        desc = "Location list";
      };
    }
    {
      mode = "n";
      key = "<leader>xq";
      action = "<cmd>copen<cr>";
      options = {
        desc = "Quickfix list";
      };
    }
    {
      mode = "n";
      key = "[q";
      action = {
        __raw = "vim.cmd.cprev";
      };
      options = {
        desc = "Previous quickfix";
      };
    }
    {
      mode = "n";
      key = "]q";
      action = {
        __raw = "vim.cmd.cnext";
      };
      options = {
        desc = "Next quickfix";
      };
    }

    # Terminal
    {
      mode = "t";
      key = "<Esc><Esc>";
      action = "<C-\\><C-n>";
      options = {
        desc = "Enter normal mode";
      };
    }
    {
      mode = "t";
      key = "<C-h>";
      action = "<cmd>wincmd h<cr>";
      options = {
        desc = "Go to left window";
      };
    }
    {
      mode = "t";
      key = "<C-j>";
      action = "<cmd>wincmd j<cr>";
      options = {
        desc = "Go to lower window";
      };
    }
    {
      mode = "t";
      key = "<C-k>";
      action = "<cmd>wincmd k<cr>";
      options = {
        desc = "Go to upper window";
      };
    }
    {
      mode = "t";
      key = "<C-l>";
      action = "<cmd>wincmd l<cr>";
      options = {
        desc = "Go to right window";
      };
    }

    # Tabs
    {
      mode = "n";
      key = "<leader><tab>l";
      action = "<cmd>tablast<cr>";
      options = {
        desc = "Last tab";
      };
    }
    {
      mode = "n";
      key = "<leader><tab>f";
      action = "<cmd>tabfirst<cr>";
      options = {
        desc = "First tab";
      };
    }
    {
      mode = "n";
      key = "<leader><tab><tab>";
      action = "<cmd>tabnew<cr>";
      options = {
        desc = "New tab";
      };
    }
    {
      mode = "n";
      key = "<leader><tab>]";
      action = "<cmd>tabnext<cr>";
      options = {
        desc = "Next tab";
      };
    }
    {
      mode = "n";
      key = "<leader><tab>d";
      action = "<cmd>tabclose<cr>";
      options = {
        desc = "Close tab";
      };
    }
    {
      mode = "n";
      key = "<leader><tab>[";
      action = "<cmd>tabprevious<cr>";
      options = {
        desc = "Previous tab";
      };
    }
  ];
}
