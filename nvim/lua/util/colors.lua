--             _
--    ___ ___ | | ___  _ __ ___
--   / __/ _ \| |/ _ \| '__/ __|
--  | (_| (_) | | (_) | |  \__ \
--   \___\___/|_|\___/|_|  |___/
-- =============================================================================

local M = {}

-- CATPPUCCIN
--------------------------------------------------------------------------------
-- https://catppuccin.com/palette
local colors = require("catppuccin.palettes").get_palette()
M.catppuccin = {

    -- Barbar
    ----------------------------------------------------------------------------
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

    -- Cmp
    ----------------------------------------------------------------------------
    Pmenu = {                     -- Completion window
        bg = colors.base,
    },
    PmenuSel = {},                -- Selection background
    PmenuSbar = {},               -- Scrollbar background
    PmenuThumb = {},              -- Scrollbar forground
    NormalFloat = {               -- Completion documentation window
        bg = colors.surface0,
    },
    CmpItemAbbr = {               -- Unmatched characters
        fg = colors.subtext1,
    },
    CmpItemAbbrMatch = {          -- Matched chars (no fuzzy matches)
        fg = colors.yellow,
        bg = colors.overlay1,
        italic = true,
    },
    CmpItemAbbrMatchFuzzy = {     -- Fuzzy matched chars
        fg = colors.yellow,
        bg = colors.surface0,
        italic = true,
    },
    CmpItemMenu = {               -- Menu field (lsp, spell etc.)
        fg = colors.overlay1,
    },
    CmpItemAbbrDeprecated = {     -- Deprecated results
        bg = colors.red,
    },

    -- Cmp icon color overrides
    CmpItemKindSnippet = {        -- Snippet
        fg = colors.crust,
        bg = colors.red,
    },
    CmpItemKindKeyword = {        -- Keyword
        fg = colors.crust,
        bg = colors.mauve,
    },
    CmpItemKindText = {           -- Text
        fg = colors.crust,
        bg = colors.teal,
    },
    CmpItemKindMethod = {         -- Method
        fg = colors.crust,
        bg = colors.blue,
    },
    CmpItemKindConstructor = {    -- Constructor
        fg = colors.crust,
        bg = colors.blue,
    },
    CmpItemKindFunction = {       -- Function
        fg = colors.crust,
        bg = colors.blue,
    },
    CmpItemKindFolder = {         -- Folder
        fg = colors.crust,
        bg = colors.blue,
    },
    CmpItemKindModule = {         -- Module
        fg = colors.crust,
        bg = colors.blue,
    },
    CmpItemKindConstant = {       -- Constant
        fg = colors.crust,
        bg = colors.peach,
    },
    CmpItemKindField = {          -- Field
        fg = colors.crust,
        bg = colors.green,
    },
    CmpItemKindProperty = {       -- Property
        fg = colors.crust,
        bg = colors.green,
    },
    CmpItemKindEnum = {           -- Enum
        fg = colors.crust,
        bg = colors.green,
    },
    CmpItemKindUnit = {           -- Unit
        fg = colors.crust,
        bg = colors.green,
    },
    CmpItemKindClass = {          -- Class
        fg = colors.crust,
        bg = colors.yellow,
    },
    CmpItemKindVariable = {       -- Variable
        fg = colors.crust,
        bg = colors.flamingo,
    },
    CmpItemKindFile = {           -- File
        fg = colors.crust,
        bg = colors.blue,
    },
    CmpItemKindInterface = {      -- Interface
        fg = colors.crust,
        bg = colors.yellow,
    },
    CmpItemKindColor = {          -- Color
        fg = colors.crust,
        bg = colors.red,
    },
    CmpItemKindReference = {      -- Reference
        fg = colors.crust,
        bg = colors.red,
    },
    CmpItemKindEnumMember = {     -- EnumMember
        fg = colors.crust,
        bg = colors.red,
    },
    CmpItemKindStruct = {         -- Struct
        fg = colors.crust,
        bg = colors.blue,
    },
    CmpItemKindValue = {          -- Value
        fg = colors.crust,
        bg = colors.peach,
    },
    CmpItemKindEvent = {          -- Event
        fg = colors.crust,
        bg = colors.blue,
    },
    CmpItemKindOperator = {       -- Operator
        fg = colors.crust,
        bg = colors.blue,
    },
    CmpItemKindTypeParameter = {  -- Type parameter
        fg = colors.crust,
        bg = colors.blue,
    },

    -- Diagnostics
    ----------------------------------------------------------------------------
    DiagnosticSignError = { fg = colors.red },
    DiagnosticSignWarn = { fg = colors.yellow },
    DiagnosticSignInfo = { fg = colors.teal },
    DiagnosticSignHint = { fg = colors.text },

    -- Fzf lua
    ----------------------------------------------------------------------------
    FzfLuaNormal = {              -- Menu fg/bg
        bg = colors.crust,
    },
    FzfLuaBorder = {              -- Menu border
        bg = colors.crust,
    },
    FzfLuaTitle = {               -- Menu title
        fg = colors.crust,
        bg = colors.sapphire,
        italic = true,
    },
    FzfLuaCursorLine = {          -- Cursor line
        bg = colors.surface1,
    },
    FzfLuaPreviewNormal = {       -- Preview fg/bg
        bg = colors.base,
    },
    FzfLuaPreviewBorder = {       -- Preview border
        bg = colors.base,
    },
    FzfLuaPreviewTitle = {        -- Preview title
        fg = colors.crust,
        bg = colors.red,
    },

    -- GitSigns
    ----------------------------------------------------------------------------
    GitSignsAdd = { fg = colors.green },
    GitSignsChange = { fg = colors.peach },
    GitSignsDelete = { fg = "#d20f39" },  -- Latte red
    GitSignsChangedelete = { fg = colors.maroon },
    GitSignsTopdelete = { fg = colors.maroon },
    GitSignsUntracked = { fg = colors.yellow },

    -- Glance
    ----------------------------------------------------------------------------
    GlanceListNormal = { bg = colors.crust },
    GlanceListCursorLine = { bg = colors.surface0 },
    GlancePreviewNormal = { bg = colors.base },
    GlancePreviewCursorLine = { bg = colors.surface0 },
    GlanceWinBarTitle = { bg = colors.surface1 },
    GlanceWinBarFilepath = { bg = colors.surface1 },
    GlanceWinBarFilename = {
        fg = colors.green,
        bg = colors.surface1,
    },

    -- Quicker
    ----------------------------------------------------------------------------
    QuickFixLineNr = { fg = colors.green },

    -- Ui
    ----------------------------------------------------------------------------
    FoldColumn = { fg = colors.yellow },      -- Line next to folded section
    WinSeparator = { fg = colors.overlay0 },  -- Line between splits
    CursorColumn = { bg = colors.surface0 },  -- Vertical cursor column line
}


-- IBL
--------------------------------------------------------------------------------
M.ibl = {
    red = "#e78284",  -- Frappe red
    yellow = colors.yellow,
    blue = colors.blue,
    orange = colors.peach,
    green = colors.green,
    violet = colors.sapphire,
    cyan = colors.surface0,
}


-- LUALINE
--------------------------------------------------------------------------------
M.lualine = {
    normal = {
        a = {
            fg = colors.crust,
            bg = colors.text,
        },
        b = {
            fg = colors.crust,
            bg = "#a6d189",  -- Frappe green
        },
        c = {
            fg = colors.peach,
            bg = colors.surface1,
        }
    },
    insert = {
        a = {
            fg = colors.crust,
            bg = colors.text,
        },
        b = {
            fg = colors.crust,
            bg = colors.lavender,
        },
        c = {
            gui = "italic",
            fg = colors.peach,
            bg = colors.crust,
        }
    },
    visual = {
        a = {
            fg = colors.crust,
            bg = colors.text,
        },
        b = {
            fg = colors.text,
            bg = "#1e66f5",  -- Latte blue
        },
        c = {
            gui = "italic",
            fg = colors.crust,
            bg = "#8aadf4",  -- Macchiato blue
        }
    },
    replace = {
        a = {
            fg = colors.crust,
            bg = colors.text,
        },
        b = {
            fg = colors.crust,
            bg = colors.red,
        },
        c = {
            fg = colors.peach,
            bg = colors.base,
        }
    },
    command = {
        a = {
            fg = colors.crust,
            bg = colors.text,
        },
        b = {
            fg = colors.text,
            bg = "#d20f39",  -- Latte red
        },
        c = {
            fg = colors.peach,
            bg = colors.base,
        }
    },
    inactive = {
        c = {
            gui = "italic",
            fg = colors.surface2,
            bg = colors.mantle,
        }
    }
}


-- NEOCOMPOSER
--------------------------------------------------------------------------------
M.neocomposer = {
    bg = colors.base,
    fg = colors.peach,
    red = "#d20f39",  -- Latte red
    blue = colors.blue,
    green = colors.green,
}

return M
