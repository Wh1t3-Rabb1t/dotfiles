--                   _       _
--    __ _  ___ _ __(_) __ _| |
--   / _` |/ _ \ '__| |/ _` | |
--  | (_| |  __/ |  | | (_| | |
--   \__,_|\___|_|  |_|\__,_|_|
-- =============================================================================

local M = {}

-- ICONS
--------------------------------------------------------------------------------
local icons = {
    mid_item = "├─",
    last_item = "└─",
    nested_top = "│ ",
    whitespace = "  ",
}


-- INIT
--------------------------------------------------------------------------------
local map = require("util.utils").map
function M.init()
    map("n", "<A-a>", "<cmd>AerialOpen<CR>", {
        desc = "Toggle Aerial"
    })
end


-- CONFIG
--------------------------------------------------------------------------------
function M.config()
    local status_ok = pcall(require, "aerial")
    if not status_ok then return end

    -- Setup
    require("aerial").setup({
        -- Priority list of preferred backends for aerial
        backends = { "treesitter", "lsp", "markdown", "asciidoc", "man" },

        layout = {
            -- Can be integers or a float between 0 and 1 (e.g. 0.4 for 40%)
            --     min_width and max_width can be a list of mixed types.
            --     max_width = {40, 0.2} means "the lesser of 40 columns or 20% of total"
            max_width = { 40, 0.2 },
            width = 30,
            min_width = 10,
            win_opts = {},               -- Window-local opts for aerial window (e.g. winhl)
            default_direction = "left",  -- prefer_right, prefer_left, right, left, float
            placement = "edge",          -- Open aerial at the edge of the editor
            resize_to_content = false,
            preserve_equality = false,   -- Prevent altering of split sizes on open
        },

        -- Determines how the aerial window decides which buffer to display symbols for:
        --     window - display symbols for the buffer in the window from which it was opened
        --     global - display symbols for the current window
        attach_mode = "window",

        -- List of enum values that configure when to auto-close the aerial window:
        --     unfocus       - close when you leave the original source window
        --     switch_buffer - close when you change buffers in the source window
        --     unsupported   - close when attaching to a buffer that has no symbol source
        close_automatic_events = { "switch_buffer" },

        -- Set to `false` to remove a keymap
        keymaps = {
            ["?"] = "actions.show_help",
            ["<CR>"] = "actions.jump",
            ["e"] = "actions.up_and_scroll",
            ["d"] = "actions.down_and_scroll",
            ["f"] = "actions.scroll",
            ["t"] = "actions.tree_toggle",
            ["l"] = "actions.tree_open",
            ["o"] = "actions.tree_open_recursive",
            ["u"] = "actions.tree_close_recursive",
            ["O"] = "actions.jump_vsplit",
            ["U"] = "actions.jump_split",
            ["a"] = "actions.tree_open_all",
            ["A"] = "actions.tree_close_all",
            ["q"] = "actions.close",
            ["<A-a>"] = "actions.close",  -- Toggle aerial open / closed
            ["<2-LeftMouse>"] = false,
            ["<C-v>"] = false,
            ["<C-s>"] = false,
            ["<C-j>"] = false,
            ["<C-k>"] = false,
            ["p"] = false,
            ["{"] = false,
            ["}"] = false,
            ["g?"] = false,
            ["L"] = false,
            ["[["] = false,
            ["]]"] = false,
            ["zr"] = false,
            ["zR"] = false,
            ["zm"] = false,
            ["zM"] = false,
            ["zO"] = false,
            ["zC"] = false,
            ["za"] = false,
            ["zA"] = false,
            ["zo"] = false,
            ["h"] =  false,
            ["H"] =  false,
            ["zc"] = false,
            ["zx"] = false,
            ["zX"] = false,
        },
        lazy_load = true,            -- Defaults to false if `on_attach` is provided
        disable_max_lines = 10000,   -- Disable aerial on files with this many lines
        disable_max_size = 2000000,  -- Default 2000000 (2MB)

        -- Displayed symbols. Set, false to display all symbols. (:help SymbolKind)
        filter_kind = {
            "Class",
            "Constructor",
            "Enum",
            "Function",
            "Interface",
            "Module",
            "Method",
            "Struct",
        },

        -- Determines line highlighting mode when multiple splits are visible:
        --     split_width   Each open window will have its cursor location marked in the
        --                   aerial buffer. Each line will only be partially highlighted
        --                   to indicate which window is at that location.
        --     full_width    Each open window will have its cursor location marked as a
        --                   full-width highlight in the aerial buffer.
        --     last          Only the most-recently focused window will have its location
        --                   marked in the aerial buffer.
        --     none          Do not show the cursor locations in the aerial window.
        highlight_mode = "split_width",
        highlight_closest = true,    -- Highlight closest symbol if the cursor isn't on one
        highlight_on_hover = false,  -- Highlight symbol when cursor is in the aerial win

        -- When jumping to a symbol, highlight the line for this many ms
        -- Set to false to disable
        highlight_on_jump = 300,
        autojump = false,  -- Jump to symbol when the cursor moves
        icons = {},        -- Define symbol icons

        -- Which windows and buffers aerial should ignore
        ignore = {
            unlisted_buffers = false,  -- Ignore unlisted buffers
            diff_windows = true,       -- Ignore diff windows
            filetypes = {},            -- List of filetypes to ignore

            -- Ignored buftypes. Can be one of the following:
            --     false or nil - No buftypes are ignored.
            --     "special"    - All buffers other than normal, help and man page buffers are ignored.
            --     table        - A list of buftypes to ignore. See :help buftype for the
            --                    possible values.
            --     function     - A function that returns true if the buffer should be
            --                    ignored or false if it should not be ignored.
            --                    Takes two arguments, `bufnr` and `buftype`.
            buftypes = "special",

            -- Ignored wintypes. Can be one of the following:
            --     false or nil - No wintypes are ignored.
            --     "special"    - All windows other than normal windows are ignored.
            --     table        - A list of wintypes to ignore. See :help win_gettype() for the
            --                    possible values.
            --     function     - A function that returns true if the window should be
            --                    ignored or false if it should not be ignored.
            --                    Takes two arguments, `winid` and `wintype`.
            wintypes = "special",
        },

        -- Use symbol tree for folding. Set to true or false to enable/disable
        -- Set to "auto" to manage folds if your previous foldmethod was 'manual'
        -- This can be a filetype map (see :help aerial-filetype-map)
        manage_folds = false,

        -- When you fold code with za, zo, or zc, update the aerial tree as well.
        -- Only works when manage_folds = true
        link_folds_to_tree = false,

        -- Fold code when you open/collapse symbols in the tree.
        -- Only works when manage_folds = true
        link_tree_to_folds = false,

        -- Set default symbol icons to use patched font icons (see https://www.nerdfonts.com/)
        -- "auto" will set it to true if nvim-web-devicons or lspkind-nvim is installed.
        nerd_font = "auto",
        on_attach = function(bufnr) end,         -- Called when aerial attaches to a buffer
        on_first_symbols = function(bufnr) end,  -- Called when aerial first sets symbols on a buffer
        open_automatic = false,                  -- Auto open when entering supported buffers

        -- Run this command after jumping to a symbol (false will disable)
        post_jump_cmd = "normal! zz",

        -- Invoked after each symbol is parsed, can be used to modify the parsed item,
        -- or to filter it by returning false.
        --
        -- bufnr: a neovim buffer number
        -- item: of type aerial.Symbol
        -- ctx: a record containing the following fields:
        --     * backend_name: treesitter, lsp, man...
        --     * lang: info about the language
        --     * symbols?: specific to the lsp backend
        --     * symbol?: specific to the lsp backend
        --     * syntax_tree?: specific to the treesitter backend
        --     * match?: specific to the treesitter backend, TS query match
        post_parse_symbol = function(bufnr, item, ctx)
            return true
        end,

        -- Invoked after all symbols have been parsed and post-processed,
        -- allows to modify the symbol structure before final display
        --
        -- bufnr: a neovim buffer number
        -- items: a collection of aerial.Symbol items, organized in a tree,
        --        with 'parent' and 'children' fields
        -- ctx: a record containing the following fields:
        --     * backend_name: treesitter, lsp, man...
        --     * lang: info about the language
        --     * symbols?: specific to the lsp backend
        --     * syntax_tree?: specific to the treesitter backend
        post_add_all_symbols = function(bufnr, items, ctx)
            return items
        end,

        -- When true, aerial will automatically close after jumping to a symbol
        close_on_select = false,

        -- The autocmds that trigger symbols update (not used for LSP backend)
        update_events = "TextChanged,InsertLeave",

        -- Show box drawing characters for the tree hierarchy
        show_guides = true,

        -- Customize the characters used when show_guides = true
        guides = {
            mid_item = icons.mid_item,      -- When the child item has a sibling below it
            last_item = icons.last_item,    -- When the child item is the last in the list
            nested_top = icons.nested_top,  -- When there are nested child guides to the right
            whitespace = icons.whitespace,  -- Raw indentation
        },

        -- Set this function to override the highlight groups for certain symbols
        get_highlight = function(symbol, is_icon, is_collapsed)
            -- return "MyHighlight" .. symbol.kind
        end,

        -- Options for opening aerial in a floating win
        float = {
            border = "rounded",
            relative = "cursor",
            max_height = 0.9,
            height = nil,
            min_height = { 8, 0.1 },
            override = function(conf, source_winid)
                -- This is the config that will be passed to nvim_open_win.
                -- Change values here to customize the layout
                return conf
            end,
        },

        -- Options for the floating nav windows
        nav = {
            border = "rounded",
            max_height = 0.9,
            min_height = { 10, 0.1 },
            max_width = 0.5,
            min_width = { 0.2, 20 },
            win_opts = {
                cursorline = true,
                winblend = 10,
            },
            autojump = false,  -- Jump to symbol in source window when the cursor moves
            preview = false,   -- Show code preview in right column, if there are no child symbols
            keymaps = {
                ["<CR>"] = false,
                ["<2-LeftMouse>"] = false,
                ["<C-v>"] = false,
                ["<C-s>"] = false,
                ["h"] = false,
                ["l"] = false,
                ["<Esc>"] = "actions.close",
            }
        },

        lsp = {
            diagnostics_trigger_update = false,  -- Update symbols when LSP diagnostics update
            update_when_errors = true,           -- Update when there are LSP errors

            -- How long (in ms) after a buffer change before updating
            -- Only used when diagnostics_trigger_update = false
            update_delay = 300,

            -- Map of LSP client name to priority. Default value is 10.
            -- Clients with higher (larger) priority will be used before those with lower priority.
            -- Set to -1 to never use the client.
            priority = {
                -- pyright = 10,
            }
        },

        -- How long (in ms) after a buffer change before updating
        treesitter = { update_delay = 300 },
        markdown = { update_delay = 300 },
        asciidoc = { update_delay = 300 },
        man = { update_delay = 300 },
    })
end

return M
