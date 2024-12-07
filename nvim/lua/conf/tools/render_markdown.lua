--                      _                           _
--   _ __ ___ _ __   __| | ___ _ __   _ __ ___   __| |
--  | '__/ _ \ '_ \ / _` |/ _ \ '__| | '_ ` _ \ / _` |
--  | | |  __/ | | | (_| |  __/ |    | | | | | | (_| |
--  |_|  \___|_| |_|\__,_|\___|_|    |_| |_| |_|\__,_|
-- =============================================================================

local M = {}

-- CONFIG
--------------------------------------------------------------------------------
function M.config()
    local status_ok = pcall(require, "render-markdown")
    if not status_ok then return end

    local icons = require("util.icons").render_markdown

    -- Setup
    require("render-markdown").setup({
        enabled = true,               -- Enable by default
        max_file_size = 10.0,         -- Max file size to render (in MB)
        render_modes = { "n", "c" },  -- Which modes will show rendered markdown
        anti_conceal = {
            enabled = true,  -- Hide any added text on line the cursor is on

            -- Which elements to always show, ignoring anti conceal behavior. Values
            -- can either be booleans to fix the behavior or string lists representing
            -- modes where anti conceal behavior will be ignored. Possible keys are:
            --     head_icon, head_background, head_border, code_language, code_background,
            --     code_border dash, bullet, check_icon, check_scope, quote, table_border,
            --     callout, link, sign
            ignore = {
                code_background = true,
                sign = true,
            },
            above = 0,  -- Number of lines above cursor to show
            below = 0,  -- Number of lines below cursor to show
        },
        padding = {
            -- Highlight to use when adding whitespace, should match background
            highlight = "Normal",
        },
        latex = {
            enabled = true,                    -- Whether LaTeX should be rendered
            converter = "latex2text",          -- Exec used to convert latex to unicode
            highlight = "RenderMarkdownMath",  -- Highlight for LaTeX blocks
            top_pad = 0,                       -- Empty lines above LaTeX blocks
            bottom_pad = 0,                    -- Empty lines below LaTeX blocks
        },
        on = {
            -- Called when plugin initially attaches to a buffer
            attach = function() end,
        },
        heading = {
            enabled = true,  -- Toggle heading icon & background rendering
            sign = true,     -- Toggle sign column related rendering

            -- Determines how icons fill the available space:
            --     inline:  underlying '#'s are concealed resulting in a left aligned icon
            --     overlay: result is left padded with spaces to hide any additional '#'
            position = "overlay",
            icons = {                -- Header icons
                icons.heading1,
                icons.heading2,
                icons.heading3,
                icons.heading4,
                icons.heading5,
                icons.heading6,
            },
            signs = { icons.signs },      -- Added to the sign column if enabled
            width = "full",               -- Width of the heading background (full, block)
            left_margin = 0,              -- Margin added to the left of headings
            left_pad = 0,                 -- Padding added to the left of headings
            right_pad = 0,                -- Padding added to right of headings when width is 'block'
            min_width = 0,                -- Min width for headings when width is 'block'
            border = false,               -- Add border above and below headings
            border_virtual = false,       -- Always use virtual lines for heading borders
            border_prefix = false,        -- Highlight the start of the border
            above = icons.above_heading,  -- Used above heading for border
            below = icons.below_heading,  -- Used below heading for border

            -- Highlight for the heading icon and extends through the entire line
            -- The 'level' is used to index into the list using a clamp
            backgrounds = {
                "RenderMarkdownH1Bg",
                "RenderMarkdownH2Bg",
                "RenderMarkdownH3Bg",
                "RenderMarkdownH4Bg",
                "RenderMarkdownH5Bg",
                "RenderMarkdownH6Bg",
            },

            -- Highlight for the heading and sign icons
            -- The 'level' is used to index into the list using a clamp
            foregrounds = {
                "RenderMarkdownH1",
                "RenderMarkdownH2",
                "RenderMarkdownH3",
                "RenderMarkdownH4",
                "RenderMarkdownH5",
                "RenderMarkdownH6",
            }
        },
        paragraph = {
            enabled = true,   -- Toggle paragraph rendering
            left_margin = 0,  -- Margin added to left of paragraphs
            min_width = 0,    -- Min width for paragraphs
        },
        code = {
            enabled = true,  -- Toggle code block & inline code rendering
            sign = true,     -- Toggle any sign column related rendering

            -- Determines how code blocks & inline code are rendered:
            --     none:     disables all rendering
            --     normal:   adds highlight group to code blocks & inline code, adds padding to code blocks
            --     language: adds language icon to sign column if enabled and icon + name above code blocks
            --     full:     normal + language
            style = "full",

            -- Determines where language icon is rendered:
            --     right: right side of code block
            --     left:  left side of code block
            position = "left",
            language_pad = 0,                 -- Padding added around the language
            language_name = true,             -- Include language name next to the icon
            disable_background = { "diff" },  -- Languages to disable bg highlighting

            -- Width of the code block background:
            --     block: width of the code block
            --     full:  full width of the window
            width = "full",
            left_margin = 0,  -- Margin added to left of code blocks
            left_pad = 0,     -- Padding added to left of code blocks
            right_pad = 0,    -- Padding added to right of code blocks when width is 'block'
            min_width = 0,    -- Min width of code blocks when width is 'block'

            -- Determins how the top / bottom of code block are rendered:
            --     thick: use the same highlight as the code body
            --     thin:  when lines are empty overlay the above & below icons
            border = "thin",
            above = icons.above_code,                       -- Used above code blocks for thin border
            below = icons.below_code,                       -- Used below code blocks for thin border
            highlight = "RenderMarkdownCode",               -- Highlight for code blocks
            highlight_inline = "RenderMarkdownCodeInline",  -- Hl for inline code
            highlight_language = nil,                       -- Highlight for lang, overrides default icon
        },
        dash = {
            enabled = true,                    -- Toggle thematic break rendering
            icon = "─",                        -- Replaces '---'|'***'|'___'|'* * *' of 'thematic_break'
            width = "full",                    -- Width of the generated line
            highlight = "RenderMarkdownDash",  -- Hl for whole line generated from icon
        },
        bullet = {
            enabled = true,  -- Toggle list bullet rendering
            icons = {
                icons.bullet_circle_full,
                icons.bullet_circle_empty,
                icons.bullet_diamond_full,
                icons.bullet_diamond_empty,
            },
            left_pad = 0,                        -- Padding added left of bullet point
            right_pad = 0,                       -- Padding added right of bullet point
            highlight = "RenderMarkdownBullet",  -- Highlight for the bullet icon
        },

        -- Checkboxes are a special instance of a 'list_item' that start with a 'shortcut_link'
        -- There are two special states for unchecked & checked defined in the markdown grammar
        checkbox = {
            enabled = true,  -- Toggle checkbox state rendering

            -- Determines how icons fill the available space:
            --     inline:  underlying text is concealed resulting in a left aligned icon
            --     overlay: result is left padded with spaces to hide any additional text
            position = "inline",
            unchecked = {
                icon = icons.checkbox_unchecked,        -- Replaces '[ ]' of 'task_list_marker_unchecked'
                highlight = "RenderMarkdownUnchecked",  -- Highlight for the unchecked icon
                scope_highlight = nil,                  -- Highlight for item associated with unchecked checkbox
            },
            checked = {
                icon = icons.checkbox_checked,          -- Replaces '[x]' of 'task_list_marker_checked'
                highlight = "RenderMarkdownChecked",    -- Highligh for the checked icon
                scope_highlight = nil,                  -- Highlight for item associated with checked checkbox
            },

            -- Define custom checkbox states, more involved as they are not part of the markdown grammar
            -- As a result this requires neovim >= 0.10.0 since it relies on 'inline' extmarks
            -- Can specify as many additional states as you like following the 'todo' pattern below
            -- The key in this case 'todo' is for healthcheck and to allow users to change its values:
            --     'raw':             Matched against the raw text of a 'shortcut_link'
            --     'rendered':        Replaces the 'raw' value when rendering
            --     'highlight':       Highlight for the 'rendered' icon
            --     'scope_highlight': Highlight for item associated with custom checkbox
            custom = {
                todo = {
                    raw = icons.todo_raw,
                    rendered = icons.todo_rendered,
                    highlight = "RenderMarkdownTodo",
                    scope_highlight = nil
                }
            }
        },
        quote = {
            enabled = true,                     -- Turn on / off block quote & callout rendering
            icon = icons.block_quote,           -- Replaces '>' of 'block_quote'
            repeat_linebreak = false,           -- Whether to repeat icon on wrapped lines
            highlight = "RenderMarkdownQuote",  -- Highlight for the quote icon
        },
        pipe_table = {
            enabled = true,  -- Toggle pipe table rendering

            -- Pre configured settings for setting table border:
            --     heavy:  use thicker border characters
            --     double: use double line border characters
            --     round:  use round border corners
            preset = "none",

            -- Determines how the table as a whole is rendered:
            --     none:   disables all rendering
            --     normal: applies the 'cell' style rendering to each row of the table
            --     full:   normal + a top & bottom line that fill out the table when lengths match
            style = "full",

            -- Determines how individual cells of a table are rendered:
            --     overlay: writes completely over the table, removing conceal behavior and highlights
            --     raw:     replaces only the '|' characters in each row, leaving the cells unmodified
            --     padded:  raw + cells are padded to maximum visual width for each column
            --     trimmed: padded except empty space is subtracted from visual width calculation
            cell = "padded",
            padding = 1,                                 -- Space between cell contents and border
            min_width = 0,                               -- Min column width for padded or trimmed cell
            border = icons.border_chars,                 -- Characters used to replace table border
            alignment_indicator = icons.alignment_icon,  -- Placed in delimiter row for each column
            head = "RenderMarkdownTableHead",            -- Hl for table heading, delimiter, and line above
            row = "RenderMarkdownTableRow",              -- Hl for everything else
            filler = "RenderMarkdownTableFill",          -- Hl for inline padding used to add back concealed space
        },

        -- Callouts are a special instance of a 'block_quote' that start with a 'shortcut_link'
        -- Can specify as many additional values as you like following the pattern from any below, such as 'note'
        --     The key in this case 'note' is for healthcheck and to allow users to change its values
        --     'raw':        Matched against the raw text of a 'shortcut_link', case insensitive
        --     'rendered':   Replaces the 'raw' value when rendering
        --     'highlight':  Highlight for the 'rendered' text and quote markers
        --     'quote_icon': Optional override for quote.icon value for individual callout
        callout = {
            note = {
                raw = "[!NOTE]",
                rendered = icons.callout_note,
                highlight = "RenderMarkdownInfo"
            },
            tip = {
                raw = "[!TIP]",
                rendered =  icons.callout_tip,
                highlight = "RenderMarkdownSuccess"
            },
            important = {
                raw = "[!IMPORTANT]",
                rendered =  icons.callout_important,
                highlight = "RenderMarkdownHint"
            },
            warning = {
                raw = "[!WARNING]",
                rendered =  icons.callout_warning,
                highlight = "RenderMarkdownWarn"
            },
            caution = {
                raw = "[!CAUTION]",
                rendered =  icons.callout_caution,
                highlight = "RenderMarkdownError"
            }
        },
        link = {
            enabled = true,                    -- Toggle inline link icon rendering
            image = icons.link_image,          -- Inlined with 'image' elements
            email = icons.link_email,          -- Inlined with 'email_autolink' elements
            hyperlink = icons.link_hyperlink,  -- Fallback icon for 'inline_link' elements
            highlight = "RenderMarkdownLink",  -- Applies to the fallback inlined icon
            wiki = {                           -- Applies to WikiLink elements
                icon = icons.link_wiki,
                highlight = "RenderMarkdownWikiLink"
            },

            -- Define custom destination patterns so icons can quickly inform you of what a link
            -- contains. Applies to 'inline_link' and wikilink nodes.
            -- Can specify as many additional values as you like following the 'web' pattern below
            -- The key in this case 'web' is for healthcheck and to allow users to change its values:
            --     'pattern':   Matched against the destination text see :h lua-pattern
            --     'icon':      Gets inlined before the link text
            --     'highlight': Highlight for the 'icon'
            custom = {
                web = {
                    pattern = "^http[s]?://",
                    icon = icons.link_web,
                    highlight = "RenderMarkdownLink",
                }
            }
        },
        sign = {
            enabled = true,                    -- Toggle sign rendering
            highlight = "RenderMarkdownSign",  -- Hl for bg of sign text
        },

        -- Mimic org-indent-mode behavior by indenting everything under a heading based on the
        -- level of the heading. Indenting starts from level 2 headings onward.
        indent = {
            enabled = false,       -- Toggle org-indent-mode
            per_level = 2,         -- Additional padding added for each heading level
            skip_level = 1,        -- Use 0 to begin indenting from the first level
            skip_heading = false,  -- Don't indent heading titles, only the body
        },

        -- Window options to use that change between rendered and raw view
        win_options = {
            conceallevel = {  -- See :h 'conceallevel'
                -- Used when not being rendered, get user setting
                default = vim.api.nvim_get_option_value("conceallevel", {}),
                -- Used when being rendered, concealed text is completely hidden
                rendered = 3,
            },
            concealcursor = {  -- See :h 'concealcursor'
                -- Used when not being rendered, get user setting
                default = vim.api.nvim_get_option_value("concealcursor", {}),
                -- Used when being rendered, disable concealing text in all modes
                rendered = "",
            }
        },

        -- More granular configuration mechanism, allows different aspects of buffers
        -- to have their own behavior. Values default to the top level configuration
        -- if no override is provided. Supports the following fields:
        --     enabled, max_file_size, debounce, render_modes, anti_conceal, padding,
        --     heading, paragraph, code, dash, bullet, checkbox, quote, pipe_table,
        --     callout, link, sign, indent, win_options
        overrides = {
            buftype = {  -- Overrides for different buftypes, see :h 'buftype'
                nofile = {
                    padding = { highlight = "NormalFloat" },
                    sign = { enabled = false },
                }
            },
            filetype = {},  -- Overrides for different filetypes, see :h 'filetype'
        },

        -- Mapping from treesitter language to user defined handlers
        -- See 'Custom Handlers' document for more info
        custom_handlers = {},
    })
end

return M
