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
-- Misc:
--   Toggle bluetooth
--   Quit app

local brightness = require('brightness')
local wk         = require('which_key')
local win        = require('windows')
local wifi       = require('wifi')

M.apps = {
    -- These are temporarily bound to actions after the eventtap has been
    -- stopped, then unbound once the eventtap is restarted. Therefor they
    -- don't have corresponding actions.
    ----------------------------------------------------------------------------
    ['insert'] = {
    ----------------------------------------------------------------------------
        {
            category = 'Bound until invoked',
            bindings = {
                {   -- return (enter)
                    desc = 'Relaunch menu',
                    key  = 'Enter',
                },
                {   -- escape
                    desc = 'Cancel',
                    key  = 'Escape',
                },
            },
        },
    },

    ----------------------------------------------------------------------------
    ['system'] = {
    ----------------------------------------------------------------------------
        -- Launch or focus
        {
            category = 'Launch or focus',
            bindings = {
                {   -- y
                    desc   = 'Firefox',
                    key    = 'y',
                    action = { wk.hide(), win.launch_or_focus('Firefox'), win.snap(), wk.show() },
                },
                -- {   -- .
                --     desc   = 'kitty',
                --     key    = '.',
                --     action = { wk.hide(), win.launch_or_focus('kitty'), win.snap(), wk.show() },
                -- },
                -- {   -- ,
                --     desc   = 'Brave Browser',
                --     key    = ',',
                --     action = { wk.hide(), win.launch_or_focus('Brave Browser'), win.snap(), wk.show() },
                -- },
            },
        },

        -- Windows
        {
            category = 'Windows',
            bindings = {
                -- {   -- _
                --     desc   = 'DEBUG',
                --     key    = '-', mods = { 'shift' },
                --     action = win.debug_slots(),
                -- },

                {   -- _
                    desc   = 'Cycle cat apps',
                    key    = '-', mods = { 'shift' },
                    action = { wk.hide(), win.cycle_main_apps(), wk.show() },
                },

                {   -- n
                    desc   = 'Cycle next open',
                    key    = 'n',
                    action = { wk.hide(), win.cycle_open('next'), wk.show() },
                },
                {   -- N
                    desc   = 'Cycle prev open',
                    key    = 'n', mods = { 'shift' },
                    action = { wk.hide(), win.cycle_open('prev'), wk.show() },
                },

                {   -- o
                    desc   = 'Next app window',
                    key    = 'o',
                    action = { wk.hide(), win.cycle_app_specific('next'), wk.show() },
                },
                {   -- u
                    desc   = 'Prev app window',
                    key    = 'u',
                    action = { wk.hide(), win.cycle_app_specific('prev'), wk.show() },
                },


                {   -- f
                    desc   = 'Resize right',
                    key    = 'f',
                    action = { wk.hide(), win.resize('right'), win.snap(), wk.show() },
                },
                {   -- s
                    desc   = 'Resize left',
                    key    = 's',
                    action = { wk.hide(), win.resize('left'), win.snap(), wk.show() },
                },
                {   -- g
                    desc   = 'Maximize',
                    key    = 'g',
                    action = { wk.hide(), win.maximize(), win.snap(), wk.show() },
                },
                {   -- G
                    desc   = 'Swap positions',
                    key    = 'g', mods = { 'shift' },
                    action = { wk.hide(), win.swap(), win.snap(), wk.show() },
                },
                {   -- p
                    desc   = 'Move to next screen',
                    key    = 'p',
                    action = { wk.hide(), win.move_to_screen(), win.snap(), wk.show() },
                },
            },
        },

        -- Popups
        {
            category = 'Popups',
            bindings = {
                {   -- R
                    desc   = 'Cycle positions',
                    key    = 'r', mods = { 'shift' },
                    action = { wk.hide(), wk.cycle_corner_pos(), wk.show() },
                },
                {   -- A
                    desc   = 'Cycle menu stacking',
                    key    = 'a', mods = { 'shift' },
                    action = { wk.hide(), wk.cycle_stacking(), wk.show() },
                },
                {   -- O
                    desc   = 'Opacity up',
                    key    = 'o', mods = { 'shift' },
                    action = wk.opacity('up'),
                },
                {   -- U
                    desc   = 'Opacity down',
                    key    = 'u', mods = { 'shift' },
                    action = wk.opacity('down'),
                },
            },
        },

        -- Clipboard
        {
            category = 'Clipboard',
            bindings = {
                {   -- c
                    desc   = 'Copy',
                    key    = 'c',
                    action = wk.send_keys({'cmd'}, 'c'),
                },
                {   -- x
                    desc   = 'Cut',
                    key    = 'x',
                    action = wk.send_keys({'cmd'}, 'x'),
                },
                {   -- v
                    desc   = 'Paste',
                    key    = 'v',
                    action = wk.send_keys({'cmd'}, 'v'),
                },
            },
        },

        -- Brightness
        {
            category = 'Brightness',
            bindings = {
                {   -- z
                    desc   = 'Up',
                    key    = 'z',
                    action = brightness.adjust('up'),
                },
                {   -- j
                    desc   = 'Down',
                    key    = 'j',
                    action = brightness.adjust('down'),
                },
                {   -- P
                    desc   = 'Print',
                    key    = 'p', mods = { 'shift' },
                    action = brightness.print_values(),
                },
            },
        },

        -- Misc
        {
            category = 'Misc',
            bindings = {
                {   -- Z
                    desc   = 'Zoom in',
                    key    = 'z', mods = { 'shift' },
                    action = wk.send_keys({'cmd'}, '='),
                },
                {   -- J
                    desc   = 'Zoom out',
                    key    = 'j', mods = { 'shift' },
                    action = wk.send_keys({'cmd'}, '-'),
                },
                {   -- W
                    desc   = 'Toggle wifi on/off',
                    key    = 'w', mods = { 'shift' },
                    action = wifi.toggle_wifi(),
                },
                {   -- escape
                    desc   = 'Cancel',
                    key    = 'escape',
                    action = { wk.turn_eventtap('off'), wk.hide() },
                },
            },
        },
    },

    ----------------------------------------------------------------------------
    ['kitty'] = {
    ----------------------------------------------------------------------------
        -- Scrollback
        {
            category = 'Scrollback',
            bindings = {
                {   -- e
                    desc   = 'Page up',
                    key    = 'e',
                    action = wk.send_keys({'shift'}, 'pageup'),
                },
                {   -- d
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
                {   -- i
                    desc   = 'Up',
                    key    = 'i',
                    action = wk.send_keys({'ctrl', 'alt'}, 'up'),
                },
                {   -- k
                    desc   = 'Down',
                    key    = 'k',
                    action = wk.send_keys({'ctrl', 'alt'}, 'down'),
                },
                {   -- l
                    desc   = 'Right',
                    key    = 'l',
                    action = wk.send_keys({'ctrl', 'alt'}, 'right'),
                },
                {   -- t
                    desc   = 'Left',
                    key    = 't',
                    action = wk.send_keys({'ctrl', 'alt'}, 'left'),
                },
                {   -- I
                    desc   = 'Resize up',
                    key    = 'i', mods = { 'shift' },
                    action = wk.send_keys({'ctrl', 'alt', 'shift'}, 'up'),
                },
                {   -- K
                    desc   = 'Resize down',
                    key    = 'k', mods = { 'shift' },
                    action = wk.send_keys({'ctrl', 'alt', 'shift'}, 'down'),
                },
                {   -- L
                    desc   = 'Resize right',
                    key    = 'l', mods = { 'shift' },
                    action = wk.send_keys({'ctrl', 'alt', 'shift'}, 'right'),
                },
                {   -- T
                    desc   = 'Resize left',
                    key    = 't', mods = { 'shift' },
                    action = wk.send_keys({'ctrl', 'alt', 'shift'}, 'left'),
                },
                {   -- m
                    desc   = 'New split',
                    key    = 'm',
                    action = wk.send_keys({'cmd', 'ctrl', 'alt'}, 'm'),
                },
                -- {
                --     desc   = 'New window',
                --     key    = 'n', mods = { 'shift' },
                --     action = wk.send_keys({'cmd', 'ctrl', 'alt', 'shift'}, 'm'),
                -- },
                {   -- M
                    desc   = 'Detach split',
                    key    = 'm', mods = { 'shift' },
                    action = wk.send_keys({'cmd', 'ctrl', 'alt', 'shift'}, 'w'),
                },
                {   -- W
                    desc   = 'Close',
                    key    = 'w', mods = { 'shift' },
                    action = wk.send_keys({'cmd', 'shift'}, 'd'),
                },
            },
        },

        -- Tabs
        {
            category = 'Tabs',
            bindings = {
                {   -- ;
                    desc   = 'Next',
                    key    = ';',
                    action = wk.send_keys({'ctrl'}, 'end'),
                },
                {   -- h
                    desc   = 'Previous',
                    key    = 'h',
                    action = wk.send_keys({'ctrl'}, 'home'),
                },
                -- {
                --     desc   = 'Open',
                --     key    = 'n',
                --     action = wk.send_keys({'cmd', 'ctrl', 'alt'}, 'n'),
                -- },
            },
        },

        -- Layout
        {
            category = 'Layout',
            bindings = {
                {   -- R
                    desc   = 'Rotate splits',
                    key    = 'r', mods = { 'shift' },
                    action = wk.send_keys({'cmd', 'ctrl', 'alt'}, 'p'),
                },
                {   -- r
                    desc   = 'Next',
                    key    = 'r',
                    action = wk.send_keys({'cmd', 'ctrl', 'alt', 'shift'}, 'p'),
                },
            },
        },
    },

    ----------------------------------------------------------------------------
    -- brave://settings/system/shortcuts
    --
    ['Brave Browser'] = {
    ----------------------------------------------------------------------------
        -- Page
        {
            category = 'Page',
            bindings = {
                {   -- e
                    desc   = 'Up',
                    key    = 'e',
                    action = wk.send_keys({}, 'pageup'),
                },
                {   -- d
                    desc   = 'Down',
                    key    = 'd',
                    action = wk.send_keys({}, 'pagedown'),
                },
                {   -- E
                    desc   = 'Top',
                    key    = 'e', mods = { 'shift' },
                    action = wk.send_keys({}, 'home'),
                },
                {   -- D
                    desc   = 'Bottom',
                    key    = 'd', mods = { 'shift' },
                    action = wk.send_keys({}, 'end'),
                },
                {   -- F
                    desc   = 'Search for text',
                    key    = 'f', mods = { 'shift' },
                    action = { wk.send_keys({'cmd'}, 'f'), wk.turn_eventtap('off'), wk.hide(), wk.temporary_insert() },
                },
                {   -- R
                    desc   = 'Reload',
                    key    = 'r', mods = { 'shift' },
                    action = wk.send_keys({'cmd'}, 'r'),
                },
                {   -- O
                    desc   = 'Forward',
                    key    = 'o', mods = { 'shift' },
                    action = wk.send_keys({'cmd'}, ']'),
                },
                {   -- U
                    desc   = 'Back',
                    key    = 'u', mods = { 'shift' },
                    action = wk.send_keys({'cmd'}, '['),
                },
            },
        },

        -- Tabs
        {
            category = 'Tabs',
            bindings = {
                {   -- h
                    desc   = 'Left',
                    key    = 'h',
                    action = wk.send_keys({'ctrl'}, 'pageup'),
                },
                {   -- ;
                    desc   = 'Right',
                    key    = ';',
                    action = wk.send_keys({'ctrl'}, 'pagedown'),
                },
                {   -- H
                    desc   = 'Swap with left',
                    key    = 'h', mods = { 'shift' },
                    action = wk.send_keys({'ctrl', 'shift'}, 'pageup'),
                },
                {   -- :
                    desc   = 'Swap with right',
                    key    = ';', mods = { 'shift' },
                    action = wk.send_keys({'ctrl', 'shift'}, 'pagedown'),
                },
                {   -- /
                    desc   = 'Search tabs',
                    key    = '/',
                    action = { wk.send_keys({'cmd', 'shift'}, 'a'), wk.turn_eventtap('off'), wk.hide(), wk.temporary_insert() },
                },
                {   -- m
                    desc   = 'Open',
                    key    = 'm',
                    action = wk.send_keys({'cmd'}, 't'),
                },
                {   -- M
                    desc   = 'Re-open closed',
                    key    = 'm', mods = { 'shift' },
                    action = wk.send_keys({'cmd', 'shift'}, 't'),
                },
                {   -- w
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
                {   -- i
                    desc   = 'Up arrow',
                    key    = 'i',
                    action = wk.send_keys({}, 'up'),
                },
                {   -- k
                    desc   = 'Down arrow',
                    key    = 'k',
                    action = wk.send_keys({}, 'down'),
                },
                {   -- l
                    desc   = 'Focus next',
                    key    = 'l',
                    action = wk.send_keys({}, 'tab'),
                },
                {   -- t
                    desc   = 'Focus prev',
                    key    = 't',
                    action = wk.send_keys({'shift'}, 'tab'),
                },
            },
        },

        -- Misc
        {
            category = 'Misc',
            bindings = {
                {   -- '
                    desc   = 'Focus searchbar',
                    key    = "'",
                    action = { wk.send_keys({'cmd'}, 'l'), wk.turn_eventtap('off'), wk.hide(), wk.temporary_insert() },
                },
                {   -- B
                    desc   = 'Add bookmark',
                    key    = 'b', mods = { 'shift' },
                    action = wk.send_keys({'cmd'}, 'd'),
                },
                {   -- P
                    desc   = 'Open history',
                    key    = 'p', mods = { 'shift' },
                    action = wk.send_keys({'cmd'}, 'h'),
                },
                {   -- return (enter)
                    desc   = 'Confirm',
                    key    = 'return',
                    action = wk.send_keys({}, 'return'),
                },
            },
        },
    },
}

return M
