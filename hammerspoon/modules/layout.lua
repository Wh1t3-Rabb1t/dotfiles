
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


-- Determine whether or not a winodw is "fullscreen"
--------------------------------------------------------------------------------
function M.is_window_fullscreen(win_frame, screen_frame)
    -- MacOS occasionally returns coords off by one pixel due to scaling,
    -- retina displays, or animations.
    local function frames_equal(a, b)
        return math.abs(a.x - b.x) <= 1
           and math.abs(a.y - b.y) <= 1
           and math.abs(a.w - b.w) <= 1
           and math.abs(a.h - b.h) <= 1
    end

    if frames_equal(win_frame, screen_frame) then
        return true
    else
        return false
    end
end


-- Determine initial window layout
--------------------------------------------------------------------------------
function M.window_layout(screen_frame)
    local layout = {
        fullscreen_win = nil,
        left_win = nil,
        right_win = nil,
    }

    local win = hs.window.frontmostWindow()
    local app = win:application():name()

    if state.supported_apps[app] then
        local win_frame = win:frame()
        local fullscreen_window = M.is_window_fullscreen(win_frame, screen_frame)

        if fullscreen_window then
            layout.fullscreen_win = win
        else
            layout.left_win = win
        end
    end

    return layout
end


-- Init layout table
--------------------------------------------------------------------------------
function M.init()
    for _, screen in ipairs(hs.screen.allScreens()) do
        local uuid = screen:id()
        local frame = M.usable_frame(screen)
        local layout = M.window_layout(frame)

        state.screens[uuid] = {
            divider = 0.50,
            fullscreen = layout.fullscreen_win,
            slots = {
                left = layout.left_win,
                right = layout.right_win,
            },
            frame = {
                w = frame.w,
                h = frame.h,
                x = frame.x,
                y = frame.y,
            }
        }
    end
end

return M


-- hs.console.hswindow():focus()  -- debug
-- print(win:title())
