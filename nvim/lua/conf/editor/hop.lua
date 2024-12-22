--      __
--     / /_  ____  ____
--    / __ \/ __ \/ __ \
--   / / / / /_/ / /_/ /
--  /_/ /_/\____/ .___/  Neovim motions on speed!
-- ============/_/==============================================================

local M = {}

-- KEYS
--------------------------------------------------------------------------------
M.keys = {
    {
        mode = { "n", "v" },
        "<Leader>j",
        "<cmd>HopChar2<CR>",
        desc = "HOP (2 char search)"
    }
}


-- CONFIG
--------------------------------------------------------------------------------
function M.config()
    local status_ok = pcall(require, "hop")
    if not status_ok then return end

    -- Setup
    require("hop").setup({
        -- Missing keys: zZbBjJqQpP
        keys = "ftdksleiwoacnvghyxmruFTDKSLEIWOACNVGHYXMRU"
    })
end

return M
