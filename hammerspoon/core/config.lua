local M = {}

M.mouse = {
    follow_window_focus = true,
}

M.disallowed_apps = {
    ['Hammerspoon'] = true,
}

M.alert_fmt = {
    strokeWidth     = 5,
    textFont        = 'Optima-BoldItalic',
    textSize        = 24,
    atScreenEdge    = 1,  -- (1) Align to the top
    fadeOutDuration = 1,
}

M.grid = {
    size     = 60,
    textSize = 30,
    font     = 'Courier',
    color    = { white = 1 },

    -- Grid jump invocation key bindings
    topLeft      = 'w',  -- Top left
    topCenter    = 'e',  -- Top center
    topRight     = 'r',  -- Top right
    centerLeft   = 's',  -- Center left
    center       = 'd',  -- Center
    centerRight  = 'f',  -- Center right
    bottomLeft   = 'x',  -- Bottom left
    bottomCenter = 'c',  -- Bottom center
    bottomRight  = 'v',  -- Bottom right
}

return M
