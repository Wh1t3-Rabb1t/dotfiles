local M = {}

local state = require('state')
local cache = require('cache')


-- function refresh_window_state()
--     local curr_wind = state.apps.all.curr_win
--     local borders = state.apps.all.borders
--     local wins    = state.apps.all.wins
--     local idx     = state.apps.all.idx
--     -- local border = state.apps.borders[id]
--     if border then
--         border:delete()
--         state.wins.borders[id] = nil
--     end
-- end


-- function M.debug_slots()
--     return function(done)
--         local screen = hs.mouse.getCurrentScreen()
--         local id     = screen:id()
--         local layout = state.screens[id].layout
--         if layout.left then
--             local lhs = layout.left:application():name()
--             hs.alert.show('id: ' .. id  .. '  lhs: ' .. lhs)
--         end
--         if layout.right then
--             local rhs = layout.right:application():name()
--             hs.alert.show('id: ' .. id  .. '  rhs: ' .. rhs)
--         end
--         if layout.maximized then
--             local max = layout.maximized:application():name()
--             hs.alert.show('id: ' .. id  .. '  max: ' .. max)
--         end
--         done()
--     end
-- end



-- Compare the dimensions of two frame objects
--------------------------------------------------------------------------------
local function frames_equal(a, b, tolerance)
    -- MacOS occasionally returns coords off by one pixel due to scaling,
    -- retina displays etc.
    tolerance = tolerance or 1

    return math.abs(a.x - b.x) <= tolerance
       and math.abs(a.y - b.y) <= tolerance
       and math.abs(a.w - b.w) <= tolerance
       and math.abs(a.h - b.h) <= tolerance
end


-- Determine whether or not a winodw is maximized
--------------------------------------------------------------------------------
local function is_fullscreen(win)
    local id           = win:screen():id()
    local cached_frame = cache.screens[id].frame

    local frames = frames_equal(
        win:frame(),
        cached_frame
    )

    return frames
end


-- Is window aligned to the left or right of the screen
--------------------------------------------------------------------------------
local function get_side(win)
    local win_frame    = win:frame()
    local screen       = win:screen()
    local screen_frame = screen:fullFrame()
    local screen_mid   = screen_frame.x + (screen_frame.w / 2)
    local win_mid      = win_frame.x + (win_frame.w / 2)

    local side = 'right'

    if win_mid < screen_mid then
        side = 'left'
    end

    return side
end


-- Calculate left/right slot frames
--------------------------------------------------------------------------------
local function get_coords(id, border)
    border = border or 8

    local frame       = cache.screens[id].frame
    local left_width  = frame.w * state.screens[id].divider
    local right_width = frame.w - left_width

    local frames = {
        left = {
            x = frame.x + border,
            y = frame.y + border,
            w = left_width - border,
            h = frame.h - (border * 2),
        },
        right = {
            x = frame.x + left_width + border,
            y = frame.y + border,
            w = right_width - (border * 2),
            h = frame.h - (border * 2),
        }
    }

    return frames
end


-- Snap windows into their respective slot coords
--------------------------------------------------------------------------------
local function snap_layout()
    local win    = state.apps.all.curr_win
    local id     = win:screen():id()
    local layout = state.screens[id].layout
    local frames = get_coords(id)

    if layout.maximized then
        layout.maximized:setFrame(cache.screens[id].frame, 0.02)
    else
        if layout.left then
            layout.left:setFrame(frames.left, 0.02)
        end
        if layout.right then
            layout.right:setFrame(frames.right, 0.02)
        end
    end
end


-- Remove windows from layout state
--------------------------------------------------------------------------------
local function remove_window(layout, win)
    if layout.left      == win then layout.left      = false end
    if layout.right     == win then layout.right     = false end
    if layout.maximized == win then layout.maximized = false end
end


-- Assign windows to layout state.
--
-- If a window is fullscreen at the forefront and a new window that is NOT
-- fullscreen is focused on the same screen, fullscreen the new window.
--
-- The 'left' and 'right' slots are retained until explicitly overwritten
-- (i.e. they are unaffected by the 'fullscreen' slot).
--------------------------------------------------------------------------------
local function assign_window(layout, existing, win)
    if is_fullscreen(win) then
        layout.maximized = win

        -- Exit early
        return
    end

    if layout.maximized then
        if layout.right == win then
            layout.left = layout.maximized
        elseif layout.left == win then
            layout.right = layout.maximized
        end

        layout.maximized = win

        -- Exit early
        return
    end

    layout.maximized = false

    local side = get_side(win)

    if existing and get_side(existing) == side then
        side = (side == 'left') and 'right' or 'left'
    end

    layout[side] = win
end


-- Find a windows index in the state table
--------------------------------------------------------------------------------
local function get_window_index(wins, target)
    for i, win in ipairs(wins) do
        if win == target then
            return i
        end
    end
end


-- Sync app specific window indexes when focused
--------------------------------------------------------------------------------
local function sync_app_index(win)
    local app  = win:application():name()
    local apps = state.apps[app]

    if not apps then
        return
    end

    local idx = get_window_index(apps.wins, win)

    if idx then
        apps.idx = idx
    end
end


-- Force focus of new windows.
--
-- Need to ensure Apples window server has updated before mutating state and
-- :focus() is buggy as hell when targeting apps with multiple windows open.
--------------------------------------------------------------------------------
local function force_focus(win)
    local ax = hs.axuielement.windowElement(win)

    if not ax then
        return false
    end

    win:application():activate()

    ax:setAttributeValue('AXMain', true)
    ax:setAttributeValue('AXFocused', true)

    local focused = hs.window.focusedWindow()

    if focused and focused:id() == win:id() then
        return true
    end

    return false
end


-- Iterate focus between open windows
--------------------------------------------------------------------------------
local function iterate_windows(app, direction)
    local wins  = state.apps[app].wins
    local idx   = state.apps[app].idx
    local apps  = state.apps.all
    local count = #wins

    if count == 0 then
        return false
    end

    local new_idx

    if direction == 'next' then
        new_idx = idx % count + 1
    elseif direction == 'prev' then
        new_idx = (idx - 2) % count + 1
    else
        return false
    end

    local win = wins[new_idx]

    if force_focus(win) then
        if app ~= 'all' then
            new_idx = get_window_index(apps.wins, win)
        end

        sync_app_index(win)  -- Sync app index if compatible

        -- Update borders
        local old_border = apps.borders[apps.idx]
        local new_border = apps.borders[new_idx]

        if old_border then old_border:hide() end
        if new_border then new_border:show() end

        apps.idx      = new_idx
        apps.curr_win = win
    else
        return false
    end

    return true
end


-- Create border canvases for each open window
--------------------------------------------------------------------------------
local function create_border(win)
    local canvas = hs.canvas.new(win:frame())

    canvas:appendElements({
        type        = 'rectangle',
        action      = 'stroke',
        strokeColor = { white = 1, alpha = 1 },
        strokeWidth = 3,
    })

    canvas:level(hs.canvas.windowLevels.overlay)
    canvas:behavior(hs.canvas.windowBehaviors.canJoinAllSpaces)

    return canvas
end


-- Get all open windows
--------------------------------------------------------------------------------
local function get_open_windows(focused)
    local running_apps = hs.application.runningApplications()

    local windows = {}

    -- All open windows
    windows.all = {
        idx      = 1,
        curr_win = focused,
        wins     = {},
        borders  = {},
    }

    for _, app in ipairs(running_apps) do
        local app_wins = {}

        for _, win in ipairs(app:allWindows()) do
            if win:isStandard() and win:isVisible() then
                table.insert(windows.all.wins, win)
                table.insert(app_wins, win)

                local border = create_border(win)

                table.insert(windows.all.borders, border)
            end
        end

        if #app_wins > 0 then
            windows[app:name()] = {
                idx  = 1,
                wins = app_wins,
            }
        end
    end

    if #windows.all.wins > 0 then
        return windows
    else
        return false
    end
end


--------------------------------------------------------------------------------
-- Maximize focused window
--------------------------------------------------------------------------------
function M.maximize()
    return function(done)
        local win    = state.apps.all.curr_win
        local id     = win:screen():id()
        local layout = state.screens[id].layout

        layout.maximized = win

        snap_layout()

        done()
    end
end


--------------------------------------------------------------------------------
-- Re-align window divider
--------------------------------------------------------------------------------
function M.resize(direction, step_val)
    return function(done)
        local step    = step_val or 0.01
        local win     = state.apps.all.curr_win
        local id      = win:screen():id()
        local screen  = state.screens[id]
        local divider = screen.divider
        local layout  = screen.layout

        if direction == 'left' then
            divider = divider - step
        elseif direction == 'right' then
            divider = divider + step
        end

        local num = math.min(0.80, math.max(0.20, divider))
        screen.divider = (num * 100) / 100

        -- If window is maximized, snap back to splits layout
        if layout.maximized then
            if direction == 'left' then
                if layout.right == win then
                    layout.right = layout.left
                end

                layout.left = win
            elseif direction == 'right' then
                if layout.left == win then
                    layout.left = layout.right
                end

                layout.right = win
            end

            layout.maximized = false
        end

        snap_layout()

        done()
    end
end


--------------------------------------------------------------------------------
-- Swap left/right window slots
--------------------------------------------------------------------------------
function M.swap()
    return function(done)
        local win    = state.apps.all.curr_win
        local id     = win:screen():id()
        local layout = state.screens[id].layout
        local lhs    = layout.left
        local rhs    = layout.right

        layout.left  = rhs
        layout.right = lhs

        snap_layout()

        done()
    end
end


--------------------------------------------------------------------------------
-- Move window to the next/previous connected screen
--------------------------------------------------------------------------------
function M.move_to_screen()
    return function(done)
        local win         = state.apps.all.curr_win
        local curr_screen = win:screen()
        local next_screen = curr_screen:next()

        local old_layout = state.screens[curr_screen:id()].layout
        local new_layout = state.screens[next_screen:id()].layout

        remove_window(old_layout, win)

        win:moveToScreen(next_screen)

        assign_window(new_layout, nil, win)

        snap_layout()

        done()
    end
end


--------------------------------------------------------------------------------
-- Launch or focus target app
--------------------------------------------------------------------------------
function M.launch_or_focus(app)
    return function(done)
        local existing = hs.window.focusedWindow()

        local function finish(new)
            state.apps.all.curr_win = new

            if existing and new and existing:id() ~= new:id() then
                local id     = new:screen():id()
                local layout = state.screens[id].layout

                assign_window(layout, existing, new)

                snap_layout()
            end

            done()
        end

        if existing and existing:application():name() == app then
            finish(existing)

            return
        end

        local wf = hs.window.filter.new(app)

        wf:subscribe(hs.window.filter.windowFocused, function(new)
            wf:unsubscribeAll()
            finish(new)
        end)

        hs.application.launchOrFocus(app)
    end
end


--------------------------------------------------------------------------------
-- Cycle focus between main apps (the twin cats)
--------------------------------------------------------------------------------
function M.cycle_main_apps()
    return function(done)
        local existing = hs.window.focusedWindow()

        local target_app = 'kitty'

        if existing and existing:application():name() == 'kitty' then
            target_app = 'Brave Browser'
        end

        local wf = hs.window.filter.new(target_app)

        wf:subscribe(
            hs.window.filter.windowFocused,
            function(target_win)
                wf:unsubscribeAll()
                wf = nil

                local id     = target_win:screen():id()
                local layout = state.screens[id].layout

                assign_window(layout, existing, target_win)

                state.apps.all.curr_win = target_win

                done()
            end
        )

        hs.application.launchOrFocus(target_app)
    end
end


--------------------------------------------------------------------------------
-- Cycle between the currently focused apps open windows
--------------------------------------------------------------------------------
function M.cycle_app_specific(direction)
    return function(done)
        local win  = state.apps.all.curr_win
        local app  = win:application():name()
        local apps = state.apps[app]

        if not apps or #apps.wins < 2 then
            done()
            return
        end

        iterate_windows(app, direction)

        done()
    end
end


--------------------------------------------------------------------------------
-- Cycle between all open windows
--------------------------------------------------------------------------------
function M.cycle_open(direction)
    return function(done)
        local apps = state.apps.all

        if #apps.wins < 2 then
            done()
            return
        end

        iterate_windows('all', direction)

        done()
    end
end


--------------------------------------------------------------------------------
-- Toggle border visibility
--------------------------------------------------------------------------------
function M.border(toggle)
    return function(done)
        local apps = state.apps.all

        apps.idx = get_window_index(
            apps.wins,
            apps.curr_win
        )

        local border = apps.borders[apps.idx]

        if border then
            if toggle == 'show' then
                border:show()
            elseif toggle == 'hide' then
                border:hide()
            end
        end

        done()
    end
end


--------------------------------------------------------------------------------
-- Init
--------------------------------------------------------------------------------
function M.init()
    local win = hs.window.focusedWindow()
    local app = win:application():name()

    local all_wins = get_open_windows(win)

    if all_wins then
        state.apps = all_wins

        -- Establish 'all' idx from the focused window
        state.apps.all.idx = get_window_index(
            state.apps.all.wins,
            state.apps.all.curr_win
        )
    end

    -- Init layout if the focused window is compatible
    if cache.assets[app] then
        local id     = win:screen():id()
        local layout = state.screens[id].layout

        assign_window(layout, nil, win)
    end

    -- Show window border
    local init_fn = M.border('show')
    init_fn(function()
        -- Call done()
    end)
end

return M
