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

    -- STRUCTURE:
    --------------
    -- screens = {
    --     [uuid] = {
    --         divider = .50,  (0.15 .. 0.85)
    --         fullscreen_active = (true|false),
    --         layout = {
    --             maximized = (win|false),
    --             left      = (win|false),
    --             right     = (win|false),
    --         },
    --         frame = {
    --             w = frame.w,
    --             h = frame.h,
    --             x = frame.x,
    --             y = frame.y,
    --         }
    --     }
    -- }

}

return M


