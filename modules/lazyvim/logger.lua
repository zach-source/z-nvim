-- Custom logger module for Neovim debugging
-- Based on logger.nvim and Neovim dev_tools best practices

local M = {}

-- Log levels (matching vim.log.levels)
M.levels = {
  TRACE = 0,
  DEBUG = 1,
  INFO = 2,
  WARN = 3,
  ERROR = 4,
}

local level_names = { "TRACE", "DEBUG", "INFO", "WARN", "ERROR" }

-- Default configuration
local config = {
  log_level = M.levels.INFO,
  log_file = vim.fn.stdpath("state") .. "/debug.log",
  echo_messages = false, -- Disabled to prevent "Press ENTER" prompts
  max_file_size = 1024 * 1024, -- 1MB
  rotation_count = 3,
}

-- Rotate log file if too large
local function rotate_log()
  local size = vim.fn.getfsize(config.log_file)
  if size > config.max_file_size then
    -- Rotate old logs
    for i = config.rotation_count - 1, 1, -1 do
      local old_file = config.log_file .. "." .. i
      local new_file = config.log_file .. "." .. (i + 1)
      vim.fn.rename(old_file, new_file)
    end
    vim.fn.rename(config.log_file, config.log_file .. ".1")
  end
end

-- Format and write log message
local function log_message(level, ...)
  -- Check if message should be logged based on level
  if level < config.log_level then
    return
  end

  local level_name = level_names[level + 1] or "UNKNOWN"
  local timestamp = os.date("%Y-%m-%d %H:%M:%S")

  -- Format message parts
  local parts = {}
  for i = 1, select("#", ...) do
    local arg = select(i, ...)
    if type(arg) == "table" then
      table.insert(parts, vim.inspect(arg))
    else
      table.insert(parts, tostring(arg))
    end
  end

  local message = table.concat(parts, " ")
  local formatted = string.format("[%s] [%s] %s", timestamp, level_name, message)

  -- Write to file
  rotate_log()
  local file = io.open(config.log_file, "a")
  if file then
    file:write(formatted .. "\n")
    file:close()
  end

  -- Optionally echo to messages
  if config.echo_messages then
    -- Use vim.api.nvim_echo to ensure it goes to :messages
    -- This bypasses any vim.notify overrides
    vim.api.nvim_echo({{formatted, "Normal"}}, false, {})
  end
end

-- Public API
function M.trace(...)
  log_message(M.levels.TRACE, ...)
end

function M.debug(...)
  log_message(M.levels.DEBUG, ...)
end

function M.info(...)
  log_message(M.levels.INFO, ...)
end

function M.warn(...)
  log_message(M.levels.WARN, ...)
end

function M.error(...)
  log_message(M.levels.ERROR, ...)
end

-- Configuration
function M.set_level(level)
  if type(level) == "string" then
    config.log_level = M.levels[level:upper()] or M.levels.INFO
  else
    config.log_level = level
  end
end

function M.set_file(filepath)
  config.log_file = filepath
end

function M.set_echo(enabled)
  config.echo_messages = enabled
end

function M.get_config()
  return vim.deepcopy(config)
end

-- Clear log file
function M.clear()
  local file = io.open(config.log_file, "w")
  if file then
    file:close()
  end
end

-- Get log file path
function M.get_log_path()
  return config.log_file
end

-- Open log file in new buffer
function M.open_log()
  vim.cmd("tabnew " .. config.log_file)
end

return M
