
local M = {}

local state = require('state').layout


-- Screen data
--------------------------------------------------------------------------------
function M.init_screen_data()
    for _, screen in ipairs(hs.screen.allScreens()) do
        local id = screen:id()
        local frame = screen:frame()

        state.screens[id] = {
            fullscreen = false,
            divider = 0.50,
            dimensions = {
                w = frame.w,
                h = frame.h,
            },
            coords = {
                x = frame.x,
                y = frame.y,
            }
        }
    end
end


-- Window data
--------------------------------------------------------------------------------
function M.init_window_data()
    local win = hs.window.frontmostWindow()
    local app = win:application():name()
    local id = win:screen():id()
    local frame = win:screen():frame()

    if state.supported_apps[app] then
        if win:isStandard() then
            local container = state.screens[id]
            container.left = win  -- default to left on init

            local multiplier = state.screens[id].divider

            state.windows[win] = {
                uuid = id,
                position = 'left',
                dimensions = {
                    w = (frame.w * multiplier),
                    h = frame.h,
                },
                coords = {
                    x = frame.x,
                    y = frame.y,
                },
            }

        end
    end
end


-- TODO: move this fn elsewhere later
--
-- Launch or focus target app
--------------------------------------------------------------------------------
function M.launch_or_focus(app)
    hs.application.launchOrFocus(app)

    -- when launching an app we need to check if the apps frontmostWindow is
    -- already stored in the state table.
    --
    -- if it is we just call:
    --     hs.application.launchOrFocus(app)
    --
    -- if not we need to determine the screen it's launched on (same screen as
    -- the current frontmostWindow) and put it into the adjacent slot, then call:
    --     hs.application.launchOrFocus(app)
end


-- Init layout
--------------------------------------------------------------------------------
function M.init()
    M.init_screen_data()
    M.init_window_data()
end

return M


-- hs.console.hswindow():focus()  -- debug
-- print(win:title())
