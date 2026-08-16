local M = {}

-- Commented out entries are populated on init

M.menu = {
    tap_active = false,  -- (true|false)
    corner     = 'bottom_right',
    stack      = 'horizontal',
    opacity    = 1,
}

M.action_queue = {
    items   = {},
    running = false,
}

M.apps = {
    -- ['all'] = {
    --     idx      = 1,
    --     curr_win = win,
    --     wins     = { ... },
    --     borders  = { ... },
    -- },
    -- ['Brave Browser'] = {
    --     idx     = 1,
    --     wins    = { ... },
    -- },
    -- ['kitty'] = {
    --     idx     = 1,
    --     wins    = { ... },
    -- },
    -- ...
}

M.screens = {
    -- [id] = {
    --     brightness = (1..100),
    --     divider    = .50,  (0.20 .. 0.80)
    --     layout = {
    --         maximized = (win|false),
    --         left      = (win|false),
    --         right     = (win|false),
    --     }
    -- }
    -- ...
}

return M
