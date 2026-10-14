local M = {}

local state = require('state')
local cache = require('cache')
local util  = require('util')

local screens    = require('screens')
local apps       = require('apps')
local windows    = require('windows')
local wk_popups  = require('wk_popups')
local wk_actions = require('wk_actions')


--------------------------------------------------------------------------------
-- Create the main orchestrator event tap
--------------------------------------------------------------------------------
local function create_event_tap()
    local events = hs.eventtap.event

    local event_types = {
        events.types.keyUp,
        events.types.keyDown,
        events.types.flagsChanged
        -- events.types.leftMouseUp,
    }

    local tap = hs.eventtap.new(event_types, function(event)
        -- Check for state invalidation on keyUp/leftMouseUp
        if event:getType() == events.types.keyUp then
            -- hs.timer.usleep(1000)

            if state.invalid == true then
                -- print('re init triggered')

                local border = state.windows.border
                if border then border:hide() end

                local wk_hide = wk_actions.hide()
                wk_hide(function()
                    -- Call done()
                end)

                M.init_modules()

                local wk_show = wk_actions.show()
                wk_show(function()
                    -- Call done()
                end)
            end
        else
            local flags   = event:getFlags()
            local keycode = event:getKeyCode()
            local key     = hs.keycodes.map[keycode]

            local win = hs.window.focusedWindow()
            local app = win:application():name()

            local mods = {}

            if flags.cmd   then table.insert(mods, 'cmd') end
            if flags.alt   then table.insert(mods, 'alt') end
            if flags.ctrl  then table.insert(mods, 'ctrl') end
            if flags.shift then table.insert(mods, 'shift') end

            local lookup_key   = util.binding_id(key, mods)
            local app_lookup   = cache.lookup[app] or {}
            local bound_action = cache.lookup.system[lookup_key]
                              or app_lookup[lookup_key]

            if bound_action then
                bound_action()
            end
        end

        return true
    end)

    return tap
end


--------------------------------------------------------------------------------
-- Init required module data and validate state
--------------------------------------------------------------------------------
function M.init_modules()
    screens.init()
    apps.init()
    windows.init()
    wk_popups.init()

    state.invalid = false
end


--------------------------------------------------------------------------------
-- Launch which key
--------------------------------------------------------------------------------
function M.launch()
    if state.menu.tap_active then
        return
    end

    M.init_modules()

    -- Create event tap
    cache.wk_tap = create_event_tap()

    -- Start event tap
    state.menu.tap_active = true
    cache.wk_tap:start()

    -- Show popup
    local init_fn = wk_actions.show()
    init_fn(function()
        -- Call done()
    end)
end

return M

