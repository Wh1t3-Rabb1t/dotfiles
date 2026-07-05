local M = {}

M.overlays = {}
M.brightness = {}

M.menu = {
    menu_active = false,
    ignore_until = 0,
}

M.assets = {}
M.lookup = {}

M.layout = {
    supported_apps = {
        ['Brave Browser'] = true,
        ['kitty'] = true,
    },
    screens = {},  -- Packed on init
}

return M


-- STRUCTURE:
--------------
-- screens = {
--     [uuid] = {
--         divider = .50,
--         layout = {
--             fullscreen = (win|false),
--             left       = (win|false),
--             right      = (win|false),
--         },
--         frame = {
--             w = frame.w,
--             h = frame.h,
--             x = frame.x,
--             y = frame.y,
--         }
--     }
-- }
