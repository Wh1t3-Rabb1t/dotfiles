local M = {
    apps = {}
}

local brightness = require('brightness')
local wk         = require('which_key')
local win        = require('windows')
local wifi       = require('wifi')

local current_app
local current_category

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


-- Add application group
--------------------------------------------------------------------------------
local function add_app(name)
    local app = {}

    M.apps[name] = app
    current_app  = app
end


-- Add app group sub categories
--------------------------------------------------------------------------------
local function add_category(name)
    local category = {
        category = name,
        bindings = {},
    }

    table.insert(current_app, category)
    current_category = category
end


-- Add shift to the mod table
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


-- Construct binding entry for temporary insert mode
--------------------------------------------------------------------------------
local function insert_bind(...)
    for _, args in ipairs({...}) do
        table.insert(current_category.bindings, {
            key  = args[1],
            desc = args[2],
        })
    end
end


-- Construct binding entry
--------------------------------------------------------------------------------
local function bind(...)
    for _, args in ipairs({...}) do
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

        table.insert(current_category.bindings, binding)
    end
end


-------------------------------------------------------------------------------+
add_app('insert')                                                           -- |
-------------------------------------------------------------------------------+

-- These are temporarily bound to actions after the eventtap has been stopped,
-- then unbound once the eventtap is restarted. Therefor they don't have
-- corresponding actions.

add_category('Bound until invoked')  ------------------------------------------+
insert_bind(
    { 'enter',  'Relaunch menu' },
    { 'escape', 'Cancel'        }
)


-------------------------------------------------------------------------------+
add_app('system')                                                           -- |
-------------------------------------------------------------------------------+

add_category('Launch or focus')  ----------------------------------------------+
bind(
    { 'y', 'Firefox', wk.hide(), win.launch_or_focus('Firefox'), win.snap(), wk.show() }
    -- { '', 'Brave Browser', wk.hide(), win.launch_or_focus('Brave Browser'), win.snap(), wk.show() },
    -- { '', 'kitty',         wk.hide(), win.launch_or_focus('kitty'), win.snap(), wk.show()         },
)

add_category('Windows')  ------------------------------------------------------+
bind(
    { '_', 'Cycle cat apps',      wk.hide(), win.cycle_main_apps(), wk.show()            },
    { 'n', 'Cycle next open',     wk.hide(), win.cycle_open('next'), wk.show()           },
    { 'N', 'Cycle prev open',     wk.hide(), win.cycle_open('prev'), wk.show()           },
    { 'o', 'Next app window',     wk.hide(), win.cycle_app_specific('next'), wk.show()   },
    { 'u', 'Prev app window',     wk.hide(), win.cycle_app_specific('prev'), wk.show()   },
    { 'f', 'Resize right',        wk.hide(), win.resize('right'), win.snap(), wk.show()  },
    { 's', 'Resize left',         wk.hide(), win.resize('left'), win.snap(), wk.show()   },
    { 'g', 'Maximize',            wk.hide(), win.maximize(), win.snap(), wk.show()       },
    { 'G', 'Swap positions',      wk.hide(), win.swap(), win.snap(), wk.show()           },
    { 'p', 'Move to next screen', wk.hide(), win.move_to_screen(), win.snap(), wk.show() }
)

add_category('Popups')  -------------------------------------------------------+
bind(
    { 'R', 'Cycle positions',     wk.hide(), wk.cycle_corner_pos(), wk.show() },
    { 'A', 'Cycle menu stacking', wk.hide(), wk.cycle_stacking(), wk.show()   },
    { 'O', 'Opacity up',          wk.opacity('up')                            },
    { 'U', 'Opacity down',        wk.opacity('down')                          }
)

add_category('Clipboard')  ----------------------------------------------------+
bind(
    { 'c', 'Copy',   wk.send_keys({'cmd'}, 'c') },
    { 'x', 'Cut',    wk.send_keys({'cmd'}, 'x') },
    { 'v', 'Paste',  wk.send_keys({'cmd'}, 'v') }
)

add_category('Brightness')  ---------------------------------------------------+
bind(
    { 'z', 'Up',    brightness.adjust('up')   },
    { 'j', 'Down',  brightness.adjust('down') },
    { 'P', 'Print', brightness.print_values() }
)

add_category('Misc')  ---------------------------------------------------------+
bind(
    { 'Z',      'Zoom in',            wk.send_keys({'cmd'}, '=')         },
    { 'J',      'Zoom out',           wk.send_keys({'cmd'}, '-')         },
    { 'W',      'Toggle wifi on/off', wifi.toggle_wifi()                 },
    { 'escape', 'Cancel',             wk.turn_eventtap('off'), wk.hide() }
)


-------------------------------------------------------------------------------+
add_app('kitty')                                                            -- |
-------------------------------------------------------------------------------+

add_category('Scrollback')  ---------------------------------------------------+
bind(
    { 'e', 'Page up',   wk.send_keys({'shift'}, 'pageup')   },
    { 'd', 'Page down', wk.send_keys({'shift'}, 'pagedown') }
)

add_category('Splits')  -------------------------------------------------------+
bind(
    { 'i', 'Up',           wk.send_keys({'ctrl', 'alt'}, 'up') },
    { 'k', 'Down',         wk.send_keys({'ctrl', 'alt'}, 'down') },
    { 'l', 'Right',        wk.send_keys({'ctrl', 'alt'}, 'right') },
    { 't', 'Left',         wk.send_keys({'ctrl', 'alt'}, 'left') },
    { 'I', 'Resize up',    wk.send_keys({'ctrl', 'alt', 'shift'}, 'up') },
    { 'K', 'Resize down',  wk.send_keys({'ctrl', 'alt', 'shift'}, 'down') },
    { 'L', 'Resize right', wk.send_keys({'ctrl', 'alt', 'shift'}, 'right') },
    { 'T', 'Resize left',  wk.send_keys({'ctrl', 'alt', 'shift'}, 'left') },
    { 'm', 'New split',    wk.send_keys({'cmd', 'ctrl', 'alt'}, 'm') },
    -- { '', 'New window',   wk.send_keys({'cmd', 'ctrl', 'alt', 'shift'}, 'm') },
    { 'M', 'Detach split', wk.send_keys({'cmd', 'ctrl', 'alt', 'shift'}, 'w') },
    { 'W', 'Close',        wk.send_keys({'cmd', 'shift'}, 'd') }
)

add_category('Tabs')  ---------------------------------------------------------+
bind(
    { ';', 'Next',     wk.send_keys({'ctrl'}, 'end')  },
    { 'h', 'Previous', wk.send_keys({'ctrl'}, 'home') }
    -- bind('', 'Open',     wk.send_keys({'ctrl'}, 'home'))
)

add_category('Layout')  -------------------------------------------------------+
bind(
    { 'R', 'Rotate splits', wk.send_keys({'cmd', 'ctrl', 'alt'}, 'p')  },
    { 'r', 'Next layout',   wk.send_keys({'cmd', 'ctrl', 'alt', 'shift'}, 'p') }
)


-------------------------------------------------------------------------------+
add_app('Brave Browser')                                                    -- |
-------------------------------------------------------------------------------+

add_category('Page')  ---------------------------------------------------------+
bind(
    { 'e', 'Up',      wk.send_keys({}, 'pageup') },
    { 'd', 'Down',    wk.send_keys({}, 'pagedown') },
    { 'E', 'Top',     wk.send_keys({}, 'home') },
    { 'D', 'Bottom',  wk.send_keys({}, 'end') },
    { 'F', 'Search',  wk.send_keys({'cmd'}, 'f'), wk.turn_eventtap('off'), wk.hide(), wk.temporary_insert() },
    { 'R', 'Reload',  wk.send_keys({'cmd'}, 'r') }
    -- { '', 'Forward', wk.send_keys({'cmd'}, ']') },
    -- { '', 'Back',    wk.send_keys({'cmd'}, '[') },
)

add_category('Tabs')  ---------------------------------------------------------+
bind(
    { 'h', 'Left',            wk.send_keys({'ctrl'}, 'pageup') },
    { ';', 'Right',           wk.send_keys({'ctrl'}, 'pagedown') },
    { 'H', 'Swap with left',  wk.send_keys({'ctrl', 'shift'}, 'pageup') },
    { ':', 'Swap with right', wk.send_keys({'ctrl', 'shift'}, 'pagedown') },
    { '/', 'Search tabs',     wk.send_keys({'cmd', 'shift'}, 'a'), wk.turn_eventtap('off'), wk.hide(), wk.temporary_insert() },
    { 'm', 'Open',            wk.send_keys({'cmd'}, 't') },
    { 'M', 'Re-open closed',  wk.send_keys({'cmd', 'shift'}, 't') },
    { 'w', 'Close',           wk.send_keys({'cmd'}, 'w') }
)

add_category('Navigation')  ---------------------------------------------------+
bind(
    { 'i', 'Up arrow',    wk.send_keys({}, 'up') },
    { 'k', 'Down arrow',  wk.send_keys({}, 'down') },
    { 'l', 'Focus next',  wk.send_keys({}, 'tab') },
    { 't', 'Focus prev',  wk.send_keys({'shift'}, 'tab') }
)

add_category('Misc')  ---------------------------------------------------------+
bind(
    { "'",      'Focus searchbar', wk.send_keys({'cmd'}, 'l'), wk.turn_eventtap('off'), wk.hide(), wk.temporary_insert() },
    { 'b',      'Add bookmark',    wk.send_keys({'cmd'}, 'd') },
    { 'P',      'Open history',    wk.send_keys({'cmd'}, 'h') },
    { 'return', 'Confirm',         wk.send_keys({}, 'return') }
)

return M



-------+
-- DOC |
-------+
--
-- Example data structure that is produced by the functions below:
--
-- ('...' Denotes continued entries in the table)
--
-- -----------------------------------------------------------------------------
-- add_app('insert')
-- add_category('Bound until invoked')
-- insert_bind(
--     { 'enter',  'Relaunch menu' },
--     { 'escape', 'Cancel'        }
-- )
-- add_app('system')
-- add_category('Windows')
-- bind(
--     { '_', 'Cycle cat apps',  wk.hide(), win.cycle_main_apps(), wk.show()  },
--     { 'n', 'Cycle next open', wk.hide(), win.cycle_open('next'), wk.show() },
--     { 'N', 'Cycle prev open', wk.hide(), win.cycle_open('prev'), wk.show() },
-- )
-- add_category('Popups')
-- bind(
--     { 'R', 'Cycle positions',     wk.hide(), wk.cycle_corner_pos(), wk.show() },
--     { 'A', 'Cycle menu stacking', wk.hide(), wk.cycle_stacking(), wk.show()   },
-- )
-- add_app('kitty')
-- add_category('Scrollback')
-- bind(
--     { 'e', 'Page up',   wk.send_keys({'shift'}, 'pageup')   },
--     { 'd', 'Page down', wk.send_keys({'shift'}, 'pagedown') }
-- )
-- add_category('Splits')
-- bind(
--     { 'i', 'Up',   wk.send_keys({'ctrl', 'alt'}, 'up') },
--     { 'k', 'Down', wk.send_keys({'ctrl', 'alt'}, 'down') },
-- )
-- -----------------------------------------------------------------------------
--
-- M.apps = {
--     ['insert'] = {
--         {
--             category = 'Bound until invoked',
--             bindings = {
--                 {   -- return (enter)
--                     desc = 'Relaunch menu',
--                     key  = 'Enter',
--                 },
--                 {   -- escape
--                     desc = 'Cancel',
--                     key  = 'Escape',
--                 }
--             }
--         }
--     },
--
--     ['system'] = {
--         {
--             category = 'Windows',
--             bindings = {
--                 {
--                     desc   = 'Cycle cat apps',
--                     key    = '-',
--                     mods   = { 'shift' },
--                     action = { wk.hide(), win.cycle_main_apps(), wk.show() },
--                 },
--                 {
--                     desc   = 'Cycle next open',
--                     key    = 'n',
--                     action = { wk.hide(), win.cycle_open('next'), wk.show() },
--                 },
--                 {
--                     desc   = 'Cycle prev open',
--                     key    = 'n',
--                     mods   = { 'shift' },
--                     action = { wk.hide(), win.cycle_open('prev'), wk.show() },
--                 },
--
--                 ...
--             }
--         },
--         {
--             category = 'Popups',
--             bindings = {
--                 {
--                     desc   = 'Cycle positions',
--                     key    = 'r',
--                     mods   = { 'shift' },
--                     action = { wk.hide(), wk.cycle_corner_pos(), wk.show() },
--                 },
--                 {
--                     desc   = 'Cycle menu stacking',
--                     key    = 'a',
--                     mods   = { 'shift' },
--                     action = { wk.hide(), wk.cycle_stacking(), wk.show() },
--                 },
--
--                 ...
--             }
--         },
--
--         ...
--     },
--
--     ['kitty'] = {
--         {
--             category = 'Scrollback',
--             bindings = {
--                 {
--                     desc   = 'Page up',
--                     key    = 'e',
--                     action = wk.send_keys({'shift'}, 'pageup'),
--                 },
--                 {
--                     desc   = 'Page down',
--                     key    = 'd',
--                     action = wk.send_keys({'shift'}, 'pagedown'),
--                 },
--
--                 ...
--             }
--         },
--         {
--             category = 'Splits',
--             bindings = {
--                 {
--                     desc   = 'Up',
--                     key    = 'i',
--                     action = wk.send_keys({'ctrl', 'alt'}, 'up'),
--                 },
--                 {
--                     desc   = 'Down',
--                     key    = 'k',
--                     action = wk.send_keys({'ctrl', 'alt'}, 'down'),
--                 },
--
--                 ...
--             }
--         },
--
--         ...
--     }
-- }
