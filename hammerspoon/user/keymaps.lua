
local shader = require('shaders')
local qtimer = require('quit_timer')

local bk = hs.hotkey.bind

-- MonitorControl was buggy spyware anyway
bk({},        'tab', function() shader.adjust_brightness('up') end)
bk({'shift'}, 'tab', function() shader.adjust_brightness('down') end)
bk({'ctrl'},  'r',   function() shader.print_brightness_values() end)

-- Hot reload hammerspoon
bk({'ctrl', 'shift'}, 'r', function() hs.reload() end)

-- Command-Q delay on quitting an application
bk({'cmd'}, 'q', qtimer.startCmdQ, qtimer.stopCmdQ)
