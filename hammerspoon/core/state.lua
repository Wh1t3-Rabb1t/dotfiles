local M = {}

-- Commented out entries are populated on init

M.initialized = false

-- Move to wk_assets.lua
M.action_queue = {
    running = false,
    items   = {},
}

-- Move to wk.lua
M.windows = {
    -- idx      = 1,
    -- border   = obj,
    -- curr_win = win,
    -- wins     = { ... },
}

M.wk = {
    tap_active  = false,
    corner      = 'bottom_right',
    stack       = 'horizontal',
    opacity     = 1,
}

-- Move to screen.lua
M.watchers = {
    initialized = false,
    screen      = {},
}


-- Needs to be retained in central state:

M.screens = {
    -- [screen:id()] = {
    --     frame      = {},
    --     overlay    = {},
    --     brightness = (1..100),
    --     divider    = .50,  (0.20 .. 0.80)
    --     layout = {
    --         maximized = (win|false),
    --         left      = (win|false),
    --         right     = (win|false),
    --     }
    -- },
    -- ...
}

M.apps = {
    -- list = { ... },
    -- [application:name()] = {
    --     idx  = 1,
    --     wins = { ... },
    -- },
    -- ...
}

return M
