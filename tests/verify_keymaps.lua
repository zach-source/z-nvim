-- Simple keymap verification test
-- Run with: nvim --headless -u verify_keymaps.lua

-- Set leader
vim.g.mapleader = " "

-- Mock Snacks
_G.Snacks = {
  explorer = { toggle = function() end },
  picker = {
    buffers = function() end,
    files = function() end,
    recent = function() end,
    grep = function() end,
    grep_word = function() end,
  },
  bufdelete = function() end,
}

-- Mock layouts
package.loaded["config.layouts"] = {
  dev_with_claude = function() end,
  focus = function() end,
}

-- Load keymaps
local keymaps_file = vim.fn.expand("~/.config/nvim/lua/config/keymaps.lua")
if vim.fn.filereadable(keymaps_file) == 1 then
  dofile(keymaps_file)
  print("✅ Keymaps file loaded")
else
  print("❌ Keymaps file not found: " .. keymaps_file)
  vim.cmd("cquit 1")
end

-- Wait a moment for keymaps to register
vim.wait(100)

-- Check for keymaps
local keymaps = vim.api.nvim_get_keymap("n")
local found = {}
local total = 0

for _, map in ipairs(keymaps) do
  total = total + 1
  if map.lhs == " ww" then found["ww"] = true end
  if map.lhs == " wd" then found["wd"] = true end
  if map.lhs == " ws" then found["ws"] = true end
  if map.lhs == " wv" then found["wv"] = true end
  if map.lhs == " w=" then found["w="] = true end
  if map.lhs == "[b" then found["[b"] = true end
  if map.lhs == "]b" then found["]b"] = true end
end

print(string.format("Found %d total keymaps", total))

-- Report results
local all_found = true
local tests = {"ww", "wd", "ws", "wv", "w=", "[b", "]b"}

for _, test in ipairs(tests) do
  if found[test] then
    print(string.format("✅ Found keymap: %s", test))
  else
    print(string.format("❌ Missing keymap: %s", test))
    all_found = false
  end
end

if all_found then
  print("")
  print("✅ All critical keymaps verified!")
  vim.cmd("qall!")
else
  print("")
  print("❌ Some keymaps missing")
  vim.cmd("cquit 1")
end
