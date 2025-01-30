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
    component_separator_left = "╱",
    component_separator_right = "╱",
    section_separator_left = "",
    section_separator_right = "",
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

--       component_separators = { left = '╲', right = '╱' },
-- disabled_filetypes = { 'alpha', 'neo-tree', 'snacks_dashboard' },
-- section_separators = { left = '', right = '' },

-- ""
--  "
-- icon = "",
-- symbols = { added = " ", modified = " ", removed = " " },
-- symbols = { error = " ", warn = " ", info = " ", hint = " " },

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
            a = { fg = colors.crust, bg = colors.text },
            b = { fg = colors.crust, bg = "#a6d189" },
            c = { fg = colors.peach, bg = colors.surface1 },
        },
        insert = {
            a = { fg = colors.crust, bg = colors.text },
            b = { fg = colors.crust, bg = colors.lavender },
            c = { fg = colors.peach, bg = colors.crust, gui = "italic" },
        },
        visual = {
            a = { fg = colors.crust, bg = colors.text },
            b = { fg = colors.text, bg = "#1e66f5" },
            c = { fg = colors.crust, bg = "#8aadf4", gui = "italic" },
        },
        replace = {
            a = { fg = colors.crust, bg = colors.text },
            b = { fg = colors.crust, bg = colors.red },
            c = { fg = colors.peach, bg = colors.base },
        },
        command = {
            a = { fg = colors.crust, bg = colors.text },
            b = { fg = colors.text, bg = "#d20f39" },
            c = { fg = colors.peach, bg = colors.base },
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
            lualine_a = { icons.vim_logo },
            lualine_b = { icons.get_vim_mode },
            lualine_c = {
                "location",
                "progress",
                {   -- Grapple
                    icons.grapple_icon,
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
            lualine_y = { "branch" },
            lualine_z = { icons.get_cwd }
        },

        -- Focused window
        winbar = {
            lualine_a = {},
            lualine_b = { icons.get_vim_mode },
            lualine_c = {
                {
                    -- Omit the 'symbols' field for now as it crashes neovim if
                    -- launched without any files open.
                    "filename",
                    file_status = true,
                    newfile_status = false,
                    path = 1,
                    -- 0: Just the filename
                    -- 1: Relative path
                    -- 2: Absolute path
                    -- 3: Absolute path, with tilde as the home directory
                    -- 4: Filename and parent dir, with tilde as the home directory
                }
            },
            lualine_x = {},
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
                    -- Displays file status (readonly status, modified status)
                    file_status = true,
                    -- Display new file status (new file means no write after created)
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
