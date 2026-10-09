local M = {}

local state = require('state')
local util  = require('util')


--------------------------------------------------------------------------------
function create_watcher(app)
    local watcher = app:newWatcher(function(element, event)
        if event == 'AXFocusedWindowChanged' then
            local apps  = hs.application.runningApplications()
            local count = 0

            for _, running_app in ipairs(apps) do
                for _, win in ipairs(running_app:allWindows()) do
                    if win:isStandard() and win:isVisible() then
                        count = count + 1
                    end
                end
            end

            if count ~= #state.windows.wins then
                -- Signal to the eventtap that state needs to be re-built
                state.invalid = true

                print('state invalid')
            end
        end
    end)

    -- watcher:start({
    --     -- Window level events
    --     hs.uielement.watcher.focusedWindowChanged,
    -- })

    return watcher
end


--------------------------------------------------------------------------------
local function sort_apps()
    local running_apps = hs.application.runningApplications()

    table.sort(running_apps, function(a, b)
        return a:name() < b:name()
    end)

    return running_apps
end

--------------------------------------------------------------------------------
local function get_app_wins(app)
    local app_wins = {}

    for _, win in ipairs(app:allWindows()) do
        if win:isStandard() and win:isVisible() then
            table.insert(app_wins, win)
        end
    end

    if #app_wins > 0 then
        return app_wins
    else
        return false
    end
end


--------------------------------------------------------------------------------
-- Init
--------------------------------------------------------------------------------
function M.init()
    local apps = {
        list = {}
    }

    local sorted_apps = sort_apps()

    for _, app in ipairs(sorted_apps) do
        local app_wins = get_app_wins(app)

        if app_wins then
            table.insert(apps.list, app)

            apps[app:name()] = {
                idx     = 1,
                wins    = app_wins,
                watcher = create_watcher(app),
            }

            -- Init/start watchers
            if util.tbl(state.apps[app:name()]) then
                state.apps[app:name()].watcher:start({
                    hs.uielement.watcher.focusedWindowChanged,
                })
            end

        end
    end

    if #apps.list > 0 then
        state.apps = apps
    end
end

return M



-- local M = {}
--
-- local state = require('state')
--
--
-- --------------------------------------------------------------------------------
-- local function create_watcher(app)
--     if not app then
--         return
--     end
--
--     local watcher = app:newWatcher(function(element, event)
--         if event == 'AXFocusedWindowChanged' then
--             local apps  = hs.application.runningApplications()
--             local count = 0
--
--             for _, running_app in ipairs(apps) do
--                 for _, win in ipairs(running_app:allWindows()) do
--                     if win:isStandard() and win:isVisible() then
--                         count = count + 1
--                     end
--                 end
--             end
--
--             if count ~= #state.windows.wins then
--                 -- Signal to the eventtap that state needs to be re-built
--                 state.invalid = true
--
--                 print('state invalid')
--             end
--         end
--     end)
--
--     watcher:start({
--         -- Window level events
--         hs.uielement.watcher.focusedWindowChanged,
--     })
--
--     return watcher
-- end
--
--
-- --------------------------------------------------------------------------------
-- local function init_app_data()
--     local running_apps = hs.application.runningApplications()
--
--     table.sort(running_apps, function(a, b)
--         return a:name() < b:name()
--     end)
--
--     local apps = {
--         list = {}
--     }
--
--     for _, app in ipairs(running_apps) do
--         local app_wins = {}
--
--         for _, win in ipairs(app:allWindows()) do
--             if win:isStandard() and win:isVisible() then
--                 table.insert(app_wins, win)
--             end
--         end
--
--         if #app_wins > 0 then
--             table.insert(apps.list, app)
--
--             apps[app:name()] = {
--                 idx     = 1,
--                 wins    = app_wins,
--                 -- watcher = create_watcher(app),
--             }
--         end
--     end
--
--     if #apps.list > 0 then
--         return apps
--     else
--         return false
--     end
-- end
--
--
-- --------------------------------------------------------------------------------
-- -- Init
-- --------------------------------------------------------------------------------
-- function M.init()
--     local data = init_app_data()
--
--     if data then
--         state.apps = data
--     end
-- end
--
-- return M
