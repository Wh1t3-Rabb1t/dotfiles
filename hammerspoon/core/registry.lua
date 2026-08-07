local M = {}

-- !! These could all be bound behind a leader key (space)
--
-- Apple:
--   Spotlight
--   Dock
--
-- Volume:
--   Up
--   Down
--   Mute
--
-- Media:
--   Toggle (play/pause)
--
-- Clipboard:
--   Copy
--   Cut
--   Paste
--
-- Misc:
--   Toggle bluetooth
--   Quit app


local brightness = require('brightness')
local wk         = require('which_key')
local splits     = require('splits')
local wifi       = require('wifi')

M.apps = {
    -- These are temporarily bound to actions after the eventtap has been
    -- stopped, then unbound once the eventtap is restarted. Therefor the
    -- don't have corresponding actions in the action table.
    ['insert'] = {
        {
            category = 'Bound until invoked',
            bindings = {
                {
                    desc = 'Relaunch menu',
                    key  = 'Enter',
                },
                {
                    desc = 'Cancel',
                    key  = 'Escape',
                },
            },
        },
    },

    ['system'] = {
        -- Launch or focus
        {
            category = 'Launch or focus',
            bindings = {
                {
                    desc   = 'Firefox',
                    key    = 'y',
                    action = {
                        wk.hide_menu(),
                        splits.launch_or_focus('Firefox'),
                        splits.snap(),
                        wk.show_menu()
                    },
                },
                {
                    desc   = 'kitty',
                    key    = 'v',
                    action = {
                        wk.hide_menu(),
                        splits.launch_or_focus('kitty'),
                        splits.snap(),
                        wk.show_menu()
                    },
                },
                {
                    desc   = 'Brave Browser',
                    key    = 'b',
                    action = {
                        wk.hide_menu(),
                        splits.launch_or_focus('Brave Browser'),
                        splits.snap(),
                        wk.show_menu()
                    },
                },
            },
        },

        -- Splits
        {
            category = 'Splits',
            bindings = {
                {
                    desc   = 'Resize right',
                    key    = 'o',
                    action = {
                        wk.hide_menu(),
                        splits.resize('right'),
                        splits.snap(),
                        wk.show_menu()
                    },
                },
                {
                    desc   = 'Resize left',
                    key    = 'u',
                    action = {
                        wk.hide_menu(),
                        splits.resize('left'),
                        splits.snap(),
                        wk.show_menu()
                    },
                },
                {
                    desc   = 'Maximize',
                    key    = 'g',
                    action = {
                        wk.hide_menu(),
                        splits.maximize(),
                        splits.snap(),
                        wk.show_menu()
                    },
                },
                {
                    desc   = 'Move to next screen',
                    key    = 'c',
                    action = {
                        wk.hide_menu(),
                        splits.move_to_screen(),
                        splits.snap(),
                        wk.show_menu()

                    },
                },
                {
                    desc   = 'Swap positions',
                    key    = 's',
                    action = {
                        wk.hide_menu(),
                        splits.swap(),
                        splits.snap(),
                        wk.show_menu()
                    },
                },
            },
        },

        -- Popups
        {
            category = 'Popups',
            bindings = {
                {
                    desc   = 'Cycle positions',
                    key    = 'r',
                    mods   = {'shift'},
                    action = {
                        wk.hide_menu(),
                        wk.cycle_corner_pos(),
                        wk.show_menu()
                    },
                },
                {
                    desc   = 'Cycle menu stacking',
                    key    = 'a',
                    mods   = {'shift'},
                    action = {
                        wk.hide_menu(),
                        wk.cycle_stacking(),
                        wk.show_menu()
                    },
                },
                {
                    desc   = 'Opacity up',
                    key    = 'r',
                    action = wk.menu_opacity('up'),
                },
                {
                    desc   = 'Opacity down',
                    key    = 'f',
                    action = wk.menu_opacity('down'),
                },
            },
        },

        -- Brightness
        {
            category = 'Brightness',
            bindings = {
                {
                    desc   = 'Up',
                    key    = 'z',
                    action = brightness.adjust('up'),
                },
                {
                    desc   = 'Down',
                    key    = 'j',
                    action = brightness.adjust('down'),
                },
                {
                    desc   = 'Print',
                    key    = 'p',
                    action = brightness.print_values(),
                },
            },
        },

        -- Misc
        {
            category = 'Misc',
            bindings = {
                {
                    desc   = 'Zoom in',
                    key    = 'z',
                    mods   = {'shift'},
                    action = wk.send_keys({'cmd'}, '='),
                },
                {
                    desc   = 'Zoom out',
                    key    = 'j',
                    mods   = {'shift'},
                    action = wk.send_keys({'cmd'}, '-'),
                },
                {
                    desc   = 'Toggle wifi on/off',
                    key    = 'w',
                    action = wifi.toggle_wifi(),
                },
                {
                    desc   = 'Cancel',
                    key    = 'escape',
                    action = {
                        wk.turn_eventtap('off'),
                        wk.hide_menu()
                    },
                },
            },
        },
    },

    ['kitty'] = {
        -- Scrollback
        {
            category = 'Scrollback',
            bindings = {
                {
                    desc   = 'Page up',
                    key    = 'e',
                    action = wk.send_keys({'shift'}, 'pageup'),
                },
                {
                    desc   = 'Page down',
                    key    = 'd',
                    action = wk.send_keys({'shift'}, 'pagedown'),
                },
            },
        },

        -- Splits
        {
            category = 'Splits',
            bindings = {
                {
                    desc   = 'Up',
                    key    = 'i',
                    action = wk.send_keys({'ctrl', 'alt'}, 'up'),
                },
                {
                    desc   = 'Down',
                    key    = 'k',
                    action = wk.send_keys({'ctrl', 'alt'}, 'down'),
                },
                {
                    desc   = 'Right',
                    key    = 'l',
                    action = wk.send_keys({'ctrl', 'alt'}, 'right'),
                },
                {
                    desc   = 'Left',
                    key    = 't',
                    action = wk.send_keys({'ctrl', 'alt'}, 'left'),
                },
                {
                    desc   = 'Resize up',
                    key    = 'i',
                    mods   = {'shift'},
                    action = wk.send_keys({'ctrl', 'alt', 'shift'}, 'up'),
                },
                {
                    desc   = 'Resize down',
                    key    = 'k',
                    mods   = {'shift'},
                    action = wk.send_keys({'ctrl', 'alt', 'shift'}, 'down'),
                },
                {
                    desc   = 'Resize right',
                    key    = 'l',
                    mods   = {'shift'},
                    action = wk.send_keys({'ctrl', 'alt', 'shift'}, 'right'),
                },
                {
                    desc   = 'Resize left',
                    key    = 't',
                    mods   = {'shift'},
                    action = wk.send_keys({'ctrl', 'alt', 'shift'}, 'left'),
                },
                {
                    desc   = 'New split',
                    key    = 'm',
                    action = wk.send_keys({'cmd', 'ctrl', 'alt'}, 'm'),
                },
                {
                    desc   = 'New window',
                    key    = 'm',
                    mods   = {'shift'},
                    action = wk.send_keys({'cmd', 'ctrl', 'alt', 'shift'}, 'm'),
                },
                {
                    desc   = 'Detach split',
                    key    = 'n',
                    mods   = {'shift'},
                    action = wk.send_keys({'cmd', 'ctrl', 'alt', 'shift'}, 'w'),
                },
                {
                    desc   = 'Close',
                    key    = 'w',
                    mods   = {'shift'},
                    action = wk.send_keys({'cmd', 'shift'}, 'd'),
                },
            },
        },

        -- Tabs
        {
            category = 'Tabs',
            bindings = {
                {
                    desc   = 'Next',
                    key    = ';',
                    action = wk.send_keys({'ctrl'}, 'end'),
                },
                {
                    desc   = 'Previous',
                    key    = 'h',
                    action = wk.send_keys({'ctrl'}, 'home'),
                },
                {
                    desc   = 'Open',
                    key    = 'n',
                    action = wk.send_keys({'cmd', 'ctrl', 'alt'}, 'n'),
                },
            },
        },

        -- Layout
        {
            category = 'Layout',
            bindings = {
                {
                    desc   = 'Rotate splits',
                    key    = 'r',
                    mods   = {'shift'},
                    action = wk.send_keys({'cmd', 'ctrl', 'alt'}, 'p'),
                },
                {
                    desc   = 'Next',
                    key    = 'r',
                    action = wk.send_keys({'cmd', 'ctrl', 'alt', 'shift'}, 'p'),
                },
            },
        },
    },

    ['Brave Browser'] = {
        -- Page
        {
            category = 'Page',
            bindings = {
                {
                    desc   = 'Up',
                    key    = 'e',
                    action = wk.send_keys({}, 'pageup'),
                },
                {
                    desc   = 'Down',
                    key    = 'd',
                    action = wk.send_keys({}, 'pagedown'),
                },
                {
                    desc   = 'Top',
                    key    = 'e',
                    mods   = {'shift'},
                    action = wk.send_keys({}, 'home'),
                },
                {
                    desc   = 'Bottom',
                    key    = 'd',
                    mods   = {'shift'},
                    action = wk.send_keys({}, 'end'),
                },
                {
                    desc   = 'Search for text',
                    key    = 'f',
                    mods   = {'shift'},
                    action = {
                        wk.send_keys({'cmd'}, 'f'),
                        wk.turn_eventtap('off'),
                        wk.hide_menu(),
                        wk.temporary_insert()
                    },
                },
                {
                    desc   = 'Reload',
                    key    = 'r',
                    mods   = {'shift'},
                    action = wk.send_keys({'cmd'}, 'r'),
                },
                {
                    desc   = 'Back',
                    key    = 'u',
                    mods   = {'shift'},
                    action = wk.send_keys({'cmd'}, '['),
                },
                {
                    desc   = 'Forward',
                    key    = 'o',
                    mods   = {'shift'},
                    action = wk.send_keys({'cmd'}, ']'),
                },
            },
        },

        -- Tabs
        {
            category = 'Tabs',
            bindings = {
                {
                    desc   = 'Left',
                    key    = 'h',
                    action = wk.send_keys({'ctrl'}, 'pageup'),
                },
                {
                    desc   = 'Right',
                    key    = ';',
                    action = wk.send_keys({'ctrl'}, 'pagedown'),
                },
                {
                    desc   = 'Swap with left',
                    key    = 'h',
                    mods   = {'shift'},
                    action = wk.send_keys({'ctrl', 'shift'}, 'pageup'),
                },
                {
                    desc   = 'Swap with right',
                    key    = ';',
                    mods   = {'shift'},
                    action = wk.send_keys({'ctrl', 'shift'}, 'pagedown'),
                },
                {
                    desc   = 'Search tabs',
                    key    = '/',
                    action = {
                        wk.send_keys({'cmd', 'shift'}, 'a'),
                        wk.turn_eventtap('off'),
                        wk.hide_menu(),
                        wk.temporary_insert()
                    },
                },
                {
                    desc   = 'Open',
                    key    = 'm',
                    action = wk.send_keys({'cmd'}, 't'),
                },
                {
                    desc   = 'Re-open closed',
                    key    = 'm',
                    mods   = {'shift'},
                    action = wk.send_keys({'cmd', 'shift'}, 't'),
                },
                {
                    desc   = 'Close',
                    key    = 'w',
                    action = wk.send_keys({'cmd'}, 'w'),
                },
            },
        },

        -- Navigation
        {
            category = 'Navigation',
            bindings = {
                {
                    desc   = 'Up arrow',
                    key    = 'i',
                    action = wk.send_keys({}, 'up'),
                },
                {
                    desc   = 'Down arrow',
                    key    = 'k',
                    action = wk.send_keys({}, 'down'),
                },
                {
                    desc   = 'Focus prev',
                    key    = 't',
                    action = wk.send_keys({'shift'}, 'tab'),
                },
                {
                    desc   = 'Focus next',
                    key    = 'l',
                    action = wk.send_keys({}, 'tab'),
                },
            },
        },

        -- Misc
        {
            category = 'Misc',
            bindings = {
                {
                    desc   = 'Focus searchbar',
                    key    = "'",
                    action = {
                        wk.send_keys({'cmd'}, 'l'),
                        wk.turn_eventtap('off'),
                        wk.hide_menu(),
                        wk.temporary_insert()
                    },
                },
                {
                    desc   = 'Add bookmark',
                    key    = 'b',
                    mods   = {'shift'},
                    action = wk.send_keys({'cmd'}, 'd'),
                },
                {
                    desc   = 'Open history',
                    key    = 'p',
                    mods   = {'shift'},
                    action = wk.send_keys({'cmd'}, 'h'),
                },
                {
                    desc   = 'Confirm',
                    key    = 'return',
                    action = wk.send_keys({}, 'return'),
                },
            },
        },
    },
}

return M
