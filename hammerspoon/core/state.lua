local M = {}

M.system = {
    wifi = true
}

M.menu = {
    tap_active = false,  -- (true|false)
    curr_win   = false,  -- (win|false)
    new_win    = false,  -- (win|false)
    corner     = 'bottom_right',
    stack      = 'vertical',
    opacity    = 1,
}

M.action_queue = {
    items   = {},
    running = false,
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
    -- }
}

return M
