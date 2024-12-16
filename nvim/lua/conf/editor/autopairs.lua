--               _                    _
--    __ _ _   _| |_ ___  _ __   __ _(_)_ __ ___
--   / _` | | | | __/ _ \| '_ \ / _` | | '__/ __|
--  | (_| | |_| | || (_) | |_) | (_| | | |  \__ \
--   \__,_|\__,_|\__\___/| .__/ \__,_|_|_|  |___/
-- ======================|_|====================================================

local M = {}

-- CONFIG
--------------------------------------------------------------------------------
function M.config()
    local status_ok = pcall(require, "nvim-autopairs")
    if not status_ok then return end

    -- Setup
    require("nvim-autopairs").setup({
        check_ts = true,  -- Enable treesitter
        ts_config = {
            lua = {
                -- Don't add pairs in lua string treesitter nodes
                "string"
            },
            javascript = {
                -- Don't add pairs in javascript template_string treesitter nodes
                "template_string"
            }
            -- java = false,  -- Don't check treesitter on java
        }
    })

    -- Integrate autopairs with completion
    local cmp = require("cmp")
    local cmp_autopairs = require("nvim-autopairs.completion.cmp")
    cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
end

return M
