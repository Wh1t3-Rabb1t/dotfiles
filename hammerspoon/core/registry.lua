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
            key    = 'o',
            action = 'resize_split_right',
            desc   = 'Re-size splits right',
        },
        {
            key    = 'u',
            action = 'resize_split_left',
            desc   = 'Re-size splits left',
        },
        {
            key    = 'g',
            action = 'maximize_split',
            desc   = 'Maximize focused split',
        },
        {
            key    = 's',
            action = 'swap_splits',
            desc   = 'Swap split positions',
        },
        {
            key    = 'escape',
            action = 'close_menu',
            desc   = 'Cancel',
        },
    },

    ['kitty'] = {
        -- SCROLLBACK
        {
            key    = 'v',
            action = 'paste_from_clipboard',
            desc   = 'Paste from system clipboard',
        },
        {
            key    = 'b',
            action = 'show_last_command_output',
            desc   = 'Open last command output in nvim',
        },
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
        -- {
        --     key    = 'e',
        --     mods   = 'shift',
        --     action = 'page_up',
        --     desc   = 'Scroll up',
        -- },
        -- {
        --     key    = 'd',
        --     mods   = 'shift',
        --     action = 'page_down',
        --     desc   = 'Scroll down',
        -- },
        -- {
        --     key    = 'up',
        --     mods   = 'shift',
        --     action = 'previous_prompt',
        --     desc   = 'Jump to the previous prompt',
        -- },
        -- {
        --     key    = 'down',
        --     mods   = 'shift',
        --     action = 'page_down',
        --     desc   = 'Jump to the next prompt',
        -- },
        -- {
        --     key    = 'k',
        --     mods   = 'shift',
        --     action = 'clear_terminal',
        --     desc   = 'Clear the scrollback',
        -- },

        -- WINDOWS
        {
            key    = 'm',
            action = 'new_split',
            desc   = 'Split the terminal window',
        },
        -- {
        --     key    = 'm',
        --     mods   = 'shift',
        --     action = 'new_os_window',
        --     desc   = 'Open a new terminal window',
        -- },
        {
            key    = 'i',
            action = 'split_above',
            desc   = 'Focus the above split',
        },
        {
            key    = 'k',
            action = 'split_below',
            desc   = 'Focus the below split',
        },
        {
            key    = 'l',
            action = 'split_right',
            desc   = 'Focus the right split',
        },
        {
            key    = 't',
            action = 'split_left',
            desc   = 'Focus the left split',
        },

        -- {
        --     key    = 'i',
        --     mods   = 'shift',
        --     action = 'resize_split_up',
        --     desc   = 'Resize the split up',
        -- },
        -- {
        --     key    = 'k',
        --     mods   = 'shift',
        --     action = 'resize_split_down',
        --     desc   = 'Resize the split down',
        -- },
        -- {
        --     key    = 'l',
        --     mods   = 'shift',
        --     action = 'resize_split_right',
        --     desc   = 'Resize the split right',
        -- },
        -- {
        --     key    = 't',
        --     mods   = 'shift',
        --     action = 'resize_split_left',
        --     desc   = 'Resize the split left',
        -- },

        -- {
        --     key    = 'p',
        --     mods   = 'shift',
        --     action = 'swap_with_split',
        --     desc   = 'Swap split',
        -- },


        {
            key    = 'w',
            action = 'close_split',
            desc   = 'Close split with confirmation',
        },
        -- {
        --     key    = 'w',
        --     mods   = 'shift',
        --     action = 'detach_window',
        --     desc   = 'Detach from parent os window',
        -- },


        -- TABS
        {
            key    = 'n',
            action = 'new_tab',
            desc   = 'Open a new tab',
        },
        -- {
        --     key    = 'n',
        --     mods   = 'shift',
        --     action = 'set_tab_title',
        --     desc   = 'Rename the current tab',
        -- },

        {
            key    = ';',
            action = 'next_tab',
            desc   = 'Next tab',
        },
        {
            key    = 'h',
            action = 'prev_tab',
            desc   = 'Previous tab',
        },

        -- LAYOUT
        -- {
        --     key    = 'r',
        --     mods   = 'shift',
        --     action = 'rotate_splits',
        --     desc   = 'Rotate focused split',
        -- },
        {
            key    = 'r',
            action = 'next_layout',
            desc   = 'Next layout',
        },

        -- ZOOM
        -- {
        --     key    = '=',
        --     mods   = 'cmd',
        --     action = 'zoom_in',
        --     desc   = 'Zoom in',
        -- },
        -- {
        --     key    = '-',
        --     mods   = 'cmd',
        --     action = 'zoom_out',
        --     desc   = 'Zoom out',
        -- },

    },

    ['Brave Browser'] = {
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
        paste_from_clipboard     = function() which_key.send_keys({'alt'}, 'v') end,
        show_last_command_output = function() which_key.send_keys({'alt'}, 'b') end,
        scroll_page_up           = function() which_key.send_keys({'shift'}, 'pageup') end,
        scroll_page_down         = function() which_key.send_keys({'shift'}, 'pagedown') end,
        clear_terminal           = function() which_key.send_keys({'shift'}, 'k') end,
        new_split                = function() which_key.send_keys({'cmd', 'ctrl', 'alt'}, 'm') end,
        new_window               = function() which_key.send_keys({'cmd', 'ctrl', 'alt', 'shift'}, 'm') end,
        split_above              = function() which_key.send_keys({'ctrl', 'alt'}, 'up') end,
        split_below              = function() which_key.send_keys({'ctrl', 'alt'}, 'down') end,
        split_left               = function() which_key.send_keys({'ctrl', 'alt'}, 'left') end,
        split_right              = function() which_key.send_keys({'ctrl', 'alt'}, 'right') end,
        close_split              = function() which_key.send_keys({'cmd', 'ctrl', 'alt'}, 'w') end,
        new_tab                  = function() which_key.send_keys({'cmd', 'ctrl', 'alt'}, 'n') end,
        next_tab                 = function() which_key.send_keys({'ctrl'}, 'end') end,
        prev_tab                 = function() which_key.send_keys({'ctrl'}, 'home') end,
        next_layout              = function() which_key.send_keys({'cmd', 'ctrl', 'alt', 'shift'}, 'p') end,
    },

    ['Brave Browser'] = {
        focus_searchbar = function() which_key.send_keys('cmd', 'l') which_key.close_menu() end,
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


-- # SCROLLBACK
--
-- # LAUNCH IN NVIM:
--     alt+b       show_last_command_output
--     alt+shift+b show_scrollback
-- # PAGE UP/DOWN:
--     e  shift+page_up scroll_page_up
--     d  shift+page_down scroll_page_down
-- # UP/DOWN MULTIPLE LINES AT A TIME:
--     E  page_up combine : scroll_line_up : scroll_line_up : scroll_line_up : scroll_line_up : scroll_line_up : scroll_line_up
--     D  page_down combine : scroll_line_down : scroll_line_down : scroll_line_down : scroll_line_down : scroll_line_down : scroll_line_down
-- # NEXT/PREVIOUS PROMPT:
--     shift+up scroll_to_prompt -1
--     shift+down scroll_to_prompt 1
-- # CLEAR THE TERMINAL SCROLLBACK BY ERASING IT:
--     super+k clear_terminal scrollback active
----------------------------------------------------------------------------
-- # WINDOWS
--
-- # LAUNCH:
--     super+ctrl+alt+m launch --location=split --cwd=current --window-title current
--     super+ctrl+alt+shift+m new_os_window
-- # NAVIGATE:
--     i  ctrl+alt+up neighboring_window top
--     k  ctrl+alt+down neighboring_window bottom
--     t  ctrl+alt+left neighboring_window left
--     l  ctrl+alt+right neighboring_window right
-- # RESIZE:
--     I  ctrl+alt+shift+up kitten relative_resize.py up
--     K  ctrl+alt+shift+down kitten relative_resize.py down
--     T  ctrl+alt+shift+left kitten relative_resize.py left
--     L  ctrl+alt+shift+right kitten relative_resize.py right
-- # SWAP POSITIONS:
--     P  super+ctrl+alt+shift+z swap_with_window
-- # CLOSE:
--     w  super+ctrl+alt+w close_window_with_confirmation
-- # DETACH FROM PARENT OS WINDOW:
--     W  super+ctrl+alt+shift+w detach_window
----------------------------------------------------------------------------
-- # TABS
--
-- # LAUNCH:
--     n  super+ctrl+alt+n new_tab
-- # RENAME:
--     N  super+ctrl+alt+shift+n set_tab_title
-- # NAVIGATE:
--     ;  ctrl+end next_tab
--     h  ctrl+home previous_tab
----------------------------------------------------------------------------
-- # LAYOUT
--
-- # ROTATE THE CURRENT SPLIT:
--     R  super+ctrl+alt+p layout_action rotate
-- # CYCLE LAYOUTS:
--     r  super+ctrl+alt+shift+p next_layout
----------------------------------------------------------------------------
-- # ZOOM
--
-- # WINDOW SPECIFIC:
--     super+equal change_font_size current +1.0
--     super+minus change_font_size current -1.0
-- # UNIVERSAL:
--     super+shift+equal change_font_size all +1.0
--     super+shift+minus change_font_size all -1.0
