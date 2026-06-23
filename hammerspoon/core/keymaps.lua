
local qtimer = require('quit_timer')

local bk = hs.hotkey.bind

-- Hot reload hammerspoon
bk({'ctrl', 'shift'}, 'r', function() hs.reload() end)

-- Command-Q delay on quitting an application
bk({'cmd'}, 'q', qtimer.startCmdQ, qtimer.stopCmdQ)


-- Binding popup menu
--------------------------------------------------------------------------------
local sys_menu = require('sys_menu')
local menu = require('state').sys_menu

local tap
tap = hs.eventtap.new({ hs.eventtap.event.types.keyDown }, function(event)
    local keycode = event:getKeyCode()
    local key = hs.keycodes.map[keycode]

    if key == 'escape' then
        menu.modal_active = false
        tap:stop()
        hs.alert.show("Off")
        sys_menu.hide_overlay()
        return true
    end

    local action = menu.bindings[key].action
    if action then
        action()
    end

    return true
end)

bk({ 'ctrl' }, 'f', function()
    if menu.modal_active then
        return
    end

    menu.modal_active = true
    hs.alert.show("On")
    sys_menu.show_overlay()
    tap:start()
end)
