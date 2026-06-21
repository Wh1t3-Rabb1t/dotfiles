
-- MonitorControl was buggy spyware anyway
local monitor = require('monitor_control')

hs.hotkey.bind({},        'tab', function() monitor.adjust_brightness('up') end)
hs.hotkey.bind({'shift'}, 'tab', function() monitor.adjust_brightness('down') end)


-- Hot reload hammerspoon
hs.hotkey.bind({'ctrl', 'shift'}, 'r', function() hs.reload() end)
