--                               _
--    __ _ _ __ __ _ _ __  _ __ | | ___
--   / _` | '__/ _` | '_ \| '_ \| |/ _ \
--  | (_| | | | (_| | |_) | |_) | |  __/
--   \__, |_|  \__,_| .__/| .__/|_|\___|
-- ==|___/==========|_|===|_|===================================================

local M = {}

-- CONFIG
--------------------------------------------------------------------------------
function M.config()
    local status_ok = pcall(require, "grapple")
    if not status_ok then return end

    -- Setup
    local util = require("util.utils")
    require("grapple").setup({
        scope = "git",               -- Default scope to use when managing Grapple tags
        scopes = {},                 -- User-defined scopes or overrides
        default_scopes = {},         -- Default scopes provided by Grapple
        icons = true,                -- Show icons (requires "nvim-tree/nvim-web-devicons")
        status = true,               -- Highlight the current selection
        name_pos = "end",            -- Tag name position in Grapple windows (start or end)
        style = "relative",          -- Path rendering (basename or relative)
        quick_select = "123456789",  -- Quick select chars
        command = vim.cmd.edit,      -- Default command to use when selecting a tag

        -- Simplify statusline string for user sync util function
        statusline = {
            active = "%s",
            inactive = "%s"
        },

        -- Time limit used for pruning unused scope (IDs).
        -- Can be an integer (in seconds) or a string time limit
        -- (e.g. "30d" or "2h" or "15m")
        prune = "30d",
        tag_title = nil,     -- Tags title function for windows
        scope_title = nil,   -- Scopes title function for windows
        loaded_title = nil,  -- Loaded scopes title function for windows

        -- Additional window options (See :h nvim_open_win)
        win_opts = {
            -- Can be fractional
            width = 70,
            height = 20,
            row = 5,
            col = 0.5,
            relative = "editor",
            border = "rounded",
            focusable = false,
            style = "minimal",
            title = "Grapple",      -- Fallback title for Grapple windows
            title_pos = "center",
            title_padding = " ",    -- Custom: adds padding around window title
            footer_pos = "center",  -- footer = "", (disable footer)
        }
    })

    -- Sync barbar tabs with grapple indexes grapple ui exit
    vim.api.nvim_create_augroup("GrappleGroup", { clear = true })
    vim.api.nvim_create_autocmd("WinLeave", {
        group = "GrappleGroup",
        callback = function()
            if vim.bo.filetype == "grapple" then
                util.sync_grapple_and_barbar_indexes()
            end
        end,
        desc = "Sync barbar and grapple indexes",
    })
end

return M
