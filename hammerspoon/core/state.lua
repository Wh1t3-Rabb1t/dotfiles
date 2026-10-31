local M = {}

-- Commented out entries are populated on init

-- M.mouse = {
--     is_pressed = false
-- }

M.wk = {
    initialized = false,
    tap_active  = false,
    corner      = 'bottom_right',
    stack       = 'horizontal',
    opacity     = 1,
}

M.action_queue = {
    running = false,
    items   = {},
}

M.apps = {
    -- list = { ... },
    -- [application:name()] = {
    --     idx  = 1,
    --     wins = { ... },
    -- },
    -- ...
}

M.windows = {
    -- idx      = 1,
    -- border   = obj,
    -- curr_win = win,
    -- wins     = { ... },
}

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

M.watchers = {
    initialized = false,
    screen      = {},
}

return M
