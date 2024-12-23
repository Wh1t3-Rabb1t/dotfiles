
local Var = {
    --------------------------------------------------------------------------------------------------------
    -- Cursor base movent speed variables.
    --------------------------------------------------------------------------------------------------------
    standardSpeed = 4,    -- Cursor movement speed without multipliers.
    slowSpeed = 3,        -- Cursor movements speed slowed down.
    fastSpeed = 12,        -- Cursor movements speed sped up.
    minSpeed = 1.1,         -- Minimum cursor movement speed after multipliers are applied.
    maxSpeed = 18,        -- Maximum cursor movement speed after multipliers are applied.

    --------------------------------------------------------------------------------------------------------
    -- Cursor acceleration / deceleration multipliers and on / off toggle.
    --------------------------------------------------------------------------------------------------------
    decelerationMultiplier = 10,    -- Cursor speed deceleration multiplier.
    accelerationMultiplier = 16,    -- Cursor speed acceleration multiplier.
    accelerationEnabled = true,     -- Enable or disable cursor acceleration when fastSpeed is active.
    decelerationEnabled = true,     -- Enable or disable cursor deceleration when slowSpeed is active.

    --------------------------------------------------------------------------------------------------------
    -- Size of the jump coordinate highlights.
    --------------------------------------------------------------------------------------------------------
    highlightSize = 60,         -- Size of the initial jump coordinate highlight.
    smallHighlightSize = 20,    -- Size of the secondary jump coordinate highlight.

    --------------------------------------------------------------------------------------------------------
    -- Scroll event key bindings.
    --------------------------------------------------------------------------------------------------------
    scrollUp = 'e',       -- Send a scroll up event.
    scrollDown = 'd',     -- Send a scroll down event.
    scrollLeft = 'w',     -- Send a scroll left event.
    scrollRight = 'r',    -- Send a scroll right event.

    --------------------------------------------------------------------------------------------------------
    -- Mouse event key bindings.
    --------------------------------------------------------------------------------------------------------
    cursorSlow = 's',    -- Slow down cursor movement.
    cursorFast = 'f',    -- Speed up cursor movement.
    cursorUp = 'i',      -- Move the cursor up.
    cursorDown = 'k',    -- Move the cursor down.
    cursorLeft = 't',    -- Move the cursor leftt.
    cursorRight = 'l',   -- Move the cursor right.

    --------------------------------------------------------------------------------------------------------
    -- Grid jump invocation key bindings.
    --------------------------------------------------------------------------------------------------------
    showAppGrid = ';',       -- Display the focused apps jump grid.
    showScreenGrid = "'",    -- Display the current screens jump grid.
    topLeft = 'w',           -- Jump the cursor to the top left coordinate.
    topCenter = 'e',         -- Jump the cursor to the top center coordinate.
    topRight = 'r',          -- Jump the cursor to the top right coordinate.
    centerLeft = 's',        -- Jump the cursor to the center left coordinate.
    center = 'd',            -- Jump the cursor to the center coordinate.
    centerRight = 'f',       -- Jump the cursor to the center right coordinate.
    bottomLeft = 'x',        -- Jump the cursor to the bottom left coordinate.
    bottomCenter = 'c',      -- Jump the cursor to the bottom center coordinate.
    bottomRight = 'v',       -- Jump the cursor to the bottom right coordinate.

    --------------------------------------------------------------------------------------------------------
    -- Jump to the next or previous monitor.
    --------------------------------------------------------------------------------------------------------
    jumpNextScreen = 'n',        -- Jump the cursor to the middle of the next screen.
    jumpPreviousScreen = 'p',    -- Jump the cursor to the middle of the previous screen.
}

return Var




-- local Var = {}
-- --------------------------------------------------------------------------------------------------------
-- -- Cursor base movent speed variables.
-- --------------------------------------------------------------------------------------------------------
-- Var.standardSpeed = 4    -- Cursor movement speed without multipliers.
-- Var.slowSpeed = 4        -- Cursor movements speed slowed down.
-- Var.fastSpeed = 8        -- Cursor movements speed sped up.
-- Var.minSpeed = 1         -- Minimum cursor movement speed after multipliers are applied.
-- Var.maxSpeed = 24        -- Maximum cursor movement speed after multipliers are applied.

-- --------------------------------------------------------------------------------------------------------
-- -- Cursor acceleration / deceleration multipliers and on / off toggle.
-- --------------------------------------------------------------------------------------------------------
-- Var.decelerationMultiplier = 10    -- Cursor speed deceleration multiplier.
-- Var.accelerationMultiplier = 16    -- Cursor speed acceleration multiplier.
-- Var.accelerationEnabled = true     -- Enable or disable cursor acceleration when fastSpeed is active.
-- Var.decelerationEnabled = true     -- Enable or disable cursor deceleration when slowSpeed is active.

-- --------------------------------------------------------------------------------------------------------
-- -- Size of the jump coordinate highlights.
-- --------------------------------------------------------------------------------------------------------
-- Var.highlightSize = 60         -- Size of the initial jump coordinate highlight.
-- Var.smallHighlightSize = 20    -- Size of the secondary jump coordinate highlight.

-- --------------------------------------------------------------------------------------------------------
-- -- Scroll event key bindings.
-- --------------------------------------------------------------------------------------------------------
-- Var.scrollUp = 'e'       -- Send a scroll up event.
-- Var.scrollDown = 'd'     -- Send a scroll down event.
-- Var.scrollLeft = 'w'     -- Send a scroll left event.
-- Var.scrollRight = 'r'    -- Send a scroll right event.

-- --------------------------------------------------------------------------------------------------------
-- -- Mouse event key bindings.
-- --------------------------------------------------------------------------------------------------------
-- Var.cursorSlow = 's'    -- Slow down cursor movement.
-- Var.cursorFast = 'f'    -- Speed up cursor movement.
-- Var.cursorUp = 'i'      -- Move the cursor up.
-- Var.cursorDown = 'k'    -- Move the cursor down.
-- Var.cursorLeft = 't'    -- Move the cursor leftt.
-- Var.cursorRight = 'l'   -- Move the cursor right.

-- --------------------------------------------------------------------------------------------------------
-- -- Grid jump invocation key bindings.
-- --------------------------------------------------------------------------------------------------------
-- Var.showAppGrid = ';'       -- Display the focused apps jump grid.
-- Var.showScreenGrid = "'"    -- Display the current screens jump grid.
-- Var.topLeft = 'w'           -- Jump the cursor to the top left coordinate.
-- Var.topCenter = 'e'         -- Jump the cursor to the top center coordinate.
-- Var.topRight = 'r'          -- Jump the cursor to the top right coordinate.
-- Var.centerLeft = 's'        -- Jump the cursor to the center left coordinate.
-- Var.center = 'd'            -- Jump the cursor to the center coordinate.
-- Var.centerRight = 'f'       -- Jump the cursor to the center right coordinate.
-- Var.bottomLeft = 'x'        -- Jump the cursor to the bottom left coordinate.
-- Var.bottomCenter = 'c'      -- Jump the cursor to the bottom center coordinate.
-- Var.bottomRight = 'v'       -- Jump the cursor to the bottom right coordinate.

-- --------------------------------------------------------------------------------------------------------
-- -- Jump to the next or previous monitor.
-- --------------------------------------------------------------------------------------------------------
-- Var.jumpNextScreen = 'g'        -- Jump the cursor to the middle of the next screen.
-- Var.jumpPreviousScreen = 'a'    -- Jump the cursor to the middle of the previous screen.

-- return Var






-- --------------------------------------------------------------------------------------------------------











































-- local Var = {
--     standardSpeed = 8, -- Cursor movement speed without multipliers.
--     fastSpeed = 15, -- Cursor movements speed sped up.
--     slowSpeed = 6, -- Cursor movements speed slowed down.
--     maxSpeed = 30, -- Maximum cursor movement speed after multipliers are applied.
--     minSpeed = 1, -- Minimum cursor movement speed after multipliers are applied.
--     acceleration = 1,
--     deceleration = 1,
--     highlightSize = 60, -- Size of the jump coord highlights.
-- }

-- k_keyDown = false
-- i_keyDown = false
-- l_keyDown = false
-- t_keyDown = false
-- shift_keyDown = nil
-- ctrl_keyDown = nil
-- dragging = false

-- local keycodes = hs.keycodes.map
-- local orig_coords = nil
-- local mappedCoords = {}
-- local dragging = false
-- local quoteHeld = false
-- local semicolonHeld = false
-- local AppGrid = require('../vivi_modules/cursor_highlight')
-- local o_keyDown = nil
-- local u_keyDown = nil
-- local scrolling = 0
