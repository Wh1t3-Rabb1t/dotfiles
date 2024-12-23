
-- The postMouseEvent vs update the absolutePosition logic can be handled in the vimouse file then passed in here.
-- Possibly create a new module to handle the insideScreen logic.
--
-- Condider writing a new logic block inside one of the functions below that determins the distance from the screen
-- edge and increase the coords by one less than that number to prevent the out of bounds bug.
--
-- Condider applying flags to mouse events to send combos like cmd + click etc.

local MoveCursor = {}

-------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------

function updateCursorPosition(step, axis)
    local eventTypes = hs.eventtap.event.types
    local coords = hs.mouse.absolutePosition()

    if ctrl_keyDown then
        step = step / 4
    end

    if axis == 'x' then
        coords.x = coords.x + step
        axis = nil
    elseif axis == 'y' then
        coords.y = coords.y + step
        axis = nil
    end

    postMouseEvent(eventTypes.mouseMoved, coords, flags, 0)
end

-------------------------------------------------------------------------------------------------------------------------------------

function MoveCursor:keyRepeat(step, axis)
    local keyRepeateRate = hs.eventtap.keyRepeatInterval()
    local eventTypes = hs.eventtap.event.types
    local timer

    timer = hs.timer.new(keyRepeateRate, function()
        local coords = hs.mouse.absolutePosition()

        -- -- If another key is pressed or the active key is released stop repeating key strokes.
        -- if interrupt or shift_keyDown or not keyHeld then
        --     postMouseEvent(eventTypes.leftMouseUp, coords, flags, 0)
        --     keyAutoRepeating = false
        --     timer:stop()
        -- else
        --     updateCursorPosition(step, axis)
        -- end

        -- If another key is pressed or the active key is released stop repeating key strokes.
        if interrupt or shift_keyDown then
            keyAutoRepeating = false
            timer:stop()
        elseif not keyHeld then
            postMouseEvent(eventTypes.leftMouseUp, coords, flags, 0)
            keyAutoRepeating = false
            timer:stop()
        else
            updateCursorPosition(step, axis)
        end

    end)
    timer:start()
end

-------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------

function MoveCursor:horizontally(step)
    local axis = 'x'

    if keyAutoRepeating then
        return
    elseif i_keyDown or k_keyDown then
        -- print('vertical cancel')
        return
    else
        updateCursorPosition(step, axis)
    end
end

-------------------------------------------------------------------------------------------------------------------------------------

function MoveCursor:vertically(step)
    local axis = 'y'

    if keyAutoRepeating then
        return
    elseif t_keyDown or l_keyDown then
        -- print('horizontal cancel')
        return
    else
        updateCursorPosition(step, axis)
    end
end

-------------------------------------------------------------------------------------------------------------------------------------

function MoveCursor:diagonally(step_x, step_y)
    local eventTypes = hs.eventtap.event.types
    local coords = hs.mouse.absolutePosition()

    if ctrl_keyDown then
        step_x = step_x / 4
        step_y = step_y / 4
    end

    coords.x = coords.x + step_x
    coords.y = coords.y + step_y
    postMouseEvent(eventTypes.mouseMoved, coords, flags, 0)
end

-------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------

return MoveCursor






-- function MoveCursor:horizontally(step, upKey, downKey, inBounds_x, keyAutoRepeating, ctrlPressed)
--     local coords = hs.mouse.absolutePosition()

--     if keyAutoRepeating then
--         return
--         -- print('autoRepeat triggered return')
--     elseif upKey or downKey then
--         return
--         -- print('key triggered return')
--     else
--         coords.x = coords.x + step

--         -- Only post mouse events if the cursor is within the boundaries of the current screen to prevent out of bounds movement.
--         if inBounds_x then
--             postMouseEvent(eventTypes.mouseMoved, coords, flags, 0)
--             -- print('postEvt')
--         else
--             hs.mouse.absolutePosition(coords)
--             -- print('absPos')
--         end

--     end
-- end

-------------------------------------------------------------------------------------------------------------------------------------

-- function MoveCursor:vertically(step, leftKey, rightKey, inBounds_y, keyAutoRepeating)
--     local coords = hs.mouse.absolutePosition()

--     if keyAutoRepeating then
--         return
--         -- print('autoRepeat triggered return')
--     elseif leftKey or rightKey then
--         return
--         -- print('key triggered return')
--     else

--         coords.y = coords.y + step

--         -- Only post mouse events if the cursor is within the boundaries of the current screen to prevent out of bounds movement.
--         if inBounds_y then
--             postMouseEvent(eventTypes.mouseMoved, coords, flags, 0)
--             -- print('postEvt')
--         else
--             hs.mouse.absolutePosition(coords)
--             -- print('absPos')
--         end

--     end
-- end

-------------------------------------------------------------------------------------------------------------------------------------

-- function MoveCursor:diagonally(step_x, step_y, inBounds_x, inBounds_y)
--     local coords = hs.mouse.absolutePosition()

--     coords.x = coords.x + step_x
--     coords.y = coords.y + step_y

--     -- Only post mouse events if the cursor is within the boundaries of the current screen to prevent out of bounds movement.
--     if inBounds_x and inBounds_y then
--         postMouseEvent(eventTypes.mouseMoved, coords, flags, 0)
--         -- print('postEvt')
--     else
--         hs.mouse.absolutePosition(coords)
--         -- print('absPos')
--     end

-- end


-- function MoveCursor:keyRepeat(step, axis)
--     local keyRepeateRate = hs.eventtap.keyRepeatInterval()
--     local eventTypes = hs.eventtap.event.types
--     local timer

--     timer = hs.timer.new(keyRepeateRate, function()
--         local coords = hs.mouse.absolutePosition()

--         -- If another key is pressed or the active key is released stop repeating key strokes.
--         if interrupt or shift_keyDown then
--             postMouseEvent(eventTypes.leftMouseUp, coords, flags, 0)

--             timer:stop()
--             keyAutoRepeating = false
--         elseif not keyHeld then
--             postMouseEvent(eventTypes.leftMouseUp, coords, flags, 0)

--             timer:stop()
--             keyAutoRepeating = false
--         else
--             updateCursorPosition(step, axis)
--         end

--     end)
--     timer:start()
-- end



-- function MoveCursor:keyRepeat(step, axis)
--     local keyRepeateRate = hs.eventtap.keyRepeatInterval()
--     -- local timer

--     -- timer = hs.timer.new(keyRepeateRate, function()
--     keyRepeatTimer = hs.timer.new(keyRepeateRate, function()
--         -- If another key is pressed or the active key is released stop repeating key strokes.
--         if interrupt then
--             keyRepeatTimer:stop()
--             keyAutoRepeating = false
--         elseif not keyHeld then
--             keyRepeatTimer:stop()
--             keyAutoRepeating = false
--         elseif shift_keyDown then
--             keyRepeatTimer:stop()
--             keyAutoRepeating = false
--         else
--             updateCursorPosition(step, axis)
--         end
--     end)

--     keyRepeatTimer:start()
-- end
