local M = {}

local state = require('state')
local cache = require('cache')


-- Check if tables have been initialized.
--------------------------------------------------------------------------------
function M.tbl(obj)
    if type(obj) == 'table' and next(obj) ~= nil then
        return true
    end
end






-- Get popups width and height.
--
-- Parameters:
--   popups   (table):   hs.canvas objects
--   spacing  (number):  Number of pixels to use as spacing
--   stacking (string):  'horizontal' or 'vertical'
--
-- Returns:
--   (table): Width and height of each popup
--------------------------------------------------------------------------------
local function get_popup_w_h(popups, spacing, stacking)
    local width  = 0
    local height = 0

    for i, popup in ipairs(popups) do
        if stacking == 'vertical' then
            width  = math.max(width, popup.frame.w)
            height = height + popup.frame.h

            if i < #popups then
                height = height + spacing
            end
        elseif stacking == 'horizontal' then
            width  = width + popup.frame.w
            height = math.max(height, popup.frame.h)

            if i < #popups then
                width = width + spacing
            end
        end
    end

    return {
        w = width,
        h = height
    }
end


-- Get popups x and y coords.
--
-- Parameters:
--   popups   (table):   hs.canvas objects
--   spacing  (number):  Number of pixels to use as spacing
--   stacking (string):  'horizontal' or 'vertical'
--
-- Returns:
--   coords (table):  x and y coordinates of each popup
--------------------------------------------------------------------------------
local function get_popup_x_y(popups, spacing, stacking)
    local x = 0
    local y = 0

    local coords = {}

    for i, popup in ipairs(popups) do
        if stacking == 'horizontal' then
            coords[i] = {
                x = x,
                y = 0,
            }

            x = x + popup.frame.w + spacing
        elseif stacking == 'vertical' then
            coords[i] = {
                x = 0,
                y = y,
            }

            y = y + popup.frame.h + spacing
        end
    end

    return coords
end


-- Get popup anchor position.
--
-- Parameters:
--   frame  (table):   hs.window:frame()
--   width  (number):  Width of the canvas object
--   height (number):  Height of the canvas object
--
-- Returns:
--   anchor (table):  Width and height of each popup
--------------------------------------------------------------------------------
local function get_popup_anchor(frame, width, height)
    local corner = state.wk.corner

    local padding = 25

    local anchor = {}

    if corner == 'top_left' then
        anchor.x = frame.x + padding
        anchor.y = frame.y + padding
    elseif corner == 'top_right' then
        anchor.x = frame.x + frame.w - width - padding
        anchor.y = frame.y + padding
    elseif corner == 'bottom_left' then
        anchor.x = frame.x + padding
        anchor.y = frame.y + frame.h - height - padding
    elseif corner == 'bottom_right' then
        anchor.x = frame.x + frame.w - width - padding
        anchor.y = frame.y + frame.h - height - padding
    end

    return anchor
end


-- Calculate popup coordinates relative to the focused window.
--
-- Parameters:
--   popups   (table):   Popups containing frame dimensions
--   spacing  (number):  Space between adjacent popups
--   stacking (string):  'horizontal' or 'vertical'
--
-- Returns:
--   coords (table):  x and y coordinates for each popup
--------------------------------------------------------------------------------
local function get_popup_coords(win, popups)
    local stack        = state.wk.stack
    local screen_frame = state.screens[win:screen():id()].frame

    local spacing = 25

    local coords = {}

    local dimensions = get_popup_w_h(popups, spacing, stack)

    -- Arrange popups side by side if the stack height exceeds the screen height
    if dimensions.h > screen_frame.h then
        dimensions = get_popup_w_h(popups, spacing, 'horizontal')
        coords     = get_popup_x_y(popups, spacing, 'horizontal')
    else
        coords = get_popup_x_y(popups, spacing, stack)
    end

    local anchor = get_popup_anchor(win:frame(), dimensions.w, dimensions.h)

    for _, coord in ipairs(coords) do
        coord.x = coord.x + anchor.x
        coord.y = coord.y + anchor.y
    end

    return coords
end


--------------------------------------------------------------------------------
-- Toggle popup visibility.
--
-- Parameters:
--   (table):  Contains strings, either 'on' or 'off'
--
-- Calls:
--   get_popup_coords()
--------------------------------------------------------------------------------
function M.toggle_popups( ... )
    for _, set_to in ipairs({ ... }) do
        if set_to == 'on' then
            local win      = state.windows.curr_win
            local app_name = win:application():name()

            local popups = {}

            -- App specific popup
            if cache.assets[app_name] then
                table.insert(popups, cache.assets[app_name])
            end

            -- System popup
            table.insert(popups, cache.assets.system)

            local coords = get_popup_coords(win, popups)

            for i, v in ipairs(popups) do
                v.popup:topLeft(coords[i])
                v.popup:alpha(state.wk.opacity)
                v.popup:show(0.15)
            end

        elseif set_to == 'off' then
            for _, v in pairs(cache.assets) do
                if v.popup:isShowing() then
                    v.popup:hide()
                end
            end
        end
    end
end


--------------------------------------------------------------------------------
-- Toggle border visibility.
--
-- Parameters:
--   (table):  Contains strings, either 'on' or 'off'
--
-- State changes:
--   windows.border
--------------------------------------------------------------------------------
function M.toggle_border( ... )
    for _, set_to in ipairs({ ... }) do
        local win    = state.windows.curr_win
        local border = state.windows.border

        if set_to == 'on' then
            -- Create border if it doesn't already exist
            if not border then
                border = hs.canvas.new(win:frame())

                border:appendElements({
                    type        = 'rectangle',
                    action      = 'stroke',
                    strokeColor = { white = 1, alpha = 1 },
                    strokeWidth = 3,
                })

                border:level(hs.canvas.windowLevels.overlay)
                border:behavior(hs.canvas.windowBehaviors.canJoinAllSpaces)

                state.windows.border = border
            else
                border:frame(win:frame())
            end

            border:show()

        elseif set_to == 'off' then
            border:hide()
        end
    end
end


--------------------------------------------------------------------------------
-- Toggle event tap.
--
-- Parameters:
--   (table):  Contains strings, either 'on' or 'off'
--
-- State changes:
--   state.wk.tap_active
--------------------------------------------------------------------------------
function M.toggle_tap( ... )
    for _, set_to in ipairs({ ... }) do
        if set_to == 'on' then
            state.wk.tap_active = true
            cache.wk_tap:start()
        elseif set_to == 'off' then
            state.wk.tap_active = false
            cache.wk_tap:stop()
        end
    end
end

return M
