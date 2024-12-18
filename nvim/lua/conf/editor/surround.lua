--                                            _
--   ___ _   _ _ __ _ __ ___  _   _ _ __   __| |
--  / __| | | | '__| '__/ _ \| | | | '_ \ / _` |
--  \__ \ |_| | |  | | | (_) | |_| | | | | (_| |
--  |___/\__,_|_|  |_|  \___/ \__,_|_| |_|\__,_|
-- =============================================================================

local M = {}

-- CONFIG
--------------------------------------------------------------------------------
function M.config()
    local status_ok = pcall(require, "nvim-surround")
    if not status_ok then return end

    -- Setup
    require("nvim-surround").setup({
        -- Configuration here, or leave empty to use defaults
        keymaps = {
            insert = false,
            insert_line = false,
            normal = false,
            normal_cur = false,
            normal_line = false,
            normal_cur_line = false,
            visual_line = false,
            change_line = false,
            visual = false,
            delete = false,
            change = false,
        },

        -- Wrap content without adding spaces
        surrounds = {
            ["("] = {
                add = { "(", ")" }
            },
            ["["] = {
                add = { "[", "]" }
            },
            ["<"] = {
                add = { "<", ">" }
            }
        }
    })
end

return M