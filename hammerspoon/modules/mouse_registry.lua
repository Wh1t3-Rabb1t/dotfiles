local M = {}

local mouse = require('mouse')
local jg    = require('jump_grids')
local util  = require('util')

M.mouse_control = {}

-- Mouse event bindings.
--------------------------------------------------------------------------------
M.mouse_control.cursor = {
    {
        category = 'Move',
        bindings = {
            { 'i', 'Up',    mouse.move('up')    },
            { 'k', 'Down',  mouse.move('down')  },
            { 't', 'Left',  mouse.move('left')  },
            { 'l', 'Right', mouse.move('right') },
        },
    },
    {
        category = 'Scroll',
        bindings = {
            { 'up',   'Up',   mouse.scroll('up')   },
            { 'down', 'Down', mouse.scroll('down') },
        },
    },
    {
        category = 'Misc',
        bindings = {
            { 'escape', 'Cancel', mouse.quit() }
        },
    },
}

-- Pass each binding table in apps.* to the bind() fn for processing.
--------------------------------------------------------------------------------
for _, categories in pairs(M.mouse_control) do
    for _, category in ipairs(categories) do
        category.bindings = util.bind(table.unpack(category.bindings))
    end
end

return M
