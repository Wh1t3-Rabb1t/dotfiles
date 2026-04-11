--   _                _
--  | |__   __ _ _ __| |__   __ _ _ __
--  | '_ \ / _` | '__| '_ \ / _` | '__|
--  | |_) | (_| | |  | |_) | (_| | |
--  |_.__/ \__,_|_|  |_.__/ \__,_|_|
-- =============================================================================

local M = {}

-- EVENT
--------------------------------------------------------------------------------
function M.event()
    -- Restore tab order via session file if present
    if vim.tbl_contains(vim.v.argv, "-S") then
        return "SessionLoadPost"
    else
        return "VeryLazy"
    end
end

-- KEYS
--------------------------------------------------------------------------------
M.keys = {
    -- Navigate tabs
    {
        "<C-PageDown>",
        -- Prevent bug when tab switching with a single help page open
        function()
            if vim.bo.filetype ~= "help" then vim.cmd("BufferNext") end
        end,
        mode = { "n" },
        desc = " Next tab",
    },
    {
        "<C-PageUp>",
        function()
            if vim.bo.filetype ~= "help" then vim.cmd("BufferPrevious") end
        end,
        mode = { "n" },
        desc = " Previous tab",
    },

    -- Reorder tabs
    {
        "<C-S-PageDown>",
        function() vim.cmd("BufferMoveNext") end,
        mode = { "n" },
        desc = " Swap tab with next",
    },
    {
        "<C-S-PageUp>",
        function() vim.cmd("BufferMovePrevious") end,
        mode = { "n" },
        desc = " Swap tab with previous",
    },

    -- Close tabs
    {
        "<A-w>",
        function()
            if vim.bo.filetype == "qf" then
                vim.cmd("bo cclose")
                return
            end
            vim.cmd("BufferClose")
        end,
        mode = { "n" },
        desc = " Close tab",
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
        clickable = false,                     -- Left-click: go to buffer, Middle-click: delete buffer
        exclude_ft = { "checkhealth", "qf" },  -- Exclude buffers by filetype
        focus_on_close = "right",              -- Previous, left, right
        highlight_inactive_file_icons = true,  -- Highlighting unfocused buffer icons
        icons = {
            button = "",
            separator = {
                left = "",
                right = "│",
            },

            -- Configure the icons on the bufferline when modified or pinned.
            -- Supports all the base icon options.
            modified = { button = "●" },

            -- Configure the icons on the bufferline based on the visibility of a buffer.
            -- Supports all the base icon options, plus `modified` and `pinned`.
            inactive = {
                separator = {
                    left = "",
                    right = "│",
                }
            }
        },
        maximum_padding = 1,  -- Sets the maximum padding width for each tab
        minimum_padding = 1,  -- Sets the minimum padding width for each tab
        maximum_length = 30,  -- Sets the maximum buffer name length
        minimum_length = 0,   -- Sets the minimum buffer name length
    })
end

return M
