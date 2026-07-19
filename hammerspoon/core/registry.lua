local M = {}

local shader = require('brightness')
local window = require('windows')
local which_key = require('which_key')

M.bindings = {
    ['system'] = {
        {
            key    = 'y',
            action = 'launch_firefox',
            desc   = 'Launch Firefox',
        },
        {
            key    = 'z',
            action = 'brightness_up',
            desc   = 'Brightness Up',
        },
        {
            key    = 'j',
            action = 'brightness_down',
            desc   = 'Brightness Down',
        },
        {
            key    = 'p',
            action = 'brightness_print',
            desc   = 'Print Brightness',
        },
        {
            key    = 'l',
            action = 'resize_split_right',
            desc   = 'Re-size splits right',
        },
        {
            key    = 't',
            action = 'resize_split_left',
            desc   = 'Re-size splits left',
        },
        {
            key    = 'm',
            action = 'maximize_split',
            desc   = 'Maximize focused split',
        },
        {
            key    = 's',
            action = 'swap_splits',
            desc   = 'Swap split positions',
        },
        {
            key    = 'k',
            action = 'launch_kitty',
            desc   = 'Launch kitty',
        },
        {
            key    = 'b',
            action = 'launch_brave',
            desc   = 'Launch Brave',
        },
        {
            key    = 'escape',
            action = 'close_menu',
            desc   = 'Cancel',
        },
    },

    ['kitty'] = {
        {
            key    = 'a',
            action = 'kitty_open_split',
            desc   = 'New split',
        },
        {
            key    = 'q',
            action = 'kitty_close_split',
            desc   = 'Close split',
        },
    },

    ['Brave Browser'] = {
        {
            key    = "'",
            action = 'focus_searchbar',
            desc   = 'Focus searchbar',
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
            key    = 'h',
            action = 'tab_left',
            desc   = 'Tab left',
        },
        {
            key    = ';',
            action = 'tab_right',
            desc   = 'Tab right',
        },
        {
            key    = 'w',
            action = 'tab_close',
            desc   = 'Close tab',
        },
    },
}

M.actions = {
    ['system'] = {
        brightness_up      = function() shader.adjust_brightness('up') end,
        brightness_down    = function() shader.adjust_brightness('down') end,
        brightness_print   = function() shader.print_values() end,
        resize_split_left  = function() window.resize_splits('left') end,
        resize_split_right = function() window.resize_splits('right') end,
        maximize_split     = function() window.maximize_split() end,
        swap_splits        = function() window.swap_splits() end,
        launch_kitty       = function() window.launch_or_focus('kitty') end,
        launch_brave       = function() window.launch_or_focus('Brave Browser') end,
        launch_firefox     = function() window.launch_or_focus('Firefox') end,
        close_menu         = function() which_key.close_menu() end,
    },

    ['kitty'] = {
        kitty_open_split  = function() window.launch_or_focus('Firefox') end,
        kitty_close_split = function() which_key.close_menu(hs.window.focusedWindow()) end,
    },

    ['Brave Browser'] = {
        focus_searchbar = function() which_key.send_keys('l', 'cmd') M.close_menu() end,
        left_arrow      = function() which_key.send_keys('left') end,
        right_arrow     = function() which_key.send_keys('right') end,
        tab_left        = function() which_key.send_keys('pageup', 'ctrl') end,
        tab_right       = function() which_key.send_keys('pagedown', 'ctrl') end,
        tab_close       = function() which_key.send_keys('w', 'cmd') end,
    },
}

return M
