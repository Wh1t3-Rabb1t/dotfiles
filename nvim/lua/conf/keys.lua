--   _
--  | | _____ _   _ ___
--  | |/ / _ \ | | / __|
--  |   <  __/ |_| \__ \
--  |_|\_\___|\__, |___/
-- ===========|___/=============================================================

local M = {}

local util = require("util.utils")
local map = require("util.utils").map


-- AERIAL
--------------------------------------------------------------------------------
function M.aerial()
    map("n", "<A-a>", "<cmd>AerialOpen<CR>", {
        desc = "Toggle Aerial"
    })
end


-- BARBAR
--------------------------------------------------------------------------------
function M.barbar()
    local tag = require("grapple")

    -- Navigate tabs
    map("n", "<C-PageDown>", function()
        -- Prevent bug when tab switching with a single help page open
        if vim.bo.filetype ~= "help" then
            vim.cmd("BufferNext")
        end
    end, {
        desc = "Next tab"
    })
    map("n", "<C-PageUp>", function()
        -- Prevent bug when tab switching with a single help page open
        if vim.bo.filetype ~= "help" then
            vim.cmd("BufferPrevious")
        end
    end, {
        desc = "Previous tab"
    })

    -- Rearrange tabs
    map("n", "<C-S-PageDown>", function()
        -- Prevent reordering of pinned tabs
        if type(tag.name_or_index()) ~= "number" then
            vim.cmd("BufferMoveNext")
        end
    end, {
        desc = "Swap tab with next tab"
    })
    map("n", "<C-S-PageUp>", function()
        -- Prevent reordering of pinned tabs
        if type(tag.name_or_index()) ~= "number" then
            vim.cmd("BufferMovePrevious")
        end
    end, {
        desc = "Swap tab with previous tab"
    })

    -- Close tabs
    map("n", "<A-w>", function()
        if type(tag.name_or_index()) == "number" then
            vim.cmd("Grapple toggle")
            vim.cmd("BufferClose")
            util.sync_grapple_and_barbar_indexes()
        else
            vim.cmd("BufferClose")
        end
    end, {
        desc = "Close focused tab"
    })
end


-- CMP CMD LINE KEYS
--------------------------------------------------------------------------------
M.cmd_line_keys = {
    "/",
    ":",
}


-- COMMENT
--------------------------------------------------------------------------------
M.comment = {
    {
        mode = { "n", "v" },
        "<A-/>",
        desc = "Comment"
    }
}


-- DIAL
--------------------------------------------------------------------------------
function M.dial()
    map("n", "<A-c>", function()
        require("dial.map").manipulate("increment", "normal")
    end, { desc = "Increment" })
    map("n", "<A-x>", function()
        require("dial.map").manipulate("decrement", "normal")
    end, { desc = "Decrement" })
    map("v", "<A-c>", function()
        require("dial.map").manipulate("increment", "visual")
    end, { desc = "Increment" })
    map("v", "<A-x>", function()
        require("dial.map").manipulate("decrement", "visual")
    end, { desc = "Decrement" })
end


-- DROPBAR
--------------------------------------------------------------------------------
M.dropbar = {
    {
        mode = { "n" },
        "<Home>",
        function()
            require("dropbar.api").pick()
        end,
        desc = "Focus DropBar menu"
    }
}


-- FZF LUA
--------------------------------------------------------------------------------
M.fzflua = {
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


-- GRAPPLE
--------------------------------------------------------------------------------
M.grapple = {
    {
        mode = { "n" },
        "<Leader>g",
        function()
            vim.cmd("Grapple toggle")
            util.sync_grapple_and_barbar_indexes()
        end,
        desc = "󰛢 Toggle Grapple tag on current buffer"
    },
    {
        mode = { "n" },
        "G",
        "<cmd>Grapple toggle_tags<CR>",
        desc = "󰛢 Open Grapple tags window"
    },
    {
        mode = { "n" },
        "<Leader>1",
        "<cmd>Grapple select index=1<CR>",
        desc = "󰛢 Select Grapple tag #1"
    },
    {
        mode = { "n" },
        "<Leader>2",
        "<cmd>Grapple select index=2<CR>",
        desc = "󰛢 Select Grapple tag #2"
    },
    {
        mode = { "n" },
        "<Leader>3",
        "<cmd>Grapple select index=3<CR>",
        desc = "󰛢 Select Grapple tag #3"
    },
    {
        mode = { "n" },
        "<Leader>4",
        "<cmd>Grapple select index=4<CR>",
        desc = "󰛢 Select Grapple tag #4"
    },
    {
        mode = { "n" },
        "<Leader>5",
        "<cmd>Grapple select index=5<CR>",
        desc = "󰛢 Select Grapple tag #5"
    },
    {
        mode = { "n" },
        "<Leader>6",
        "<cmd>Grapple select index=6<CR>",
        desc = "󰛢 Select Grapple tag #6"
    },
    {
        mode = { "n" },
        "<Leader>7",
        "<cmd>Grapple select index=7<CR>",
        desc = "󰛢 Select Grapple tag #7"
    },
    {
        mode = { "n" },
        "<Leader>8",
        "<cmd>Grapple select index=8<CR>",
        desc = "󰛢 Select Grapple tag #8"
    },
    {
        mode = { "n" },
        "<Leader>9",
        "<cmd>Grapple select index=9<CR>",
        desc = "󰛢 Select Grapple tag #9"
    }
}


-- HOP
--------------------------------------------------------------------------------
M.hop = {
    {
        mode = { "n", "v" },
        "<Leader>j",
        "<cmd>HopChar2<CR>",
        desc = "HOP (2 char search)"
    }
}


-- LEGENDARY
--------------------------------------------------------------------------------
M.legendary = {
    {
        mode = { "n", "v" },
        "p",
        "<cmd>Legendary<CR>",
        desc = "Launch Legendary"
    },
    {
        mode = { "n", "v" },
        "<Leader>p",
        "<cmd>LegendaryRepeat<CR>",
        desc = "Repeat last Legendary command"
    }
}


-- NEOCOMPOSER
--------------------------------------------------------------------------------
M.neocomposer = {
    "q",
    "m",
    "M",
}


-- NEOTREE
--------------------------------------------------------------------------------
M.neotree = {
    {
        mode = { "n" },
        "<End>",
        "<cmd>Neotree reveal<CR>",
        desc = "Toggle Neotree"
    }
}


-- RIP SUBSTITUTE
--------------------------------------------------------------------------------
M.rip_substitute = {
    {
        mode = { "n", "x" },
        "<A-r>",
        function()
            require("rip-substitute").sub()
        end,
        desc = "Rip Substitute",
    }
}


-- SPIDER
--------------------------------------------------------------------------------
M.spider = {
    {
        mode = { "n", "v", "o" },
        "o",
        "<cmd>lua require('spider').motion('w')<CR>",
        desc = "Jump forward by word"
    },
    {
        mode = { "n", "v", "o" },
        "u",
        "<cmd>lua require('spider').motion('b')<CR>",
        desc = "Jump backward by word"
    },
    {
        mode = { "n", "v", "o" },
        "O",
        "<cmd>lua require('spider').motion('e')<CR>",
        desc = "Jump forward to word end"
    },
    {
        mode = { "n", "v", "o" },
        "U",
        "<cmd>lua require('spider').motion('ge')<CR>",
        desc = "Jump backward to word end"
    }
}


-- SURROUND
--------------------------------------------------------------------------------
M.surround = {

    -- Change
    {                                     -- ''
        mode = { "n" },
        "<Leader>'",
        "<Plug>(nvim-surround-change)'",
        desc = "Change SURROUNDING ''"
    },
    {                                     -- ""
        mode = { "n" },
        '<Leader>"',
        '<Plug>(nvim-surround-change)"',
        desc = 'Change SURROUNDING ""'
    },
    {                                     -- ``
        mode = { "n" },
        "<Leader>`",
        "<Plug>(nvim-surround-change)`",
        desc = "Change SURROUNDING ``"
    },
    {                                     -- {}
        mode = { "n" },
        "<Leader>{",
        "<Plug>(nvim-surround-change){",
        desc = "Change SURROUNDING {}"
    },
    {                                     -- ()
        mode = { "n" },
        "<Leader>(",
        "<Plug>(nvim-surround-change)(",
        desc = "Change SURROUNDING ()"
    },
    {                                     -- []
        mode = { "n" },
        "<Leader>[",
        "<Plug>(nvim-surround-change)[",
        desc = "Change SURROUNDING []"
    },
    {                                     -- <>
        mode = { "n" },
        "<Leader><",
        "<Plug>(nvim-surround-change)<",
        desc = "Change SURROUNDING <>"
    },

    -- Delete
    {                                     -- ''
        mode = { "n" },
        "<Leader>''",
        "<Plug>(nvim-surround-delete)'",
        desc = "Delete SURROUNDING ''"
    },
    {                                     -- ""
        mode = { "n" },
        '<Leader>""',
        '<Plug>(nvim-surround-delete)"',
        desc = 'Delete SURROUNDING ""'
    },
    {                                     -- ``
        mode = { "n" },
        "<Leader>``",
        "<Plug>(nvim-surround-delete)`",
        desc = "Delete SURROUNDING ``"
    },
    {                                     -- {}
        mode = { "n" },
        "<Leader>{{",
        "<Plug>(nvim-surround-delete){",
        desc = "Delete SURROUNDING {}"
    },
    {                                     -- ()
        mode = { "n" },
        "<Leader>((",
        "<Plug>(nvim-surround-delete)(",
        desc = "Delete SURROUNDING ()"
    },
    {                                     -- []
        mode = { "n" },
        "<Leader>[[",
        "<Plug>(nvim-surround-delete)[",
        desc = "Delete SURROUNDING []"
    },
    {                                     -- <>
        mode = { "n" },
        "<Leader><<",
        "<Plug>(nvim-surround-delete)<",
        desc = "Delete SURROUNDING <>"
    },

    -- Add (visual mode)
    {                                     -- ''
        mode = { "v" },
        "'",
        "<Plug>(nvim-surround-visual)'",
        desc = "Add SURROUNDING ''"
    },
    {                                     -- ""
        mode = { "v" },
        '"',
        '<Plug>(nvim-surround-visual)"',
        desc = 'Add SURROUNDING ""'
    },
    {                                     -- ``
        mode = { "v" },
        "`",
        "<Plug>(nvim-surround-visual)`",
        desc = "Add SURROUNDING ``"
    },
    {                                     -- {}
        mode = { "v" },
        "{",
        "<Plug>(nvim-surround-visual){",
        desc = "Add SURROUNDING {}"
    },
    {                                     -- ()
        mode = { "v" },
        "(",
        "<Plug>(nvim-surround-visual)(",
        desc = "Add SURROUNDING ()"
    },
    {                                     -- []
        mode = { "v" },
        "[",
        "<Plug>(nvim-surround-visual)[",
        desc = "Add SURROUNDING []"
    },
    {                                     -- <>
        mode = { "v" },
        "<",
        "<Plug>(nvim-surround-visual)<",
        desc = "Add SURROUNDING <>"
    }
}

-- TRAILBLAZER
--------------------------------------------------------------------------------
M.trailblazer = {
    "<Leader>b",
    "<A-b>",
    "b",
    "B",
}

return M
