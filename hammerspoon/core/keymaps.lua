
local qtimer = require('quit_timer')

local bk = hs.hotkey.bind

-- Hot reload hammerspoon
bk({'ctrl', 'shift'}, 'r', function() hs.reload() end)

-- Command-Q delay on quitting an application
bk({'cmd'}, 'q', qtimer.startCmdQ, qtimer.stopCmdQ)


-- Binding popup menu
--------------------------------------------------------------------------------
local sys_menu = require('sys_menu')

bk({ 'ctrl' }, 'f', function() sys_menu.handle_keys() end)
