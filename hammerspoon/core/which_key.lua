local M = {}

local state = require('state')
local cache = require('cache')
local splits = require('splits')
local popups = require('popups')



-- TODO: refactor and move elsewhere
--
-- Launch or focus target app
--------------------------------------------------------------------------------
function M.launch_or_focus(app)
    local existing_win = hs.window.focusedWindow()

    local wf
    wf = hs.window.filter.new(app)

    wf:subscribe(hs.window.filter.windowFocused, function(win)
        wf:unsubscribeAll()
        wf = nil

        if existing_win and win:id() == existing_win:id() then
            return
        end

        popups.hide(existing_win)

        splits.snap(
            win, splits.get_layout(existing_win, win)
        )

        popups.show(win)
    end)

    hs.application.launchOrFocus(app)
end



-- Process action queue
--------------------------------------------------------------------------------
function M.queue(...)
    local jobs = { ... }

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


-- Toggle event tap
--------------------------------------------------------------------------------
function M.turn_eventtap(set_to)
    local job = function (done)
        if set_to == 'on' then
            state.menu.tap_active = true
            cache.assets.tap:start()
        elseif set_to == 'off' then
            state.menu.tap_active = false
            cache.assets.tap:stop()
        end

        done()
    end

    return job
end


-- Send keystrokes (while bypassing active eventtap)
--------------------------------------------------------------------------------
function M.send_keys(mods, key)
    local job = function(done)
        state.menu.tap_active = false
        cache.assets.tap:stop()

        hs.eventtap.keyStroke(mods, key, 0)

        state.menu.tap_active = true
        cache.assets.tap:start()

        done()
    end

    return job
end


-- Temporarily bind 'enter' to relaunch menu, 'escape' to cancel auto relaunch
--------------------------------------------------------------------------------
function M.temporary_insert()
    local job = function(done)
        local win = state.menu.active_win or hs.window.focusedWindow()
        local frame = win:frame()
        local opacity = state.menu.opacity
        local insert_popup = cache.assets.insert.popup

        local function end_insert_mode(hotkeys, popup)
            for _, hk in ipairs(hotkeys) do
                hk:disable()
            end

            popup:hide()
        end

        local pos = {
            x = frame.x + 10,
            y = frame.y + 10,
        }

        insert_popup:topLeft(pos)
        insert_popup:alpha(opacity)
        insert_popup:show(0.15)

        local hotkeys = {}

        hotkeys[1] = hs.hotkey.bind({}, 'return', function()
            end_insert_mode(hotkeys, insert_popup)

            hs.eventtap.keyStroke({}, 'return')
            M.launch_menu()
        end)

        hotkeys[2] = hs.hotkey.bind({}, 'escape', function()
            end_insert_mode(hotkeys, insert_popup)
        end)

        done()
    end

    return job
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

    M.queue(
        M.turn_eventtap('on'),
        popups.show(hs.window.focusedWindow())
    )
end

return M
