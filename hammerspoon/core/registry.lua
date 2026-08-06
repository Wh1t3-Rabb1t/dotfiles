local M = {}

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
                    key  = 'Enter',
                    desc = 'Relaunch menu',
                },
                {
                    key  = 'Escape',
                    desc = 'Cancel',
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
                    key    = 'y',
                    action = 'launch_firefox',
                    desc   = 'Firefox',
                },
                {
                    key    = 'v',
                    action = 'launch_kitty',
                    desc   = 'kitty',
                },
                {
                    key    = 'b',
                    action = 'launch_brave',
                    desc   = 'Brave Browser',
                },
            },
        },

        -- Brightness
        {
            category = 'Brightness',
            bindings = {
                {
                    key    = 'z',
                    action = 'brightness_up',
                    desc   = 'Up',
                },
                {
                    key    = 'j',
                    action = 'brightness_down',
                    desc   = 'Down',
                },
                {
                    key    = 'p',
                    action = 'brightness_print',
                    desc   = 'Print',
                },
            },
        },

        -- Splits
        {
            category = 'Splits',
            bindings = {
                {
                    key    = 'o',
                    action = 'resize_split_right',
                    desc   = 'Resize right',
                },
                {
                    key    = 'u',
                    action = 'resize_split_left',
                    desc   = 'Resize left',
                },
                {
                    key    = 'g',
                    action = 'maximize_split',
                    desc   = 'Maximize',
                },
                {
                    key    = 's',
                    action = 'swap_splits',
                    desc   = 'Swap positions',
                },
            },
        },

        -- Popups
        {
            category = 'Popups',
            bindings = {
                {
                    key    = 'r',
                    mods   = { 'shift' },
                    action = 'cycle_corner_pos',
                    desc   = 'Cycle positions',
                },
                {
                    key    = 'a',
                    mods   = { 'shift' },
                    action = 'cycle_stacking',
                    desc   = 'Cycle menu stacking',
                },
                {
                    key    = 'r',
                    action = 'opacity_up',
                    desc   = 'Opacity up',
                },
                {
                    key    = 'f',
                    action = 'opacity_down',
                    desc   = 'Opacity down',
                },
            },
        },

        -- Misc
        {
            category = 'Misc',
            bindings = {
                {
                    key    = 'z',
                    mods   = { 'shift' },
                    action = 'zoom_in',
                    desc   = 'Zoom in',
                },
                {
                    key    = 'j',
                    mods   = { 'shift' },
                    action = 'zoom_out',
                    desc   = 'Zoom out',
                },
                {
                    key    = 'w',
                    action = 'toggle_wifi',
                    desc   = 'Toggle wifi on/off',
                },
                {
                    key    = 'escape',
                    action = 'close_menu',
                    desc   = 'Cancel',
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
                    key    = 'e',
                    action = 'page_up',
                    desc   = 'Page up',
                },
                {
                    key    = 'd',
                    action = 'page_down',
                    desc   = 'Page down',
                },
            },
        },

        -- Splits
        {
            category = 'Splits',
            bindings = {
                {
                    key    = 'i',
                    action = 'focus_split_above',
                    desc   = 'Up',
                },
                {
                    key    = 'k',
                    action = 'focus_split_below',
                    desc   = 'Down',
                },
                {
                    key    = 'l',
                    action = 'focus_split_right',
                    desc   = 'Right',
                },
                {
                    key    = 't',
                    action = 'focus_split_left',
                    desc   = 'Left',
                },
                {
                    key    = 'i',
                    mods   = { 'shift' },
                    action = 'resize_split_up',
                    desc   = 'Resize up',
                },
                {
                    key    = 'k',
                    mods   = { 'shift' },
                    action = 'resize_split_down',
                    desc   = 'Resize down',
                },
                {
                    key    = 'l',
                    mods   = { 'shift' },
                    action = 'resize_split_right',
                    desc   = 'Resize right',
                },
                {
                    key    = 't',
                    mods   = { 'shift' },
                    action = 'resize_split_left',
                    desc   = 'Resize left',
                },
                {
                    key    = 'm',
                    action = 'new_split',
                    desc   = 'New split',
                },
                {
                    key    = 'm',
                    mods   = { 'shift' },
                    action = 'new_os_window',
                    desc   = 'New window',
                },
                {
                    key    = 'n',
                    mods   = { 'shift' },
                    action = 'detach_split',
                    desc   = 'Detach split',
                },
                {
                    key    = 'w',
                    mods   = { 'shift' },
                    action = 'close_split',
                    desc   = 'Close',
                },
            },
        },

        -- Tabs
        {
            category = 'Tabs',
            bindings = {
                {
                    key    = ';',
                    action = 'next_tab',
                    desc   = 'Next',
                },
                {
                    key    = 'h',
                    action = 'prev_tab',
                    desc   = 'Previous',
                },
                {
                    key    = 'n',
                    action = 'new_tab',
                    desc   = 'Open',
                },
            },
        },

        -- Layout
        {
            category = 'Layout',
            bindings = {
                {
                    key    = 'r',
                    mods   = { 'shift' },
                    action = 'rotate_splits',
                    desc   = 'Rotate split',
                },
                {
                    key    = 'r',
                    action = 'next_layout',
                    desc   = 'Next',
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
                    key    = 'i',
                    action = 'up_arrow',
                    desc   = 'Up arrow',
                },
                {
                    key    = 'k',
                    action = 'down_arrow',
                    desc   = 'Down arrow',
                },
                {
                    key    = 't',
                    action = 'left_arrow',
                    desc   = 'Left arrow',
                },
                {
                    key    = 'l',
                    action = 'right_arrow',
                    desc   = 'Right arrow',
                },
                {
                    key    = 'e',
                    action = 'page_up',
                    desc   = 'Up',
                },
                {
                    key    = 'd',
                    action = 'page_down',
                    desc   = 'Down',
                },
                {
                    key    = 'e',
                    mods   = { 'shift' },
                    action = 'page_top',
                    desc   = 'Top',
                },
                {
                    key    = 'd',
                    mods   = { 'shift' },
                    action = 'page_bottom',
                    desc   = 'Bottom',
                },
                {
                    key    = 'f',
                    mods   = { 'shift' },
                    action = 'search_text',
                    desc   = 'Search for text',
                },
                {
                    key    = 'r',
                    mods   = { 'shift' },
                    action = 'reload',
                    desc   = 'Reload',
                },
                {
                    key    = 'u',
                    mods   = { 'shift' },
                    action = 'back',
                    desc   = 'Back',
                },
                {
                    key    = 'o',
                    mods   = { 'shift' },
                    action = 'forward',
                    desc   = 'Forward',
                },
            },
        },

        -- Tabs
        {
            category = 'Tabs',
            bindings = {
                {
                    key    = 'h',
                    action = 'tab_left',
                    desc   = 'Left',
                },
                {
                    key    = ';',
                    action = 'tab_right',
                    desc   = 'Right',
                },
                {
                    key    = 'h',
                    mods   = { 'shift' },
                    action = 'move_tab_left',
                    desc   = 'Swap with left',
                },
                {
                    key    = ';',
                    mods   = { 'shift' },
                    action = 'move_tab_right',
                    desc   = 'Swap with right',
                },
                {
                    key    = '/',
                    action = 'search_tabs',
                    desc   = 'Search tabs',
                },
                {
                    key    = 'm',
                    action = 'new_tab',
                    desc   = 'Open',
                },
                {
                    key    = 'm',
                    mods   = { 'shift' },
                    action = 'reopen_closed',
                    desc   = 'Re-open closed',
                },
                {
                    key    = 'w',
                    action = 'close_tab',
                    desc   = 'Close',
                },
            },
        },

        -- Misc
        {
            category = 'Misc',
            bindings = {
                {
                    key    = "'",
                    action = 'focus_searchbar',
                    desc   = 'Focus searchbar',
                },
                {
                    key    = 'b',
                    mods   = { 'shift' },
                    action = 'add_bookmark',
                    desc   = 'Add bookmark',
                },
                {
                    key    = 'p',
                    mods   = { 'shift' },
                    action = 'open_history',
                    desc   = 'Open history',
                },
            },
        },
    },
}


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
-- Wifi:
--   Toggle (on/off)
--
-- Clipboard:
--   Copy
--   Cut
--   Paste
--
-- Windows:
--   n  Win_to_next_screen
M.actions = {
    ['system'] = {
        -- Launch or focus
        launch_kitty = {
            popups.hide(),
            splits.launch_or_focus('kitty'),
            splits.snap_new(),
            popups.show()
        },
        launch_brave = {
            popups.hide(),
            splits.launch_or_focus('Brave Browser'),
            splits.snap_new(),
            popups.show()
        },
        launch_firefox = {
            popups.hide(),
            splits.launch_or_focus('Firefox'),
            splits.snap_new(),
            popups.show()
        },

        -- Brightness
        brightness_up    = brightness.adjust('up'),
        brightness_down  = brightness.adjust('down'),
        brightness_print = brightness.print_values(),

        -- Splits
        maximize_split = {
            popups.hide(),
            splits.maximize(),
            popups.show()
        },
        swap_splits = {
            popups.hide(),
            splits.swap(),
            splits.snap('split'),
            popups.show()
        },
        resize_split_left = {
            splits.resize('left'),
            splits.snap('split')
        },
        resize_split_right = {
            splits.resize('right'),
            splits.snap('split')
        },

        -- Popup
        opacity_up       = popups.opacity('up'),
        opacity_down     = popups.opacity('down'),
        cycle_corner_pos = {
            popups.hide(),
            popups.cycle_corner_pos(),
            popups.show()
        },
        cycle_stacking = {
            popups.hide(),
            popups.cycle_stacking(),
            popups.show()
        },

        -- Misc
        zoom_in     = wk.send_keys({'cmd'}, '='),
        zoom_out    = wk.send_keys({'cmd'}, '-'),
        toggle_wifi = wifi.toggle_wifi(),
        close_menu  = {
            wk.turn_eventtap('off'),
            popups.hide()
        },
    },

    ['kitty'] = {
        -- Scrollback
        page_up            = wk.send_keys({'shift'}, 'pageup'),
        page_down          = wk.send_keys({'shift'}, 'pagedown'),

        -- Splits
        new_split          = wk.send_keys({'cmd', 'ctrl', 'alt'}, 'm'),
        new_os_window      = wk.send_keys({'cmd', 'ctrl', 'alt', 'shift'}, 'm'),
        focus_split_above  = wk.send_keys({'ctrl', 'alt'}, 'up'),
        focus_split_below  = wk.send_keys({'ctrl', 'alt'}, 'down'),
        focus_split_left   = wk.send_keys({'ctrl', 'alt'}, 'left'),
        focus_split_right  = wk.send_keys({'ctrl', 'alt'}, 'right'),
        resize_split_up    = wk.send_keys({'ctrl', 'alt', 'shift'}, 'up'),
        resize_split_down  = wk.send_keys({'ctrl', 'alt', 'shift'}, 'down'),
        resize_split_left  = wk.send_keys({'ctrl', 'alt', 'shift'}, 'left'),
        resize_split_right = wk.send_keys({'ctrl', 'alt', 'shift'}, 'right'),
        detach_split       = wk.send_keys({'cmd', 'ctrl', 'alt', 'shift'}, 'w'),
        close_split        = wk.send_keys({'cmd', 'shift'}, 'd'),

        -- Tabs
        next_tab           = wk.send_keys({'ctrl'}, 'end'),
        prev_tab           = wk.send_keys({'ctrl'}, 'home'),
        new_tab            = wk.send_keys({'cmd', 'ctrl', 'alt'}, 'n'),

        -- Layout
        rotate_splits      = wk.send_keys({'cmd', 'ctrl', 'alt'}, 'p'),
        next_layout        = wk.send_keys({'cmd', 'ctrl', 'alt', 'shift'}, 'p'),
    },

    ['Brave Browser'] = {
        -- Page
        up_arrow    = wk.send_keys({}, 'up'),
        down_arrow  = wk.send_keys({}, 'down'),
        left_arrow  = wk.send_keys({}, 'left'),
        right_arrow = wk.send_keys({}, 'right'),
        page_up     = wk.send_keys({}, 'pageup'),
        page_down   = wk.send_keys({}, 'pagedown'),
        page_top    = wk.send_keys({}, 'home'),
        page_bottom = wk.send_keys({}, 'end'),
        search_text = {
            wk.send_keys({'cmd'}, 'f'),
            wk.turn_eventtap('off'),
            popups.hide(),
            wk.temporary_insert()
        },
        reload  = wk.send_keys({'cmd'}, 'r'),
        back    = wk.send_keys({'cmd'}, '['),
        forward = wk.send_keys({'cmd'}, ']'),

        -- Tabs
        tab_left       = wk.send_keys({'ctrl'}, 'pageup'),
        tab_right      = wk.send_keys({'ctrl'}, 'pagedown'),
        move_tab_left  = wk.send_keys({'ctrl', 'shift'}, 'pageup'),
        move_tab_right = wk.send_keys({'ctrl', 'shift'}, 'pagedown'),
        search_tabs    = {
            wk.send_keys({'cmd', 'shift'}, 'a'),
            wk.turn_eventtap('off'),
            popups.hide(),
            wk.temporary_insert()
        },
        new_tab       = wk.send_keys({'cmd'}, 't'),
        reopen_closed = wk.send_keys({'cmd', 'shift'}, 't'),
        close_tab     = wk.send_keys({'cmd'}, 'w'),

        -- Misc
        focus_searchbar = {
            wk.send_keys({'cmd'}, 'l'),
            wk.turn_eventtap('off'),
            popups.hide(),
            wk.temporary_insert()
        },
        add_bookmark = wk.send_keys({'cmd'}, 'd'),
        open_history = wk.send_keys({'cmd'}, 'h'),
    },
}

return M
