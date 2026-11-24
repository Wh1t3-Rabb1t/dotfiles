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
    textSize    = 30,
    minTextSize = 12,
    textBoxSize = 60,
    textOffsetY = 8,
    font        = 'Courier',
    ringRadius  = 24,
    ringStroke  = 2,
    ringColor   = { red = 1, green = 0, blue = 0, alpha = 1 },
    lineStroke  = 2,
    lineColor   = { white = 1, alpha = 0.5 },

    ringVisible = true,
    lineVisible = false,

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
