local M = {}

local wk      = require('wk')
local screens = require('screens')
local win     = require('windows')
local wifi    = require('wifi')
local mouse   = require('mouse')


M.apps = {}

-- Universal bindings.
--------------------------------------------------------------------------------
M.apps.system = {
    -- MacOS default keybindings:  https://support.apple.com/en-ca/102650
    {
        category = 'Mouse',
        bindings = {
            { 'up', 'Scroll up',   mouse.scroll('up')   },
            { 'down', 'Scroll down', mouse.scroll('down') },
        },
    },
    {
        category = 'Windows',
        bindings = {

            -- { '-', 'To prev screen',  win.move_to_screen('prev'), wk.refresh() },
            -- { '_', 'To next screen',  win.move_to_screen('next'), wk.refresh() },
            -- { 'o', 'Next app window', win.cycle_app_specific('next'), wk.refresh() },
            -- { 'u', 'Prev app window', win.cycle_app_specific('prev'), wk.refresh() },

            -- { '_', 'Cycle cat apps', win.cycle_main_apps()                       },
            -- { '_', 'Next app',       win.cycle_all_apps('next')                  },
            -- { '-', 'Prev app',       win.cycle_all_apps('prev')                  },

            { ':', 'Next window', win.cycle_open('next')                         },
            { 'H', 'Prev window', win.cycle_open('prev')                         },
            { 'n', 'Open window', wk.send_keys({'cmd'}, 'n'), wk.refresh() },
            { 'm', 'Open tab',    wk.send_keys({'cmd'}, 't'), wk.refresh() },
            { 'W', 'Close tab',   wk.send_keys({'cmd'}, 'w'), wk.refresh() }
        },
    },
    {
        category = 'Layout',
        bindings = {
            { 'l', 'Next slot',      win.traverse_slots('next') },
            { 't', 'Prev slot',      win.traverse_slots('prev') },
            { 'L', 'To right slot',  win.move_to_slot('right')  },
            { 'T', 'To left slot',   win.move_to_slot('left')   },
            { 'f', 'Resize right',   win.resize('right')        },
            { 's', 'Resize left',    win.resize('left')         },
            { 'g', 'Maximize',       win.maximize()             },
            { 'G', 'Swap positions', win.swap()                 }
        },
    },
    {
        category = 'Popups',
        bindings = {
            { 'R', 'Cycle positions',     wk.cycle_corner_pos() },
            { 'A', 'Cycle menu stacking', wk.cycle_stacking()   },
            { 'V', 'Opacity up',          wk.opacity('up')      },
            { 'Y', 'Opacity down',        wk.opacity('down')    }
        },
    },
    {
        category = 'Clipboard',
        bindings = {
            { 'c', 'Copy',  wk.send_keys({'cmd'}, 'c') },
            { 'x', 'Cut',   wk.send_keys({'cmd'}, 'x') },
            { 'v', 'Paste', wk.send_keys({'cmd'}, 'v') }
        },
    },
    {
        category = 'Brightness',
        bindings = {
            { 'z', 'Up',    screens.brightness('up')   },
            { 'j', 'Down',  screens.brightness('down') },
            { 'P', 'Print', screens.print_brightness() }
        },
    },
    {
        category = 'Misc',
        bindings = {
            { 'Z',      'Zoom in',            wk.send_keys({'cmd'}, '=') },
            { 'J',      'Zoom out',           wk.send_keys({'cmd'}, '-') },
            { 'X',      'Toggle wifi on/off', wifi.toggle_wifi()         },
            { 'escape', 'Cancel',             wk.quit()                  }
        },
    },
}


-- Brave bindings.
--------------------------------------------------------------------------------
M.apps['Brave Browser'] = {
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
        bindings = {
            -- { 'e', 'Up',      wk.send_keys({}, 'pageup')              },
            -- { 'd', 'Down',    wk.send_keys({}, 'pagedown')            },
            -- { 'E', 'Top',     wk.send_keys({}, 'home')                },
            -- { 'D', 'Bottom',  wk.send_keys({}, 'end')                 },
            { 'F', 'Search',  wk.send_keys({'cmd'}, 'f'), wk.insert() },
            { 'R', 'Reload',  wk.send_keys({'cmd'}, 'r')              }

            -- { '', 'Forward', wk.send_keys({'cmd'}, ']') },
            -- { '', 'Back',    wk.send_keys({'cmd'}, '[') },
        },
    },
    {
        category = 'Tabs',
        bindings = {
            -- { 'h', 'Left',            wk.send_keys({'ctrl'}, 'end')                 },
            -- { ';', 'Right',           wk.send_keys({'ctrl'}, 'home')               },
            { 'h', 'Left',            wk.send_keys({'ctrl'}, 'pageup')                 },
            { ';', 'Right',           wk.send_keys({'ctrl'}, 'pagedown')               },
            { 'H', 'Swap with left',  wk.send_keys({'ctrl', 'shift'}, 'pageup')        },
            { ':', 'Swap with right', wk.send_keys({'ctrl', 'shift'}, 'pagedown')      },
            { '/', 'Search tabs',     wk.send_keys({'cmd', 'shift'}, 'a'), wk.insert() },
            { 'M', 'Re-open closed',  wk.send_keys({'cmd', 'shift'}, 't')              }

            -- { 'm', 'Open',            wk.send_keys({'cmd'}, 't')                       },
        },
    },
    -- {
    --     category = 'Navigation',
    --     bindings = {
    --         { 'i', 'Up arrow',    wk.send_keys({}, 'up')         },
    --         { 'k', 'Down arrow',  wk.send_keys({}, 'down')       },
    --         { 'l', 'Focus next',  wk.send_keys({}, 'tab')        },
    --         { 't', 'Focus prev',  wk.send_keys({'shift'}, 'tab') }
    --     },
    -- },
    {
        category = 'Misc',
        bindings = {
            { "'",      'Focus searchbar', wk.send_keys({'cmd'}, 'l'), wk.insert() },
            { 'b',      'Add bookmark',    wk.send_keys({'cmd'}, 'd')              },
            { 'P',      'Open history',    wk.send_keys({'cmd'}, 'h')              },
            { 'return', 'Confirm',         wk.send_keys({}, 'return')              }
        },
    },
}


-- Kitty bindings.
--------------------------------------------------------------------------------
M.apps.kitty = {
    {
        category = 'Scrollback',
        bindings = {
            { 'e', 'Page up',   wk.send_keys({'shift'}, 'pageup')   },
            { 'd', 'Page down', wk.send_keys({'shift'}, 'pagedown') }
        },
    },
    {
        category = 'Splits',
        bindings = {
            -- { 'i', 'Up',           wk.send_keys({'ctrl', 'alt'}, 'up')             },
            -- { 'k', 'Down',         wk.send_keys({'ctrl', 'alt'}, 'down')           },
            -- { 'l', 'Right',        wk.send_keys({'ctrl', 'alt'}, 'right')          },
            -- { 't', 'Left',         wk.send_keys({'ctrl', 'alt'}, 'left')           },
            -- { 'I', 'Resize up',    wk.send_keys({'ctrl', 'alt', 'shift'}, 'up')    },
            -- { 'K', 'Resize down',  wk.send_keys({'ctrl', 'alt', 'shift'}, 'down')  },
            -- { 'L', 'Resize right', wk.send_keys({'ctrl', 'alt', 'shift'}, 'right') },
            -- { 'T', 'Resize left',  wk.send_keys({'ctrl', 'alt', 'shift'}, 'left')  },

            -- new_win
            { 'M', 'Detach split', wk.send_keys({'cmd', 'ctrl', 'alt', 'shift'}, 'w'), wk.refresh() }

            -- { 'm', 'New split',    wk.send_keys({'cmd', 'ctrl', 'alt'}, 'm')          },
            -- { 'W', 'Close',        wk.send_keys({'cmd', 'shift'}, 'd')                }
            -- { '', 'New window',   wk.send_keys({'cmd', 'ctrl', 'alt', 'shift'}, 'm') },
        },
    },
    {
        category = 'Tabs',
        bindings = {
            { ';', 'Next',     wk.send_keys({'ctrl'}, 'pageup')   },
            { 'h', 'Previous', wk.send_keys({'ctrl'}, 'pagedown') }
            -- { ';', 'Next',     wk.send_keys({'ctrl'}, 'end')  },
            -- { 'h', 'Previous', wk.send_keys({'ctrl'}, 'home') }

            -- M.bind('', 'Open',     wk.send_keys({'ctrl'}, 'home'))
        },
    },
    {
        category = 'Layout',
        bindings = {
            { 'R', 'Rotate splits', wk.send_keys({'cmd', 'ctrl', 'alt'}, 'p')          },
            { 'r', 'Next layout',   wk.send_keys({'cmd', 'ctrl', 'alt', 'shift'}, 'p') }
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
for _, categories in pairs(M.apps) do
    for _, category in ipairs(categories) do
        category.bindings = bind(table.unpack(category.bindings))
    end
end

return M
