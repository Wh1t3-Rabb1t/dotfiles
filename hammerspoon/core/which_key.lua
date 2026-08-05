local M = {}

local state = require('state')
local cache = require('cache')
local popups = require('popups')


-- Process action queue
--------------------------------------------------------------------------------
function M.queue(...)
    local jobs = { ... }

    return function()
        for _, job in ipairs(jobs) do
            table.insert(state.action_queue.items, job)
        end

        if state.action_queue.running then
            return
        end

        state.action_queue.running = true

        local function next_job()
            local job = table.remove(state.action_queue.items, 1)

            if not job then
                state.action_queue.running = false
                return
            end

            job(next_job)
        end

        next_job()
    end
end


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


-- -- Close menu
-- --------------------------------------------------------------------------------
-- function M.close_menu(win)
--     local job = function (done)
--         util.turn_eventtap('off')
--         popups.hide(win)
--
--         done()
--     end
--
--     return job
-- end


-- Launch menu
--------------------------------------------------------------------------------
function M.launch_menu()
    if state.menu.tap_active then
        return
    end

    local init_fn = M.queue(
        M.turn_eventtap('on'),
        popups.show(hs.window.focusedWindow())
    )

    init_fn()
end

-- function M.launch_menu()
--     if state.menu.tap_active then
--         return
--     end
--
--     M.queue(
--         M.turn_eventtap('on'),
--         popups.show(hs.window.focusedWindow())
--     )
-- end

return M
