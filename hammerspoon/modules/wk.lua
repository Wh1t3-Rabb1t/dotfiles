local M = {}

-- local G     = require('core.config')
local state = require('state')
local cache = require('cache')
local util  = require('util')


--------------------------------------------------------------------------------
-- Cycle menu corner positions.
--
-- Calls:
--   util.toggle_popups()
--
-- State changes:
--   state.wk.corner
--------------------------------------------------------------------------------
function M.cycle_corner_pos()
    return function(done)
        done = done or function() end

        local corners = {
            'bottom_right',
            'top_right',
            'bottom_left',
            'top_left',
        }

        local curr_corner = state.wk.corner
        local curr_idx    = 1

        -- Find the index of the current corner
        for i, v in ipairs(corners) do
            if v == curr_corner then
                curr_idx = i

                break
            end
        end

        -- Calculate the next index, wrapping around using modulo arithmetic
        local new_idx    = (curr_idx % #corners) + 1
        local new_corner = corners[new_idx]

        state.wk.corner = new_corner

        util.toggle_popups('off', 'on')

        done()
    end
end


--------------------------------------------------------------------------------
-- Cycle menu layout (vertical/horizontal stacking).
--
-- Calls:
--   util.toggle_popups()
--
-- State changes:
--   state.wk.stack
--------------------------------------------------------------------------------
function M.cycle_stacking()
    return function(done)
        done = done or function() end

        local stack     = state.wk.stack
        local new_stack = (stack == 'vertical') and 'horizontal' or 'vertical'

        state.wk.stack = new_stack

        util.toggle_popups('off', 'on')

        done()
    end
end


--------------------------------------------------------------------------------
-- Set poppup opacity.
--
-- Parameters:
--   direction (string):  'up' or 'down'
--
-- State changes:
--   state.wk.opacity
--------------------------------------------------------------------------------
function M.opacity(direction)
    return function(done)
        done = done or function() end

        local opacity  = state.wk.opacity
        local win      = state.windows.curr_win
        local app_name = win:application():name()

        local step = 0.1

        if direction == 'up' then
            opacity = math.min(opacity + step, 1.0)
        elseif direction == 'down' then
            opacity = math.max(opacity - step, 0.1)
        end

        -- App specific popup (if supported)
        if cache.assets[app_name] then
            cache.assets[app_name].popup:alpha(opacity)
        end

        -- System popup
        cache.assets.system.popup:alpha(opacity)

        state.wk.opacity = opacity

        done()
    end
end


--------------------------------------------------------------------------------
-- Temporarily bind 'enter' to relaunch menu, 'escape' to cancel auto relaunch.
--
-- Calls:
--   util.toggle_popups()
--   util.toggle_tap()
--   end_insert_mode()
--   M.launch()
--------------------------------------------------------------------------------
function M.insert()
    return function(done)
        done = done or function() end

        util.toggle_popups('off')
        util.toggle_tap('off')

        local frame = state.windows.curr_win:frame()
        local popup = cache.assets.insert.popup

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
        popup:alpha(state.wk.opacity)
        popup:show(0.15)

        local hotkeys = {}

        -- Send 'enter' key and re-launch wk
        hotkeys[1] = hs.hotkey.bind({}, 'return', function()
            end_insert_mode(hotkeys, popup)
            hs.eventtap.keyStroke({}, 'return')
            M.launch()
        end)

        -- Send 'escape' key and cancel re-launching wk
        hotkeys[2] = hs.hotkey.bind({}, 'escape', function()
            end_insert_mode(hotkeys, popup)
        end)

        done()
    end
end


--------------------------------------------------------------------------------
-- Send keystrokes (while bypassing active eventtap).
--
-- Parameters:
--   mods (table):   Containing valid modifier strings i.e. 'cmd'
--   key  (string):  Containing valid key strings i.e. 't', 'space'
--
-- Calls:
--   util.toggle_tap()
--------------------------------------------------------------------------------
function M.send_keys(mods, key)
    return function(done)
        done = done or function() end

        util.toggle_tap('off')

        hs.eventtap.keyStroke(mods, key, 0)

        util.toggle_tap('on')

        done()
    end
end


--------------------------------------------------------------------------------
-- Quit wk.
--
-- Calls:
--   util.toggle_popups()
--   util.toggle_border()
--   util.toggle_tap()
--------------------------------------------------------------------------------
function M.quit()
    return function(done)
        done = done or function() end

        util.toggle_popups('off')
        util.toggle_border('off')
        util.toggle_tap('off')

        done()
    end
end


--------------------------------------------------------------------------------
-- Regenerate cache assets (screen, app, and window data).
--
-- Calls:
--   util.toggle_border()
--   apps.init()
--   M.init()
--   util.toggle_popups()
--------------------------------------------------------------------------------
function M.refresh_state()
    return function(done)
        done = done or function() end

        local start_win = state.windows.curr_win

        -- Border is toggled back on during windows.init()
        util.toggle_border('off')

        require('apps').init()
        require('windows').init()

        if start_win ~= state.windows.curr_win then
            util.toggle_popups('off', 'on')
        end

        done()
    end
end


--------------------------------------------------------------------------------
-- Launch which key.
--
-- Calls:
--   screens.init()
--   apps.init()
--   M.init()
--   wk_assets.init()
--   util.toggle_popups()
--   util.toggle_tap()
--------------------------------------------------------------------------------
function M.launch()
    if state.wk.tap_active then
        return
    end

    require('screens').init()
    require('apps').init()
    require('windows').init()

    -- M.init()

    -- Init wk_assets if not already existing
    if not cache.initialized then
        require('wk_assets').init()
    end

    util.toggle_popups('on')
    util.toggle_tap('on')
end

return M
