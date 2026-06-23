local M = {}

local state = require('state').sys_menu

-- Popup bindings
--------------------------------------------------------------------------------
M.bindings = {
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
    --         sys_menu.hide_popup()
    --         return true
    --     end,
    -- },
}

-- Show popup
--------------------------------------------------------------------------------
function M.show_popup()
    local popup = hs.canvas.new({ x = 30, y = 30, w = 220, h = 90 })

    local keys = {}
    local lines = {}

    for k, v in pairs(M.bindings) do
        table.insert(keys, { key = k, idx = v.idx, binding = v })
    end

    table.sort(keys, function(a, b) return a.idx < b.idx end)

    for _, item in ipairs(keys) do
        table.insert(lines, string.format("%-2s : %s", item.key, item.binding.desc))
    end

    local fmt_text = table.concat(lines, "\n")

    popup:appendElements(
        {
            type = "rectangle",
            action = "fill",
            fillColor = { alpha = 0.85 },
            roundedRectRadii = { xRadius = 8, yRadius = 8 },
        },
        {
            type = "text",
            frame = { x = 10, y = 10, w = 200, h = 70 },
            text = fmt_text,
            textSize = 18,
            textColor = { white = 1 },
        }
    )

    state.popup = popup
    popup:show()
end

-- Hide popup
--------------------------------------------------------------------------------
function M.hide_popup()
    local popup = state.popup

    if popup then
        popup:delete()
        state.popup = false
    end
end

return M
