local M = {}

local brightness = require('brightness')
local window = require('windows')
local which_key = require('which_key')

M.bindings = {

    ['system'] = {
        ---------------------
        -- Launch or focus --
        ---------------------
        {
            category = 'Launch or focus',
            bindings = {
                {
                    key    = 'y',
                    action = 'launch_firefox',
                    desc   = 'Firefox',
                },
                {
                    key    = 'a',
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

        ----------------
        -- Brightness --
        ----------------
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

        ------------
        -- Splits --
        ------------
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

        ----------
        -- Misc --
        ----------
        {
            category = 'Cancel (quit)',
            bindings = {
                {
                    key    = 'escape',
                    action = 'close_menu',
                    desc   = 'Cancel',
                },
            },
        },
    },

    ----------------------------------------------------------------------------

    ['kitty'] = {
        ----------------
        -- Scrollback --
        ----------------
        {
            category = 'Scrollback',
            bindings = {
                {
                    key    = 'e',
                    action = 'scroll_page_up',
                    desc   = 'Page up',
                },
                {
                    key    = 'd',
                    action = 'scroll_page_down',
                    desc   = 'Page down',
                },
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
            },
        },

        ------------
        -- Splits --
        ------------
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

        ----------
        -- Tabs --
        ----------
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

        ------------
        -- Layout --
        ------------
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

    ----------------------------------------------------------------------------

    ['Brave Browser'] = {
        ----------
        -- Tabs --
        ----------
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
                    key    = 'w',
                    action = 'tab_close',
                    desc   = 'Close',
                },
            },
        },

        ----------
        -- Misc --
        ----------
        {
            category = 'Misc',
            bindings = {
                {
                    key    = "'",
                    action = 'focus_searchbar',
                    desc   = 'Focus searchbar',
                },
                {
                    key    = 'u',
                    action = 'left_arrow',
                    desc   = 'Left arrow',
                },
                {
                    key    = 'o',
                    action = 'right_arrow',
                    desc   = 'Right arrow',
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
    -- Brightness:
    --   Up
    --   Down
    --   Print
    --
    -- Wifi:
    --   Toggle (on/off)
    --
    -- Clipboard:
    --   Copy
    --   Cut
    --   Paste
    --
    --
    -- Scrolling:
    --   e  Up
    --   d  Down
    --   s  Left
    --   f  Right
    --
    -- Windows:
    --   ,  Resize_split_left
    --   .  Resize_split_right
    --   m  Maximize_split
    --   n  Win_to_next_screen
    --   p  Swap_splits
    --
    -- Apps:
    --   kitty
    --   b  Brave Browser
    --   Firefox


    ['system'] = {
        -- Launch or focus
        launch_kitty       = function() window.launch_or_focus('kitty') end,
        launch_brave       = function() window.launch_or_focus('Brave Browser') end,
        launch_firefox     = function() window.launch_or_focus('Firefox') end,

        -- Brightness
        brightness_up      = function() brightness.adjust_brightness('up') end,
        brightness_down    = function() brightness.adjust_brightness('down') end,
        brightness_print   = function() brightness.print_values() end,

        -- Splits
        resize_split_left  = function() window.resize_splits('left') end,
        resize_split_right = function() window.resize_splits('right') end,
        maximize_split     = function() window.maximize_split() end,
        swap_splits        = function() window.swap_splits() end,

        -- Misc
        close_menu         = function() which_key.close_menu() end,
    },

    ['kitty'] = {
        -- Scrollback
        scroll_page_up     = function() which_key.send_keys({'shift'}, 'pageup') end,
        scroll_page_down   = function() which_key.send_keys({'shift'}, 'pagedown') end,
        zoom_in            = function() which_key.send_keys({'cmd'}, '=') end,
        zoom_out           = function() which_key.send_keys({'cmd'}, '-') end,

        -- Splits
        new_split          = function() which_key.send_keys({'cmd', 'ctrl', 'alt'}, 'm') end,
        new_os_window      = function() which_key.send_keys({'cmd', 'ctrl', 'alt', 'shift'}, 'm') end,
        focus_split_above  = function() which_key.send_keys({'ctrl', 'alt'}, 'up') end,
        focus_split_below  = function() which_key.send_keys({'ctrl', 'alt'}, 'down') end,
        focus_split_left   = function() which_key.send_keys({'ctrl', 'alt'}, 'left') end,
        focus_split_right  = function() which_key.send_keys({'ctrl', 'alt'}, 'right') end,
        resize_split_up    = function() which_key.send_keys({'ctrl', 'alt', 'shift'}, 'up') end,
        resize_split_down  = function() which_key.send_keys({'ctrl', 'alt', 'shift'}, 'down') end,
        resize_split_left  = function() which_key.send_keys({'ctrl', 'alt', 'shift'}, 'left') end,
        resize_split_right = function() which_key.send_keys({'ctrl', 'alt', 'shift'}, 'right') end,
        detach_split       = function() which_key.send_keys({'cmd', 'ctrl', 'alt', 'shift'}, 'w') end,
        close_split        = function() which_key.send_keys({'cmd', 'shift'}, 'd') end,

        -- Tabs
        next_tab           = function() which_key.send_keys({'ctrl'}, 'end') end,
        prev_tab           = function() which_key.send_keys({'ctrl'}, 'home') end,
        new_tab            = function() which_key.send_keys({'cmd', 'ctrl', 'alt'}, 'n') end,

        -- Layout
        rotate_splits      = function() which_key.send_keys({'cmd', 'ctrl', 'alt'}, 'p') end,
        next_layout        = function() which_key.send_keys({'cmd', 'ctrl', 'alt', 'shift'}, 'p') end,
    },

    ['Brave Browser'] = {
        focus_searchbar = function() which_key.send_keys({'cmd'}, 'l') which_key.close_menu() end,
        left_arrow      = function() which_key.send_keys('left') end,
        right_arrow     = function() which_key.send_keys('right') end,
        tab_left        = function() which_key.send_keys({'ctrl'}, 'pageup') end,
        tab_right       = function() which_key.send_keys({'ctrl'}, 'pagedown') end,
        tab_close       = function() which_key.send_keys({'cmd'}, 'w') end,

        -- scroll_up
        -- scroll_down
        -- scroll_left
        -- scroll_right
        -- page_back       = function() which_key.send_keys('[', 'cmd') end,
        -- page_forward    = function() which_key.send_keys(']', 'cmd') end,
        -- zoom_in         = function() which_key.send_keys('+', 'cmd') end,
        -- zoom_out        = function() which_key.send_keys('-', 'cmd') end,
    },
}

return M
