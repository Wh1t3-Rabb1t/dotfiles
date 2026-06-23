local M = {}

M.overlays = {}
M.brightness = {}


M.sys_menu = {
    modal_active = false,
    popup = false,
    bindings = {
        -- MonitorControl was buggy spyware anyway
        u = {
            desc = 'Brightness Up', idx = 1,
            action = function() require('shaders').adjust_brightness('up') end,
        },
        d = {
            desc = 'Brightness Down', idx = 2,
            action = function() require('shaders').adjust_brightness('down') end,
        },
        p = {
            desc = 'Print Brightness', idx = 3,
            action = function() require('shaders').print_brightness_values() end,
        },
        -- escape = {
        --     desc = 'Cancel', idx = 4,
        --     action = function()
        --         menu.modal_active = false
        --         tap:stop()
        --         hs.alert.show("Off")
        --         sys_menu.hide_overlay()
        --         return true
        --     end,
        -- },
    }
}

return M

