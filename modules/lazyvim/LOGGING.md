# Neovim Logging System

Comprehensive logging solution based on Neovim dev_tools and logger.nvim best practices.

## Log Files

All logs are stored in `~/.local/state/nvim/`:

| File | Purpose | Contents |
|------|---------|----------|
| **lsp.log** | LSP communication | All language server protocol messages (level: info) |
| **debug.log** | Application logging | Diagnostics, notifications, custom logs |
| **log** | Neovim internals | Low-level Neovim logs (via $NVIM_LOG_FILE) |

## Using the Logger

The logger is globally available as `logger` in Lua:

```lua
-- In Neovim command mode
:lua logger.info("This is an info message")
:lua logger.warn("This is a warning")
:lua logger.error("This is an error")
:lua logger.debug("This is a debug message")  -- Only shown if level is "debug"

-- Log tables
:lua logger.info("Config:", { foo = "bar", baz = 123 })

-- In Lua files or init.lua
logger.info("Plugin loaded successfully")
logger.warn("Missing optional dependency")
logger.error("Failed to load configuration")
```

## Log Levels

Set the log level to control verbosity:

```lua
-- In Neovim
:lua logger.set_level("debug")   -- Show everything
:lua logger.set_level("info")    -- Show info, warn, error (default)
:lua logger.set_level("warn")    -- Show only warn and error
:lua logger.set_level("error")   -- Show only errors
```

## Viewing Logs

### Real-time Monitoring

```bash
# Watch debug log
tail -f ~/.local/state/nvim/debug.log

# Watch LSP log
tail -f ~/.local/state/nvim/lsp.log

# Watch all logs
tail -f ~/.local/state/nvim/*.log
```

### From Within Neovim

```vim
" Open debug log in new tab
:lua logger.open_log()

" View messages (includes logged messages due to echo_messages=true)
:messages

" Clear message history
:messages clear
```

## Log Management

```lua
-- Clear debug log
:lua logger.clear()

-- Get log file path
:lua print(logger.get_log_path())

-- Get current configuration
:lua print(vim.inspect(logger.get_config()))
```

## Automatic Logging

The following are logged automatically:

1. **Diagnostics** - ERROR and WARN level diagnostics from LSP servers
2. **Notifications** - All `vim.notify()` calls (errors, warnings, info)
3. **Startup** - "Neovim starting up" message on launch

## Log Rotation

Debug logs automatically rotate when they exceed 1MB:
- `debug.log` - Current log
- `debug.log.1` - Previous log
- `debug.log.2` - Older log
- `debug.log.3` - Oldest log (then deleted)

## Configuration

Edit `~/.config/nvim/init.lua` to change logging behavior:

```lua
-- Change log level
logger.set_level("debug")  -- More verbose

-- Change log file location
logger.set_file("/tmp/nvim-debug.log")

-- Disable echoing to :messages
logger.set_echo(false)
```

## LSP Logging

LSP logging is separate and configured via:

```lua
vim.lsp.set_log_level("trace")  -- Very verbose
vim.lsp.set_log_level("debug")  -- Verbose
vim.lsp.set_log_level("info")   -- Default
vim.lsp.set_log_level("warn")   -- Minimal
vim.lsp.set_log_level("error")  -- Only errors
```

## Troubleshooting

### Logs not appearing

1. Check log file exists:
   ```bash
   ls -lh ~/.local/state/nvim/debug.log
   ```

2. Verify logger is loaded:
   ```vim
   :lua print(logger)
   ```

3. Test logging manually:
   ```vim
   :lua logger.info("Test message")
   :messages
   ```

### Too much logging

Reduce log level:
```vim
:lua logger.set_level("warn")
```

### Performance issues

Disable echo to :messages:
```vim
:lua logger.set_echo(false)
```

## Advanced: Low-Level Neovim Logging

For debugging Neovim itself (not plugins):

```bash
# Set environment variable before starting nvim
export NVIM_LOG_FILE=~/.local/state/nvim/nvim-debug.log
nvim

# Or use verbose mode
nvim -V3
```

## Examples

### Debugging Plugin Issues

```lua
-- At the start of your plugin
logger.info("MyPlugin: Initializing")

-- During operation
logger.debug("MyPlugin: Processing file", vim.fn.expand("%"))

-- On errors
logger.error("MyPlugin: Failed to load config", {
  error = err.message,
  file = config_file
})
```

### Debugging LSP Issues

```bash
# Enable verbose LSP logging
:lua vim.lsp.set_log_level("debug")

# Restart LSP server
:LspRestart

# Watch LSP log
# In another terminal:
tail -f ~/.local/state/nvim/lsp.log
```

### Debugging Diagnostics

Diagnostics (errors/warnings from LSP) are automatically logged to `debug.log` when they occur.

```vim
" Force diagnostic update
:lua vim.diagnostic.show()

" Check debug log
:lua logger.open_log()
```
