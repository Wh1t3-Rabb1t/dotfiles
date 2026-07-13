local M = {}

M.supported_apps = {
    ['Brave Browser'] = true,
    ['kitty'] = true,
    -- ...
}

M.assets = {}
M.lookup = {}

-- Data for each screen is populated on init
M.screens = {
    -- [id] = {
    --     frame = {
    --         w = frame.w,
    --         h = frame.h,
    --         x = frame.x,
    --         y = frame.y,
    --     },
    --     overlay = (canvas),
    -- }
}

return M
