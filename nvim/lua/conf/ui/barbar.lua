--   _                _
--  | |__   __ _ _ __| |__   __ _ _ __
--  | '_ \ / _` | '__| '_ \ / _` | '__|
--  | |_) | (_| | |  | |_) | (_| | |
--  |_.__/ \__,_|_|  |_.__/ \__,_|_|
-- =============================================================================

local M = {}

-- CONFIG
--------------------------------------------------------------------------------
function M.config()
    local status_ok = pcall(require, "barbar")
    if not status_ok then return end

    -- Setup
    local icons = require("util.icons").barbar
    require("barbar").setup({
        animation = false,                     -- Enable/disable animations
        tabpages = true,                       -- Toggle tabpages indicator (top right corner)
        clickable = false,                     -- Left-click: go to buffer, Middle-click: delete buffer
        exclude_ft = {                         -- Exclude buffers by filetype
            "checkhealth",
            "qf",
        },
        exclude_name = {},                     -- Exclude buffers by name
        focus_on_close = "right",              -- Previous, left, right
        highlight_alternate = false,           -- Highlighting unfocused buffers
        highlight_inactive_file_icons = true,  -- Highlighting unfocused buffer icons
        highlight_visible = true,              -- Highlighting active buffers
        icons = {
            buffer_index = false,
            buffer_number = false,
            button = "",
            separator = {
                left = "",
                right = icons.separator
            },

            -- -- Configure the icons on the bufferline when modified or pinned.
            -- -- Supports all the base icon options.
            modified = { button = icons.modified },
            pinned = {
                buffer_index = true,
                filename = true,
            },

            -- Configure the icons on the bufferline based on the visibility of a buffer.
            -- Supports all the base icon options, plus `modified` and `pinned`.
            inactive = {
                separator = {
                    left = "",
                    right = "│",  -- 'required' icon doesn't load on UiEnter event
                }
            }
        },
        maximum_padding = 1,  -- Max padding around each tab
        minimum_padding = 1,  -- Min padding around each tab
        maximum_length = 30,  -- Max buffer name length
        minimum_length = 0,   -- Min buffer name length
    })
end

return M
