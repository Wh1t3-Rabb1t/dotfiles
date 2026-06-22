
local monitor = require('monitor_control')
local qtimer = require('quit_timer')

local bk = hs.hotkey.bind

-- MonitorControl was buggy spyware anyway
bk({},        'tab', function() monitor.adjust_brightness('up') end)
bk({'shift'}, 'tab', function() monitor.adjust_brightness('down') end)

-- Hot reload hammerspoon
bk({'ctrl', 'shift'}, 'r', function() hs.reload() end)

-- Command-Q delay on quitting an application
bk({'cmd'}, 'q', qtimer.startCmdQ, qtimer.stopCmdQ)
