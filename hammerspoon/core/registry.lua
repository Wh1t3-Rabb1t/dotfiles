local M = {}

local brightness = require('brightness')
local wk         = require('which_key')
local win        = require('windows')
local wifi       = require('wifi')


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
local function insert_bind( ... )
    local binding_field = {}

    for _, args in ipairs({ ... }) do
        table.insert(binding_field, {
            key  = args[1],
            desc = args[2],
        })
    end

    return binding_field
end


-- Construct binding entry
--------------------------------------------------------------------------------
local function bind( ... )
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
-- Bindings for each registered app
--------------------------------------------------------------------------------
M.apps = {
    -------------------+
    ['insert'] = {  -- |
    -------------------+
        -- These are temporarily bound to actions after the eventtap has been
        -- stopped, then unbound once the eventtap is restarted. Therefor they
        -- don't have corresponding actions.
        {
            category = 'Bound until invoked',
            bindings = insert_bind(
                { 'enter',  'Relaunch menu' },
                { 'escape', 'Cancel'        }
            ),
        },
    },

    -------------------+
    ['system'] = {  -- |
    -------------------+
        {
            category = 'Launch or focus',
            bindings = bind(
                { 'y', 'Firefox', wk.hide(), win.launch_or_focus('Firefox'), win.snap(), wk.show() }

                -- { '', 'Brave Browser', wk.hide(), win.launch_or_focus('Brave Browser'), win.snap(), wk.show() },
                -- { '', 'kitty',         wk.hide(), win.launch_or_focus('kitty'), win.snap(), wk.show()         },
            ),
        },
        {
            category = 'Windows',
            bindings = bind(
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
            ),
        },
        {
            category = 'Popups',
            bindings = bind(
                { 'R', 'Cycle positions',     wk.hide(), wk.cycle_corner_pos(), wk.show() },
                { 'A', 'Cycle menu stacking', wk.hide(), wk.cycle_stacking(), wk.show()   },
                { 'O', 'Opacity up',          wk.opacity('up')                            },
                { 'U', 'Opacity down',        wk.opacity('down')                          }
            ),
        },
        {
            category = 'Clipboard',
            bindings = bind(
                { 'c', 'Copy',  wk.send_keys({'cmd'}, 'c') },
                { 'x', 'Cut',   wk.send_keys({'cmd'}, 'x') },
                { 'v', 'Paste', wk.send_keys({'cmd'}, 'v') }
            ),
        },
        {
            category = 'Brightness',
            bindings = bind(
                { 'z', 'Up',    brightness.adjust('up')   },
                { 'j', 'Down',  brightness.adjust('down') },
                { 'P', 'Print', brightness.print_values() }
            ),
        },
        {
            category = 'Misc',
            bindings = bind(
                { 'Z',      'Zoom in',            wk.send_keys({'cmd'}, '=')                       },
                { 'J',      'Zoom out',           wk.send_keys({'cmd'}, '-')                       },
                { 'W',      'Toggle wifi on/off', wifi.toggle_wifi()                               },
                { 'escape', 'Cancel',             wk.turn_tap('off'), win.border('hide'), wk.hide() }
                -- { 'escape', 'Cancel',             wk.turn_tap('off'), wk.hide() }
            ),
        },
    },

    --------------------------+
    ['Brave Browser'] = {  -- |
    --------------------------+
        -- brave://settings/system/shortcuts
        --
        -- Test these:
        --   Dev tools inspect                (Command Shift c|Command Alt c)
        --   Dev tools toggle                 F12
        --   Move Tab to New Window
        --   New Split View with Current Tab  Command Alt n
        --   Find next                        Command g
        --   Find previous                    Command Shift g
        --   Stop                             Command .
        --   New Private Window               Command Shift n
        --   Reopen Closed Tab                Command Shift t
        --   New Split View with Current Tab  Command Alt n
        --   Collapse Tabs                    Command Shift l
        --   Add new tab to group             Command Control c
        --   Create new tab group             Command Control p
        --   Focus next tab group             Command Control x
        --   Focus previous tab group         Command Control z
        --   Close tab group                  Command Control w
        --   View Source                      Command Alt u
        --   Focus next pane                  Command Alt ArrowDown
        --   Focus previous pane              Command Alt ArrowUp
        --   Developer Tools                  Command Alt i
        --   JavaScript Console               Command Alt j
        --   Show Bookmarks Bar               Command Shift b
        --   Show history                     Command y
        --   Show bookmark manager            Command Alt b
        --   Options                          Command ,
        --   Reading Mode                     Command Alt r
        --   New Private Window with Tor      Command Alt n
        --   Toggle tab mute                  Control m
        --   Toggle sidebar                   Command b
        --   Quick Commands                   Command Shift p
        --   Remove tab from current group
        --   Unsplit Tabs
        --   Swap Tab Positions
        --   Toggle sidebar position
        --   Focus web contents pane
        --   Take Screenshot
        --   Focus bookmarks
        --   Show all windows
        --   Name Window
        --   Open in PWA window
        --   Move Tab to New Window
        --   Mute site
        --   Pin tab
        --   Group tab
        --   Open Guest Profile
        --   Toggle Focus Mode
        --   Focus toolbar
        --   Focus menu bar
        --   Inspect Devices
        --   Show performance settings
        --   Task Manager
        --   Open all bookmarks
        --   Open Bookmarks Manager
        --   Bookmark bar add to bookmarks bar
        --   Bookmark bar remove from bookmarks bar
        --   Toggle JavaScript
        --   Move group to new window
        --   Toggle vertical tabs expanded
        {
            category = 'Page',
            bindings = bind(
                { 'e', 'Up',      wk.send_keys({}, 'pageup')                                             },
                { 'd', 'Down',    wk.send_keys({}, 'pagedown')                                           },
                { 'E', 'Top',     wk.send_keys({}, 'home')                                               },
                { 'D', 'Bottom',  wk.send_keys({}, 'end')                                                },
                { 'F', 'Search',  wk.send_keys({'cmd'}, 'f'), wk.turn_tap('off'), wk.hide(), wk.insert() },
                { 'R', 'Reload',  wk.send_keys({'cmd'}, 'r')                                             }

                -- { '', 'Forward', wk.send_keys({'cmd'}, ']') },
                -- { '', 'Back',    wk.send_keys({'cmd'}, '[') },
            ),
        },
        {
            category = 'Tabs',
            bindings = bind(
                { 'h', 'Left',            wk.send_keys({'ctrl'}, 'pageup')                                                },
                { ';', 'Right',           wk.send_keys({'ctrl'}, 'pagedown')                                              },
                { 'H', 'Swap with left',  wk.send_keys({'ctrl', 'shift'}, 'pageup')                                       },
                { ':', 'Swap with right', wk.send_keys({'ctrl', 'shift'}, 'pagedown')                                     },
                { '/', 'Search tabs',     wk.send_keys({'cmd', 'shift'}, 'a'), wk.turn_tap('off'), wk.hide(), wk.insert() },
                { 'm', 'Open',            wk.send_keys({'cmd'}, 't')                                                      },
                { 'M', 'Re-open closed',  wk.send_keys({'cmd', 'shift'}, 't')                                             },
                { 'w', 'Close',           wk.send_keys({'cmd'}, 'w')                                                      }
            ),
        },
        {
            category = 'Navigation',
            bindings = bind(
                { 'i', 'Up arrow',    wk.send_keys({}, 'up')         },
                { 'k', 'Down arrow',  wk.send_keys({}, 'down')       },
                { 'l', 'Focus next',  wk.send_keys({}, 'tab')        },
                { 't', 'Focus prev',  wk.send_keys({'shift'}, 'tab') }
            ),
        },
        {
            category = 'Misc',
            bindings = bind(
                { "'",      'Focus searchbar', wk.send_keys({'cmd'}, 'l'), wk.turn_tap('off'), wk.hide(), wk.insert() },
                { 'b',      'Add bookmark',    wk.send_keys({'cmd'}, 'd')                                             },
                { 'P',      'Open history',    wk.send_keys({'cmd'}, 'h')                                             },
                { 'return', 'Confirm',         wk.send_keys({}, 'return')                                             }
            ),
        },
    },

    ------------------+
    ['kitty'] = {  -- |
    ------------------+
        {
            category = 'Scrollback',
            bindings = bind(
                { 'e', 'Page up',   wk.send_keys({'shift'}, 'pageup')   },
                { 'd', 'Page down', wk.send_keys({'shift'}, 'pagedown') }
            ),
        },
        {
            category = 'Splits',
            bindings = bind(
                { 'i', 'Up',           wk.send_keys({'ctrl', 'alt'}, 'up')                },
                { 'k', 'Down',         wk.send_keys({'ctrl', 'alt'}, 'down')              },
                { 'l', 'Right',        wk.send_keys({'ctrl', 'alt'}, 'right')             },
                { 't', 'Left',         wk.send_keys({'ctrl', 'alt'}, 'left')              },
                { 'I', 'Resize up',    wk.send_keys({'ctrl', 'alt', 'shift'}, 'up')       },
                { 'K', 'Resize down',  wk.send_keys({'ctrl', 'alt', 'shift'}, 'down')     },
                { 'L', 'Resize right', wk.send_keys({'ctrl', 'alt', 'shift'}, 'right')    },
                { 'T', 'Resize left',  wk.send_keys({'ctrl', 'alt', 'shift'}, 'left')     },
                { 'm', 'New split',    wk.send_keys({'cmd', 'ctrl', 'alt'}, 'm')          },
                { 'M', 'Detach split', wk.send_keys({'cmd', 'ctrl', 'alt', 'shift'}, 'w') },
                { 'W', 'Close',        wk.send_keys({'cmd', 'shift'}, 'd')                }

                -- { '', 'New window',   wk.send_keys({'cmd', 'ctrl', 'alt', 'shift'}, 'm') },
            ),
        },
        {
            category = 'Tabs',
            bindings = bind(
                { ';', 'Next',     wk.send_keys({'ctrl'}, 'end')  },
                { 'h', 'Previous', wk.send_keys({'ctrl'}, 'home') }

                -- bind('', 'Open',     wk.send_keys({'ctrl'}, 'home'))
            ),
        },
        {
            category = 'Layout',
            bindings = bind(
                { 'R', 'Rotate splits', wk.send_keys({'cmd', 'ctrl', 'alt'}, 'p')          },
                { 'r', 'Next layout',   wk.send_keys({'cmd', 'ctrl', 'alt', 'shift'}, 'p') }
            ),
        },
    },
}

return M
