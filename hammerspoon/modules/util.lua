local M = {}


--------------------------------------------------------------------------------
-- Format rgb table
--------------------------------------------------------------------------------
function M.rgb(r, g, b, opacity)
    opacity = opacity or 1.0

    local color_table = {
        red   = r / 255,
        green = g / 255,
        blue  = b / 255,
        alpha = opacity,
    }

    return color_table
end


--------------------------------------------------------------------------------
-- Normalize bindings with modifiers
--------------------------------------------------------------------------------
function M.binding_id(key, mods)
    if not mods or #mods == 0 then
        return key
    end

    table.sort(mods)

    return table.concat(mods, '+') .. '+' .. key
end


--------------------------------------------------------------------------------
-- Construct binding entry for temporary insert mode
--------------------------------------------------------------------------------
function M.insert_bind( ... )
    local binding_field = {}

    for _, args in ipairs({ ... }) do
        table.insert(binding_field, {
            key  = args[1],
            desc = args[2],
        })
    end

    return binding_field
end


--------------------------------------------------------------------------------
-- Construct binding entry
--------------------------------------------------------------------------------
function M.bind( ... )
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


--------------------------------------------------------------------------------
-- Check if tables have been initialized
--------------------------------------------------------------------------------
function M.tbl(obj)
    local done = false

    if type(obj) == 'table' and next(obj) ~= nil then
        done = true
    end

    return done
end


--------------------------------------------------------------------------------
-- Benchmark function(s) execution time
--
-- Usage:
--   benchmark('somename', function()
--       screens.init()
--       windows.init()
--       ...
--   end)
--------------------------------------------------------------------------------
function M.benchmark(name, fn)
    local start = hs.timer.absoluteTime()

    fn()

    local elapsed = hs.timer.absoluteTime() - start
    local ms      = elapsed / 1e9

    print(string.format("%s: %.3f ms", name, ms))
end

return M
