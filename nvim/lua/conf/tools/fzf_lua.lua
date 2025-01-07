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
    {
        mode = { "n" },
        "<Leader>f",
        "<cmd>FzfLua files<CR>",
        desc = "Search files in cwd"
    },
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
        desc = "Grep current buffer"
    },
    {
        mode = { "n" },
        "<A-g>",
        "<cmd>FzfLua live_grep_native<CR>",
        desc = "Grep cwd"
    },
    {
        mode = { "v" },
        "<A-f>",
        "<cmd>FzfLua grep_visual<CR>",
        desc = "Grep visual selection"
    },
    {
        mode = { "n" },
        "<A-S-f>",
        "<cmd>FzfLua blines<CR>",
        desc = "Fzy search current buffer"
    },
    {
        mode = { "n" },
        "<A-'>",
        "<cmd>FzfLua buffers<CR>",
        desc = "Search open buffers"
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
        desc = "Paste from system register into FzfLua",
        noremap = true,
        silent = false,
    })

    -- Setup
    local actions = require("fzf-lua.actions")
    require("fzf-lua").register_ui_select()
    require("fzf-lua").setup({
        fzf_opts = {
            -- !!
            -- Required to preserve correct formatting with Legendary
            ["--with-nth"] = "2..",
            ["--no-hscroll"] = true,
            -- !!
            ["--margin"] = "1%",
            ["--cycle"] = "",
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
                default = "bat",           -- override the default previewer?

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
            rg_opts = [[--color=never --files --hidden --follow -g "!.git"]],
            fd_opts = [[--color=never --type f --hidden --follow --exclude .git]],
            cwd_header = true,
            cwd_prompt = false,
            cwd_prompt_shorten_len = 28,         -- Shorten prompt beyond this length
            cwd_prompt_shorten_val = 1,          -- Shortened path parts length
            toggle_ignore_flag = "--no-ignore",  -- Flag toggled in `actions.toggle_ignore`
            toggle_hidden_flag = "--hidden",     -- Flag toggled in `actions.toggle_hidden`
            actions = {
                ["alt-i"] = actions.toggle_ignore,
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
                ["alt-f"] = actions.grep_lgrep,
                ["alt-i"] = actions.toggle_ignore,
                ["ctrl-g"] = false,
            },
            no_header = false,    -- Hide grep|cwd header?
            no_header_i = false,  -- Hide interactive header?
            fzf_opts = {
                ["--with-nth"] = "1..",
                ["--no-hscroll"] = false,
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
            fzf_opts = {
                -- Don't include bufnr in fuzzy matching
                -- tiebreak by line no.
                ["--delimiter"] = "[\\]:]",
                ["--nth"] = "2..",
                ["--no-hscroll"] = false,
                ["--tiebreak"] = "index",
                ["--tabstop"] = "1",
            }
        },
        blines = {
            previewer = "builtin",    -- Set to 'false' to disable
            prompt = "FzyBuf  ",
            show_unlisted = true,     -- Include 'help' buffers
            no_term_buffers = false,  -- Include 'term' buffers
            start = "cursor",         -- Start display from cursor
            fzf_opts = {
                -- Hide filename, tiebreak by line no.
                ["--delimiter"] = "[:]",
                ["--with-nth"] = "2..",
                ["--no-hscroll"] = false,
                ["--tiebreak"] = "index",
                ["--tabstop"] = "1",
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
            -- "  Unnamed register. Holds the last deleted or yanked text.
            -- #  Alternate file name register. Holds name of the last file edited.
            -- /  Last search pattern register. Stores the most recent search pattern.
            -- *  Primary system clipboard selection (X11 on Unix-like systems).
            -- +  Secondary clipboard register. Used for copying/pasting with the system clipboard.
            -- .  Last inserted text register. Contains last inserted text.
            -- %  Current file name register. Holds the name of the current file.
            -- :  Last executed command register. Containing the last command-line command entered.
            -- -  Small delete register. Holds text from deletions smaller than a line (like dw).
            -- _  Black hole register. Discards any text sent to it, acting as a "null" register.
            -- =  Expression register. Allows you to evaluate expressions and insert the result.
            -- 0  Yank register for the last yank command. Last yanked text (not overwritten by deletes).
            -- ~  Register for the last tilde operation. Stores result of the last g~ or ~ operation.
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


-- previewers = {
--     cat = {
--         cmd = "cat",
--         args = "-n",
--     },
--     bat = {
--         cmd = "bat",
--         args = "--color=always --style=numbers,changes",
--         -- uncomment to set a bat theme, `bat --list-themes`
--         -- theme           = 'Coldark-Dark',
--     },
--     head = {
--         cmd = "head",
--         args = nil,
--     },
--     git_diff = {
--         -- if required, use `{file}` for argument positioning
--         -- e.g. `cmd_modified = "git diff --color HEAD {file} | cut -c -30"`
--         cmd_deleted = "git diff --color HEAD --",
--         cmd_modified = "git diff --color HEAD",
--         cmd_untracked = "git diff --color --no-index /dev/null",
--         -- git-delta is automatically detected as pager, set `pager=false`
--         -- to disable, can also be set under 'git.status.preview_pager'
--     },
--     man = {
--         -- NOTE: remove the `-c` flag when using man-db
--         -- replace with `man -P cat %s | col -bx` on OSX
--         cmd = "man -c %s | col -bx",
--     },
--     builtin = {
--         syntax = true, -- preview syntax highlight?
--         syntax_limit_l = 0, -- syntax limit (lines), 0=nolimit
--         syntax_limit_b = 1024 * 1024, -- syntax limit (bytes), 0=nolimit
--         limit_b = 1024 * 1024 * 10, -- preview limit (bytes), 0=nolimit
--         -- previewer treesitter options:
--         -- enable specific filetypes with: `{ enable = { "lua" } }
--         -- exclude specific filetypes with: `{ disable = { "lua" } }
--         -- disable fully with: `{ enable = false }`
--         treesitter = { enable = true, disable = {} },
--         -- By default, the main window dimensions are calculated as if the
--         -- preview is visible, when hidden the main window will extend to
--         -- full size. Set the below to "extend" to prevent the main window
--         -- from being modified when toggling the preview.
--         toggle_behavior = "default",
--         -- Title transform function, by default only displays the tail
--         -- title_fnamemodify = function(s) vim.fn.fnamemodify(s, ":t") end,
--         -- preview extensions using a custom shell command:
--         -- for example, use `viu` for image previews
--         -- will do nothing if `viu` isn't executable
--         extensions = {
--             -- neovim terminal only supports `viu` block output
--             ["png"] = { "viu", "-b" },
--             -- by default the filename is added as last argument
--             -- if required, use `{file}` for argument positioning
--             ["svg"] = { "chafa", "{file}" },
--             ["jpg"] = { "ueberzug" },
--         },
--         -- if using `ueberzug` in the above extensions map
--         -- set the default image scaler, possible scalers:
--         --   false (none), "crop", "distort", "fit_contain",
--         --   "contain", "forced_cover", "cover"
--         -- https://github.com/seebye/ueberzug
--         ueberzug_scaler = "cover",
--         -- Custom filetype autocmds aren't triggered on
--         -- the preview buffer, define them here instead
--         -- ext_ft_override = { ["ksql"] = "sql", ... },
--         -- render_markdown.nvim integration, enabled by default for markdown
--         render_markdown = { enable = true, filetypes = { ["markdown"] = true } },
--     }
-- },
