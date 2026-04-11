# TODO

## Priority: High

- Look into whether or not we can disable multiple tabs
  (help pages etc forced to launch in splits).

## Priority: Low

- `:checkhealth which-key` has useful info about overlapping bindings.
- Create autocommand to turn off wrap if buffer width is < 80.
- Consider creating an ignored filetypes module that sets ignore lists for
  different plugins to prevent plugins clashing.
- Set up bindings to inspect / evaluate selection.
- Write correct lua evaluation bindings for a popup window -- vmap("=", ":lua<CR>", { silent = false }).
- Set up code action bindings.

## Plugins

- https://github.com/andrewferrier/debugprint.nvim
- https://github.com/stevearc/overseer.nvim
- https://github.com/kawre/leetcode.nvim
- https://github.com/lukas-reineke/cmp-under-comparator

- Plugin framework: https://github.com/ldelossa/litee.nvim

## Debug

- https://github.com/mfussenegger/nvim-dap
- https://github.com/rcarriga/nvim-dap-ui
- https://github.com/theHamsta/nvim-dap-virtual-text
- https://github.com/leoluz/nvim-dap-go
- https://github.com/rcarriga/cmp-dap

wiki: https://github.com/mfussenegger/nvim-dap/wiki/Debug-Adapter-installation#lua

## Possibly incorporate these bindings

```lua
-- MOVE SELECTION LEFT / RIGHT
--------------------------------------------------------------------------------
vmap("<Right>", [["zx"zpgvlolo]])                 -- Move selection right
vmap("<Left>",  [["zxhh"zpgvhoho]])               -- Move selection left
```
