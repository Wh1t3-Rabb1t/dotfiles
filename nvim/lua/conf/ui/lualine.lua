--   _             _ _
--  | |_   _  __ _| (_)_ __   ___
--  | | | | |/ _` | | | '_ \ / _ \
--  | | |_| | (_| | | | | | |  __/
--  |_|\__,_|\__,_|_|_|_| |_|\___|
-- =============================================================================

local M = {}

-- ICONS
--------------------------------------------------------------------------------
local icons = {
    clock = "",
    component_separator_left = "╱",
    component_separator_right = "╱",
    section_separator_left = "",
    section_separator_right = "",
    location_icon = " ",
    diagnostics_error = " ",
    diagnostics_warn = " ",
    diagnostics_info = " ",
    diagnostics_hint = "󱠂 ",
    diff_added = " ",
    diff_modified = " ",
    diff_removed = "󰍷 ",
    modified = function() return "●" end,
    vim_logo = function() return "" end,
    grapple_icon = function() return "󰛢" end,
    get_vim_mode = function()
        local vim_mode = vim.fn.mode()
        local mode_icon = {
            ["n"] = "❮",
            ["i"] = "❯",
            ["v"] = "V",
            ["V"] = "L",
            ["c"] = "󰞷",
            ["R"] = "▶",
            ["\x16"] = "B",  -- Vblock escape sequence
        }
        -- Return search icon when fzf is active
        return mode_icon[vim_mode] or ""
    end,
    get_cwd = function()
        local cwd = vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
        return " " .. cwd
    end
}


-- CONFIG
--------------------------------------------------------------------------------
function M.config()
    local status_ok = pcall(require, "lualine")
    if not status_ok then return end

    -- Color overrides
    local colors = require("catppuccin.palettes").get_palette()
    local lualine_theme = require("lualine.themes.powerline_dark")
    lualine_theme = {
        normal = {
            a = { fg = colors.crust, bg = colors.sky },
            b = { fg = colors.crust, bg = colors.sky },
            c = { fg = colors.peach, bg = colors.surface1 },
        },
        insert = {
            a = { fg = colors.crust, bg = colors.sky },
            b = { fg = colors.sky, bg = colors.surface1 },
            c = { fg = colors.peach, bg = colors.crust, gui = "italic" },
        },
        visual = {
            a = { fg = colors.crust, bg = colors.sky },
            b = { fg = colors.sky, bg = "#125ef4" },
            c = { fg = colors.peach, bg = "#06338d", gui = "italic" },
        },
        replace = {
            a = { fg = colors.crust, bg = colors.sky },
            b = { fg = colors.crust, bg = "#8d0a26" },
            c = { fg = colors.peach, bg = colors.crust },
        },
        command = {
            a = { fg = colors.crust, bg = colors.sky },
            b = { fg = colors.sky, bg = "#d20f39" },
            c = { fg = colors.peach, bg = "#4d0615" },
        },
        inactive = {
            c = { fg = colors.surface2, bg = colors.mantle, gui = "italic" },
        }
    }

    -- Setup
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
            refresh = { tabline = 100000, },
            disabled_filetypes = {
                winbar = {
                    "neo-tree"
                }
            }
        },

        -- Status line
        sections = {
            lualine_a = {},
            lualine_b = { icons.get_vim_mode },
            lualine_c = {
                {
                    "location",
                    separator = "",
                    padding = 0,
                    icon = {
                        icons.location_icon,
                        align="left"
                    }
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

        -- Focused window
        winbar = {
            lualine_a = { icons.vim_logo },
            lualine_b = {},
            lualine_c = {
                {
                    -- Omit the 'symbols' field for now as it crashes neovim if
                    -- launched without any files open.
                    "filename",

                    -- Displays file status (readonly status, modified status)
                    file_status = true,

                    -- Display new file status (new file means no write after created)
                    newfile_status = false,

                    -- 0: Just the filename
                    -- 1: Relative path
                    -- 2: Absolute path
                    -- 3: Absolute path, with tilde as the home directory
                    -- 4: Filename and parent dir, with tilde as the home directory
                    path = 1,
                },
                {   -- Grapple
                    icons.grapple_icon,
                    color = { fg = colors.sky },
                    cond = function()
                        return require("grapple").exists()
                    end
                }
            },
            lualine_x = {
                {
                    "datetime",
                    icon = icons.clock,
                    style = "%H:%M",
                }
            },
            lualine_y = {},
            lualine_z = {},
        },

        -- Unfocused window
        inactive_winbar = {
            lualine_a = {},
            lualine_b = {},
            lualine_c = {
                {
                    "filename",
                    file_status = true,
                    newfile_status = false,
                    path = 1,
                }
            },
            lualine_x = {},
            lualine_y = {},
            lualine_z = {},
        },

        extensions = {},
    })
end

return M
