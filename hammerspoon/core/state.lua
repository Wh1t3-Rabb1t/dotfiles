local M = {}

M.menu = {
    tap_active = false,  -- (true|false)
    curr_win   = false,  -- (win|false)
    corner     = 'bottom_right',
    stack      = 'horizontal',
    opacity    = 1,
}

M.action_queue = {
    items   = {},
    running = false,
}

M.wins = {
    -- win = id,
    -- ...
}

-- Data for each screen is populated on init
M.screens = {
    -- [id] = {
    --     divider = .50,  (0.20 .. 0.80)
    --     layout = {
    --         maximized = (win|false),
    --         left      = (win|false),
    --         right     = (win|false),
    --     },
    --     brightness = (1..100),
    --     wins = { ... },
    -- }
}

return M
