--   _
--  (_) ___ ___  _ __  ___
--  | |/ __/ _ \| '_ \/ __|
--  | | (_| (_) | | | \__ \
--  |_|\___\___/|_| |_|___/
-- =============================================================================

return {

    -- AERIAL
    ----------------------------------------------------------------------------
    aerial = {
        mid_item = "├─",
        last_item = "└─",
        nested_top = "│ ",
        whitespace = "  ",
    },

    -- BARBAR
    ----------------------------------------------------------------------------
    barbar = {
        separator = "│",
        modified = "●",
        pinned = "",
    },

    -- DAP
    ----------------------------------------------------------------------------
    dap = {
        breakpoint = "󰝥",
        breakpoint_condition = "󰟃",
        breakpoint_rejected = "",
        log_point = "",
        pause = "",
        play = "",
        run_last = "↻",
        step_back = "",
        step_into = "󰆹",
        step_out = "󰆸",
        step_over = "󰆷",
        stopped = "",
        terminate = "󰝤",
    },

    -- DIAGNOSTICS
    ----------------------------------------------------------------------------
    diagnostics = {
        error = "",
        warn = "",
        info = "",
        hint = "",
    },

    -- FIDGET
    ----------------------------------------------------------------------------
    fidget = {
        done_icon = "✔",
        group_separator = "---",
        icon_separator = " ",
    },

    -- GITSIGNS
    ----------------------------------------------------------------------------
    gitsigns = {
        add = "+",
        change = "~",
        delete = "_",
        topdelete = "‾",
        changedelete = "~",
        untracked = "┆",
    },

    -- GLANCE
    ----------------------------------------------------------------------------
    glance = {
        fold_closed = "",
        fold_open = "",
        icon = "│",
    },

    -- LEGENDARY
    ----------------------------------------------------------------------------
    legendary = {
        prompt = "LGD  ",
        col_separator_char = "│",
        command = "",
        fn = "󰡱",
        itemgroup = "",
    },

    -- LUALINE
    ----------------------------------------------------------------------------
    lualine = {
        component_separator_left = "│",
        component_separator_right = "│",
        section_separator_left = "",
        section_separator_right = "",
        modified = function() return "●" end,
        vim_logo = function() return "" end,
        grappe_icon = function() return "󰛢" end,
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
        end,
        lazy_startuptime = function()
            local lazy_stats = require("lazy").stats()
            local start_time = math.floor(lazy_stats.startuptime)
            return " " .. start_time .. "ms"
        end,
    },

    -- MASON
    ----------------------------------------------------------------------------
    mason = {
        package_installed = "✓",
        package_pending = "➜",
        package_uninstalled = "✗",
    },

    -- NEOTREE
    ----------------------------------------------------------------------------
    neotree = {
        git_added = "",
        git_modified = "M",
        git_deleted = "",
        git_renamed = "",
        git_untracked = "U",
        git_ignored = "I",
        git_unstaged = "",
        git_staged = "",
        git_conflict = "",
        dir_closed = "",
        dir_open = "",
        dir_empty = "",
        modified = "",
        vline = "│",
        vline_bottom_left_corner = "└",
        expander_closed = "› ",
        expander_open = "⌄",
    },

    -- OPTIONS
    ----------------------------------------------------------------------------
    options = {
        foldclose = "󰅂",
        foldopen = "󰅀",
        foldsep = "│",
        sb = "󰌑 ",
    },

    -- QUICKER
    ----------------------------------------------------------------------------
    quicker = {
        E = "󰅚 ",
        W = "󰀪 ",
        I = " ",
        N = " ",
        H = " ",
        vert = "┃",
        strong_header = "━",
        strong_cross = "╋",
        strong_end = "┫",
        soft_header = "╌",
        soft_cross = "╂",
        soft_end = "┨",
    },

    -- RENDER MARKDOWN
    ----------------------------------------------------------------------------
    render_markdown = {
        heading1 = "󰉫 ",
        heading2 = "󰉬 ",
        heading3 = "󰉭 ",
        heading4 = "󰉮 ",
        heading5 = "󰉯 ",
        heading6 = "󰉰 ",
        signs = "󰫎 ",
        above_heading = "▄",
        below_heading = "▀",
        above_code = "▄",
        below_code = "▀",
        bullet_circle_full = "●",
        bullet_circle_empty = "○",
        bullet_diamond_full = "◆",
        bullet_diamond_empty = "◇",
        checkbox_checked = "󰄱 ",
        checkbox_unchecked = "󰱒 ",
        todo_raw = "[-]",
        todo_rendered = "󰥔 ",
        block_quote = "▋",
        border_chars = {
            '┌', '┬', '┐',
            '├', '┼', '┤',
            '└', '┴', '┘',
            '│', '─',
        },
        alignment_icon = "━",
        callout_note = "󰋽 Note",
        callout_tip = "󰌶 Tip",
        callout_important = "󰅾 Important",
        callout_warning = "󰀪 Warning",
        callout_caution = "󰳦 Caution",
        link_image = "󰥶 ",
        link_email = "󰀓 ",
        link_hyperlink = "󰌹 ",
        link_wiki = "󱗖 ",
        link_web = "󰖟 ",
    },

    -- TRAILBLAZER
    ----------------------------------------------------------------------------
    trailblazer = {
        mark = "⚑",
    }
}
