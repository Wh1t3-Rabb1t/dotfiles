--    ___    __   _
--   / _|___/ _| | |_   _  __ _
--  | ||_  / |_  | | | | |/ _` |
--  |  _/ /|  _| | | |_| | (_| |
--  |_|/___|_|   |_|\__,_|\__,_|
-- =============================================================================

local M = {}

-- KEYS
--------------------------------------------------------------------------------
M.keys = {
    -- Alt bindings
    {
        mode = { "n" },
        "<A-f>",
        function()
            -- Use `blines` in place of rg when searching man pages
            vim.cmd(vim.bo.filetype == "man" and
                "FzfLua blines" or
                "FzfLua lgrep_curbuf"
            )
        end,
        desc = "󰢱 FZF grep buffer"
    },
    {
        mode = { "n" },
        "<A-g>",
        "<cmd>FzfLua live_grep_native<CR>",
        desc = "󰢱 FZF grep cwd"
    },
    {
        mode = { "v" },
        "<A-f>",
        "<cmd>FzfLua grep_visual<CR>",
        desc = "󰢱 FZF grep visual selection"
    },
    {
        mode = { "n" },
        "<A-S-f>",
        "<cmd>FzfLua blines<CR>",
        desc = "󰢱 FZF fuzzy buffer"
    },
    {
        mode = { "n" },
        "<A-'>",
        "<cmd>FzfLua buffers<CR>",
        desc = "󰢱 FZF open buffers"
    },
    {
        mode = { "n" },
        "<A-p>",
        "<cmd>FzfLua registers<CR>",
        desc = "󰢱 FZF registers"
    },
    {
        mode = { "v" },
        "<A-p>",
        function()
            vim.cmd([[
                :execute 'normal! "_d'
                FzfLua registers
            ]])
        end,
        desc = "󰢱 FZF paste over selection from register (visual)"
    },

    -- Leader bindings
    {
        mode = { "n" },
        "<Leader>f",
        "<cmd>FzfLua files<CR>",
        desc = "󰢱 FZF files in cwd"
    },
    {
        mode = { "n" },
        "<Leader>h",
        "<cmd>FzfLua helptags<CR>",
        desc = "󰢱 FZF help tags"
    },
    {
        mode = { "n" },
        "<Leader>H",
        "<cmd>FzfLua highlights<CR>",
        desc = "󰢱 FZF highlights"
    },
    {
        mode = { "n" },
        "<Leader>C",
        "<cmd>FzfLua commands<CR>",
        desc = "󰢱 FZF commands"
    },
    {
        mode = { "n" },
        "<Leader>l",
        function()
            require("fzf-lua").lsp_finder({
                prompt="LSP finder  ",
                fzf_opts = { ["--with-nth"] = "1.." }
            })
        end,
        desc = "󰢱 FZF LSP finder"
    },
    {
        mode = { "n" },
        "<Leader>s",
        function()
            require("fzf-lua").lsp_document_symbols({
                prompt="DocSymbols  ",
                fzf_opts = { ["--with-nth"] = "1.." }
            })
        end,
        desc = "󰢱 FZF LSP document symbols"
    },
    {
        mode = { "n" },
        "<Leader>S",
        function()
            require("fzf-lua").lsp_workspace_symbols({
                prompt="WsSymbols  ",
                fzf_opts = { ["--with-nth"] = "1.." }
            })
        end,
        desc = "󰢱 FZF LSP workspace symbols"
    },
    {
        mode = { "n" },
        "<Leader>m",
        "<cmd>FzfLua marks<CR>",
        desc = "󰢱 FZF marks"
    },
    {
        mode = { "n" },
        "<Leader>M",
        "<cmd>FzfLua manpages<CR>",
        desc = "󰢱 FZF manpages"
    },
    {
        mode = { "n" },
        "<Leader>GS",
        "<cmd>FzfLua spell_suggest<CR>",
        desc = "󰢱 FZF spelling suggestions"
    }
}


-- CONFIG
--------------------------------------------------------------------------------
function M.config()
    local status_ok = pcall(require, "fzf-lua")
    if not status_ok then return end

    -- Hack for pasting into the input field
    -- https://github.com/ibhagwan/fzf-lua/issues/534
    vim.keymap.set("t", "<A-v>", function()
        vim.api.nvim_paste(vim.fn.getreg("*"), true, -1)
    end, {
        noremap = true,
        silent = false,
        desc = "Paste from system register into FzfLua",
    })

    -- Setup
    local actions = require("fzf-lua.actions")
    require("fzf-lua").register_ui_select()
    require("fzf-lua").setup({
        fzf_opts = {
            -- NOTE: no-hscroll preserves correct formatting in Legendary
            ["--no-hscroll"] = true,
            ["--margin"] = "1%",
            ["--cycle"] = true,
            ["--layout"] = "default",
        },

        -- Window options
        ------------------------------------------------------------------------
        winopts = {
            height = 0.85,  -- window height
            width = 0.80,   -- window width
            row = 0.35,     -- window row position (0=top, 1=bottom)
            col = 0.50,     -- window col position (0=left, 1=right)

            -- Create invisible border
            border = { " ", " ", " ", " ", " ", " ", " ", " " },

            -- Backdrop opacity, 0 is fully opaque, 100 is fully transparent (i.e. disabled)
            backdrop = 0,
            number = false,
            list = false,
            title = " FZF 󰢱 ",
            title_pos = "center",  -- 'left', 'center' or 'right'
            fullscreen = false,    -- start fullscreen?
            preview = {
                default = "bat",   -- override the default previewer?

                -- Defaults are: border|noborder
                border = { " ", " ", " ", " ", " ", " ", " ", " " },
                wrap = "nowrap",           -- wrap|nowrap
                hidden = "nohidden",       -- hidden|nohidden
                vertical = "up:45%",       -- up|down:size
                horizontal = "right:50%",  -- right|left:size
                layout = "flex",           -- horizontal|vertical|flex
                flip_columns = 150,        -- #cols to switch to horizontal on flex

                -- Only used with the builtin previewer:
                title = true,          -- preview border title (file/buf)?
                title_pos = "center",  -- left|center|right, title alignment
                scrollbar = "false",   -- `false` or string:'float|border'
                delay = 40,            -- preview delay(ms) (prevents lag on fast scrolling)

                -- Builtin previewer window options
                winopts = {
                    cursorcolumn = false,  -- Must be false to set bg color in preview window
                    number = false,
                    relativenumber = false,
                    cursorline = true,
                    cursorlineopt = "both",
                    signcolumn = "no",
                    list = false,
                    foldenable = false,
                    foldmethod = "manual",
                }
            },
            on_create = function()
                -- called once upon creation of the fzf main window
                -- can be used to add custom fzf-lua mappings, e.g:
                --   vim.keymap.set("t", "<C-j>", "<Down>", { silent = true, buffer = true })
            end,
            -- called once _after_ the fzf interface is closed
            -- on_close = function() ... end
        },

        -- Keymaps
        ------------------------------------------------------------------------
        keymap = {
            -- Below are the default binds, setting any value in these tables will override
            -- the defaults, to inherit from the defaults change [1] from `false` to `true`
            builtin = {
                false,  -- Inherit from defaults
                -- neovim `:tmap` mappings for the fzf win
                ["<S-Esc>"] = "hide",  -- Hide fzf-lua, `:FzfLua resume` to continue
                ["?"] = "toggle-help",
                ["<A-S-f>"] = "toggle-fullscreen",

                -- Rotate preview clockwise/counter-clockwise
                ["<S-Right>"] = "toggle-preview-ccw",
                ["<S-Left>"] = "toggle-preview-cw",
                ["<PageUp>"] = "preview-page-up",
                ["<PageDown>"] = "preview-page-down",

                -- Only valid with the 'builtin' previewer
                ["<S-End>"] = "toggle-preview-wrap",
                ["<A-p>"] = "toggle-preview",

                -- Unmapped keys
                ["<S-Up>"] = false,
                ["<S-Down>"] = false,
                ["<C-f>"] = false,
                ["<C-b>"] = false,
                ["<C-c>"] = false,
                ["<C-q>"] = false,
            },

            fzf = {
                true,  -- Inherit from defaults
                ["ctrl-u"] = "unix-line-discard",
                ["shift-down"] = "half-page-down",
                ["shift-up"] = "half-page-up",
                ["home"] = "beginning-of-line",
                ["end"] = "end-of-line",
                ["alt-a"] = "toggle-all",
                ["alt-g"] = "last",
                ["alt-G"] = "first",

                -- Only valid with fzf previewers (bat/cat/git/etc)
                -- ["f4"] = "toggle-preview",
                -- ["f3"] = "toggle-preview-wrap",
                ["f3"] = false,
                ["f4"] = false,
                ["ctrl-z"] = false,
                ["ctrl-a"] = false,
                ["ctrl-e"] = false,
            }
        },

        -- Actions
        ------------------------------------------------------------------------
        actions = {
            -- Setting any value in these tables will override the defaults
            files = {
                false,  -- Inherit from defaults
                ["enter"] = actions.file_edit_or_qf,
                ["alt-n"] = actions.file_split,
                ["alt-m"] = actions.file_vsplit,
                ["alt-r"] = actions.file_sel_to_qf,
                ["alt-l"] = actions.file_sel_to_ll,
                ["alt-t"] = actions.file_tabedit,
            }
        },

        --  Files in cwd
        ------------------------------------------------------------------------
        files = {
            prompt = "Files  ",
            previewer = "builtin",   -- Set to 'false' to disable
            multiprocess = true,     -- Run command in a separate process
            git_icons = true,        -- Show git icons?
            file_icons = true,       -- Show file icons (true|"devicons"|"mini")?
            color_icons = true,      -- Colorize file|git icons
            find_opts = [[-type f -not -path '*/\.git/*' -printf '%P\n']],
            rg_opts = [[--color=never --files --follow -g "!.git"]],
            fd_opts = [[--color=never --type f --hidden --follow --exclude .git]],
            cwd_header = false,
            cwd_prompt = false,
            cwd_prompt_shorten_len = 28,         -- Shorten prompt beyond this length
            cwd_prompt_shorten_val = 1,          -- Shortened path parts length
            toggle_ignore_flag = "--no-ignore",  -- Flag toggled in `actions.toggle_ignore`
            toggle_hidden_flag = "--hidden",     -- Flag toggled in `actions.toggle_hidden`
            no_header = true,
            no_header_i = true,
            actions = {
                ["alt-i"] = false,
                ["shift-tab"] = actions.toggle_ignore,
                ["tab"] = actions.toggle_hidden,
                ["enter"] = actions.file_edit,  -- Don't send multiselect to qf
            },
            fzf_opts = {
                ["--with-nth"] = "1..",
                ["--no-hscroll"] = false,
            }
        },

        --  Buffers
        ------------------------------------------------------------------------
        buffers = {
            prompt = "Buffers  ",
            file_icons = true,     -- Show file icons (true|"devicons"|"mini")?
            color_icons = true,    -- Colorize file|git icons
            sort_lastused = true,  -- Sort buffers() by last used
            show_unloaded = true,  -- Show unloaded buffers
            cwd_only = false,      -- Buffers for the cwd only
            cwd = nil,             -- Buffers list for a given dir
            no_header = true,
            no_header_i = true,
            actions = {
                ["alt-w"] = { fn = actions.buf_del, reload = true },
                ["ctrl-x"] = false,
            },
            fzf_opts = {
                ["--with-nth"] = "1..",
                ["--no-hscroll"] = false,
            }
        },

        --  Grep
        ------------------------------------------------------------------------
        grep = {
            prompt = "Rg  ",
            input_prompt = "Rg: ",
            multiprocess = true,  -- Run command in a separate process
            git_icons = true,     -- Show git icons?
            file_icons = true,    -- Show file icons (true|"devicons"|"mini")?
            color_icons = true,   -- Colorize file|git icons

            -- Executed command priority is 'cmd' (if exists)
            -- otherwise auto-detect prioritizes `rg` over `grep`
            -- default options are controlled by 'rg|grep_opts'
            -- cmd            = "rg --vimgrep",
            grep_opts = "--binary-files=without-match --line-number --recursive --color=auto --perl-regexp -e",
            rg_opts = "--column --line-number --multiline --no-heading --color=always --smart-case --max-columns=4096 -e",
            -- Uncomment to use the rg config file `$RIPGREP_CONFIG_PATH`
            -- RIPGREP_CONFIG_PATH = vim.env.RIPGREP_CONFIG_PATH

            -- Set to 'true' to always parse globs in both 'grep' and 'live_grep'
            -- search strings will be split using the 'glob_separator' and translated
            -- to '--iglob=' arguments, requires 'rg'
            -- can still be used when 'false' by calling 'live_grep_glob' directly
            rg_glob = false,            -- Default to glob parsing?
            glob_flag = "--iglob",      -- For case sensitive globs use '--glob'
            glob_separator = "%s%-%-",  -- Query separator pattern (lua): ' --'

            -- Enable with narrow term width, split results to multiple lines
            -- NOTE: multiline requires fzf >= v0.53 and is ignored otherwise
            -- multiline      = 1,      -- Display as: PATH:LINE:COL\nTEXT
            -- multiline      = 2,      -- Display as: PATH:LINE:COL\nTEXT\n
            actions = {
                ["tab"] = actions.grep_lgrep,
                ["alt-/"] = actions.toggle_ignore,
                ["ctrl-g"] = false,
            },
            no_header = true,    -- Hide grep|cwd header?
            no_header_i = true,  -- Hide interactive header?
            fzf_opts = {
                ["--with-nth"] = "1..",
                ["--no-hscroll"] = false,
                ["--tac"] = true,
            }
        },

        --  Lines (fuzzy search)
        ------------------------------------------------------------------------
        lines = {
            previewer = "builtin",   -- Set to 'false' to disable
            prompt = "FzyCwd  ",
            show_unloaded = true,    -- Show unloaded buffers
            show_unlisted = false,   -- Exclude 'help' buffers
            no_term_buffers = true,  -- Exclude 'term' buffers
            no_header = true,
            no_header_i = true,
            fzf_opts = {
                -- Don't include bufnr in fuzzy matching
                -- tiebreak by line no.
                ["--delimiter"] = "[\\]:]",
                ["--nth"] = "1..",
                ["--no-hscroll"] = false,
                ["--tiebreak"] = "index",
                ["--tabstop"] = "1",
                ["--tac"] = true,
            }
        },
        blines = {
            previewer = "builtin",    -- Set to 'false' to disable
            prompt = "FzyBuf  ",
            show_unlisted = true,     -- Include 'help' buffers
            no_term_buffers = false,  -- Include 'term' buffers
            start = "cursor",         -- Start display from cursor
            no_header = true,
            no_header_i = true,
            fzf_opts = {
                ["--no-hscroll"] = false,
                ["--tiebreak"] = "index",
                ["--tabstop"] = "1",
                ["--tac"] = true,
            }
        },

        --  Marks
        ------------------------------------------------------------------------
        marks = {
            prompt = "Marks  ",
            fzf_opts = {
                ["--with-nth"] = "1..",
                ["--no-hscroll"] = false,
            }
        },

        --  Manpages
        ------------------------------------------------------------------------
        manpages = {
            prompt = "Manpages  ",
            fzf_opts = {
                ["--with-nth"] = "1..",
                ["--no-hscroll"] = false,
            }
        },

        --  Registers
        ------------------------------------------------------------------------
        registers = {
            prompt = "Registers  ",
            fzf_opts = {
                ["--with-nth"] = "1..",
                ["--no-hscroll"] = false,
            }
        },

        --  Commands
        ------------------------------------------------------------------------
        commands = {
            prompt = "Commands  ",
            fzf_opts = {
                ["--with-nth"] = "1..",
                ["--no-hscroll"] = false,
            }
        },

        --  Highlights
        ------------------------------------------------------------------------
        highlights = {
            prompt = "Highlights  ",
            fzf_opts = {
                ["--with-nth"] = "1..",
                ["--no-hscroll"] = false,
            }
        }
    })
end

return M
