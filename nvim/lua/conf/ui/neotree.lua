--                    _
--   _ __   ___  ___ | |_ _ __ ___  ___
--  | '_ \ / _ \/ _ \| __| '__/ _ \/ _ \
--  | | | |  __/ (_) | |_| | |  __/  __/
--  |_| |_|\___|\___/ \__|_|  \___|\___|
-- =============================================================================

local M = {}

-- ICONS
--------------------------------------------------------------------------------
local icons = {
    git_added = " ",
    git_deleted = " ",
    git_modified = " ",
    git_renamed = " ",
    git_untracked = "󰆆 ",
    git_ignored = " ",
    git_unstaged = " ",
    git_staged = " ",
    git_conflict = " ",
    dir_closed = "",
    dir_open = "",
    dir_empty = "",
    modified = "",
    vline = "│",
    vline_bottom_left_corner = "└",
    expander_closed = "› ",
    expander_open = "⌄",
}


-- KEYS
--------------------------------------------------------------------------------
M.keys = {
    {
        mode = { "n" },
        "<A-Right>",
        "<cmd>Neotree reveal<CR>",
        desc = "Toggle Neotree"
    }
}


-- CONFIG
--------------------------------------------------------------------------------
function M.config()
    local status_ok = pcall(require, "neo-tree")
    if not status_ok then return end

    -- Setup
    require("neo-tree").setup({
        close_if_last_window = true,
        popup_border_style = "rounded",
        enable_git_status = true,
        enable_diagnostics = false,

        -- When opening files, don't use windows containing these file or buftypes
        open_files_do_not_replace_types = {
            "terminal",
            "qf",
        },
        sort_case_insensitive = false,  -- Used when sorting files and dirs in the tree

        -- Winbar above neotree (gets overwritten by LuaLine winbar)
        source_selector = {
            winbar = false,
            statusline = false,
        },

        -- Use a custom function for sorting files and directories in the tree
        sort_function = nil,

        default_component_configs = {
            container = {
                enable_character_fade = true,
            },

            indent = {
                indent_size = 2,
                padding = 1,  -- Extra padding on left hand side

                -- Indent guides
                with_markers = true,
                indent_marker = icons.vline,
                last_indent_marker = icons.vline,
                highlight = "NeoTreeIndentMarker",

                -- Expander config, needed for nesting files
                with_expanders = nil,  -- If nil and file nesting is enabled, will enable expanders
                expander_collapsed = icons.expander_closed,
                expander_expanded = icons.expander_open,
                expander_highlight = "NeoTreeFileName",  -- Default: "NeoTreeExpander"
            },

            icon = {
                folder_closed = icons.dir_closed,
                folder_open = icons.dir_open,
                folder_empty = icons.dir_empty,

                -- The next two settings are only a fallback, if you use nvim-web-devicons
                -- and configure default icons there then these will never be used.
                default = "*",
                highlight = "NeoTreeFileIcon"
            },

            modified = {
                symbol = icons.modified,
                highlight = "NeoTreeModified",
            },

            name = {
                trailing_slash = false,
                use_git_status_colors = true,
                highlight = "NeoTreeFileName",
            },

            git_status = {
                symbols = {
                    added = icons.git_added,
                    modified = icons.git_modified,
                    deleted = icons.git_deleted,
                    renamed = icons.git_renamed,
                    untracked = icons.git_untracked,
                    ignored = icons.git_ignored,
                    unstaged = icons.git_unstaged,
                    staged = icons.git_staged,
                    conflict = icons.git_conflict,
                }
            },

            -- If you don't want to use these columns, you can set
            -- 'enabled = false' for each of them individually.
            file_size = {
                enabled = true,
                required_width = 64,  -- Min width required to show this column
            },
            type = {
                enabled = true,
                required_width = 122
            },
            last_modified = {
                enabled = true,
                required_width = 88
            },
            created = {
                enabled = true,
                required_width = 110
            },
            symlink_target = { enabled = false },
        },

        -- A list of functions, each representing a global custom command that will be
        -- available in all sources (if not overridden in 'opts[source_name].commands')
        -- see ':h neo-tree-custom-commands-global'.
        commands = {},
        window = {
            position = "right",
            width = 35,
            mapping_options = {
                noremap = true,
                nowait = true,
            },

            mappings = {
                ["<Space>"] = false,
                ["<Esc>"] = "cancel",  -- Close preview or floating neo-tree window
                ["<CR>"] = "open",

                -- See: '# Preview Mode' for more information
                ["p"] = {
                    "toggle_preview",
                    config = {
                        use_float = true,
                        use_image_nvim = true,
                    }
                },
                ["P"] = "focus_preview",
                ["<2-LeftMouse>"] = false,
                ["q"] = false,  -- "close_window",
                ["w"] = false,  -- "open_with_window_picker",
                ["S"] = false,  -- "open_split",
                ["s"] = false,  -- "open_vsplit",
                ["z"] = false,  -- "close_all_nodes",
                ["d"] = false,  -- "delete",
                ["A"] = false,  -- "add_directory",
                ["a"] = false,  -- "add",
                ["y"] = false,  -- "copy",
                ["m"] = false,  -- "move",
                ["R"] = false,  -- "refresh",
                ["<"] = false,  -- "prev_source",
                [">"] = false,  -- "next_source",
                ["i"] = false,
                ["I"] = false,
                ["l"] = "toggle_node",
                ["L"] = false,
                ["t"] = "close_node",
                ["T"] = false,
                ["K"] = false,
                ["D"] = "show_file_details",
                ["E"] = "expand_all_nodes",
                ["C"] = "close_all_nodes",
                ["h"] = "close_all_subnodes",
                ["n"] = "add",  -- Create new files or directories
                ["r"] = "rename",
                ["c"] = "copy_to_clipboard",
                ["x"] = "cut_to_clipboard",
                ["v"] = "paste_from_clipboard",
                ["<BS>"] = "delete",
                ["?"] = "show_help",
                ["<C-PageDown>"] = "next_source",  -- Cycle view left
                ["<C-PageUp>"] = "prev_source",    -- Cycle view right
                ["<A-Right>"] = "close_window",    -- Close neotree
            }
        },

        nesting_rules = {
            ["js"] = { "js.map" }
        },

        filesystem = {
            filtered_items = {
                visible = false,  -- When true, they will be displayed differently
                hide_dotfiles = false,
                hide_gitignored = true,
                hide_hidden = true,  -- Only works on Windows for hidden files/dirs

                -- Uses glob style patterns
                hide_by_pattern = {},
                never_show_by_pattern = {
                    -- "*.meta",
                    -- "*/src/*/tsconfig.json",
                },

                -- Uses file / directory names
                hide_by_name = {},  -- e.g "node_modules"
                always_show = {},
                never_show = {},
            },

            -- This will find and focus the file in the active buffer every
            -- time the current file is changed while the tree is open.
            follow_current_file = {
                enabled = false,
                leave_dirs_open = false,
            },

            group_empty_dirs = false,  -- When true, empty folders will be grouped together

            -- "open_default",  -- netrw disabled, opening a directory opens neo-tree
            -- in whatever position is specified in window.position
            -- "open_current",  -- netrw disabled, opening a directory opens within the
            -- window like netrw would, regardless of window.position
            -- "disabled",    -- netrw left alone, neo-tree does not handle opening dirs
            hijack_netrw_behavior = "open_default",

            -- This will use the OS level file watchers to detect changes
            -- instead of relying on nvim autocmd events.
            use_libuv_file_watcher = false,

            window = {
                mappings = {
                    ["/"] = "fuzzy_finder",
                    ["D"] = "fuzzy_finder_directory",
                    ["."] = "toggle_hidden",
                    ["<C-PageDown>"] = "next_source",
                    ["<C-PageUp>"] = "prev_source",
                    ["H"] = false,      -- "toggle_hidden",
                    ["f"] = false,      -- "filter_on_submit",
                    ["<C-x>"] = false,  -- "clear_filter",
                    ["[g"] = false,     -- "prev_git_modified",
                    ["]g"] = false,     -- "next_git_modified",
                    ["e"] = false,      -- "toggle_auto_expand_width"
                    ["o"] = {
                        "show_help",
                        nowait = false,
                        config = {
                            title = "Order by",
                            prefix_key = "o",
                        }
                    },

                    ["oc"] = { "order_by_created", nowait = false },
                    ["od"] = { "order_by_diagnostics", nowait = false },
                    ["og"] = { "order_by_git_status", nowait = false },
                    ["om"] = { "order_by_modified", nowait = false },
                    ["on"] = { "order_by_name", nowait = false },
                    ["os"] = { "order_by_size", nowait = false },
                    ["ot"] = { "order_by_type", nowait = false },
                },

                -- Keymaps for filter popup window in fuzzy_finder_mode
                fuzzy_finder_mappings = {
                    ["<Up>"] = "move_cursor_up",
                    ["<Down>"] = "move_cursor_down",
                }
            },

            -- Add a custom command or override a global one using the same function name
            commands = {},
        },

        buffers = {
            follow_current_file = {
                -- This will find and focus the file in the active buffer every time
                -- the current file is changed while the tree is open.
                enabled = true,

                -- `false` closes auto expanded dirs, such as with `:Neotree reveal`
                leave_dirs_open = false,
            },
            group_empty_dirs = true,  -- When true, empty folders will be grouped together
            show_unloaded = true,
            window = {
                mappings = {
                    ["bd"] = false,    -- "buffer_delete",
                    ["<BS>"] = false,  -- "navigate_up",
                    ["."] = false,     -- "set_root",
                    ["o"] = {
                        "show_help",
                        nowait = false,
                        config = {
                            title = "Order by",
                            prefix_key = "o",
                        }
                    },
                    ["oc"] = { "order_by_created", nowait = false },
                    ["od"] = { "order_by_diagnostics", nowait = false },
                    ["om"] = { "order_by_modified", nowait = false },
                    ["on"] = { "order_by_name", nowait = false },
                    ["os"] = { "order_by_size", nowait = false },
                    ["ot"] = { "order_by_type", nowait = false },
                }
            }
        },

        git_status = {
            window = {
                position = "float",
                mappings = {
                    ["A"] = "git_add_all",
                    ["gu"] = "git_unstage_file",
                    ["ga"] = "git_add_file",
                    ["gr"] = "git_revert_file",
                    ["gc"] = "git_commit",
                    ["gp"] = "git_push",
                    ["gg"] = "git_commit_and_push",
                    ["o"] = {
                        "show_help",
                        nowait = false,
                        config = {
                            title = "Order by",
                            prefix_key = "o",
                        },
                    },
                    ["oc"] = { "order_by_created", nowait = false },
                    ["od"] = { "order_by_diagnostics", nowait = false },
                    ["om"] = { "order_by_modified", nowait = false },
                    ["on"] = { "order_by_name", nowait = false },
                    ["os"] = { "order_by_size", nowait = false },
                    ["ot"] = { "order_by_type", nowait = false },
                }
            }
        }
    })
end

return M
