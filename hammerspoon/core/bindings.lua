local M = {}

local shader = require('shaders')

-- OS bindings
M.system = {
    -- MonitorControl was buggy spyware anyway
    u = {
        desc = 'Brightness Up', idx = 1,
        action = function() shader.adjust_brightness('up') end,
    },
    d = {
        desc = 'Brightness Down', idx = 2,
        action = function() shader.adjust_brightness('down') end,
    },
    p = {
        desc = 'Print Brightness', idx = 3,
        action = function() shader.print_values() end,
    },
}

return M
