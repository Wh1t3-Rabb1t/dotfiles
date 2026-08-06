local M = {}

local state = require('state')
local cache = require('cache')
local popups = require('popups')


-- Toggle event tap
--------------------------------------------------------------------------------
function M.turn_eventtap(set_to)
    return function (done)
        if set_to == 'on' then
            state.menu.tap_active = true
            cache.assets.tap:start()
        elseif set_to == 'off' then
            state.menu.tap_active = false
            cache.assets.tap:stop()
        end

        done()
    end
end


-- Send keystrokes (while bypassing active eventtap)
--------------------------------------------------------------------------------
function M.send_keys(mods, key)
    return function(done)
        state.menu.tap_active = false
        cache.assets.tap:stop()

        hs.eventtap.keyStroke(mods, key, 0)

        state.menu.tap_active = true
        cache.assets.tap:start()

        done()
    end
end


-- Temporarily bind 'enter' to relaunch menu, 'escape' to cancel auto relaunch
--------------------------------------------------------------------------------
function M.temporary_insert()
    return function(done)
        local win     = state.menu.curr_win or hs.window.focusedWindow()
        local frame   = win:frame()
        local opacity = state.menu.opacity
        local popup   = cache.assets.insert.popup

        local function end_insert_mode(hotkeys, active_popup)
            for _, hk in ipairs(hotkeys) do
                hk:disable()
            end

            active_popup:hide()
        end

        local pos = {
            x = frame.x + 10,
            y = frame.y + 10,
        }

        popup:topLeft(pos)
        popup:alpha(opacity)
        popup:show(0.15)

        local hotkeys = {}

        hotkeys[1] = hs.hotkey.bind({}, 'return', function()
            end_insert_mode(hotkeys, popup)

            hs.eventtap.keyStroke({}, 'return')
            M.launch_menu()
        end)

        hotkeys[2] = hs.hotkey.bind({}, 'escape', function()
            end_insert_mode(hotkeys, popup)
        end)

        done()
    end
end


-- Launch menu
--------------------------------------------------------------------------------
function M.launch_menu()
    if state.menu.tap_active then
        return
    end

    state.menu.tap_active = true
    cache.assets.tap:start()

    local init_fn = popups.show(hs.window.focusedWindow())

    init_fn()
end

return M
