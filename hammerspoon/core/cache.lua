local M = {}

M.watchers = {}

M.lookup = {
    -- [app_name] = {
    --
    -- }
}

M.assets = {
    -- [app_name] = {
    --     popup = popup,
    --     frame = frame,
    -- }
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
