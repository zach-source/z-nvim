#!/usr/bin/env bash
# Simple integration test - just verify keymaps load from actual config

set -euo pipefail

echo "🧪 Simple Keymap Verification Test"
echo "=================================="
echo ""

# Test 1: Check if config exists
echo "✓ Testing config file exists..."
if [[ ! -f "$HOME/.config/nvim/lua/config/keymaps.lua" ]]; then
    echo "❌ Config file not found!"
    exit 1
fi
echo "  ✅ Config file exists"

# Test 2: Source the config and check keymaps
echo "✓ Testing keymaps load correctly..."
nvim --headless --noplugin -c "
set runtimepath+=$HOME/.config/nvim
lua << EOF
-- Set leader
vim.g.mapleader = ' '

-- Mock Snacks to prevent errors
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
package.loaded['config.layouts'] = {
  dev_with_claude = function() end,
  focus = function() end,
}

-- Load keymaps
dofile(vim.fn.expand('~/.config/nvim/lua/config/keymaps.lua'))

-- Check for critical keymaps
local keymaps = vim.api.nvim_get_keymap('n')
local found = {}

for _, map in ipairs(keymaps) do
  if map.lhs == ' ww' then found['ww'] = true end
  if map.lhs == ' wd' then found['wd'] = true end
  if map.lhs == ' ws' then found['ws'] = true end
  if map.lhs == ' wv' then found['wv'] = true end
  if map.lhs == ' w=' then found['w='] = true end
  if map.lhs == '[b' then found['[b'] = true end
  if map.lhs == ']b' then found[']b'] = true end
end

-- Report results
local all_found = true
local tests = {'ww', 'wd', 'ws', 'wv', 'w=', '[b', ']b'}

for _, test in ipairs(tests) do
  if not found[test] then
    print('❌ Missing keymap: ' .. test)
    all_found = false
  end
end

if all_found then
  print('✅ All critical keymaps found')
  vim.cmd('qall!')
else
  vim.cmd('cquit')
end
EOF
" 2>&1

if [[ $? -eq 0 ]]; then
    echo "  ✅ Keymaps loaded successfully"
    echo ""
    echo "=================================="
    echo "✅ All tests passed!"
    exit 0
else
    echo "  ❌ Some keymaps failed to load"
    echo ""
    echo "=================================="
    echo "❌ Tests failed"
    exit 1
fi
