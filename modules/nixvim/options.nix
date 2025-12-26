# Vim options configuration - LazyVim defaults
{ ... }:
{
  programs.nixvim.opts = {
    # Line numbers
    number = true;
    relativenumber = true;

    # Tabs and indentation
    tabstop = 2;
    softtabstop = 2;
    shiftwidth = 2;
    expandtab = true;
    smartindent = true;
    shiftround = true;

    # Search
    ignorecase = true;
    smartcase = true;
    hlsearch = true;
    incsearch = true;

    # UI
    termguicolors = true;
    signcolumn = "yes";
    wrap = false;
    scrolloff = 8;
    sidescrolloff = 8;
    cursorline = true;
    ruler = false;
    showcmd = false;
    showmode = false;
    laststatus = 3; # Global statusline
    cmdheight = 1;

    # Behavior
    mouse = "a";
    clipboard = "unnamedplus";
    updatetime = 200;
    timeoutlen = 300;
    undofile = true;
    undolevels = 10000;
    splitbelow = true;
    splitright = true;
    splitkeep = "screen";

    # Completion
    completeopt = "menu,menuone,noselect";
    pumheight = 10;

    # Performance
    lazyredraw = false; # Don't use in Neovim

    # Folding (using treesitter)
    foldlevel = 99;
    foldmethod = "expr";
    foldexpr = "nvim_treesitter#foldexpr()";
    foldenable = false; # Don't fold by default

    # Other
    backup = false;
    writebackup = false;
    swapfile = false;
    conceallevel = 3;
    fileencoding = "utf-8";
    hidden = true;
    sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions";

    # List chars (show hidden characters)
    list = true;
    listchars = {
      tab = "→ ";
      trail = "·";
      nbsp = "␣";
      extends = "▸";
      precedes = "◂";
    };

    # Fill chars
    fillchars = {
      foldopen = "v"; # Expanded fold (using simple ASCII)
      foldclose = ">"; # Collapsed fold (using simple ASCII)
      fold = " ";
      foldsep = " ";
      diff = "╱";
      eob = " ";
    };
  };
}
