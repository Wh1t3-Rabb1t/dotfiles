local M = {}

local wk         = require('wk')
local brightness = require('brightness')
local wifi       = require('wifi')
local util       = require('util')


--------------------------------------------------------------------------------
-- Bindings for each registered app
--------------------------------------------------------------------------------
M.apps = {
    -- These are temporarily bound to actions after the eventtap has been
    -- stopped, then unbound once the eventtap is restarted. Therefor they
    -- don't have corresponding actions.

    -------------------+
    ['system'] = {  -- |
    -------------------+
        -- MacOS default keybindings:  https://support.apple.com/en-ca/102650
        -- {
        --     category = 'Launch or focus',
        --     bindings = bind(
        --         { 'y', 'Firefox', wk.hide(), win.launch_or_focus('Firefox'), wk.show() }
        --     ),
        -- },
        {
            category = 'Windows',
            bindings = util.bind(
                -- { '_', 'Prev app',        wk.cycle_all_apps('prev'),     wk.refresh_state() },
                -- { '-', 'To next screen',  wk.move_to_screen(),           wk.refresh_state() },
                -- { 'o', 'Next app window', wk.cycle_app_specific('next'), wk.refresh_state() },
                -- { 'u', 'Prev app window', wk.cycle_app_specific('prev'), wk.refresh_state() },


                { '_', 'To left slot',   wk.move_to_slot('left')                        },
                { '-', 'To right slot',  wk.move_to_slot('right')                       },
                -- { '-', 'db',  wk.debug_wins()                       },
                -- { '-', 'db',  wk.debug_screens()                       },

                -- { '_', 'Cycle cat apps', wk.cycle_main_apps()                           },
                -- { '-', 'Next app',       wk.cycle_all_apps('next')                      },
                { 'o', 'Next slot',      wk.traverse_slots('next')                      },
                { 'u', 'Prev slot',      wk.traverse_slots('prev')                      },
                { 'O', 'Next window',    wk.cycle_open('next')                          },
                { 'U', 'Prev window',    wk.cycle_open('prev')                          },
                { 'n', 'Open window',    wk.send_keys({'cmd'}, 'n'), wk.refresh_state() },
                { 'm', 'Open tab',       wk.send_keys({'cmd'}, 't'), wk.refresh_state() },
                { 'W', 'Close tab',      wk.send_keys({'cmd'}, 'w'), wk.refresh_state() }
            ),
        },
        {
            category = 'Layout',
            bindings = util.bind(
                { 'f', 'Resize right',   wk.resize('right') },
                { 's', 'Resize left',    wk.resize('left')  },
                { 'g', 'Maximize',       wk.maximize()      },
                { 'G', 'Swap positions', wk.swap()          }
            ),
        },
        {
            category = 'Popups',
            bindings = util.bind(
                { 'R', 'Cycle positions',     wk.cycle_corner_pos() },
                { 'A', 'Cycle menu stacking', wk.cycle_stacking()   },
                { 'V', 'Opacity up',          wk.opacity('up')      },
                { 'Y', 'Opacity down',        wk.opacity('down')    }
            ),
        },
        {
            category = 'Clipboard',
            bindings = util.bind(
                { 'c', 'Copy',  wk.send_keys({'cmd'}, 'c') },
                { 'x', 'Cut',   wk.send_keys({'cmd'}, 'x') },
                { 'v', 'Paste', wk.send_keys({'cmd'}, 'v') }
            ),
        },
        {
            category = 'Brightness',
            bindings = util.bind(
                { 'z', 'Up',    brightness.adjust('up')   },
                { 'j', 'Down',  brightness.adjust('down') },
                { 'P', 'Print', brightness.print_values() }
            ),
        },
        {
            category = 'Misc',
            bindings = util.bind(
                { 'Z',      'Zoom in',            wk.send_keys({'cmd'}, '=') },
                { 'J',      'Zoom out',           wk.send_keys({'cmd'}, '-') },
                { 'X',      'Toggle wifi on/off', wifi.toggle_wifi()         },
                { 'escape', 'Cancel',             wk.quit()                  }
            ),
        },
    },

    --------------------------+
    ['Brave Browser'] = {  -- |
    --------------------------+
        -- brave://settings/system/shortcuts
        --
        -- Test these:
        --   Dev tools inspect                (Command Shift c|Command Alt c)
        --   Dev tools toggle                 F12
        --   Move Tab to New Window
        --   New Split View with Current Tab  Command Alt n
        --   Find next                        Command g
        --   Find previous                    Command Shift g
        --   Stop                             Command .
        --   New Private Window               Command Shift n
        --   Reopen Closed Tab                Command Shift t
        --   New Split View with Current Tab  Command Alt n
        --   Collapse Tabs                    Command Shift l
        --   Add new tab to group             Command Control c
        --   Create new tab group             Command Control p
        --   Focus next tab group             Command Control x
        --   Focus previous tab group         Command Control z
        --   Close tab group                  Command Control w
        --   View Source                      Command Alt u
        --   Focus next pane                  Command Alt ArrowDown
        --   Focus previous pane              Command Alt ArrowUp
        --   Developer Tools                  Command Alt i
        --   JavaScript Console               Command Alt j
        --   Show Bookmarks Bar               Command Shift b
        --   Show history                     Command y
        --   Show bookmark manager            Command Alt b
        --   Options                          Command ,
        --   Reading Mode                     Command Alt r
        --   New Private Window with Tor      Command Alt n
        --   Toggle tab mute                  Control m
        --   Toggle sidebar                   Command b
        --   Quick Commands                   Command Shift p
        --   Remove tab from current group
        --   Unsplit Tabs
        --   Swap Tab Positions
        --   Toggle sidebar position
        --   Focus web contents pane
        --   Take Screenshot
        --   Focus bookmarks
        --   Show all windows
        --   Name Window
        --   Open in PWA window
        --   Move Tab to New Window
        --   Mute site
        --   Pin tab
        --   Group tab
        --   Open Guest Profile
        --   Toggle Focus Mode
        --   Focus toolbar
        --   Focus menu bar
        --   Inspect Devices
        --   Show performance settings
        --   Task Manager
        --   Open all bookmarks
        --   Open Bookmarks Manager
        --   Bookmark bar add to bookmarks bar
        --   Bookmark bar remove from bookmarks bar
        --   Toggle JavaScript
        --   Move group to new window
        --   Toggle vertical tabs expanded
        {
            category = 'Page',
            bindings = util.bind(
                { 'e', 'Up',      wk.send_keys({}, 'pageup')              },
                { 'd', 'Down',    wk.send_keys({}, 'pagedown')            },
                { 'E', 'Top',     wk.send_keys({}, 'home')                },
                { 'D', 'Bottom',  wk.send_keys({}, 'end')                 },
                { 'F', 'Search',  wk.send_keys({'cmd'}, 'f'), wk.insert() },
                { 'R', 'Reload',  wk.send_keys({'cmd'}, 'r')              }

                -- { '', 'Forward', wk.send_keys({'cmd'}, ']') },
                -- { '', 'Back',    wk.send_keys({'cmd'}, '[') },
            ),
        },
        {
            category = 'Tabs',
            bindings = util.bind(
                { 'h', 'Left',            wk.send_keys({'ctrl'}, 'pageup')                 },
                { ';', 'Right',           wk.send_keys({'ctrl'}, 'pagedown')               },
                { 'H', 'Swap with left',  wk.send_keys({'ctrl', 'shift'}, 'pageup')        },
                { ':', 'Swap with right', wk.send_keys({'ctrl', 'shift'}, 'pagedown')      },
                { '/', 'Search tabs',     wk.send_keys({'cmd', 'shift'}, 'a'), wk.insert() },
                { 'M', 'Re-open closed',  wk.send_keys({'cmd', 'shift'}, 't')              }

                -- { 'm', 'Open',            wk.send_keys({'cmd'}, 't')                       },
            ),
        },
        {
            category = 'Navigation',
            bindings = util.bind(
                { 'i', 'Up arrow',    wk.send_keys({}, 'up')         },
                { 'k', 'Down arrow',  wk.send_keys({}, 'down')       },
                { 'l', 'Focus next',  wk.send_keys({}, 'tab')        },
                { 't', 'Focus prev',  wk.send_keys({'shift'}, 'tab') }
            ),
        },
        {
            category = 'Misc',
            bindings = util.bind(
                { "'",      'Focus searchbar', wk.send_keys({'cmd'}, 'l'), wk.insert() },
                { 'b',      'Add bookmark',    wk.send_keys({'cmd'}, 'd')              },
                { 'P',      'Open history',    wk.send_keys({'cmd'}, 'h')              },
                { 'return', 'Confirm',         wk.send_keys({}, 'return')              }
            ),
        },
    },

    ------------------+
    ['kitty'] = {  -- |
    ------------------+
        {
            category = 'Scrollback',
            bindings = util.bind(
                { 'e', 'Page up',   wk.send_keys({'shift'}, 'pageup')   },
                { 'd', 'Page down', wk.send_keys({'shift'}, 'pagedown') }
            ),
        },
        {
            category = 'Splits',
            bindings = util.bind(
                { 'i', 'Up',           wk.send_keys({'ctrl', 'alt'}, 'up')             },
                { 'k', 'Down',         wk.send_keys({'ctrl', 'alt'}, 'down')           },
                { 'l', 'Right',        wk.send_keys({'ctrl', 'alt'}, 'right')          },
                { 't', 'Left',         wk.send_keys({'ctrl', 'alt'}, 'left')           },
                { 'I', 'Resize up',    wk.send_keys({'ctrl', 'alt', 'shift'}, 'up')    },
                { 'K', 'Resize down',  wk.send_keys({'ctrl', 'alt', 'shift'}, 'down')  },
                { 'L', 'Resize right', wk.send_keys({'ctrl', 'alt', 'shift'}, 'right') },
                { 'T', 'Resize left',  wk.send_keys({'ctrl', 'alt', 'shift'}, 'left')  },

                -- new_win
                { 'M', 'Detach split', wk.send_keys({'cmd', 'ctrl', 'alt', 'shift'}, 'w'), wk.refresh_state() }

                -- { 'm', 'New split',    wk.send_keys({'cmd', 'ctrl', 'alt'}, 'm')          },
                -- { 'W', 'Close',        wk.send_keys({'cmd', 'shift'}, 'd')                }
                -- { '', 'New window',   wk.send_keys({'cmd', 'ctrl', 'alt', 'shift'}, 'm') },
            ),
        },
        {
            category = 'Tabs',
            bindings = util.bind(
                { ';', 'Next',     wk.send_keys({'ctrl'}, 'end')  },
                { 'h', 'Previous', wk.send_keys({'ctrl'}, 'home') }

                -- util.bind('', 'Open',     wk.send_keys({'ctrl'}, 'home'))
            ),
        },
        {
            category = 'Layout',
            bindings = util.bind(
                { 'R', 'Rotate splits', wk.send_keys({'cmd', 'ctrl', 'alt'}, 'p')          },
                { 'r', 'Next layout',   wk.send_keys({'cmd', 'ctrl', 'alt', 'shift'}, 'p') }
            ),
        },
    },
}

return M
