--           _     _      _       _
-- __      _| |__ (_) ___| |__   | | _____ _   _
-- \ \ /\ / / '_ \| |/ __| '_ \  | |/ / _ \ | | |
--  \ V  V /| | | | | (__| | | | |   <  __/ |_| |
--   \_/\_/ |_| |_|_|\___|_| |_| |_|\_\___|\__, |
-- ========================================|___/================================

local M = {}

M.opts = {
    preset = "helix",  -- (classic|modern|helix)
    delay = 0,
    triggers = {
        -- Leave out mode 'x' to prevent visual mode triggering which-key
        { "<auto>", mode = "nso" },
    }
}

return M
