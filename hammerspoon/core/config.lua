local M = {}

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

return M
