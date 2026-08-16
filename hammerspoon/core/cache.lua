local M = {}

-- Commented out entries are populated on init

M.watchers = {}

M.lookup = {
    -- [app_name] = {
    --     key = action,
    -- }
    -- ...
}

M.assets = {
    -- [app_name] = {
    --     popup = popup,
    --     frame = frame,
    -- }
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
    -- ...
}

return M
