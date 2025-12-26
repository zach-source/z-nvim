-- Minimal init for testing with plugin loading
-- This loads LazyVim plugins to test real functionality

-- Set leader key before loading plugins
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Add lazy.nvim to runtimepath
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Load minimal set of plugins needed for testing
require("lazy").setup({
  -- Testing framework
  { "nvim-lua/plenary.nvim" },

  -- Snacks.nvim (needed for keymaps)
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
      bigfile = { enabled = true },
      bufdelete = { enabled = true },
      explorer = { enabled = true },
      picker = { enabled = true },
      quickfile = { enabled = true },
      rename = { enabled = true },
      scroll = { enabled = false },
      statuscolumn = { enabled = true },
      terminal = { enabled = true },
      toggle = { enabled = true },
      win = { enabled = true },
    },
    config = function(_, opts)
      local snacks = require("snacks")
      snacks.setup(opts)
      _G.Snacks = snacks
    end,
  },

  -- Zellij navigation plugin
  {
    "swaits/zellij-nav.nvim",
    lazy = false,
    keys = {
      { "<C-h>", "<cmd>ZellijNavigateLeftTab<cr>", mode = "n", silent = true },
      { "<C-j>", "<cmd>ZellijNavigateDown<cr>", mode = "n", silent = true },
      { "<C-k>", "<cmd>ZellijNavigateUp<cr>", mode = "n", silent = true },
      { "<C-l>", "<cmd>ZellijNavigateRightTab<cr>", mode = "n", silent = true },
    },
    opts = {},
  },
}, {
  defaults = { lazy = true },
  install = { missing = false }, -- Don't install missing plugins
  checker = { enabled = false },
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

-- Wait for plugins to load
vim.wait(1000, function()
  return _G.Snacks ~= nil
end)

-- Create layout module for workspace keymaps
package.loaded["config.layouts"] = {
  dev_with_claude = function()
    -- Open explorer
    if _G.Snacks and _G.Snacks.explorer then
      _G.Snacks.explorer({ width = 35 })
    end
    -- Focus would switch window and open Sidekick, but for testing just verify it's callable
    return true
  end,

  focus = function()
    -- Zen mode - for testing just verify it's callable
    if _G.Snacks and _G.Snacks.zen then
      return true
    end
    return true
  end,

  explorer_focus = function()
    if _G.Snacks and _G.Snacks.explorer then
      _G.Snacks.explorer({ width = 50 })
      return true
    end
    return false
  end,
}

-- Load keymaps after plugins
local config_path = vim.fn.stdpath("config")
local keymaps_file = config_path .. "/lua/config/keymaps.lua"
if vim.fn.filereadable(keymaps_file) == 1 then
  dofile(keymaps_file)
end
