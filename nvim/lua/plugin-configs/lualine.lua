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

    local icons = {
        clock = "",
        component_separator_left = "╱",
        component_separator_right = "╱",
        section_separator_left = "",
        section_separator_right = "",
        location_icon = " ",
        diagnostics_error = " ",
        diagnostics_warn = " ",
        diagnostics_info = " ",
        diagnostics_hint = " ",
        diff_added = " ",
        diff_removed = " ",
        diff_modified = " ",
        modified = function() return "●" end,
        vim_logo = function() return "" end,
        get_vim_mode = function()
            local vim_mode = vim.fn.mode()
            local mode_icon = {
                ["n"] = "❮",
                ["i"] = "❯",
                ["v"] = "V",
                ["V"] = "L",
                ["\x16"] = "B",  -- Vblock escape sequence
                ["c"] = "󰞷",
                ["R"] = "▶",
            }
            -- Return search icon when fzf is active
            return mode_icon[vim_mode] or ""
        end,
        get_cwd = function()
            local cwd = vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
            return " " .. cwd
        end
    }

    -- Color overrides
    local hl = require("catppuccin.palettes").get_palette()
    local lualine_theme = require("lualine.themes.powerline_dark")
    lualine_theme = {
        normal = {
            a = { fg = hl.crust, bg = hl.sky },
            b = { fg = hl.crust, bg = hl.sky },
            c = { fg = hl.peach, bg = hl.surface1 },
        },
        insert = {
            a = { fg = hl.crust, bg = hl.sky },
            b = { fg = hl.sky, bg = hl.surface1 },
            c = { fg = hl.peach, bg = hl.crust, gui = "italic" },
        },
        visual = {
            a = { fg = hl.crust, bg = hl.sky },
            b = { fg = hl.sky, bg = "#125ef4" },
            c = { fg = hl.peach, bg = "#06338d", gui = "italic" },
        },
        replace = {
            a = { fg = hl.crust, bg = hl.sky },
            b = { fg = hl.crust, bg = "#8d0a26" },
            c = { fg = hl.peach, bg = hl.crust },
        },
        command = {
            a = { fg = hl.crust, bg = hl.sky },
            b = { fg = hl.sky, bg = "#d20f39" },
            c = { fg = hl.peach, bg = "#4d0615" },
        },
        inactive = {
            c = { fg = hl.surface2, bg = hl.mantle, gui = "italic" },
        }
    }

    -- SETUP
    require("lualine").setup({
        options = {
            theme = lualine_theme,
            component_separators = {
                left = icons.component_separator_left,
                right = icons.component_separator_right,
            },
            section_separators = {
                left = icons.section_separator_left,
                right = icons.section_separator_right,
            },
            globalstatus = false,
            refresh = { tabline = 100000 },
            disabled_filetypes = {
                winbar = { "snacks_picker_list" },
                statusline = { "snacks_picker_list" },
            }
        },

        -- STATUS LINE
        sections = {
            lualine_a = {},
            lualine_b = { icons.get_vim_mode },
            lualine_c = {
                {
                    "location",
                    separator = "",
                    padding = 0,
                    icon = { icons.location_icon, align="left" }
                },
                "progress",
            },
            lualine_x = {
                {
                    "diagnostics",
                    symbols = {
                        error = icons.diagnostics_error,
                        warn = icons.diagnostics_warn,
                        info = icons.diagnostics_info,
                        hint = icons.diagnostics_hint,
                    }
                },
                {
                    "diff",
                    symbols = {
                        added = icons.diff_added,
                        modified = icons.diff_modified,
                        removed = icons.diff_removed,
                    },
                    separator = "",
                    padding = { left = 1, right = 0 },
                },
                {
                    "branch",
                    color = { fg = "#f9e2af" }
                }
            },
            lualine_y = { icons.get_cwd },
            lualine_z = {},
        },

        -- FOCUSED WINDOW
        winbar = {
            lualine_a = { icons.vim_logo },
            lualine_b = {},
            lualine_c = {
                {
                    "filename",
                    file_status = true,      -- File status (readonly status, modified status)
                    newfile_status = false,  -- New file status (new means no write after created)
                    path = 1,
                }
            },
            lualine_x = { "lsp_status" },
            lualine_y = {},
            lualine_z = {},
        },

        -- UNFOCUSED WINDOW
        inactive_winbar = {
            lualine_a = {},
            lualine_b = {},
            lualine_c = {
                {
                    function()
                        -- Hack to ensure 'snacks_picker_list' is ignored
                        if vim.bo.buftype == "nofile" then return "" end
                        return vim.fn.expand("%:t")
                    end,
                    "filename",
                    file_status = true,
                    newfile_status = false,
                    path = 1,
                }
            },
            lualine_x = {},
            lualine_y = {},
            lualine_z = {},
        }
    })
end

return M
