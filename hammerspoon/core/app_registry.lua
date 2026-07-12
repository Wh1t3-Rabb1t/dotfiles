local M = {}

local shader = require('shaders')
local layout = require('layout')
local sys_menu = require('sys_menu')

M.apps = {
    -------------------
    -- Brave Browser --
    -------------------
    brave_browser = {
        title = 'brave_browser',
        app_name = 'Brave Browser',
        bindings = {
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
        assets = {
            canvas = false,
        },
    },

    ------------
    -- System --
    ------------
    system = {
        title = 'system',
        app_name = 'system',
        bindings = {
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
                action = 'resize_split_left',
                desc   = 'Re-size splits right',
            },
            {
                key    = 't',
                action = 'resize_split_right',
                desc   = 'Re-size splits left',
            },
            {
                key    = 'm',
                action = 'maximize_window',
                desc   = 'Maximize window',
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
        assets = {
            canvas = false,
        },
    },
}

M.actions = {
    ------------
    -- System --
    ------------
    system = {
        brightness_up      = function() shader.adjust_brightness('up') end,
        brightness_down    = function() shader.adjust_brightness('down') end,
        brightness_print   = function() shader.print_values() end,
        resize_split_left  = function() layout.move_window_divider('left') end,
        resize_split_right = function() layout.move_window_divider('right') end,
        maximize           = function() layout.maximize_window() end,
        swap_splits        = function() layout.swap_splits() end,
        launch_kitty       = function() layout.launch_or_focus('kitty') end,
        launch_brave       = function() layout.launch_or_focus('Brave Browser') end,
        close_menu         = function() sys_menu.close_menu() end,
    },

    -------------------
    -- Brave Browser --
    -------------------
    brave_browser = {
        focus_searchbar = function() sys_menu.send_keys('l', 'cmd') M.close_menu() end,
        left_arrow      = function() sys_menu.send_keys('left') end,
        right_arrow     = function() sys_menu.send_keys('right') end,
        tab_left        = function() sys_menu.send_keys('pageup', 'ctrl') end,
        tab_right       = function() sys_menu.send_keys('pagedown', 'ctrl') end,
        tab_close       = function() sys_menu.send_keys('w', 'cmd') end,
    },
}

return M
