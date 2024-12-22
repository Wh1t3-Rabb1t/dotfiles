--    __ _     _            _
--   / _(_) __| | __ _  ___| |_
--  | |_| |/ _` |/ _` |/ _ \ __|
--  |  _| | (_| | (_| |  __/ |_
--  |_| |_|\__,_|\__, |\___|\__|
-- ==============|___/==========================================================

local M = {}

-- ICONS
--------------------------------------------------------------------------------
local icons = {
    done_icon = "✔",
    group_separator = "---",
    icon_separator = " ",
    moon = { "🌑", "🌘", "🌗", "🌖", "🌕", "🌔", "🌓", "🌒" },
}


-- CONFIG
--------------------------------------------------------------------------------
function M.config()
    local status_ok = pcall(require, "fidget")
    if not status_ok then return end

    -- Setup
    require("fidget").setup({

        -- Options related to LSP progress subsystem
        ------------------------------------------------------------------------
        progress = {
            poll_rate = 0,                 -- How and when to poll for progress messages
            suppress_on_insert = false,    -- Suppress new messages while in insert
            ignore_done_already = false,   -- Ignore tasks that are already complete
            ignore_empty_message = false,  -- Ignore tasks that don't contain a message
            clear_on_detach =              -- Clear notification group when LSP server detaches
            function(client_id)
                local client = vim.lsp.get_client_by_id(client_id)
                return client and client.name or nil
            end,
            notification_group =  -- How to get progress message's notification group key
            function(msg)
                return msg.lsp_client.name
            end,
            ignore = {},  -- List of LSP servers to ignore

            -- How LSP progress messages are displayed as notifications
            display = {
                render_limit = 16,               -- How many LSP messages to show at once
                done_ttl = 5,                    -- How long a message persists after completion
                done_icon = icons.done_icon,     -- Show if all LSP progress tasks are complete
                done_style = "Constant",         -- Hl group for completed LSP tasks
                progress_ttl = math.huge,        -- How long message's persist when in progress
                progress_icon =                  -- Icon shown when LSP progress tasks are in progress
                {
                    pattern = icons.moon,
                    period = 1
                },

                progress_style =  "WarningMsg",  -- Hl group for in-progress LSP tasks
                group_style = "Title",           -- Hl group for group name (LSP server name)
                icon_style = "Question",         -- Hl group for group icons
                priority = 30,                   -- Ordering priority for LSP notification group
                skip_history = true,             -- Omit progress notifications from history

                -- How to format a progress message
                format_message = require("fidget.progress.display").default_format_message,

                -- How to format a progress annotation
                format_annote = function(msg) return msg.title end,

                -- How to format progress notification group's name
                format_group_name = function(group) return tostring(group) end,

                -- Override options from default notification config
                overrides = {
                    rust_analyzer = { name = "rust-analyzer" }
                }
            },

            -- Options related to Neovim's built-in LSP client
            lsp = {
                progress_ringbuf_size = 0,  -- Configure nvim's LSP progress ring buffer size
                log_handler = false         -- Log `$/progress` handler invocations (for debugging)
            }
        },

        -- Options related to notification subsystem
        ------------------------------------------------------------------------
        notification = {
            poll_rate = 10,                -- How frequently to update notifications
            filter = vim.log.levels.INFO,  -- Minimum notifications level
            history_size = 128,            -- Number of removed messages to retain in history
            override_vim_notify = true,    -- Override vim.notify() with Fidget
            configs =                      -- How to configure notification groups when instantiated
            {
                default = require("fidget.notification").default_config
            },
            redirect =  -- Conditionally redirect notifications to another backend
            function(msg, level, opts)
                if opts and opts.on_open then
                    return require("fidget.integration.nvim-notify").delegate(msg, level, opts)
                end
            end,

            -- Options related to how notifications are rendered as text
            view = {
                stack_upwards = true,                       -- Display notifications bottom to top
                icon_separator = icons.icon_separator,      -- Separator between group name and icon
                group_separator = icons.group_separator,    -- Separator between notification groups
                group_separator_hl = "DiagnosticSignWarn",  -- Hl group used for group separator
                render_message =                            -- How to render notification messages
                function(msg, cnt)
                    return cnt == 1 and msg or string.format("(%dx) %s", cnt, msg)
                end
            },

            -- Options related to the notification window and buffer
            window = {
                normal_hl = "CmpItemAbbr",  -- Base hl group
                winblend = 0,               -- Bg color opacity
                border = "rounded",         -- "none"|"single"|"double"|"rounded"|"solid"|"shadow"
                zindex = 45,                -- Stacking priority
                max_width = 0,              -- Maximum width
                max_height = 0,             -- Maximum height
                x_padding = 1,              -- Padding from right edge of window boundary
                y_padding = 0,              -- Padding from bottom edge of window boundary
                align = "bottom",           -- How to align the window
                relative = "editor"         -- What the window position is relative to
            }
        },

        -- Options related to integrating with other plugins
        ------------------------------------------------------------------------
        integration = {
            ["nvim-tree"] = { enable = true },
            ["xcodebuild-nvim"] = { enable = true }
        },

        -- Options related to logging
        ------------------------------------------------------------------------
        logger = {
            level = vim.log.levels.WARN,  -- Minimum logging level
            max_size = 10000,             -- Maximum log file size, in KB
            float_precision = 0.01,       -- Limit number of decimals displayed for floats
            path =                        -- Where Fidget writes its logs to
            string.format("%s/fidget.nvim.log", vim.fn.stdpath("cache"))
        }
    })
end

return M
