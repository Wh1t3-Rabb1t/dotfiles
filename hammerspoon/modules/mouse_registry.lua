local M = {}

local mouse = require('mouse')
local jg    = require('jump_grids')

M.mouse_bindings = {}

-- Mouse event bindings.
--------------------------------------------------------------------------------
M.mouse_bindings.cursor = {
    {
        category = 'Scroll',
        bindings = {
            { 'up',   'Up',   mouse.scroll('up')   },
            { 'down', 'Down', mouse.scroll('down') },
        },
    },
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
        category = 'Misc',
        bindings = {
            { 'escape', 'Cancel', mouse.quit() }
        },
    },
}


-- Add shift modifier to a binding declaration.
--------------------------------------------------------------------------------
local function add_shift(mods)
    local result = {}

    if mods then
        for i, mod in ipairs(mods) do
            result[i] = mod
        end
    end

    table.insert(result, 'shift')

    return result
end


-- Construct binding entry.
--------------------------------------------------------------------------------
local shift_chars = {
    ['~'] = '`',
    ['!'] = '1',
    ['@'] = '2',
    ['#'] = '3',
    ['$'] = '4',
    ['%'] = '5',
    ['^'] = '6',
    ['&'] = '7',
    ['*'] = '8',
    ['('] = '9',
    [')'] = '0',
    ['_'] = '-',
    ['+'] = '=',
    ['{'] = '[',
    ['}'] = ']',
    [':'] = ';',
    ['"'] = "'",
    ['<'] = ',',
    ['>'] = '.',
    ['?'] = '/',
    ['|'] = '\\',
}

local function bind( ... )
    local binding_field = {}

    for _, args in ipairs({ ... }) do
        local key
        local mods
        local desc
        local action_start

        -- If a modifier was passed along with the key
        if type(args[1]) == 'table' then
            mods         = args[1]
            key          = args[2]
            desc         = args[3]
            action_start = 4
        else
            key          = args[1]
            desc         = args[2]
            action_start = 3
        end

        -- Uppercase letters and shifted punctuation implicitly mean shift
        if #key == 1 then
            if key:match('%u') then
                key  = key:lower()
                mods = add_shift(mods)
            elseif shift_chars[key] then
                key  = shift_chars[key]
                mods = add_shift(mods)
            end
        end

        local action_count = #args - action_start + 1

        local binding = {
            key  = key,
            desc = desc,
        }

        if mods then
            binding.mods = mods
        end

        -- If one action is passed, store it as a function
        if action_count == 1 then
            binding.action = args[action_start]

        -- If multiple actions are passed, store them as a table of functions
        elseif action_count > 1 then
            binding.action = {}

            for i = action_start, #args do
                table.insert(binding.action, args[i])
            end
        end

        table.insert(binding_field, binding)
    end

    return binding_field
end


-- Pass each binding table in apps.* to the bind() fn for processing.
--------------------------------------------------------------------------------
for _, categories in pairs(M.mouse_bindings) do
    for _, category in ipairs(categories) do
        category.bindings = bind(table.unpack(category.bindings))
    end
end

return M
