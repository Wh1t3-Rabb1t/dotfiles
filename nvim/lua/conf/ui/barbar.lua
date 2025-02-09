--   _                _
--  | |__   __ _ _ __| |__   __ _ _ __
--  | '_ \ / _` | '__| '_ \ / _` | '__|
--  | |_) | (_| | |  | |_) | (_| | |
--  |_.__/ \__,_|_|  |_.__/ \__,_|_|
-- =============================================================================

local M = {}

-- ICONS
--------------------------------------------------------------------------------
local icons = {
    separator = "│",
    modified = "●",
    pinned = "",
}


-- KEYS
--------------------------------------------------------------------------------
local util = require("util.utils")
M.keys = {
    -- Navigate tabs
    {
        mode = { "n" },
        "<C-PageDown>",
        function()
            -- Prevent bug when tab switching with a single help page open
            if vim.bo.filetype ~= "help" then
                vim.cmd("BufferNext")
            end
        end,
        desc = " Next tab"
    },
    {
        mode = { "n" },
        "<C-PageUp>",
        function()
            if vim.bo.filetype ~= "help" then
                vim.cmd("BufferPrevious")
            end
        end,
        desc = " Previous tab"
    },

    -- Reorder tabs
    {
        mode = { "n" },
        "<C-S-PageDown>",
        function()
            -- Prevent reordering of pinned tabs
            if type(require("grapple").name_or_index()) ~= "number" then
                vim.cmd("BufferMoveNext")
            end
        end,
        desc = " Swap tab with next"
    },
    {
        mode = { "n" },
        "<C-S-PageUp>",
        function()
            -- Prevent reordering of pinned tabs
            if type(require("grapple").name_or_index()) ~= "number" then
                vim.cmd("BufferMovePrevious")
            end
        end,
        desc = " Swap tab with previous"
    },

    -- Close tabs
    {
        mode = { "n" },
        "<A-w>",
        function()
            if vim.bo.filetype == "qf" then
                vim.cmd("bo cclose")
                return
            end

            if type(require("grapple").name_or_index()) == "number" then
                vim.cmd("Grapple toggle")
                vim.cmd("BufferClose")
                util.sync_grapple_and_barbar_indexes()
            else
                vim.cmd("BufferClose")
            end
        end,
        desc = " Close tab"
    }
}


-- CONFIG
--------------------------------------------------------------------------------
function M.config()
    local status_ok = pcall(require, "barbar")
    if not status_ok then return end

    -- Save barbar tab order in session file
    vim.api.nvim_create_user_command(
        "Mksession",
        function(attr)
            vim.api.nvim_exec_autocmds("User", { pattern = "SessionSavePre" })
            vim.cmd.mksession { bang = attr.bang, args = attr.fargs }
        end,
        {
            bang = true,
            complete = "file",
            desc = "Save barbar with :mksession",
            nargs = "?"
        }
    )

    -- Setup
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
                    right = icons.separator,
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
