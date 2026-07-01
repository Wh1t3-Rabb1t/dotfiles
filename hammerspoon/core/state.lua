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

    -- 'screens' and 'windows' are packed on init

    screens = {
    -- [screen_uuid] = {
    --     fullscreen = false,  -- might remove in favour of divider
    --     divider = .50,
    --     left = {
    --         win = win,
    --     },
    --     right = {
    --         win = win,
    --     },
    --     dimensions = {
    --         w = ,
    --         h = ,
    --     },
    --     coords = {
    --         x = ,
    --         x = ,
    --     }
    -- }
    },

    windows = {
    -- [win] = {
    --     screen_uuid = ,  -- (hs.screen.mainScreen():id())
    --     position = ,     -- (left|right|fullscreen)
    --     dimensions = {
    --         w = ,
    --         h = ,
    --     },
    --     coords = {
    --         x = ,
    --         x = ,
    --     }
    -- }
    },

}

return M

