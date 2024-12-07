--             _                              _
--    ___ __ _| |_ _ __  _ __  _   _  ___ ___(_)_ __
--   / __/ _` | __| '_ \| '_ \| | | |/ __/ __| | '_ \
--  | (_| (_| | |_| |_) | |_) | |_| | (_| (__| | | | |
--   \___\__,_|\__| .__/| .__/ \__,_|\___\___|_|_| |_|
-- ===============|_|===|_|=====================================================

local M = {}

-- CONFIG
--------------------------------------------------------------------------------
function M.config()
    local status_ok = pcall(require, "catppuccin")
    if not status_ok then return end

    -- Setup
    require("catppuccin").setup({
        compile_path = vim.fn.stdpath "cache" .. "/catppuccin",
        flavour = "mocha",              -- latte, frappe, macchiato, mocha
        background = {                  -- See `:h background`
            light = "macchiato",
            dark = "mocha",
        },
        transparent_background = true,  -- Disable setting the bg color
        show_end_of_buffer = false,     -- Show '~' characters at EOF
        term_colors = false,            -- Set term colors (e.g. `g:terminal_color_0`)
        dim_inactive = { enabled = false },
        no_italic = false,
        no_bold = false,
        no_underline = false,
        styles = {                      -- See `:h highlight-args`
            conditionals = { "italic" },
            comments = { "bold" },
            loops = { "italic" },
            functions = {},
            keywords = {},
            strings = {},
            variables = {},
            numbers = {},
            booleans = {},
            properties = {},
            types = {},
            operators = {},
        },
        color_overrides = {},
        custom_highlights = require("util.colors").catppuccin,
        integrations = {
            aerial = false,
            barbar = false,  -- Keep 'false' to enable transparent bg
            cmp = true,
            dropbar = {
                enabled = true,
                color_mode = true,  -- Enable color for kind's texts, and icons
            },
            fidget = false,
            gitsigns = true,
            neotree = true,
            treesitter = true,
            notify = false,
            -- telescope = { enabled = true },
            -- For more plugins integrations please scroll down
            -- (https://github.com/catppuccin/nvim#integrations)
        }
    })

    -- `setup` must be called before loading theme
    vim.cmd.colorscheme("catppuccin")
end

return M
