--
--    ___ _ __ ___  _ __
--   / __| '_ ` _ \| '_ \
--  | (__| | | | | | |_) |
--   \___|_| |_| |_| .__/
-- ================|_|==========================================================

local M = {}

-- CMP CMD LINE KEYS
--------------------------------------------------------------------------------
M.cmd_line_keys = {
    "/",
    ":",
}

-- CMD LINE CONFIG
--------------------------------------------------------------------------------
function M.cmd_line_config()
    local cmp = require("cmp")
    local map = require("cmp").mapping
    local sendkey = vim.api.nvim_feedkeys

    -- `/` cmdline setup
    cmp.setup.cmdline("/", {
        mapping = map.preset.cmdline({
            ["<Down>"] = cmp.mapping({
                c = function()
                    if cmp.visible() then
                        cmp.select_next_item({
                            behavior = cmp.SelectBehavior.Select
                        })
                    else
                        sendkey(vim.keycode("<Down>"), "n", true)
                    end
                end
            }),
            ["<Up>"] = cmp.mapping({
                c = function()
                    if cmp.visible() then
                        cmp.select_prev_item({
                            behavior = cmp.SelectBehavior.Select
                        })
                    else
                        sendkey(vim.keycode("<Up>"), "n", true)
                    end
                end
            }),
            ["<CR>"] = cmp.mapping({
                c = function()
                    if cmp.visible() then
                        cmp.confirm({})
                        sendkey(vim.keycode("<CR>"), "n", true)
                    else
                        sendkey(vim.keycode("<CR>"), "n", true)
                    end
                end
            }),
            ["<Tab>"] = cmp.mapping({
                c = function()
                    if cmp.visible() then
                        cmp.confirm({})
                    else
                        sendkey(vim.keycode("<Tab>"), "n", true)
                    end
                end
            })
        }),
        window = {
            completion = { side_padding = 1 },
        },
        sources = {
            { name = "buffer" }
        }
    })

    -- `:` cmdline setup
    cmp.setup.cmdline(":", {
        mapping = map.preset.cmdline({
            ["<Down>"] = cmp.mapping({
                c = function()
                    if cmp.visible() then
                        cmp.select_next_item({
                            behavior = cmp.SelectBehavior.Select
                        })
                    else
                        sendkey(vim.keycode("<Down>"), "n", true)
                    end
                end
            }),
            ["<Up>"] = cmp.mapping({
                c = function()
                    if cmp.visible() then
                        cmp.select_prev_item({
                            behavior = cmp.SelectBehavior.Select
                        })
                    else
                        sendkey(vim.keycode("<Up>"), "n", true)
                    end
                end
            }),
            ["<CR>"] = cmp.mapping({
                c = function()
                    if cmp.visible() then
                        cmp.confirm({})
                        sendkey(vim.keycode("<CR>"), "n", true)
                    else
                        sendkey(vim.keycode("<CR>"), "n", true)
                    end
                end
            }),
            ["<Tab>"] = cmp.mapping({
                c = function()
                    if cmp.visible() then
                        cmp.confirm({})
                    else
                        sendkey(vim.keycode("<Tab>"), "n", true)
                    end
                end
            })
        }),
        window = {
            completion = { side_padding = 1 },
        },
        sources = cmp.config.sources({
            { name = "path" },
            {
                name = "cmdline",
                option = {
                    ignore_cmds = { "Man", "!" }
                }
            }
        })
    })
end

-- CMP CONFIG
--------------------------------------------------------------------------------
function M.config()
    local status_ok = pcall(require, "cmp")
    if not status_ok then return end

    -- Loads snippets from installed plugins (e.g. friendly-snippets)
    require("luasnip.loaders.from_vscode").lazy_load()

    -- Setup
    local cmp = require("cmp")
    local map = require("cmp").mapping
    require("cmp").setup({
        completion = {
            completeopt = "menu,menuone,preview,noselect",
        },

        window = {
            completion = { side_padding = 1 },
            documentation = {  -- No limit on doc win size
                max_width = 0,
                max_height = 0,
            }
        },

        -- Disable preselection of menu items while typing
        preselect = cmp.PreselectMode.None,

        -- Configure how nvim-cmp interacts with snippet engine
        snippet = {
            expand = function(args)
                require("luasnip").lsp_expand(args.body)

                -- Enable shell snippets for .zsh files
                require("luasnip").filetype_extend("zsh", { "shell" })
            end
        },

        -- Key mappings
        mapping = map.preset.insert({
            ["<A-f>"] = map.complete(),            -- Show completion suggestions
            ["<Up>"] = map.select_prev_item({      -- Previous suggestion
                behavior = cmp.SelectBehavior.Select
            }),
            ["<Down>"] = map.select_next_item({    -- Next suggestion
                behavior = cmp.SelectBehavior.Select
            }),
            ["<S-Up>"] = map.select_prev_item({    -- Scroll multiple suggestions up
                behavior = cmp.SelectBehavior.Select,
                count = 10,
            }),
            ["<S-Down>"] = map.select_next_item({  -- Scroll multiple suggestions down
                behavior = cmp.SelectBehavior.Select,
                count = 10,
            }),
            ["<PageUp>"] = map.scroll_docs(-4),    -- Scroll docs up
            ["<PageDown>"] = map.scroll_docs(4),   -- Scroll docs down
            ["<Tab>"] = map.confirm({}),           -- Confirm selection
            ["<CR>"] = cmp.mapping(function(fallback)
                if cmp.visible() and cmp.get_selected_entry() then
                    cmp.confirm({})
                else
                    fallback()  -- Send the `<CR>` keystroke as usual
                end
            end)
        }),

        -- Sources for autocompletion
        sources = require("cmp").config.sources({


            { name = "nvim_lsp" },


            {   -- Snippet engine
                name = "luasnip",
                group_index = 1,
            },
            {   -- LSP signatures
                name = "nvim_lsp_signature_help",
                group_index = 2,
            },
            {   -- LSP
                name = "nvim_lsp",
                group_index = 3,
            },
            {   -- Vim api
                name = "nvim_lua",
                group_index = 4,
            },
            {   -- File system paths
                name = "path",
                group_index = 5,
                max_item_count = 10,
            },
            {   -- Text within current buffer
                name = "buffer",
                group_index = 6,
                max_item_count = 10,
                keyword_length = 3,
                dup = 0,
                option = {
                    get_bufnrs = function()
                        return vim.api.nvim_buf_line_count(0) < 7500
                            and vim.api.nvim_list_bufs()
                            or {}
                    end
                }
            },
            {   -- `rg` files in cwd
                name = "rg",
                group_index = 7,
                max_item_count = 5,
                keyword_length = 3,
                dup = 0,
            },
            {   -- Spelling (vim.o.spell must be `true` to work)
                name = "spell",
                group_index = 8,
                max_item_count = 10,
                keyword_length = 4,
                option = {
                    keep_all_entries = false,
                    enable_in_context = function()
                        return true
                    end
                }
            }
        }),

        formatting = {
            fields = { 'icon', 'abbr', 'kind', 'menu' },
            format = function(entry, item)
                -- Convert numeric kinds -> string (LSP spec -> readable)
                local kinds = require("cmp.types").lsp.CompletionItemKind
                if type(item.kind) == "number" then
                    item.kind = kinds[item.kind] or item.kind
                end

                local source_labels = {
                    luasnip = "[luaSnip]",
                    nvim_lsp = "[LSP]",
                    nvim_lua = "[nvLua]",
                    path = "[Path]",
                    buffer = "[Buf]",
                    rg = "[rg]",
                    spell = "[Eng]",
                }

                item.menu = source_labels[entry.source.name] or ""

                return item
            end
        }
    })
end

return M
