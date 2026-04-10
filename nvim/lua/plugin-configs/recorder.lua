--                              _
--   _ __ ___  ___ ___  _ __ __| | ___ _ __
--  | '__/ _ \/ __/ _ \| '__/ _` |/ _ \ '__|
--  | | |  __/ (_| (_) | | | (_| |  __/ |
--  |_|  \___|\___\___/|_|  \__,_|\___|_|
-- =============================================================================

local M = {}

-- KEYS
--------------------------------------------------------------------------------
M.keys = {
    -- These must match the keys in the mapping config below
    { "Q", desc = " Start Recording" },
    { "q", desc = " Play Recording" },
}

-- CONFIG
--------------------------------------------------------------------------------
function M.config()
    require("recorder").setup({
        mapping = {
            startStopRecording = "Q",
            playMacro = "q",
            switchSlot = "<Leader>;<C-q>",
            editMacro = "<Leader>;cq",
            deleteAllMacros = "<Leader>;dq",
            yankMacro = "<Leader>;yq",
            -- !! This should be a string you don't use in insert mode during a macro
            -- addBreakPoint = "##",
            addBreakPoint = "z#z#z#",
        },
        clear = false,  -- Clears all macros-slots on startup
        lessNotifications = false,
    })
end

return M
