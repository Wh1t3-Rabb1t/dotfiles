
-- MENTAL MODEL:
-- -------------
-- The only windows that get stored are those at the forefront of the given
-- screen. If a new window is focused, it will only be 'snapped' into the
-- (left|right) container if it is not fullscreen.
--
-- If a window is fullscreen at the forefront and a new window that is NOT
-- fullscreen is focused on the same screen, snap the previously focused
-- fullscreen window in to the adjacent container.


local M = {}

local state = require('state').layout


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


-- Calculate the available screen (total screen frame minus the dock)
--------------------------------------------------------------------------------
function M.usable_frame(screen)
    local full = screen:fullFrame()
    local usable = screen:frame()

    return {
        x = full.x,
        y = usable.y,
        w = full.w,
        h = full.h - (usable.y - full.y),
    }
end


-- Determine if two coordinate tables are equal to each other
--------------------------------------------------------------------------------
function M.frames_equal(a, b)
    -- MacOS occasionally returns coords off by one pixel due to scaling,
    -- retina displays, or animations.
    return math.abs(a.x - b.x) <= 1
       and math.abs(a.y - b.y) <= 1
       and math.abs(a.w - b.w) <= 1
       and math.abs(a.h - b.h) <= 1
end


-- Determine whether or not a winodw is "fullscreen"
--------------------------------------------------------------------------------
function M.is_window_fullscreen(win)
    return M.frames_equal(
        win:frame(),
        M.usable_frame(win:screen())
    )
end


-- Determine initial window layout
--------------------------------------------------------------------------------
function M.window_layout()
    local layout = {
        fullscreen = nil,
        left_slot = nil,
        right_slot = nil,
    }

    local win = hs.window.frontmostWindow()
    local app = win:application():name()

    if state.supported_apps[app] then
        if M.is_window_fullscreen(win) then
            layout.fullscreen = win
        else
            layout.left_slot = win
        end
    end

    return layout
end


-- Init layout table
--------------------------------------------------------------------------------
function M.init()
    for _, screen in ipairs(hs.screen.allScreens()) do
        state.screens[screen:id()] = {
            divider = 0.50,
            layout = M.window_layout(),
            frame = M.usable_frame(screen),
        }
    end
end

return M






-- hs.console.hswindow():focus()  -- debug
-- print(win:title())
