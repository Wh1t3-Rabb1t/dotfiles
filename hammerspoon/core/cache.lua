local M = {}

M.assets = {}
M.lookup = {}

M.supported_apps = {
    ['Brave Browser'] = true,
    ['kitty'] = true,
    -- ...
}

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
