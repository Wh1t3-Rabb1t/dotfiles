--   _     _       _     _ _       _     _               _
--  | |__ (_) __ _| |__ | (_) __ _| |__ | |_    ___ ___ | | ___  _ __ ___
--  | '_ \| |/ _` | '_ \| | |/ _` | '_ \| __|  / __/ _ \| |/ _ \| '__/ __|
--  | | | | | (_| | | | | | | (_| | | | | |_  | (_| (_) | | (_) | |  \__ \
--  |_| |_|_|\__, |_| |_|_|_|\__, |_| |_|\__|  \___\___/|_|\___/|_|  |___/
-- ==========|___/===========|___/==============================================

local M = {}

-- CONFIG
--------------------------------------------------------------------------------
function M.config()
    local status_ok = pcall(require, "nvim-highlight-colors")
    if not status_ok then return end

    -- Setup
    require("nvim-highlight-colors").setup({
        render = "background",               -- Render style (background foreground virtual)
        virtual_symbol = "■",                -- Virtual symbol (requires render to be 'virtual')
        virtual_symbol_prefix = "",          -- Virtual symbol suffix (defaults to '')
        virtual_symbol_suffix = " ",         -- Virtual symbol suffix (defaults to ' ')
        virtual_symbol_position = "inline",  -- Virtual symbol position (inline eol eow)
        enable_hex = true,                   -- Highlight hex colors, e.g. '#FFFFFF'
        enable_short_hex = true,             -- Highlight short hex colors e.g. '#fff'
        enable_rgb = true,                   -- Highlight rgb colors, e.g. 'rgb(0 0 0)'
        enable_hsl = true,                   -- Highlight hsl colors, e.g. 'hsl(150deg 30% 40%)'
        enable_var_usage = true,             -- Highlight CSS variables, e.g. 'var(--testing-color)'
        enable_named_colors = true,          -- Highlight named colors, e.g. 'green'
        enable_tailwind = true,              -- Highlight tailwind colors, e.g. 'bg-blue-500'

        -- Set custom colors
        ------------------------------------------------------------------------
        -- Label must be properly escaped with '%' to adhere to `string.gmatch`
        -- :help string.gmatch
        custom_colors = {
            -- { label = "%-%-theme%-primary%-color", color = "#0f1219" },
            -- { label = "%-%-theme%-secondary%-color", color = "#5a5d64" },
        },

        -- Exclude filetypes or buftypes from highlighting e.g. "exclude_buftypes = {'text'}"
        exclude_filetypes = {},
        exclude_buftypes = {}
    })
end

return M
