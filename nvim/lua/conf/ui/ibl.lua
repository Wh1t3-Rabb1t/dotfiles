--   _ _     _
--  (_) |__ | |
--  | | '_ \| |
--  | | |_) | |
--  |_|_.__/|_|
-- =============================================================================

local M = {}

-- CONFIG
--------------------------------------------------------------------------------
function M.config()
    local status_ok = pcall(require, "ibl")
    if not status_ok then return end

    local colors = require("catppuccin.palettes").get_palette()
    local highlight = {
        "RainbowRed",
        "RainbowYellow",
        "RainbowBlue",
        "RainbowOrange",
        "RainbowGreen",
        "RainbowViolet",
        "RainbowCyan",
    }

    -- Create the highlight groups in the highlight setup hook, so they
    -- are reset every time the colorscheme changes.
    local hooks = require("ibl.hooks")
    hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
        vim.api.nvim_set_hl(0, "RainbowRed", { fg = "#e78284" })
        vim.api.nvim_set_hl(0, "RainbowYellow", { fg = colors.yellow })
        vim.api.nvim_set_hl(0, "RainbowBlue", { fg = colors.blue })
        vim.api.nvim_set_hl(0, "RainbowOrange", { fg = colors.peach })
        vim.api.nvim_set_hl(0, "RainbowGreen", { fg = colors.green })
        vim.api.nvim_set_hl(0, "RainbowViolet", { fg = colors.sapphire })
        vim.api.nvim_set_hl(0, "RainbowCyan", { fg = colors.surface0 })
    end)

    vim.g.rainbow_delimiters = { highlight = highlight }
    require("ibl").setup({ scope = { highlight = highlight } })
    hooks.register(hooks.type.SCOPE_HIGHLIGHT, hooks.builtin.scope_highlight_from_extmark)
end

return M
