--   _
--  | | _____ _   _ _ __ ___   __ _ _ __  ___
--  | |/ / _ \ | | | '_ ` _ \ / _` | '_ \/ __|
--  |   <  __/ |_| | | | | | | (_| | |_) \__ \
--  |_|\_\___|\__, |_| |_| |_|\__,_| .__/|___/
-- ===========|___/================|_|==========================================

-- https://learnvimscriptthehardway.stevelosh.com/
-- https://github.com/ibhagwan/vim-cheatsheet

-- ╭───────╮
-- │ INDEX │
-- ╰───────╯
-- LEADER                              _00
-- INSERT MODE                         _01
-- VISUAL MODE                         _02
-- COMMAND LINE MODE                   _03
-- ARROW NAVIGATION                    _04
-- COMMENTS                            _05
-- MOVE LINES UP / DOWN                _06
-- INDENT / OUTDENT                    _07
-- JUMP TO START / END OF WORD / LINE  _08
-- JUMP 6 LINES / BETWEEN BLOCKS       _09
-- SCROLL PAGE UP / DOWN               _10
-- DELETE BINDINGS                     _11
-- DELETE MOTIONS                      _12
-- DOT OPERATOR / UNDO / REDO          _13
-- SWAP CASE                           _14
-- SELECT IN / AROUND                  _15
-- COPY                                _16
-- CUT                                 _17
-- CHANGE                              _18
-- PASTE                               _19
-- DUPLICATE LINE / SELECTION          _20
-- OPEN / JOIN LINES                   _21
-- `f` and `/` SEARCH                  _22
-- QUICKFIX                            _23
-- WINDOW                              _24
-- SAVE CHANGES                        _25
-- QUIT                                _26

-- Note: If a module bound to a key needs an argument, it must be wrapped
-- in a function. Neovim’s keymaps don’t support calling functions with
-- predefined arguments directly. Functions without arguments passed in
-- don't require wrapping though.

local map = require("util.utils").map
local win = require("util.window")
local km = require("util.keymap_funcs")

local nmap = function(...) map("n", ...) end
local vmap = function(...) map("x", ...) end
local imap = function(...) map("i", ...) end
local cmap = function(...) map("c", ...) end
local nvmap = function(...) map({ "n", "v" }, ...) end
local nxmap = function(...) map({ "n", "v", "x" }, ...) end
local nimap = function(...) map({ "n", "i" }, ...) end
local nvomap = function(...) map({ "n", "v", "o" }, ...) end

-- Remove most default keymaps
--
-- Note: This breaks `gcc` and `gc` bindings so comment functionality must
-- be recreated with custom functions. See: 'lua/util/keymap_funcs.lua'.
vim.cmd('mapclear')


-- LEADER (must be set before plugin init or wrong leader will be used)      _00
--------------------------------------------------------------------------------
vim.g.mapleader      = " "
vim.g.maplocalleader = " "
nvmap("<Space>",       "<Nop>")

-- Cmds
nmap("<Leader>;w", km.toggle_wrap,      { desc = ' Toggle line wrap' })
nmap("<Leader>;c", km.toggle_column_hl, { desc = ' Toggle cursor column hl' })
nmap("<Leader>;s", km.set_column_hl,    { desc = ' Set highlight at 80th column' })
nmap("<Leader>;u", km.rm_column_hl,     { desc = ' Unset highlight at 80th column' })
nmap("<Leader>;v", km.v_split_layout,   { desc = ' Set splits layout to vertical' })
nmap("<Leader>;h", km.h_split_layout,   { desc = ' Set splits layout to horizontal' })
nmap("<Leader>;l", km.open_lazy,        { desc = ' Lazy ui' })
nmap("<Leader>;m", km.open_mason,       { desc = ' Mason ui' })

-- Folds
vmap("<Leader>;f", "zf",                { desc = ' Fold selection' })
nmap("<Leader>;t", "za",                { desc = ' Toggle fold under cursor' })
nmap("<Leader>;a", "zR",                { desc = ' Open all folds' })
nmap("<Leader>;_", "zM",                { desc = ' Close all folds' })
nmap("<Leader>;d", "zD",                { desc = ' Delete fold under cursor' })

-- Inc/dec nums
vmap("<Leader>C", "g<C-a>gv",           { desc = ' Increment numbers sequentially' })
vmap("<Leader>X", "g<C-x>gv",           { desc = ' Decrement numbers sequentially' })


-- INSERT MODE                                                               _01
--------------------------------------------------------------------------------
nmap("<Esc>",    "i", { desc = ' Insert mode' })
nvmap("<S-Esc>", "I", { desc = ' Insert mode at line start' })


-- VISUAL MODE                                                               _02
--------------------------------------------------------------------------------
nvmap("s", "v",                    { desc = ' Visual mode' })
nxmap("S", "V",                    { desc = ' Visual line mode' })
nxmap("F", "<C-v>",                { desc = ' Visual block mode' })
nxmap("H", "msgv",                 { desc = ' Restore visual selection' })
vmap("a",  "o",                    { desc = ' Swap point & mark' })
vmap("A",  km.swap_point_and_mark, { desc = ' Swap point & mark' })


-- COMMAND LINE MODE                                                         _03
--------------------------------------------------------------------------------
cmap("<C-BS>",    "<C-u>",          { desc = ' Clear cmd prompt' })
cmap("<A-BS>",    "<C-w>",          { desc = ' Delete word left' })
cmap("<A-Del>",   "<S-Right><C-w>", { desc = ' Delete word right' })
cmap("<A-Left>",  "<S-Left>",       { desc = ' Jump over left word' })
cmap("<A-Right>", "<S-Right>",      { desc = ' Jump over right word' })
cmap("<S-Up>",    "<Up>",           { desc = ' Scroll up cmd history' })
cmap("<S-Down>",  "<Down>",         { desc = ' Scroll down cmd history' })


-- ARROW NAVIGATION                                                          _04
--------------------------------------------------------------------------------
nvomap("t",    "h",                { desc = ' Move cursor left' })
nvomap("i",    km.cursor_up_cmd,   { desc = ' Move cursor up' })
nvomap("k",    km.cursor_down_cmd, { desc = ' Move cursor down' })
imap("<Up>",   km.cursor_up_ins,   { desc = ' Move cursor up' })
imap("<Down>", km.cursor_down_ins, { desc = ' Move cursor down' })


-- COMMENTS                                                                  _05
--------------------------------------------------------------------------------
nmap("?", km.comment_line,   { desc = ' Comment line' })
vmap("?", km.comment_visual, { desc = ' Comment visual' })


-- MOVE LINES UP / DOWN                                                      _06
--------------------------------------------------------------------------------
nmap("I", ":m .-2<CR>==",     { desc = ' Move line up' })
nmap("K", ":m .+1<CR>==",     { desc = ' Move line down' })
vmap("I", ":m '<-2<CR>gv=gv", { desc = ' Move line up' })
vmap("K", ":m '>+1<CR>gv=gv", { desc = ' Move line down' })


-- INDENT / OUTDENT                                                          _07
--------------------------------------------------------------------------------
nmap("L", ">>",   { desc = ' Indent' })
nmap("T", "<<",   { desc = ' Outdent' })
vmap("L", ">gv^", { desc = ' Indent' })
vmap("T", "<gv^", { desc = ' Outdent' })


-- JUMP TO START / END OF WORD / LINE                                        _08
--------------------------------------------------------------------------------
imap("<A-Left>",  km.forwards_word,  { desc = ' Jump backwards by word' })
imap("<A-Right>", km.backwards_word, { desc = ' Jump backwards by word' })
imap("<Home>",    km.line_start_ins, { desc = ' Jump to line start' })
imap("<End>",     km.line_end_ins,   { desc = ' Jump to line end' })
nvmap(",",        km.line_start_cmd, { desc = ' Jump to line start' })
nvmap(".",        km.line_end_cmd,   { desc = ' Jump to line end' })


-- JUMP 6 LINES / BETWEEN BLOCKS                                             _09
--------------------------------------------------------------------------------
nvmap("e", "6k",  { desc = ' Jump 6 lines up' })
nvmap("d", "6j",  { desc = ' Jump 6 lines down' })
nvmap("E", "mj{", { desc = ' Jump block up' })
nvmap("D", "mj}", { desc = ' Jump block down' })


-- SCROLL PAGE UP / DOWN                                                     _10
--------------------------------------------------------------------------------
nvmap("<PageUp>",     "<C-u>zz", { desc = ' Page up' })
nvmap("<PageDown>",   "<C-d>zz", { desc = ' Page down' })
nvmap("<S-PageUp>",   "mjgg",    { desc = ' Page top' })
nvmap("<S-PageDown>", "mjG",     { desc = ' Page bottom' })


-- DELETE BINDINGS (all deletions are sent to the black hole register)       _11
--------------------------------------------------------------------------------
-- Char
nmap("<BS>",   '"_X',              { desc = ' Delete backwards' })
vmap("<BS>",   '"_x',              { desc = ' Delete visual selection' })
nvmap("<Del>", '"_x',              { desc = ' Delete forwards' })

-- Word
nmap("<A-BS>",  '"_db',            { desc = ' Delete word left' })
nmap("<A-Del>", '"_de',            { desc = ' Delete word right' })
imap("<A-BS>",  km.del_word_left,  { desc = ' Delete word left' })
imap("<A-Del>", km.del_word_right, { desc = ' Delete word right' })

-- Line
nmap("<S-Del>", '"_dd',            { desc = ' Delete whole line' })
nmap("<C-BS>",  '"_d^',            { desc = ' Delete to line start' })
nmap("<C-Del>", '"_d$',            { desc = ' Delete to line end' })
imap("<C-BS>",  km.del_line_left,  { desc = ' Delete to line start' })
imap("<C-Del>", km.del_line_right, { desc = ' Delete to line end' })


-- DELETE MOTIONS                                                            _12
--------------------------------------------------------------------------------
vmap("w",  '"_x',     { desc = ' Delete visual selection' })
nmap("ww", 'ggVG"_d', { desc = ' Delete whole buffer' })

-- Word
nmap("w",  "<Nop>")
nmap("wt", '"_diw',   { desc = ' Delete in word' })
nmap("wo", '"_de',    { desc = ' Delete word right' })
nmap("wu", '"_db',    { desc = ' Delete word left' })

-- Line
nmap("wl", '"_dd',    { desc = ' Delete whole line' })
nmap("w,", '"_d^',    { desc = ' Delete line left' })
nmap("w.", '"_d$',    { desc = ' Delete line right' })

-- Paragraph
nmap("wm", '"_dip',   { desc = ' Delete in paragraph' })
nmap("wi", '"_d{',    { desc = ' Delete paragraph up' })
nmap("wk", '"_d}',    { desc = ' Delete paragraph down' })

-- To char
nmap("w;", '"_dt',    { desc = ' Delete forwards to char' })
nmap("wh", '"_dT',    { desc = ' Delete backwards to char' })


-- DOT OPERATOR / UNDO / REDO                                                _13
--------------------------------------------------------------------------------
nmap("_",       ".",     { desc = ' Dot operator' })
nmap("<A-y>",   "u",     { desc = ' Undo' })
nmap("<A-S-y>", "U",     { desc = ' Redo' })
imap("<A-y>",   km.undo, { desc = ' Undo' })
imap("<A-S-y>", km.redo, { desc = ' Redo' })


-- SWAP CASE                                                                 _14
--------------------------------------------------------------------------------
nmap("-", "~",     { desc = ' Swap case' })
vmap("-", "mmu`m", { desc = ' Lowercase visual selection' })
vmap("_", "mmU`m", { desc = ' Uppercase visual selection' })


-- SELECT IN / AROUND                                                        _15
--------------------------------------------------------------------------------
nmap("m", "viw",    { desc = ' Select in word' })
vmap("m", "ip",     { desc = ' Select in paragraph' })

-- In surrounding
nmap("'", "msvi'",  { desc = " Select in ''" })
nmap('"', 'msvi"',  { desc = ' Select in ""' })
nmap("`", "msvi`",  { desc = ' Select in ``' })
nmap("{", "msvi{",  { desc = ' Select in {}' })
nmap("(", "msvi(",  { desc = ' Select in ()' })
nmap("[", "msvi[",  { desc = ' Select in []' })
nmap("<", "msvi<",  { desc = ' Select in <>' })

-- Around brackets (code blocks)
nmap("}", "msva{V", { desc = ' Select around {} block' })
nmap(")", "msva(V", { desc = ' Select around () block' })
nmap("]", "msva[V", { desc = ' Select around [] block' })
nmap(">", "msva<V", { desc = ' Select around <> block' })


-- COPY (all copied text is added to the alphabetical register stack)        _16
--------------------------------------------------------------------------------
vmap("c",     'mm"zy`m',      { desc = " Copy to 'z' register" })
vmap("<A-c>", '"*y',          { desc = ' Copy to system clipboard' })
nmap("cc",    'mmVggoG"zy`m', { desc = ' Copy whole buffer' })

-- Word
nmap("c",     "<Nop>")
nmap("ct",    'mm"zyiw`m',    { desc = ' Copy in word' })
nmap("cu",    'mm"zyb`m',     { desc = ' Copy word left' })
nmap("co",    '"zye',         { desc = ' Copy word right' })

-- Line
nmap("cl",    '"zyy',         { desc = ' Copy whole line' })
nmap("c,",    'mm"zy^`m',     { desc = ' Copy to line start' })
nmap("c.",    '"zy$',         { desc = ' Copy to line end' })

-- Paragraph
nmap("cm",    'mm"zyip`m',    { desc = ' Copy in paragraph' })
nmap("ci",    'mm"zy{`m',     { desc = ' Copy paragraph up' })
nmap("ck",    '"zy}',         { desc = ' Copy paragraph down' })

-- To char
nmap("c;",    '"zyt',         { desc = ' Copy forwards to char' })
nmap("ch",    '"zyT',         { desc = ' Copy backwards to char' })


-- CUT                                                                       _17
--------------------------------------------------------------------------------
-- Note: All `d` motions that span than one line (the deleted text is not
-- confined to a single line) are sent to the numeric register stack by
-- default; we circumvent this by instead yanking to the system register
-- then restoring the previous visual selection and deleting it to the
-- black hole register.

vmap("x",  '"zygv"_d',     { desc = " Cut to 'z' register" })
nmap("xx", 'ggVG"zygv"_d', { desc = ' Cut whole buffer' })

-- Word
nmap("x",  "<Nop>")
nmap("xt", '"zdiw',        { desc = ' Cut in word' })
nmap("xo", '"zde',         { desc = ' Cut word right' })
nmap("xu", '"zdb',         { desc = ' Cut word left' })

-- Line
nmap("xl", 'V"zygv"_d',    { desc = ' Cut whole line' })
nmap("x,", '"zd^',         { desc = ' Cut to line start' })
nmap("x.", '"zd$',         { desc = ' Cut to line end' })

-- Paragraph
nmap("xm", 'vip"zygv"_d',  { desc = ' Cut in paragraph' })
nmap("xi", 'v{"zygv"_d',   { desc = ' Cut paragraph up' })
nmap("xk", 'v}"zygv"_d',   { desc = ' Cut paragraph down' })

-- To char
nmap("x;", '"zdt',         { desc = ' Cut forwards to char' })
nmap("xh", '"zdT',         { desc = ' Cut backwards to char' })


-- CHANGE (all changed text is sent to the black hole register)              _18
--------------------------------------------------------------------------------
vmap("y",  '"_c',     { desc = ' Change visual selection' })
nmap("yy", 'ggVG"_C', { desc = ' Change whole buffer' })

-- Word
nmap("y",  "<Nop>")
nmap("yt", '"_ciw',   { desc = ' Change in word' })
nmap("yu", '"_cb',    { desc = ' Change word left' })
nmap("yo", '"_ce',    { desc = ' Change word right' })

-- Line
nmap("yl", '^"_C',    { desc = ' Change whole line' })
nmap("y,", '"_d^i',   { desc = ' Change to line start' })
nmap("y.", '"_C',     { desc = ' Change to line end' })

-- Paragraph
nmap("ym", '"_cip',   { desc = ' Change in paragraph' })
nmap("yi", '"_c{',    { desc = ' Change paragraph up' })
nmap("yk", '"_c}',    { desc = ' Change paragraph down' })

-- To char
nmap("y;", '"_ct',    { desc = ' Change forwards to char' })
nmap("yh", '"_cT',    { desc = ' Change backwards to char' })


-- PASTE                                                                     _19
--------------------------------------------------------------------------------
nmap("v",     '"z]P',   { desc = " Paste from 'p' register" })
nmap("<A-v>", '"*]P',   { desc = ' Paste from system register' })
vmap("v",     '"_d"zP', { desc = ' Paste over selection' })
cmap("<A-v>", "<C-r>z", { desc = " Paste from 'p' register" })
imap("<A-v>", km.paste, { desc = " Paste from 'p' register" })


-- DUPLICATE LINE / SELECTION                                                _20
--------------------------------------------------------------------------------
nmap("<Leader>d", "VyPj",       { desc = ' Duplicate line below' })
vmap("<Leader>d", "<C-v>VyPgv", { desc = ' Duplicate selection below' })


-- OPEN / JOIN LINES                                                         _21
--------------------------------------------------------------------------------
-- Note: `<C-o>` in insert mode sends a single normal mode cmd; then
-- returns back to insert mode.
nmap("<CR>",   "o<C-o>mo<Esc>`o", { desc = ' New line below' })
nmap("<S-CR>", "O<C-o>mo<Esc>`o", { desc = ' New line above' })
nvmap("j",     "J",               { desc = ' Join lines' })


-- `f` and `/` SEARCH                                                        _22
--------------------------------------------------------------------------------
nvmap("h",    ",",                 { desc = ' Prev f search result' })
nvmap(";",    ";",                 { desc = ' Prev f search result' })
nvmap("N",    "mnN",               { desc = ' Prev / search result' })
nvmap("n",    "mnn",               { desc = ' Next / search result' })
nmap("<A-/>", km.toggle_search_hl, { desc = ' Toggle search highlights' })
nmap("M",     "mn*",               { desc = ' Search for inner word' })
vmap("M",     km.regex_selection,  { desc = ' Search for selected area' })
vmap("/",     "<Esc>/\\%V",        { desc = ' Search within selection', silent = false })


-- QUICKFIX                                                                  _23
--------------------------------------------------------------------------------
nmap("<Leader>c", km.add_line_to_quickfix, { desc = ' Add to quickfix list' })
nmap("<Leader>x", km.toggle_quickfix_win,  { desc = ' Toggle quickfix list' })


-- WINDOW                                                                    _24
--------------------------------------------------------------------------------
-- Focus split
nmap("<Up>",    function() win.navigate_vertically("k") end)    -- Above
nmap("<Down>",  function() win.navigate_vertically("j") end)    -- Below
nmap("<Left>",  function() win.navigate_horizontally("h") end)  -- Left
nmap("<Right>", function() win.navigate_horizontally("l") end)  -- Right

-- Resize window
nmap("<S-Up>",    function() win.relative_resize("up") end)     -- Up
nmap("<S-Down>",  function() win.relative_resize("down") end)   -- Down
nmap("<S-Left>",  function() win.relative_resize("left") end)   -- Left
nmap("<S-Right>", function() win.relative_resize("right") end)  -- Right

-- Cmds
nmap("<Leader>w", win.close_window,  { desc = ' Close window' })
nmap("<A-m>",     "<cmd>vsplit<CR>", { desc = ' Split window vertically' })
nmap("<A-n>",     "<cmd>split<CR>",  { desc = ' Split window horizontally' })
nmap("<Home>",    "zhzhzh",          { desc = ' Scroll window left' })
nmap("<End>",     "zlzlzl",          { desc = ' Scroll window right' })
nmap("<D-[>",     "<C-w>r",          { desc = ' Swap splits (2 splits max)' })


-- SAVE CHANGES                                                              _25
--------------------------------------------------------------------------------
nimap("<A-s>", km.save_changes, { desc = ' Save changes' })


-- QUIT (never quit)                                                         _26
--------------------------------------------------------------------------------
nvmap("<Leader>QQ", "<cmd>qa!<CR>",  { desc = ' Force quit nvim' })
nmap("<A-q>",       km.quit_session, { desc = ' Quit and save session' })
