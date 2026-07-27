local M = {}

M.menu = {
    tap_active = false,      -- (true|false)
    active_win = false,      -- (win|false)
    corner = 'bottom_right',
    stack = 'vertical',
    ignore_until = 0,
    opacity = 1,
}

M.key_queue = {
    items = {},
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
