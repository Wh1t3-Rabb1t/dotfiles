--
--   _ __   ___  ___   ___ ___  _ __ ___  _ __   ___  ___  ___ _ __
--  | '_ \ / _ \/ _ \ / __/ _ \| '_ ` _ \| '_ \ / _ \/ __|/ _ \ '__|
--  | | | |  __/ (_) | (_| (_) | | | | | | |_) | (_) \__ \  __/ |
--  |_| |_|\___|\___/ \___\___/|_| |_| |_| .__/ \___/|___/\___|_|
-- ======================================|_|====================================

local M = {}

-- KEYS
--------------------------------------------------------------------------------
M.keys = {
    "q",
    "m",
    "M",
}


-- CONFIG
--------------------------------------------------------------------------------
function M.config()
    local status_ok = pcall(require, "NeoComposer")
    if not status_ok then return end

    -- Setup
    local colors = require("catppuccin.palettes").get_palette()
    require("NeoComposer").setup({
        notify = true,
        delay_timer = 0,
        queue_most_recent = true,

        window = {
            width = 60,
            height = 10,
            border = "none",
            winhl = { Normal = "ComposerNormal", }
        },

        colors = {
            bg = colors.base,
            fg = colors.peach,
            red = "#d20f39",  -- Latte red
            blue = colors.blue,
            green = colors.green,
        },

        keymaps = {
            toggle_record = "q",
            play_macro = "m",
            toggle_macro_menu = "M",
            yank_macro = false,
            stop_macro = false,
            cycle_next = false,
            cycle_prev = false,
        }
    })
end

return M
