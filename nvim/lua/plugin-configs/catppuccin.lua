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
    -- https://catppuccin.com/palette
    local colors = require("catppuccin.palettes").get_palette()
    require("catppuccin").setup({
        compile_path = vim.fn.stdpath "cache" .. "/catppuccin",
        flavour = "macchiato",              -- latte, frappe, macchiato, mocha
        background = {                      -- See `:h background`
            light = "macchiato",
            dark = "mocha",
        },
        transparent_background = false,  -- Disable setting the bg color
        show_end_of_buffer = false,      -- Show '~' characters at EOF
        term_colors = false,             -- Set term colors (e.g. `g:terminal_color_0`)
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
        custom_highlights = {

            -- Barbar
            -------------------------------------------------------------------
            BufferCurrent = {             -- Tab contents
                fg = colors.text,
            },
            BufferInactive = {
                fg = colors.overlay0,
                italic = true,
            },
            BufferCurrentSignRight = {    -- Tab separator
                fg = colors.text,
            },
            BufferInactiveSignRight = {
                fg = colors.text,
            },
            BufferCurrentMod = {          -- Modified contents
                fg = colors.text,
            },
            BufferInactiveMod = {
                fg = colors.overlay0,
                italic = true,
            },
            BufferCurrentModBtn = {       -- Modified icon
                fg = colors.text,
            },
            BufferInactiveModBtn = {
                fg = colors.text,
            },
            BufferScrollArrow = {         -- Scroll arrow
                fg = colors.yellow,
            },

            -- Diagnostics
            -------------------------------------------------------------------
            DiagnosticSignError = { fg = colors.red },
            DiagnosticSignWarn = { fg = colors.yellow },
            DiagnosticSignInfo = { fg = colors.teal },
            DiagnosticSignHint = { fg = colors.text },

            -- Ui
            -------------------------------------------------------------------
            FoldColumn = { fg = colors.yellow },      -- Line next to folded section
            WinSeparator = { fg = colors.overlay0 },  -- Line between splits
            CursorColumn = { bg = colors.surface0 },  -- Vertical cursor column line
            IncSearch = { bg = colors.red },          -- Search results (/)
            Search = {
                fg = colors.crust,
                bg = colors.overlay1,
            }
        },

        integrations = {
            aerial = false,
            barbar = false,         -- Keep 'false' to enable transparent bg
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
            -- For more plugins integrations please scroll down
            -- (https://github.com/catppuccin/nvim#integrations)
        }
    })

    -- `setup` must be called before loading theme
    vim.cmd.colorscheme("catppuccin")
end

return M
