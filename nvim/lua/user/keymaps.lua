--   _
--  | | _____ _   _ _ __ ___   __ _ _ __  ___
--  | |/ / _ \ | | | '_ ` _ \ / _` | '_ \/ __|
--  |   <  __/ |_| | | | | | | (_| | |_) \__ \
--  |_|\_\___|\__, |_| |_| |_|\__,_| .__/|___/
-- ===========|___/================|_|==========================================

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
-- JUMP TO START / END OF WORD / LINE
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
-- DUPLICATE LINE / SELECTION
-- OPEN / JOIN LINES
-- `f` and `/` SEARCH
-- INCREMENT / DECREMENT NUMS SEQUENTIALLY
-- QUICKFIX
-- WINDOW
-- SAVE CHANGES
-- QUIT

-- NOTE: If a module bound to a key needs an argument, it must be wrapped
-- in a function. Neovim’s keymaps don’t support calling functions with
-- predefined arguments directly. Functions without arguments passed in
-- don't require wrapping though.

local util = require("util.utils")
local win = require("util.window")
local km = require("util.keymap_funcs")
local nmap = function (...) util.map("n", ...) end
local vmap = function (...) util.map("v", ...) end
local imap = function (...) util.map("i", ...) end
local cmap = function (...) util.map("c", ...) end
local nvmap = function (...) util.map({ "n", "v" }, ...) end
local nimap = function (...) util.map({ "n", "i" }, ...) end
local nvomap = function (...) util.map({ "n", "v", "o" }, ...) end


-- LEADER
--------------------------------------------------------------------------------
-- Must map leader before plugins are required or wrong leader will be used
vim.g.mapleader      = " "
vim.g.maplocalleader = " "
nvmap("<Space>",       "<Nop>")


-- INSERT MODE
--------------------------------------------------------------------------------
nmap("<Esc>",          "i")                      -- Insert mode
nvmap("<S-Esc>",       "I")                      -- Insert mode at line start


-- VISUAL MODE
--------------------------------------------------------------------------------
nvmap("s",             "v")                      -- Visual mode
nvmap("S",             "V")                      -- Visual LINE mode
nvmap("B",             "<C-v>")                  -- Visual BLOCK mode
nvmap("G",             "msgv")                   -- Restore visual selection
vmap("a",              "o")                      -- Swap point & mark
vmap("A",              km.swap_point_and_mark)   -- Swap point & mark


-- COMMAND LINE MODE
--------------------------------------------------------------------------------
cmap("<C-BS>",         "<C-u>")                  -- Clear cmd prompt
cmap("<A-BS>",         "<C-w>")                  -- Delete WORD left
cmap("<A-Del>",        "<S-Right><C-w>")         -- Delete WORD right
cmap("<A-Left>",       "<S-Left>")               -- Jump over left WORD
cmap("<A-Right>",      "<S-Right>")              -- Jump over right WORD
cmap("<S-Up>",         "<Up>")                   -- Scroll UP cmd history
cmap("<S-Down>",       "<Down>")                 -- Scroll DOWN cmd history


-- ARROW NAVIGATION
--------------------------------------------------------------------------------
nvomap("t",            "h")                      -- Move cursor LEFT
nvomap("i",            km.cursor_up_cmd)         -- Move cursor UP
nvomap("k",            km.cursor_down_cmd)       -- Move cursor DOWN
imap("<Up>",           km.cursor_up_ins)         -- Move cursor UP
imap("<Down>",         km.cursor_down_ins)       -- Move cursor DOWN


-- MOVE LINES UP / DOWN
--------------------------------------------------------------------------------
nmap("I",              ":m .-2<CR>==")           -- Move line UP
nmap("K",              ":m .+1<CR>==")           -- Move line DOWN
vmap("I",              ":m '<-2<CR>gv=gv")       -- Move line UP
vmap("K",              ":m '>+1<CR>gv=gv")       -- Move line DOWN


-- INDENT / OUTDENT
--------------------------------------------------------------------------------
nmap("L",              ">>")                     -- Indent
nmap("T",              "<<")                     -- Outdent
vmap("L",              ">gv^")                   -- Indent
vmap("T",              "<gv^")                   -- Outdent


-- JUMP TO START / END OF WORD / LINE
--------------------------------------------------------------------------------
imap("<A-Left>",       km.forwards_word)         -- Jump backwards by word
imap("<A-Right>",      km.backwards_word)        -- Jump backwards by word
imap("<Home>",         km.line_start_ins)        -- Jump to line START
imap("<End>",          km.line_end_ins)          -- Jump to line END
nvmap(",",             km.line_start_cmd)        -- Jump to line START
nvmap(".",             km.line_end_cmd)          -- Jump to line END


-- JUMP 6 LINES / BETWEEN BLOCKS
--------------------------------------------------------------------------------
nvmap("e",             "6k")                     -- Jump 6 lines UP
nvmap("d",             "6j")                     -- Jump 6 lines DOWN
nvmap("E",             "mj{")                    -- Jump block UP
nvmap("D",             "mj}")                    -- Jump block DOWN


-- SCROLL PAGE UP / DOWN
--------------------------------------------------------------------------------
nvmap("<PageUp>",      "<C-u>zz")                -- Page UP
nvmap("<PageDown>",    "<C-d>zz")                -- Page DOWN
nvmap("<S-PageUp>",    "mjgg")                   -- Page TOP
nvmap("<S-PageDown>",  "mjG")                    -- Page BOTTOM


-- DELETE BINDINGS (all deletions are sent to the black hole register)
--------------------------------------------------------------------------------
-- Char
nmap("<BS>",           '"_X')                    -- Delete backwards
vmap("<BS>",           '"_x')                    -- Delete visual selection
nvmap("<Del>",         '"_x')                    -- Delete forwards

-- Word
nmap("<A-BS>",         '"_db')                   -- Delete word LEFT
nmap("<A-Del>",        '"_de')                   -- Delete word RIGHT
imap("<A-BS>",         km.del_word_left)         -- Delete word LEFT
imap("<A-Del>",        km.del_word_right)        -- Delete word RIGHT

-- Line
nmap("<S-Del>",        '"_dd')                   -- Delete whole line
nmap("<C-BS>",         '"_d^')                   -- Delete line LEFT
nmap("<C-Del>",        '"_d$')                   -- Delete line RIGHT
imap("<C-BS>",         km.del_line_left)         -- Delete line LEFT
imap("<C-Del>",        km.del_line_right)        -- Delete line RIGHT


-- DELETE MOTIONS
--------------------------------------------------------------------------------
vmap("w",              '"_x')                    -- Delete visual selection
nmap("ww",             'ggVG"_d')                -- Delete whole buffer

-- Word
nmap("w",              "<Nop>")
nmap("wt",             '"_diw')                  -- Delete in word
nmap("wo",             '"_de')                   -- Delete word RIGHT
nmap("wu",             '"_db')                   -- Delete word LEFT

-- Line
nmap("wl",             '"_dd')                   -- Delete whole line
nmap("w,",             '"_d^')                   -- Delete line LEFT
nmap("w.",             '"_d$')                   -- Delete line RIGHT

-- Paragraph
nmap("wp",             '"_dip')                  -- Delete in paragraph
nmap("wi",             '"_d{')                   -- Delete paragraph UP
nmap("wk",             '"_d}')                   -- Delete paragraph DOWN

-- To char
nmap("w;",             '"_dt')                   -- Delete forwards to char
nmap("wh",             '"_dT')                   -- Delete backwards to char


-- DOT OPERATOR / UNDO / REDO
--------------------------------------------------------------------------------
nmap("-",              ".")                      -- Dot operator
nmap("<A-y>",          "u")                      -- Undo
nmap("<A-S-y>",        "U")                      -- Redo
imap("<A-y>",          km.undo)                  -- Undo
imap("<A-S-y>",        km.redo)                  -- Redo


-- SWAP CASE
--------------------------------------------------------------------------------
nmap("_",              "~")                      -- Swap case
vmap("_",              "mmU`m")                  -- Uppercase visual selection
vmap("-",              "mmu`m")                  -- Lowercase visual selection


-- SELECT IN / AROUND
--------------------------------------------------------------------------------
nmap("W",              "viw")                    -- Select in word

-- In surrounding
nmap("'",              "msvi'")                  -- Select inside ''
nmap('"',              'msvi"')                  -- Select inside ""
nmap("`",              "msvi`")                  -- Select inside ``
nmap("{",              "msvi{")                  -- Select inside {}
nmap("(",              "msvi(")                  -- Select inside ()
nmap("[",              "msvi[")                  -- Select inside []
nmap("<",              "msvi<")                  -- Select inside <>

-- Around brackets
nmap("}",              "msva{V")                 -- Select around {} block
nmap(")",              "msva(V")                 -- Select around () block
nmap("]",              "msva[V")                 -- Select around [] block
nmap(">",              "msva<V")                 -- Select around <> block


-- COPY
--------------------------------------------------------------------------------
-- System register '*' entries are added to the alphabetical register stack.
-- Secondary register '+' entries are added to the numeric register stack.

vmap("c",              'mm"*y`m')                -- Copy to system register
vmap("<Leader>c",      '"+y')                    -- Copy to register stack
nmap("cc",             'mmVggoG"*y`m')           -- Copy whole buffer


-- Word
nmap("c",              "<Nop>")
nmap("ct",             'mm"*yiw`m')              -- Copy in word
nmap("cu",             'mm"*yb`m')               -- Copy word LEFT
nmap("co",             '"*ye')                   -- Copy word RIGHT

-- Line
nmap("cl",             '"*yy')                   -- Copy whole line
nmap("c,",             'mm"*y^`m')               -- Copy to line START
nmap("c.",             '"*y$')                   -- Copy to line END

-- Paragraph
nmap("cp",             'mm"*yip`m')              -- Copy in paragraph
nmap("ci",             'mm"*y{`m')               -- Copy paragraph UP
nmap("ck",             '"*y}')                   -- Copy paragraph DOWN

-- To char
nmap("c;",             '"*yt')                   -- Copy forwards to char
nmap("ch",             '"*yT')                   -- Copy backwards to char


-- CUT
--------------------------------------------------------------------------------
-- All `d` motions that span than one line (the deleted text is not confined to
-- a single line) are sent to the numeric register stack by default. We
-- circumvent this by instead yanking to the system register then restoring the
-- previous visual selection and deleting it to the black hole register.

vmap("x",              '"*ygv"_d')               -- Cut to system register
vmap("<Leader>x",      '"+ygv"_d')               -- Cut to register stack
nmap("xx",             'ggVG"*ygv"_d')           -- Cut whole buffer

-- Word
nmap("x",              "<Nop>")
nmap("xt",             '"*diw')                  -- Cut in word
nmap("xu",             '"*db')                   -- Cut word LEFT
nmap("xo",             '"*de')                   -- Cut word RIGHT

-- Line
nmap("xl",             'V"*ygv"_d')              -- Cut whole line
nmap("x,",             '"*d^')                   -- Cut to line START
nmap("x.",             '"*d$')                   -- Cut to line END

-- Paragraph
nmap("xp",             'vip"*ygv"_d')            -- Cut in paragraph
nmap("xi",             'v{"*ygv"_d')             -- Cut paragraph UP
nmap("xk",             'v}"*ygv"_d')             -- Cut paragraph DOWN

-- To char
nmap("x;",             '"*dt')                   -- Cut forwards to char
nmap("xh",             '"*dT')                   -- Cut backwards to char


-- CHANGE (all changed text is sent to the black hole register)
--------------------------------------------------------------------------------
vmap("y",              '"_c')                    -- Change visual selection
nmap("yy",             'ggVG"_C')                -- Change whole buffer

-- Word
nmap("y",              "<Nop>")
nmap("yt",             '"_ciw')                  -- Change in word
nmap("yu",             '"_cb')                   -- Change word LEFT
nmap("yo",             '"_ce')                   -- Change word RIGHT

-- Line
nmap("yl",             '^"_C')                   -- Change whole line
nmap("y,",             '"_d^i')                  -- Change to line START
nmap("y.",             '"_C')                    -- Change to line END

-- Paragraph
nmap("yp",             '"_cip')                  -- Change in paragraph
nmap("yi",             '"_c{')                   -- Change paragraph UP
nmap("yk",             '"_c}')                   -- Change paragraph DOWN

-- To char
nmap("y;",             '"_ct')                   -- Change forwards to char
nmap("yh",             '"_cT')                   -- Change backwards to char


-- PASTE
--------------------------------------------------------------------------------
nmap("v",              '"*]P')                   -- Paste from system register
vmap("v",              '"_d"*P')                 -- Paste over selection
cmap("<A-v>",          "<C-r>*")                 -- Paste from system register
imap("<A-v>",          km.paste)                 -- Paste from system register


-- DUPLICATE LINE / SELECTION
--------------------------------------------------------------------------------
nmap("<Leader>d",      "VyPj")                   -- Duplicate line below
vmap("<Leader>d",      "<C-v>VyPgv")             -- Duplicate selection below


-- OPEN / JOIN LINES
--------------------------------------------------------------------------------
-- `<C-o>` in insert mode sends a single normal
-- mode cmd then returns back to insert
nmap("<CR>",           "o<C-o>mo<Esc>`o")        -- New line BELOW
nmap("<S-CR>",         "O<C-o>mo<Esc>`o")        -- New line ABOVE
nvmap("j",             "J")                      -- Join lines


-- `f` and `/` SEARCH
--------------------------------------------------------------------------------
nvmap("h",             ",")                      -- Prev f search result
nvmap("Y",             "mnN")                    -- Prev / search result
nvmap("V",             "mnn")                    -- Next / search result
nmap("?",              km.toggle_search_hl)      -- Toggle search highlights
nmap("F",              "mn*")                    -- Search for inner word
vmap("F",              km.search_for_selection)  -- Search for selected area
vmap("/",              "<Esc>/\\%V", {           -- Search within selection
    silent = false
})


-- INCREMENT / DECREMENT NUMS SEQUENTIALLY
--------------------------------------------------------------------------------
vmap("=+",             "g<C-a>gv")               -- Increment num sequentially
vmap("=-",             "g<C-x>gv")               -- Decrement num sequentially


-- QUICKFIX
--------------------------------------------------------------------------------
nmap("<A-x>",          km.toggle_quickfix_win)   -- Toggle quickfix list
nmap("<A-c>",          km.add_line_to_quickfix)  -- Update quickfix list


-- WINDOW
--------------------------------------------------------------------------------
-- Navigate
nmap("<Up>", function()                          -- Focus split ABOVE
    win.navigate_vertically("k")
end)
nmap("<Down>", function()                        -- Focus split BELOW
    win.navigate_vertically("j")
end)
nmap("<Left>", function()                        -- Focus split LEFT
    win.navigate_horizontally("h")
end)
nmap("<Right>", function()                       -- Focus split RIGHT
    win.navigate_horizontally("l")
end)

-- Resize
nmap("<S-Up>", function()                        -- Resize window UP
    win.relative_resize("up")
end)
nmap("<S-Down>", function()                      -- Resize window DOWN
    win.relative_resize("down")
end)
nmap("<S-Left>", function()                      -- Resize window LEFT
    win.relative_resize("left")
end)
nmap("<S-Right>", function()                     -- Resize window RIGHT
    win.relative_resize("right")
end)

-- Cmds
nmap("<Leader>w",      win.close_window)         -- Close window
nmap("<A-m>",          "<cmd>vsplit<CR>")        -- Split window VERTICALLY
nmap("<A-n>",          "<cmd>split<CR>")         -- Split window HORIZONTALLY
nmap("<Home>",         "zhzhzh")                 -- Scroll window LEFT
nmap("<End>",          "zlzlzl")                 -- Scroll window RIGHT
nmap("<D-[>",          "<C-w>r")                 -- Swap splits (2 splits max)


-- SAVE CHANGES
--------------------------------------------------------------------------------
nimap("<A-s>",         km.save_changes)          -- Save changes


-- QUIT (never quit)
--------------------------------------------------------------------------------
nvmap("<Leader>QQ",    "<cmd>qa!<CR>")           -- Force quit nvim
nmap("<A-q>",          km.quit_session)          -- Quit and save session
