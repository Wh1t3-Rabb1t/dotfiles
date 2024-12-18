--   _             _ _
--  | |_   _  __ _| (_)_ __   ___
--  | | | | |/ _` | | | '_ \ / _ \
--  | | |_| | (_| | | | | | |  __/
--  |_|\__,_|\__,_|_|_|_| |_|\___|
-- =============================================================================

local M = {}

-- CONFIG
--------------------------------------------------------------------------------
function M.config()
    local status_ok = pcall(require, "lualine")
    if not status_ok then return end

    -- Setup
    local icons = require("util.icons").lualine
    local lualine_theme = require("lualine.themes.powerline_dark")
    lualine_theme = require("util.colors").lualine
    require("lualine").setup({
        options = {
            icons_enabled = true,
            theme = lualine_theme,
            component_separators = {
                left = icons.component_separator_left,
                right = icons.component_separator_right,
            },
            section_separators = {
                left = icons.section_separator_left,
                right = icons.section_separator_right,
            },
            always_divide_middle = true,
            globalstatus = true,
            refresh = {
                tabline = 100000,
            },
            disabled_filetypes = {
                sections = {
                    lualine_x = {
                        -- Prevent git signs from bugging out
                        -- when neotree is focused
                        "neo-tree"
                    }
                }
            }
        },

        -- Status line
        sections = {
            lualine_a = {
                icons.vim_logo
            },
            lualine_b = {
                icons.get_vim_mode
            },
            lualine_c = {
                "location",
                "progress",
                {   -- Grapple
                    icons.grappe_icon,
                    cond = function()
                        return require("grapple").exists()
                    end
                },
                {   -- Modified icon
                    icons.modified,
                    cond = function()
                        return vim.bo.modified
                    end,
                    color = {
                        fg = "#ffffff",
                        bg = false,
                    }
                }
            },
            lualine_x = {
                "diagnostics",
                "diff",
            },
            lualine_y = {
                "branch"
            },
            lualine_z = {
                icons.get_cwd
            }
        },

        extensions = {},
    })
end

return M
