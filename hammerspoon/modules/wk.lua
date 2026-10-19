local M = {}

local state     = require('state')
local cache     = require('cache')
local util      = require('util')
local screens   = require('screens')
local apps      = require('apps')
local windows   = require('windows')
local wk_assets = require('wk_assets')


--------------------------------------------------------------------------------
-- Launch which key
--------------------------------------------------------------------------------
function M.launch()
    if state.menu.tap_active then
        return
    end

    screens.init()
    apps.init()
    windows.init()

    -- Init wk_assets if not already initialized
    if not state.wk_initialized then
        wk_assets.init()
    end

    -- Start event tap
    state.menu.tap_active = true
    cache.wk_tap:start()

    -- Show popup
    util.run(windows.show_popups())
end

return M
