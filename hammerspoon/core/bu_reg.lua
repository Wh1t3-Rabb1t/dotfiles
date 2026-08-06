local M = {}

-- !! These could all be bound behind a leader key (space)
--
-- Spotlight:
--   /  Launch
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
-- Windows:
--   n  Win_to_next_screen


local brightness = require('brightness')
local wk = require('which_key')
local splits = require('splits')
local popups = require('popups')
local wifi = require('wifi')


-- These are temporarily bound to actions after the eventtap has been stopped,
-- then unbound once the eventtap is restarted. Therefor the don't have
-- corresponding actions in the action table.
M.insert_bindings = {
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
}

M.bindings = {
    ['system'] = {
        -- Launch or focus
        {
            category = 'Launch or focus',
            bindings = {
                {
                    desc   = 'Firefox',
                    key    = 'y',
                    action = {
                        popups.hide(),
                        splits.launch_or_focus('Firefox'),
                        splits.snap_new(),
                        popups.show()
                    },
                },
                {
                    desc   = 'kitty',
                    key    = 'v',
                    action = {
                        popups.hide(),
                        splits.launch_or_focus('kitty'),
                        splits.snap_new(),
                        popups.show()
                    },
                },
                {
                    desc   = 'Brave Browser',
                    key    = 'b',
                    action = {
                        popups.hide(),
                        splits.launch_or_focus('Brave Browser'),
                        splits.snap_new(),
                        popups.show()
                    },
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

        -- Splits
        {
            category = 'Splits',
            bindings = {
                {
                    desc   = 'Resize right',
                    key    = 'o',
                    action = {
                        splits.resize('right'),
                        splits.snap('split')
                    },
                },
                {
                    desc   = 'Resize left',
                    key    = 'u',
                    action = {
                        splits.resize('left'),
                        splits.snap('split')
                    },
                },
                {
                    desc   = 'Maximize',
                    key    = 'g',
                    action = {
                        popups.hide(),
                        splits.maximize(),
                        popups.show()
                    },
                },
                {
                    desc   = 'Swap positions',
                    key    = 's',
                    action = {
                        popups.hide(),
                        splits.swap(),
                        splits.snap('split'),
                        popups.show()
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
                    mods   = { 'shift' },
                    action = {
                        popups.hide(),
                        popups.cycle_corner_pos(),
                        popups.show()
                    },
                },
                {
                    desc   = 'Cycle menu stacking',
                    key    = 'a',
                    mods   = { 'shift' },
                    action = {
                        popups.hide(),
                        popups.cycle_stacking(),
                        popups.show()
                    },
                },
                {
                    desc   = 'Opacity up',
                    key    = 'r',
                    action = popups.opacity('up'),
                },
                {
                    desc   = 'Opacity down',
                    key    = 'f',
                    action = popups.opacity('down'),
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
                    mods   = { 'shift' },
                    action = wk.send_keys({'cmd'}, '='),
                },
                {
                    desc   = 'Zoom out',
                    key    = 'j',
                    mods   = { 'shift' },
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
                        popups.hide()
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
                    mods   = { 'shift' },
                    action = wk.send_keys({'ctrl', 'alt', 'shift'}, 'up'),
                },
                {
                    desc   = 'Resize down',
                    key    = 'k',
                    mods   = { 'shift' },
                    action = wk.send_keys({'ctrl', 'alt', 'shift'}, 'down'),
                },
                {
                    desc   = 'Resize right',
                    key    = 'l',
                    mods   = { 'shift' },
                    action = wk.send_keys({'ctrl', 'alt', 'shift'}, 'right'),
                },
                {
                    desc   = 'Resize left',
                    key    = 't',
                    mods   = { 'shift' },
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
                    mods   = { 'shift' },
                    action = wk.send_keys({'cmd', 'ctrl', 'alt', 'shift'}, 'm'),
                },
                {
                    desc   = 'Detach split',
                    key    = 'n',
                    mods   = { 'shift' },
                    action = wk.send_keys({'cmd', 'ctrl', 'alt', 'shift'}, 'w'),
                },
                {
                    desc   = 'Close',
                    key    = 'w',
                    mods   = { 'shift' },
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
                    mods   = { 'shift' },
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
                    mods   = { 'shift' },
                    action = wk.send_keys({}, 'home'),
                },
                {
                    desc   = 'Bottom',
                    key    = 'd',
                    mods   = { 'shift' },
                    action = wk.send_keys({}, 'end'),
                },
                {
                    desc   = 'Search for text',
                    key    = 'f',
                    mods   = { 'shift' },
                    action = {
                        wk.send_keys({'cmd'}, 'f'),
                        wk.turn_eventtap('off'),
                        popups.hide(),
                        wk.temporary_insert()
                    },
                },
                {
                    desc   = 'Reload',
                    key    = 'r',
                    mods   = { 'shift' },
                    action = wk.send_keys({'cmd'}, 'r'),
                },
                {
                    desc   = 'Back',
                    key    = 'u',
                    mods   = { 'shift' },
                    action = wk.send_keys({'cmd'}, '['),
                },
                {
                    desc   = 'Forward',
                    key    = 'o',
                    mods   = { 'shift' },
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
                    mods   = { 'shift' },
                    action = wk.send_keys({'ctrl', 'shift'}, 'pageup'),
                },
                {
                    desc   = 'Swap with right',
                    key    = ';',
                    mods   = { 'shift' },
                    action = wk.send_keys({'ctrl', 'shift'}, 'pagedown'),
                },
                {
                    desc   = 'Search tabs',
                    key    = '/',
                    action = {
                        wk.send_keys({'cmd', 'shift'}, 'a'),
                        wk.turn_eventtap('off'),
                        popups.hide(),
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
                    mods   = { 'shift' },
                    action = wk.send_keys({'cmd', 'shift'}, 't'),
                },
                {
                    desc   = 'Close',
                    key    = 'w',
                    action = wk.send_keys({'cmd'}, 'w'),
                },
            },
        },

        -- Misc
        {
            category = 'Misc',
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
                    desc   = 'Left arrow',
                    key    = 't',
                    action = wk.send_keys({}, 'left'),
                },
                {
                    desc   = 'Right arrow',
                    key    = 'l',
                    action = wk.send_keys({}, 'right'),
                },
                {
                    desc   = 'Focus searchbar',
                    key    = "'",
                    action = {
                        wk.send_keys({'cmd'}, 'l'),
                        wk.turn_eventtap('off'),
                        popups.hide(),
                        wk.temporary_insert()
                    },
                },
                {
                    desc   = 'Add bookmark',
                    key    = 'b',
                    mods   = { 'shift' },
                    action = wk.send_keys({'cmd'}, 'd'),
                },
                {
                    desc   = 'Open history',
                    key    = 'p',
                    mods   = { 'shift' },
                    action = wk.send_keys({'cmd'}, 'h'),
                },
            },
        },
    },
}

return M

