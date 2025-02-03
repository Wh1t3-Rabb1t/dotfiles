--   _
--  | | _____ _   _ _ __ ___   __ _ _ __  ___
--  | |/ / _ \ | | | '_ ` _ \ / _` | '_ \/ __|
--  |   <  __/ |_| | | | | | | (_| | |_) \__ \
--  |_|\_\___|\__, |_| |_| |_|\__,_| .__/|___/
-- ===========|___/================|_|==========================================

-- https://gist.github.com/Starefossen/5957088
-- https://learnvimscriptthehardway.stevelosh.com/

-- ╭───────╮
-- │ INDEX │
-- ╰───────╯
-- INSERT MODE
-- VISUAL MODE
-- COMMAND LINE MODE
-- ARROW NAVIGATION
-- MOVE LINES UP / DOWN
-- INDENT / OUTDENT
-- JUMP BACKWARDS / FORWARDS BY WORD / LINE
-- JUMP 6 LINES / BETWEEN BLOCKS
-- SCROLL PAGE UP / DOWN
-- DELETE BINDINGS
-- DELETE MOTIONS
-- DOT OPERATOR / UNDO / REDO
-- SWAP CASE
-- SELECT IN / AROUND
-- COPY
-- CUT
-- CHANGE
-- PASTE
-- OPEN / JOIN LINES
-- NAVIGATE `/` and `f` SEARCH RESULTS
-- INCREMENT / DECREMENT NUMBERS SEQUENTIALLY
-- QUICKFIX
-- WINDOW
-- SAVE CHANGES
-- QUIT

local util = require("util.utils")
local win = require("util.window")
local km = require("util.keymap_utils")
local nmap = function (...) util.map("n", ...) end
local vmap = function (...) util.map("v", ...) end
local imap = function (...) util.map("i", ...) end
local cmap = function (...) util.map("c", ...) end
local nvmap = function (...) util.map({ "n", "v" }, ...) end
local nimap = function (...) util.map({ "n", "i" }, ...) end
local nvomap = function (...) util.map({ "n", "v", "o" }, ...) end

-- NOTE: If a module bound to a key needs an argument, it must be wrapped
-- in a function. Neovim’s keymaps don’t support calling functions with
-- predefined arguments directly.


-- LEADER
--------------------------------------------------------------------------------
-- Must map leader before plugins are required or wrong leader will be used
vim.g.mapleader = " "
vim.g.maplocalleader = " "
nvmap("<Space>", "<Nop>")


-- UNMAPPED
--------------------------------------------------------------------------------
nvmap("Q", "<Nop>")
nvmap("g", "<Nop>")
nmap("w",  "<Nop>")
nmap("c",  "<Nop>")
nmap("y",  "<Nop>")
nmap("x",  "<Nop>")


-- INSERT MODE
--------------------------------------------------------------------------------
nmap("<Esc>",    "i")                             -- Insert mode
nvmap("<S-Esc>", "I")                             -- Insert mode at line start


-- VISUAL MODE
--------------------------------------------------------------------------------
nvmap("s",         "v")                           -- Visual mode
nvmap("S",         "V")                           -- Visual LINE mode
nvmap("B",         "<C-v>")                       -- Visual BLOCK mode
nvmap("G",         "msgv")                        -- Restore visual selection
vmap("a",          "o")                           -- Swap point & mark
vmap("A",          km.swap_point_and_mark)        -- Swap point & mark


-- COMMAND LINE MODE
--------------------------------------------------------------------------------
cmap("<C-BS>",    "<C-u>")                        -- Clear cmd prompt
cmap("<A-BS>",    "<C-w>")                        -- Delete WORD left
cmap("<A-Del>",   "<S-Right><C-w>")               -- Delete WORD right
cmap("<A-Left>",  "<S-Left>")                     -- Jump over left WORD
cmap("<A-Right>", "<S-Right>")                    -- Jump over right WORD
cmap("<S-Up>",    "<Up>")                         -- Scroll UP cmd history
cmap("<S-Down>",  "<Down>")                       -- Scroll DOWN cmd history


-- ARROW NAVIGATION
--------------------------------------------------------------------------------
nvomap("t", "h")                                  -- Move cursor LEFT
nvomap("i", "v:count == 0 ? 'gk' : 'k'", {        -- Move cursor UP
    expr = true
})
nvomap("k", "v:count == 0 ? 'gj' : 'j'", {        -- Move cursor DOWN
    expr = true
})
imap("<Up>",   km.cursor_up)                      -- Move cursor UP
imap("<Down>", km.cursor_down)                    -- Move cursor DOWN


-- MOVE LINES UP / DOWN
--------------------------------------------------------------------------------
nmap("I", ":m .-2<CR>==")                         -- Move line UP
nmap("K", ":m .+1<CR>==")                         -- Move line DOWN
vmap("I", ":m '<-2<CR>gv=gv")                     -- Move line UP
vmap("K", ":m '>+1<CR>gv=gv")                     -- Move line DOWN


-- INDENT / OUTDENT
--------------------------------------------------------------------------------
nmap("L", ">>")                                   -- Indent
nmap("T", "<<")                                   -- Outdent
vmap("L", ">gv^")                                 -- Indent
vmap("T", "<gv^")                                 -- Outdent


-- JUMP BACKWARDS / FORWARDS BY WORD / LINE
--------------------------------------------------------------------------------
imap("<A-Left>",  km.forwards_word)               -- Jump backwards by word
imap("<A-Right>", km.backwards_word)              -- Jump backwards by word

-- Use expression to deal with line wrap
nvmap(",", "v:count == 0 ? 'g^' : '^'",  {        -- Jump to line START
    expr = true
})
nvmap(".", "v:count == 0 ? 'g$h' : '$'", {        -- Jump to line END
    expr = true
})
imap("<Home>", km.line_start)                     -- Jump to line START
imap("<End>",  km.line_end)                       -- Jump to line END


-- JUMP 6 LINES / BETWEEN BLOCKS
--------------------------------------------------------------------------------
nvmap("e",  "6k")                                 -- Jump 6 lines UP
nvmap("d",  "6j")                                 -- Jump 6 lines DOWN
nvmap("E", "mj{")                                 -- Jump block UP
nvmap("D", "mj}")                                 -- Jump block DOWN


-- SCROLL PAGE UP / DOWN
--------------------------------------------------------------------------------
nvmap("<PageUp>",     "<C-u>zz")                  -- Page UP
nvmap("<PageDown>",   "<C-d>zz")                  -- Page DOWN
nvmap("<S-PageUp>",   "mjgg")                     -- Page TOP
nvmap("<S-PageDown>", "mjG")                      -- Page BOTTOM


-- DELETE BINDINGS (all deletions are sent to the black hole register)
--------------------------------------------------------------------------------
-- Char
nmap("<BS>",         '"_X')                       -- Delete backwards
vmap("<BS>",         '"_x')                       -- Delete visual selection
nvmap("<Del>",       '"_x')                       -- Delete forwards

-- Word
nmap("<A-BS>",       '"_db')                      -- Delete word LEFT
nmap("<A-Del>",      '"_de')                      -- Delete word RIGHT
imap("<A-BS>", function()                         -- Delete word LEFT
    vim.cmd([[ :execute 'normal! "_db']])
end)
imap("<A-Del>", function()                        -- Delete word RIGHT
    vim.cmd([[ :execute 'normal! "_de']])
end)

-- Line
nmap("<S-Del>",      '"_dd')                      -- Delete whole line
nmap("<C-BS>",       '"_d^')                      -- Delete line LEFT
nmap("<C-Del>",      '"_d$')                      -- Delete line RIGHT
imap("<C-BS>", function()                         -- Delete line LEFT
    vim.cmd([[ :execute 'normal! "_d^' ]])
end)
imap("<C-Del>", function()                        -- Delete line RIGHT
    vim.cmd([[ :execute 'normal! "_d$' ]])
end)


-- DELETE MOTIONS
--------------------------------------------------------------------------------
vmap("w",  '"_x')                                 -- Delete visual selection

-- Word
nmap("wt", '"_diw')                               -- Delete in word
nmap("wo", '"_de')                                -- Delete word RIGHT
nmap("wu", '"_db')                                -- Delete word LEFT

-- Line
nmap("wl", '"_dd')                                -- Delete whole line
nmap("w,", '"_d^')                                -- Delete line LEFT
nmap("w.", '"_d$')                                -- Delete line RIGHT

-- Paragraph
nmap("wi", '"_d{')                                -- Delete paragraph UP
nmap("wk", '"_d}')                                -- Delete paragraph DOWN
nmap("wp", '"_dip')                               -- Delete in paragraph

-- To char
nmap("w;", '"_dt')                                -- Delete forwards to char
nmap("wh", '"_dT')                                -- Delete backwards to char


-- DOT OPERATOR / UNDO / REDO
--------------------------------------------------------------------------------
nmap("-",       ".")                              -- Dot operator
nmap("<A-y>",   "u")                              -- Undo
nmap("<A-S-y>", "U")                              -- Redo
imap("<A-y>", function()                          -- Undo
    vim.cmd([[ :execute "normal! u" ]])
end)
imap("<A-S-y>", function()                        -- Redo
    vim.cmd([[ :execute "normal! U" ]])
end)


-- SWAP CASE
--------------------------------------------------------------------------------
nmap("_", "~")                                    -- Swap case
vmap("_", "mmU`m")                                -- Uppercase visual selection
vmap("-", "mmu`m")                                -- Lowercase visual selection


-- SELECT IN / AROUND
--------------------------------------------------------------------------------
nmap("W", "viw")                                  -- Select in word

-- In surrounding
nmap("'", "msvi'")                                -- Select inside ''
nmap('"', 'msvi"')                                -- Select inside ""
nmap("`", "msvi`")                                -- Select inside ``
nmap("{", "msvi{")                                -- Select inside {}
nmap("(", "msvi(")                                -- Select inside ()
nmap("[", "msvi[")                                -- Select inside []
nmap("<", "msvi<")                                -- Select inside <>

-- Around bracketed code blocks
nmap("}", "msva{V")                               -- Select around {} block
nmap(")", "msva(V")                               -- Select around () block
nmap("]", "msva[V")                               -- Select around [] block
nmap(">", "msva<V")                               -- Select around <> block


-- COPY
--------------------------------------------------------------------------------
-- To selected registers
vmap("c", 'mm"*y`m')                              -- Copy to system register
vmap("<Leader>c", function()                      -- Copy to register stack
    util.shift_up_register_stack()
    vim.cmd([[ :execute 'normal! mm"ay`m' ]])
end)

-- Word
nmap("ct", 'mm"*yiw`m')                           -- Copy in word
nmap("cu", 'mm"*yb`m')                            -- Copy word LEFT
nmap("co", '"*ye')                                -- Copy word RIGHT

-- Line
nmap("cl", '"*yy')                                -- Copy whole line
nmap("c,", 'mm"*y^`m')                            -- Copy to line START
nmap("c.", '"*y$')                                -- Copy to line END

-- Paragraph
nmap("ci", 'mm"*y{`m')                            -- Copy paragraph UP
nmap("ck", '"*y}')                                -- Copy paragraph DOWN
nmap("cp", 'mm"*yip`m')                           -- Copy in paragraph

-- To char
nmap("c;", '"*yt')                                -- Copy forwards to char
nmap("ch", '"*yT')                                -- Copy backwards to char


-- CUT
--------------------------------------------------------------------------------
-- To selected registers
vmap("x", '"*d')                                  -- Cut to system register
vmap("<Leader>x", function()
    util.shift_up_register_stack()                -- Cut register stack
    vim.cmd([[ :execute 'normal! "ad' ]])
end)

-- Word
nmap("xt", '"*diw')                               -- Cut in word
nmap("xu", '"*db')                                -- Cut word LEFT
nmap("xo", '"*de')                                -- Cut word RIGHT

-- Line
nmap("xl", '"*dd')                                -- Cut whole line
nmap("x,", '"*d^')                                -- Cut to line START
nmap("x.", '"*d$')                                -- Cut to line END

-- Paragraph
nmap("xi", '"*d{')                                -- Cut paragraph UP
nmap("xk", '"*d}')                                -- Cut paragraph DOWN
nmap("xp", '"*dip')                               -- Cut in paragraph

-- To char
nmap("x;", '"*dt')                                -- Cut forwards to char
nmap("xh", '"*dT')                                -- Cut backwards to char


-- CHANGE (all changed text is sent to the black hole register)
--------------------------------------------------------------------------------
vmap("y",  '"_c')                                 -- Change visual selection

-- Word
nmap("yt", '"_ciw')                               -- Change in word
nmap("yu", '"_cb')                                -- Change word LEFT
nmap("yo", '"_ce')                                -- Change word RIGHT

-- Line
nmap("yl", '^"_C')                                -- Change whole line
nmap("y,", '"_d^i')                               -- Change to line START
nmap("y.", '"_C')                                 -- Change to line END

-- Paragraph
nmap("yi", '"_c{')                                -- Change paragraph UP
nmap("yk", '"_c}')                                -- Change paragraph DOWN
nmap("yp", '"_cip')                               -- Change in paragraph

-- To char
nmap("y;", '"_ct')                                -- Change forwards to char
nmap("yh", '"_cT')                                -- Change backwards to char


-- PASTE
--------------------------------------------------------------------------------
nmap("v",     '"*]P')                             -- Paste from system register
vmap("v",     '"_d"*P')                           -- Paste over selection
cmap("<A-v>", "<C-r>*")                           -- Paste from system register
imap("<A-v>", function()                          -- Paste from system register
    -- Make paste respect indentation in insert
    vim.cmd([[ :execute 'normal! "*]Pl' ]])
end)


-- OPEN / JOIN LINES
--------------------------------------------------------------------------------
-- `<C-o>` in insert mode sends a single normal
-- mode cmd then returns back to insert
nmap("<CR>",   "o<C-o>mo<Esc>`o")                 -- New line BELOW
nmap("<S-CR>", "O<C-o>mo<Esc>`o")                 -- New line ABOVE
nvmap("j",     "J")                               -- Join lines


-- NAVIGATE `/` and `f` SEARCH RESULTS
--------------------------------------------------------------------------------
nmap("?", function()                              -- Toggle search highlights
    if vim.v.hlsearch == 1 then
        vim.cmd("nohlsearch")
    else
        vim.cmd("set hls")
    end
end)
vmap("/",  "<Esc>/\\%V", {                        -- Search within selection
    silent = false
})
nvmap("h", ",")                                   -- Prev f search result
nvmap("Y",  "mnN")                                -- Prev / search result
nvmap("V",  "mnn")                                -- Next / search result
nmap("F",   "mn*")                                -- Search for inner word
vmap("F", function()                              -- Search for selected area
    vim.cmd('normal! "9y')
    local selection = vim.fn.getreg('9')
    local escaped_selection = vim.fn.escape(selection, "\\/.*$^~[]")

    -- Replace newlines with literal "\n" so multi-line searches work
    escaped_selection = escaped_selection:gsub("\n", "\\n")

    -- Build the search command and feed it as keypresses
    local search_cmd = "/" .. escaped_selection .. "\n"
    local keys = vim.api.nvim_replace_termcodes(search_cmd, true, false, true)
    vim.api.nvim_feedkeys(keys, 'n', false)
    vim.fn.setreg('9', '')
end)


-- INCREMENT / DECREMENT NUMBERS SEQUENTIALLY
--------------------------------------------------------------------------------
vmap("=+", "g<C-a>gv")                            -- Increment num sequentially
vmap("=-", "g<C-x>gv")                            -- Decrement num sequentially


-- QUICKFIX
--------------------------------------------------------------------------------
nmap("<A-p>", function()                          -- Toggle quickfix list
    if vim.bo.filetype == "qf" then
        vim.cmd("bo cclose")
    else
        vim.cmd("bo copen")
    end
end)


-- WINDOW
--------------------------------------------------------------------------------
-- Navigate
nmap("<Up>", function()                           -- Focus split ABOVE
    win.navigate_vertically("k")
end)
nmap("<Down>", function()                         -- Focus split BELOW
    win.navigate_vertically("j")
end)
nmap("<Left>", function()                         -- Focus split LEFT
    win.navigate_horizontally("h")
end)
nmap("<Right>", function()                        -- Focus split RIGHT
    win.navigate_horizontally("l")
end)

-- Resize
nmap("<S-Up>", function()                         -- Resize window UP
    win.relative_resize("up")
end)
nmap("<S-Down>", function()                       -- Resize window DOWN
    win.relative_resize("down")
end)
nmap("<S-Left>", function()                       -- Resize window LEFT
    win.relative_resize("left")
end)
nmap("<S-Right>", function()                      -- Resize window RIGHT
    win.relative_resize("right")
end)

-- Cmds
nmap("<Leader>w", function()                      -- Close window
    if vim.bo.filetype == "checkhealth" then
        vim.api.nvim_buf_delete(
            vim.api.nvim_get_current_buf(), {
                force = true
            }
        )
    end

    -- Don't quit if only one window is open
    if win.open_win_count() ~= 1 then
        vim.cmd("q")
    end
end)
nmap("<A-m>",       "<cmd>vsplit<CR>")            -- Split window VERTICALLY
nmap("<A-n>",       "<cmd>split<CR>")             -- Split window HORIZONTALLY
nmap("<Home>",      "zhzhzh")                     -- Scroll window LEFT
nmap("<End>",       "zlzlzl")                     -- Scroll window RIGHT
nmap("<D-[>",       "<C-w>r")                     -- Swap splits (2 splits max)


-- SAVE CHANGES
--------------------------------------------------------------------------------
nimap("<A-s>", function()                         -- Save changes
    local current_ft = vim.o.filetype
    local excluded_ft = {
        "diff",
        "lazy",
        "mason",
        "neo-tree",
        "aerial",
    }

    -- Don't save when certain filetypes are focused
    if vim.tbl_contains(excluded_ft, current_ft) or vim.o.binary then
        return
    end

    vim.cmd("w")

    -- Return to normal mode if in insert mode
    if vim.fn.mode() == "i" then
        vim.api.nvim_feedkeys(vim.keycode("<Esc>"), "n", true)
    end
end)


-- QUIT (never quit)
--------------------------------------------------------------------------------
nvmap("<Leader>QQ", "<cmd>qa!<CR>")               -- Force quit nvim
nmap("<A-q>", function()                          -- Quit and save session

    -- Save session if launched via session file
    if vim.tbl_contains(vim.v.argv, "-S") then
        vim.cmd("Mksession!")
    end

    vim.cmd("qa")
end)
