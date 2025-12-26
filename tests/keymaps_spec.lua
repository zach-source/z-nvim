-- Keybindings test for LazyVim configuration
-- Run with: nvim --headless -u tests/minimal_init.lua -c "PlenaryBustedDirectory tests/"

describe("Keymaps", function()
  -- Wait for plugins to fully load
  before_each(function()
    vim.wait(2000, function()
      return _G.Snacks ~= nil
    end)
  end)

  describe("Window management", function()
    it("should have window navigation keymaps", function()
      local keymaps = vim.api.nvim_get_keymap("n")

      -- Check for window keymaps
      local has_ww = false
      local has_wd = false
      local has_ws = false
      local has_wv = false

      for _, map in ipairs(keymaps) do
        if map.lhs == " ww" then has_ww = true end
        if map.lhs == " wd" then has_wd = true end
        if map.lhs == " ws" then has_ws = true end
        if map.lhs == " wv" then has_wv = true end
      end

      assert.is_true(has_ww, "Missing <leader>ww keymap")
      assert.is_true(has_wd, "Missing <leader>wd keymap")
      assert.is_true(has_ws, "Missing <leader>ws keymap")
      assert.is_true(has_wv, "Missing <leader>wv keymap")
    end)

    it("should have window resizing keymaps", function()
      local keymaps = vim.api.nvim_get_keymap("n")

      local has_balance = false
      local has_maximize = false
      local has_increase_height = false
      local has_decrease_height = false
      local has_increase_width = false
      local has_decrease_width = false

      for _, map in ipairs(keymaps) do
        if map.lhs == " w=" then has_balance = true end
        if map.lhs == " wm" then has_maximize = true end
        if map.lhs == " w+" then has_increase_height = true end
        if map.lhs == " w-" then has_decrease_height = true end
        if map.lhs == " w>" then has_increase_width = true end
        if map.lhs == " w<" then has_decrease_width = true end
      end

      assert.is_true(has_balance, "Missing <leader>w= keymap")
      assert.is_true(has_maximize, "Missing <leader>wm keymap")
      assert.is_true(has_increase_height, "Missing <leader>w+ keymap")
      assert.is_true(has_decrease_height, "Missing <leader>w- keymap")
      assert.is_true(has_increase_width, "Missing <leader>w> keymap")
      assert.is_true(has_decrease_width, "Missing <leader>w< keymap")
    end)
  end)

  describe("Buffer management", function()
    it("should have buffer navigation keymaps", function()
      local keymaps = vim.api.nvim_get_keymap("n")

      local has_prev = false
      local has_next = false

      for _, map in ipairs(keymaps) do
        if map.lhs == "[b" then has_prev = true end
        if map.lhs == "]b" then has_next = true end
      end

      assert.is_true(has_prev, "Missing [b keymap")
      assert.is_true(has_next, "Missing ]b keymap")
    end)
  end)

  describe("Zellij navigation", function()
    it("should have Ctrl+hjkl navigation keymaps", function()
      local keymaps = vim.api.nvim_get_keymap("n")

      local has_ctrl_h = false
      local has_ctrl_j = false
      local has_ctrl_k = false
      local has_ctrl_l = false

      for _, map in ipairs(keymaps) do
        -- Ctrl+h is represented as <C-h> in the keymap
        if map.lhs:match("<C%-h>") then has_ctrl_h = true end
        if map.lhs:match("<C%-j>") then has_ctrl_j = true end
        if map.lhs:match("<C%-k>") then has_ctrl_k = true end
        if map.lhs:match("<C%-l>") then has_ctrl_l = true end
      end

      assert.is_true(has_ctrl_h, "Missing <C-h> keymap for Zellij navigation")
      assert.is_true(has_ctrl_j, "Missing <C-j> keymap for Zellij navigation")
      assert.is_true(has_ctrl_k, "Missing <C-k> keymap for Zellij navigation")
      assert.is_true(has_ctrl_l, "Missing <C-l> keymap for Zellij navigation")
    end)
  end)

  describe("Keymap descriptions", function()
    it("should have descriptions for all custom keymaps", function()
      local keymaps = vim.api.nvim_get_keymap("n")

      -- Check that important keymaps have descriptions
      local important_keys = {
        " ww",
        " wd",
        " ws",
        " wv",
        " w=",
        " wm",
        "[b",
        "]b"
      }

      for _, key in ipairs(important_keys) do
        local found = false
        local has_desc = false

        for _, map in ipairs(keymaps) do
          if map.lhs == key then
            found = true
            -- Check if desc exists in the mapping
            if map.desc and map.desc ~= "" then
              has_desc = true
            end
            break
          end
        end

        if found then
          assert.is_true(has_desc, "Keymap " .. key .. " is missing a description")
        end
      end
    end)
  end)

  describe("Plugin Integration", function()
    describe("Snacks.nvim", function()
      it("should load Snacks plugin", function()
        assert.is_not_nil(_G.Snacks, "Snacks global not loaded")
      end)

      it("should have explorer functionality", function()
        assert.is_not_nil(_G.Snacks.explorer, "Snacks.explorer not available")
        assert.is_function(_G.Snacks.explorer, "Snacks.explorer is not a function")
      end)

      it("should have picker functionality", function()
        assert.is_not_nil(_G.Snacks.picker, "Snacks.picker not available")
        assert.is_not_nil(_G.Snacks.picker.files, "Snacks.picker.files not available")
        assert.is_function(_G.Snacks.picker.files, "Snacks.picker.files is not a function")
        assert.is_function(_G.Snacks.picker.buffers, "Snacks.picker.buffers is not a function")
        assert.is_function(_G.Snacks.picker.grep, "Snacks.picker.grep is not a function")
      end)

      it("should have bufdelete functionality", function()
        assert.is_not_nil(_G.Snacks.bufdelete, "Snacks.bufdelete not available")
        assert.is_function(_G.Snacks.bufdelete, "Snacks.bufdelete is not a function")
      end)
    end)

    describe("Zellij Navigation", function()
      it("should have ZellijNavigate commands", function()
        local commands = vim.api.nvim_get_commands({})

        assert.is_not_nil(commands.ZellijNavigateLeftTab, "ZellijNavigateLeftTab command not found")
        assert.is_not_nil(commands.ZellijNavigateDown, "ZellijNavigateDown command not found")
        assert.is_not_nil(commands.ZellijNavigateUp, "ZellijNavigateUp command not found")
        assert.is_not_nil(commands.ZellijNavigateRightTab, "ZellijNavigateRightTab command not found")
      end)
    end)

    describe("Layout Functions", function()
      it("should load layout module", function()
        local layouts = package.loaded["config.layouts"]
        assert.is_not_nil(layouts, "config.layouts module not loaded")
      end)

      it("should have dev_with_claude function", function()
        local layouts = package.loaded["config.layouts"]
        assert.is_function(layouts.dev_with_claude, "dev_with_claude is not a function")
      end)

      it("should have focus function", function()
        local layouts = package.loaded["config.layouts"]
        assert.is_function(layouts.focus, "focus is not a function")
      end)

      it("dev_with_claude should be callable", function()
        local layouts = package.loaded["config.layouts"]
        local success, result = pcall(layouts.dev_with_claude)
        assert.is_true(success, "dev_with_claude failed to execute: " .. tostring(result))
      end)

      it("focus should be callable", function()
        local layouts = package.loaded["config.layouts"]
        local success, result = pcall(layouts.focus)
        assert.is_true(success, "focus failed to execute: " .. tostring(result))
      end)
    end)
  end)

  describe("Functional Tests", function()
    describe("Buffer operations", function()
      it("should navigate to next buffer", function()
        -- Create multiple buffers
        local buf1 = vim.api.nvim_create_buf(true, false)
        local buf2 = vim.api.nvim_create_buf(true, false)

        vim.api.nvim_set_current_buf(buf1)
        local initial_buf = vim.api.nvim_get_current_buf()

        -- Execute next buffer command
        vim.cmd("bnext")
        local new_buf = vim.api.nvim_get_current_buf()

        assert.is_not_equal(initial_buf, new_buf, "Buffer did not change")

        -- Cleanup
        vim.api.nvim_buf_delete(buf1, { force = true })
        vim.api.nvim_buf_delete(buf2, { force = true })
      end)
    end)

    describe("Window operations", function()
      it("should create split below", function()
        local initial_windows = #vim.api.nvim_list_wins()

        -- Execute split command
        vim.cmd("split")
        local new_windows = #vim.api.nvim_list_wins()

        assert.is_true(new_windows > initial_windows, "Split did not create new window")
      end)

      it("should create vertical split", function()
        local initial_windows = #vim.api.nvim_list_wins()

        -- Execute vertical split command
        vim.cmd("vsplit")
        local new_windows = #vim.api.nvim_list_wins()

        assert.is_true(new_windows > initial_windows, "Vertical split did not create new window")
      end)
    end)
  end)
end)
