# TODO

https://github.com/stevearc/overseer.nvim

---

## Bindings

- Set broot jump between results binding
- Set up macOS mission control navigation bindings and increase animation speed via cli os settings
- Look into enabling italic and bold in kitty Monaco font


- Finish configuring fzf lua

- Bind alt c in visual mode to copy visual selection to the qt list


- Fix line jump bindings (op pending not working for i and k)



- (maybe) Set up down left right bindings for visual mode
- Reinstall hammerspoon via homebrew


Store notes on registers somewhere:
-- "  Unnamed register. Holds the last deleted or yanked text.
-- *  Primary system clipboard selection (X11 on Unix-like systems).
-- +  Secondary clipboard register. Used for copying/pasting with the system clipboard.
-- .  Last inserted text register. Contains last inserted text.
-- -  Small delete register. Holds text from deletions smaller than a line (like dw).
-- 0  Yank register for the last yank command. Last yanked text (not overwritten by deletes).
-- _  Black hole register. Discards any text sent to it, acting as a "null" register.
-- #  Alternate file name register. Holds name of the last file edited.
-- /  Last search pattern register. Stores the most recent search pattern.
-- %  Current file name register. Holds the name of the current file.
-- :  Last executed command register. Containing the last command-line command entered.
-- =  Expression register. Allows you to evaluate expressions and insert the result.
-- ~  Register for the last tilde operation. Stores result of the last g~ or ~ operation.


---

## Misc

- on semanticTokens
-- I use for C/C++. I don't like the way tree sitter works for these
-- languages and the error recovery of the LSP prevents a missing
-- semicolon in a line to affect the syntax highlight of the next
-- lines. And since Tree sitter can't differentiate macros from types,
-- the syntax highlight is completely broken in some code.


-- Nvim plugin framework:
    https://github.com/ldelossa/litee.nvim


- Consider creating an ignored filetypes module that sets ignore lists for different plugins to prevent plugins clashing

- Set up bindings to inspect / evaluate selection


https://github.com/gdh1995/vimium-c



https://github.com/CWood-sdf/banana.nvim
https://github.com/sindrets/diffview.nvim
https://github.com/andrewferrier/debugprint.nvim
https://github.com/chrisgrieser/nvim-tinygit
https://github.com/chrisgrieser/nvim-chainsaw
https://github.com/rest-nvim/rest.nvim
https://github.com/mistweaverco/kulala.nvim
https://github.com/stevearc/overseer.nvim


- Write correct lua evaluation bindings for a popup window -- vmap("=", ":lua<CR>", { silent = false })

- Set bindings for gitsigns (commit, add etc)
- Set up code action bindings
- Clear quickfix list / search hl after using quicker substitute
- Prevent fzf lua overwriting qf list when adding to it (possibly patch fzf lua)
- Find out how to toggle annoying LSP warnings

- Add FzfLua dap commands to Legendary once dap setup
-- LEGENDARY
-- dap_commands
-- dap_configurations
-- dap_breakpoints
-- dap_variables
-- dap_frames


https://github.com/ibhagwan/vim-cheatsheet
https://github.com/gennaro-tedesco/dotfiles/blob/master/nvim/lua/mappings.lua

---

## Plugin ideas

- UNDO TREE FOR FZF LUA

- in visual block mode press a key to replace the outer lines of the visual area with box chars e.g
╭──────────╮
│  EXPORT  │
╰──────────╯
also enable insertion of line separators from visual line mode e.g #-----------------#

- Key remapping plugin (grep the users entire neovim config folder to find all instances of vim.keymap.set and save the filename and location within the file to a database to allow updating mapping regardless of the file they are stored in)

---

## Plugins to try

- LazyDev     https://github.com/folke/lazydev.nvim
- diffview    https://github.com/sindrets/diffview.nvim
- Noice       https://github.com/folke/noice.nvim
- Focus       https://github.com/nvim-focus/focus.nvim
- Leetcode    https://github.com/kawre/leetcode.nvim

---

## Completion extensions

- https://github.com/lukas-reineke/cmp-under-comparator
- https://github.com/uga-rosa/cmp-dictionary

---

## Debug

- https://github.com/mfussenegger/nvim-dap
- https://github.com/rcarriga/nvim-dap-ui
- https://github.com/theHamsta/nvim-dap-virtual-text
- https://github.com/leoluz/nvim-dap-go
- https://github.com/rcarriga/cmp-dap

wiki: https://github.com/mfussenegger/nvim-dap/wiki/Debug-Adapter-installation#lua



- possibly incorporate these somewhere:

```lua
-- vmap("<Up>", [["zx"zpgvlolo]])                 -- Search selection up
-- vmap("<Down>", [["zxhh"zpgvhoho]])               -- Search selection down
-- -- makes * and # work on visual mode too.
-- vim.api.nvim_exec(
--   [[
--   function! g:VSetSearch(cmdtype)
--     let temp = @s
--     norm! gv"sy
--     let @/ = '\V' . substitute(escape(@s, a:cmdtype.'\'), '\n', '\\n', 'g')
--     let @s = temp
--   endfunction
--   xnoremap * :<C-u>call g:VSetSearch('/')<CR>/<C-R>=@/<CR><CR>
--   xnoremap # :<C-u>call g:VSetSearch('?')<CR>?<C-R>=@/<CR><CR>
-- ]],
--   false
-- )

-- MOVE SELECTION LEFT / RIGHT
--------------------------------------------------------------------------------
vmap("<Right>", [["zx"zpgvlolo]])                 -- Move selection right
vmap("<Left>",  [["zxhh"zpgvhoho]])               -- Move selection left
```
