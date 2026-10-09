local M = {}

local state = require('state')
local cache = require('cache')
local util  = require('util')

local screens   = require('screens')
local apps      = require('apps')
local windows   = require('windows')
local wk_popups = require('wk_popups')


local function create_event_tap()
    local events = hs.eventtap.event
    local event_types = {
        events.types.keyUp,
        -- events.types.leftMouseUp,
        events.types.keyDown,
        events.types.flagsChanged
    }

    local tap = hs.eventtap.new(event_types, function(event)
        -- Check for state invalidation on keyUp/leftMouseUp
        if event:getType() == events.types.keyUp then
            if state.invalid == true then
                print('re init triggered')

                -- Delete popups
                local app_name = state.windows.curr_win:application():name()
                if cache.assets[app_name] then
                    cache.assets[app_name].popup:delete()
                end
                cache.assets.system.popup:delete()

                -- Hide border
                local border = state.windows.border
                if border then border:hide() end


                -- Re-init modules
                M.init_modules()


                -- -- Show popups
                -- app_name = state.windows.curr_win:application():name()
                -- if cache.assets[app_name] then
                --     cache.assets[app_name].popup:show()
                -- end
                -- cache.assets.system.popup:show()

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


function M.init_modules()
    screens.init()

    apps.init()
    windows.init()
    wk_popups.init()

    state.invalid = false
end

function M.init()
    M.init_modules()

    -- Create event tap
    cache.assets.tap = create_event_tap()
end

return M
