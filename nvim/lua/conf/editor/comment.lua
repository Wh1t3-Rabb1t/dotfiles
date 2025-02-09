--                                            _
--    ___ ___  _ __ ___  _ __ ___   ___ _ __ | |_
--   / __/ _ \| '_ ` _ \| '_ ` _ \ / _ \ '_ \| __|
--  | (_| (_) | | | | | | | | | | |  __/ | | | |_
--   \___\___/|_| |_| |_|_| |_| |_|\___|_| |_|\__|
-- =============================================================================

local M = {}

-- KEYS
--------------------------------------------------------------------------------
M.keys = {
    {
        mode = { "n", "v" },
        "<A-/>",
        desc = " Comment"
    }
}


-- OPTS
--------------------------------------------------------------------------------
M.opts = {
    padding = true,  -- Add a space b/w comment and the line
    sticky = true,   -- Whether the cursor should stay at its position
    ignore = "^$",   -- Ignore empty lines

    -- Normal mode
    toggler = {
        line = "<A-/>",
        block = "<A-?>",
    },

    -- Visual & op pending mode
    opleader = {
        line = "<A-/>",
        block = "<A-?>",
    },

    -- LHS of extra mappings
    extra = {
        -- above = 'gcO',  -- Add comment on the line above
        -- below = 'gco',  -- Add comment on the line below
        -- eol = 'gcA',    -- Add comment at the end of line
    },

    -- Enable keybindings
    -- !! If given "false" then the plugin won't create any mappings
    mappings = {
        basic = true,   -- Toggler & op pending
        extra = false,  -- Extra
    },

    pre_hook = nil,   -- Function to call before (un)comment
    post_hook = nil,  -- Function to call after (un)comment
}

return M
