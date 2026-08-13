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
    ['insert'] = {
    ----------------------------------------------------------------------------
        -- These are temporarily bound to actions after the eventtap has been
        -- stopped, then unbound once the eventtap is restarted. Therefor they
        -- don't have corresponding actions.
        {
            category = 'Bound until invoked',
            bindings = {
                { 'Enter', 'Relaunch menu' },
                { 'Escape', 'Cancel'       },
            },
        },
    },

    ['system'] = {
    ----------------------------------------------------------------------------
        {
            category = 'Launch or focus',
            bindings = {
                { 'y', 'Firefox', wk.hide(), win.launch_or_focus('Firefox'), win.snap(), wk.show() }
                -- { '', 'Brave Browser', wk.hide(), win.launch_or_focus('Brave Browser'), win.snap(), wk.show() },
                -- { '', 'kitty',         wk.hide(), win.launch_or_focus('kitty'), win.snap(), wk.show()         },
            },
        },
        {
            category = 'Windows',
            bindings = {
                { '_', 'Cycle cat apps',      wk.hide(), win.cycle_main_apps(), wk.show()            },
                { 'n', 'Cycle next open',     wk.hide(), win.cycle_open('next'), wk.show()           },
                { 'N', 'Cycle prev open',     wk.hide(), win.cycle_open('prev'), wk.show()           },
                { 'o', 'Next app window',     wk.hide(), win.cycle_app_specific('next'), wk.show()   },
                { 'u', 'Prev app window',     wk.hide(), win.cycle_app_specific('prev'), wk.show()   },
                { 'f', 'Resize right',        wk.hide(), win.resize('right'), win.snap(), wk.show()  },
                { 's', 'Resize left',         wk.hide(), win.resize('left'), win.snap(), wk.show()   },
                { 'g', 'Maximize',            wk.hide(), win.maximize(), win.snap(), wk.show()       },
                { 'G', 'Swap positions',      wk.hide(), win.swap(), win.snap(), wk.show()           },
                { 'p', 'Move to next screen', wk.hide(), win.move_to_screen(), win.snap(), wk.show() }
            },
        },
        {
            category = 'Popups',
            bindings = {
                { 'R', 'Cycle positions',     wk.hide(), wk.cycle_corner_pos(), wk.show() },
                { 'A', 'Cycle menu stacking', wk.hide(), wk.cycle_stacking(), wk.show()   },
                { 'O', 'Opacity up',          wk.opacity('up')                            },
                { 'U', 'Opacity down',        wk.opacity('down')                          }
            },
        },
        {
            category = 'Clipboard',
            bindings = {
                { 'c', 'Copy',   wk.send_keys({'cmd'}, 'c') },
                { 'x', 'Cut',    wk.send_keys({'cmd'}, 'x') },
                { 'v', 'Paste',  wk.send_keys({'cmd'}, 'v') }
            },
        },
        {
            category = 'Brightness',
            bindings = {
                { 'z', 'Up',    brightness.adjust('up')   },
                { 'j', 'Down',  brightness.adjust('down') },
                { 'P', 'Print', brightness.print_values() }
            },
        },
        {
            category = 'Misc',
            bindings = {
                { 'Z',      'Zoom in',            wk.send_keys({'cmd'}, '=')         },
                { 'J',      'Zoom out',           wk.send_keys({'cmd'}, '-')         },
                { 'W',      'Toggle wifi on/off', wifi.toggle_wifi()                 },
                { 'escape', 'Cancel',             wk.turn_eventtap('off'), wk.hide() }
            },
        },
    },

    ['kitty'] = {
    ----------------------------------------------------------------------------
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
                { 'i', 'Up',           wk.send_keys({'ctrl', 'alt'}, 'up') },
                { 'k', 'Down',         wk.send_keys({'ctrl', 'alt'}, 'down') },
                { 'l', 'Right',        wk.send_keys({'ctrl', 'alt'}, 'right') },
                { 't', 'Left',         wk.send_keys({'ctrl', 'alt'}, 'left') },
                { 'I', 'Resize up',    wk.send_keys({'ctrl', 'alt', 'shift'}, 'up') },
                { 'K', 'Resize down',  wk.send_keys({'ctrl', 'alt', 'shift'}, 'down') },
                { 'L', 'Resize right', wk.send_keys({'ctrl', 'alt', 'shift'}, 'right') },
                { 'T', 'Resize left',  wk.send_keys({'ctrl', 'alt', 'shift'}, 'left') },
                { 'm', 'New split',    wk.send_keys({'cmd', 'ctrl', 'alt'}, 'm') },
                -- { '', 'New window',   wk.send_keys({'cmd', 'ctrl', 'alt', 'shift'}, 'm') },
                { 'M', 'Detach split', wk.send_keys({'cmd', 'ctrl', 'alt', 'shift'}, 'w') },
                { 'W', 'Close',        wk.send_keys({'cmd', 'shift'}, 'd') }
            },
        },
        {
            category = 'Tabs',
            bindings = {
                { ';', 'Next',     wk.send_keys({'ctrl'}, 'end')  },
                { 'h', 'Previous', wk.send_keys({'ctrl'}, 'home') }
                -- bind('', 'Open',     wk.send_keys({'ctrl'}, 'home'))
            },
        },
        {
            category = 'Layout',
            bindings = {
                { 'R', 'Rotate splits', wk.send_keys({'cmd', 'ctrl', 'alt'}, 'p')  },
                { 'r', 'Next layout',   wk.send_keys({'cmd', 'ctrl', 'alt', 'shift'}, 'p') }
            },
        },
    },

    ['Brave Browser'] = {
    ----------------------------------------------------------------------------
        -- brave://settings/system/shortcuts
        {
            category = 'Page',
            bindings = {
                { 'e', 'Up',      wk.send_keys({}, 'pageup') },
                { 'd', 'Down',    wk.send_keys({}, 'pagedown') },
                { 'E', 'Top',     wk.send_keys({}, 'home') },
                { 'D', 'Bottom',  wk.send_keys({}, 'end') },
                { 'F', 'Search',  wk.send_keys({'cmd'}, 'f'), wk.turn_eventtap('off'), wk.hide(), wk.temporary_insert() },
                { 'R', 'Reload',  wk.send_keys({'cmd'}, 'r') }
                -- { '', 'Forward', wk.send_keys({'cmd'}, ']') },
                -- { '', 'Back',    wk.send_keys({'cmd'}, '[') },
            },
        },
        {
            category = 'Tabs',
            bindings = {
                { 'h', 'Left',            wk.send_keys({'ctrl'}, 'pageup') },
                { ';', 'Right',           wk.send_keys({'ctrl'}, 'pagedown') },
                { 'H', 'Swap with left',  wk.send_keys({'ctrl', 'shift'}, 'pageup') },
                { ':', 'Swap with right', wk.send_keys({'ctrl', 'shift'}, 'pagedown') },
                { '/', 'Search tabs',     wk.send_keys({'cmd', 'shift'}, 'a'), wk.turn_eventtap('off'), wk.hide(), wk.temporary_insert() },
                { 'm', 'Open',            wk.send_keys({'cmd'}, 't') },
                { 'M', 'Re-open closed',  wk.send_keys({'cmd', 'shift'}, 't') },
                { 'w', 'Close',           wk.send_keys({'cmd'}, 'w') }
            },
        },
        {
            category = 'Navigation',
            bindings = {
                { 'i', 'Up arrow',    wk.send_keys({}, 'up') },
                { 'k', 'Down arrow',  wk.send_keys({}, 'down') },
                { 'l', 'Focus next',  wk.send_keys({}, 'tab') },
                { 't', 'Focus prev',  wk.send_keys({'shift'}, 'tab') }
            },
        },
        {
            category = 'Misc',
            bindings = {
                { "'",      'Focus searchbar', wk.send_keys({'cmd'}, 'l'), wk.turn_eventtap('off'), wk.hide(), wk.temporary_insert() },
                { 'b',      'Add bookmark',    wk.send_keys({'cmd'}, 'd') },
                { 'P',      'Open history',    wk.send_keys({'cmd'}, 'h') },
                { 'return', 'Confirm',         wk.send_keys({}, 'return') }
            },
        },
    },
}

return M
