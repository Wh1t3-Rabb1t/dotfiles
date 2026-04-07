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
    local hl = require("catppuccin.palettes").get_palette()  -- https://catppuccin.com/palette
    require("catppuccin").setup({
        compile_path = vim.fn.stdpath "cache" .. "/catppuccin",
        flavour = "mocha",  -- latte, frappe, macchiato, mocha
        background = {
            light = "macchiato",
            dark = "mocha",
        },
        transparent_background = false,  -- Disable setting the bg color
        show_end_of_buffer = false,      -- Show '~' characters at EOF
        term_colors = false,             -- Set term colors (e.g. `g:terminal_color_0`)
        no_italic = false,
        no_bold = false,
        no_underline = false,
        dim_inactive = { enabled = false },
        styles = {
            conditionals = { "italic" },
            comments = { "bold" },
            loops = { "italic" },
        },
        color_overrides = {},
        custom_highlights = {

            -- Barbar
            BufferScrollArrow = { fg = hl.yellow },     -- Scroll arrow
            BufferCurrent = { fg = hl.text },           -- Tab contents
            BufferCurrentSignRight = { fg = hl.text },  -- Tab separator
            BufferCurrentMod = { fg = hl.text },        -- Modified contents
            BufferCurrentModBtn = { fg = hl.text },     -- Modified icon
            BufferInactiveModBtn = { fg = hl.text },
            BufferInactiveSignRight = { fg = hl.text },
            BufferInactive = { fg = hl.overlay0, italic = true },
            BufferInactiveMod = { fg = hl.overlay0, italic = true },

            -- Diagnostics
            DiagnosticSignError = { fg = hl.red },
            DiagnosticSignWarn = { fg = hl.yellow },
            DiagnosticSignInfo = { fg = hl.teal },
            DiagnosticSignHint = { fg = hl.text },

            -- Ui
            FoldColumn = { fg = hl.yellow },      -- Line next to folded section
            WinSeparator = { fg = hl.overlay0 },  -- Line between splits
            CursorColumn = { bg = hl.surface0 },  -- Vertical cursor column line
            IncSearch = { bg = hl.red },          -- Search results (/)
            Search = {
                fg = hl.crust,
                bg = hl.overlay1,
            }
        },

        integrations = {
            barbar = false,  -- Keep 'false' to enable transparent bg
            cmp = true,
            gitsigns = true,
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
