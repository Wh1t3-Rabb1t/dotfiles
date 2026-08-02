local M = {}

local brightness = require('brightness')
local wk = require('which_key')
local util = require('util')


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
                    action = 'cycle_menu_pos',
                    desc   = 'Cycle positions',
                },
                {
                    key    = 'a',
                    mods   = { 'shift' },
                    action = 'cycle_menu_layout',
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

M.actions = {
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


    ['system'] = {
        -- Launch or focus
        launch_kitty       = function() wk.launch_or_focus('kitty') end,
        launch_brave       = function() wk.launch_or_focus('Brave Browser') end,
        launch_firefox     = function() wk.launch_or_focus('Firefox') end,

        -- Brightness
        brightness_up      = function() brightness.adjust_brightness('up') end,
        brightness_down    = function() brightness.adjust_brightness('down') end,
        brightness_print   = function() brightness.print_values() end,

        -- Splits
        resize_split_left  = function() wk.resize_splits('left') end,
        resize_split_right = function() wk.resize_splits('right') end,
        maximize_split     = function() wk.maximize_split() end,
        swap_splits        = function() wk.swap_splits() end,

        -- Popup
        opacity_up        = function() wk.menu_opacity('up') end,
        opacity_down      = function() wk.menu_opacity('down') end,
        cycle_menu_pos    = function() wk.cycle_menu_pos() end,
        cycle_menu_layout = function() wk.cycle_menu_layout() end,

        -- Misc
        zoom_in            = function() util.queue(wk.send_keys({'cmd'}, '=')) end,
        zoom_out           = function() util.queue(wk.send_keys({'cmd'}, '-')) end,
        close_menu         = function() util.queue(wk.close_menu()) end,
    },

    ['kitty'] = {
        -- Scrollback
        page_up            = function() util.queue(wk.send_keys({'shift'}, 'pageup')) end,
        page_down          = function() util.queue(wk.send_keys({'shift'}, 'pagedown')) end,

        -- Splits
        new_split          = function() util.queue(wk.send_keys({'cmd', 'ctrl', 'alt'}, 'm')) end,
        new_os_window      = function() util.queue(wk.send_keys({'cmd', 'ctrl', 'alt', 'shift'}, 'm')) end,
        focus_split_above  = function() util.queue(wk.send_keys({'ctrl', 'alt'}, 'up')) end,
        focus_split_below  = function() util.queue(wk.send_keys({'ctrl', 'alt'}, 'down')) end,
        focus_split_left   = function() util.queue(wk.send_keys({'ctrl', 'alt'}, 'left')) end,
        focus_split_right  = function() util.queue(wk.send_keys({'ctrl', 'alt'}, 'right')) end,
        resize_split_up    = function() util.queue(wk.send_keys({'ctrl', 'alt', 'shift'}, 'up')) end,
        resize_split_down  = function() util.queue(wk.send_keys({'ctrl', 'alt', 'shift'}, 'down')) end,
        resize_split_left  = function() util.queue(wk.send_keys({'ctrl', 'alt', 'shift'}, 'left')) end,
        resize_split_right = function() util.queue(wk.send_keys({'ctrl', 'alt', 'shift'}, 'right')) end,
        detach_split       = function() util.queue(wk.send_keys({'cmd', 'ctrl', 'alt', 'shift'}, 'w')) end,
        close_split        = function() util.queue(wk.send_keys({'cmd', 'shift'}, 'd')) end,

        -- Tabs
        next_tab           = function() util.queue(wk.send_keys({'ctrl'}, 'end')) end,
        prev_tab           = function() util.queue(wk.send_keys({'ctrl'}, 'home')) end,
        new_tab            = function() util.queue(wk.send_keys({'cmd', 'ctrl', 'alt'}, 'n')) end,

        -- Layout
        rotate_splits      = function() util.queue(wk.send_keys({'cmd', 'ctrl', 'alt'}, 'p')) end,
        next_layout        = function() util.queue(wk.send_keys({'cmd', 'ctrl', 'alt', 'shift'}, 'p')) end,
    },

    ['Brave Browser'] = {
        -- Page
        up_arrow        = function() util.queue(wk.send_keys({}, 'up')) end,
        down_arrow      = function() util.queue(wk.send_keys({}, 'down')) end,
        left_arrow      = function() util.queue(wk.send_keys({}, 'left')) end,
        right_arrow     = function() util.queue(wk.send_keys({}, 'right')) end,
        page_up         = function() util.queue(wk.send_keys({}, 'pageup')) end,
        page_down       = function() util.queue(wk.send_keys({}, 'pagedown')) end,
        page_top        = function() util.queue(wk.send_keys({}, 'home')) end,
        page_bottom     = function() util.queue(wk.send_keys({}, 'end')) end,
        search_text     = function() wk.search_brave_text() end,
        reload          = function() util.queue(wk.send_keys({'cmd'}, 'r')) end,
        back            = function() util.queue(wk.send_keys({'cmd'}, '[')) end,
        forward         = function() util.queue(wk.send_keys({'cmd'}, ']')) end,

        -- Tabs
        tab_left        = function() util.queue(wk.send_keys({'ctrl'}, 'pageup')) end,
        tab_right       = function() util.queue(wk.send_keys({'ctrl'}, 'pagedown')) end,
        move_tab_left   = function() util.queue(wk.send_keys({'ctrl', 'shift'}, 'pageup')) end,
        move_tab_right  = function() util.queue(wk.send_keys({'ctrl', 'shift'}, 'pagedown')) end,
        search_tabs     = function() wk.search_brave_tabs() end,
        new_tab         = function() util.queue(wk.send_keys({'cmd'}, 't')) end,
        reopen_closed   = function() util.queue(wk.send_keys({'cmd', 'shift'}, 't')) end,
        close_tab       = function() util.queue(wk.send_keys({'cmd'}, 'w')) end,

        -- Misc
        focus_searchbar = function() wk.focus_brave_searchbar() end,
        add_bookmark    = function() util.queue(wk.send_keys({'cmd'}, 'd')) end,
        open_history    = function() util.queue(wk.send_keys({'cmd'}, 'h')) end,
    },
}

return M
