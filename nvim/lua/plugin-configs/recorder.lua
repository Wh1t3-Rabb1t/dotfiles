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
    { "q", desc = " Start Recording" },
    { "Q", desc = " Play Recording" },
}

-- CONFIG
--------------------------------------------------------------------------------
function M.config()
    require("recorder").setup({
        mapping = {
            startStopRecording = "q",
            playMacro = "Q",
        }
    })
end

return M
