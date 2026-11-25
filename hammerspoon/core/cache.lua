local M = {}

-- Commented out entries are populated on init

M.initialized       = false
M.mouse_initialized = false

M.wk_tap    = {}
M.mouse_tap = {}

M.mouse_lookup = {
    -- key = action,
    -- ...
}

M.mouse_assets = {
    -- popup = popup,
    -- frame = frame,
}

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

return M
