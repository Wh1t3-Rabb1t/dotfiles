local M = {}

M.assets = {}
M.lookup = {}

M.supported_apps = {
    -- ['Brave Browser'] = 'brave_browser',
    -- ['kitty'] = 'kitty',
    -- ...
}

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
