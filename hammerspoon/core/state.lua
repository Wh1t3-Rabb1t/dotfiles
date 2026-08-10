local M = {}

M.menu = {
    tap_active  = false,  -- (true|false)
    curr_win    = false,  -- (win|false)
    corner      = 'bottom_right',
    stack       = 'horizontal',
    opacity     = 1,
    win_idx = 1,
    -- app_win_idx = 1,  -- need one for each app
}

M.action_queue = {
    items   = {},
    running = false,
}

M.app_wins = {
    -- ['Brave Browser'] = { ... },
    -- ['kitty'] = { ... },
    -- ...
}

M.wins = {
    -- win = id,
    -- ...
}

M.win_idx = {
    -- main = 1,
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
