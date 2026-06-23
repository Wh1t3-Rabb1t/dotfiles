local M = {}

local state = require('state').sys_menu
local shader = require('shaders')

local function build_binding_menu(bindings)
    local keys = {}
    local lines = {}

    -- Build binding menu from table
    for k, v in pairs(bindings) do
        table.insert(keys, { key = k, idx = v.idx, binding = v })
    end

    table.sort(keys, function(a, b) return a.idx < b.idx end)

    for _, item in ipairs(keys) do
        table.insert(lines, string.format("%-2s : %s", item.key, item.binding.desc))
    end

    local fmt_text = table.concat(lines, "\n")

    return fmt_text
end

-- Popup bindings
--------------------------------------------------------------------------------
M.bindings = {
    -- MonitorControl was buggy spyware anyway
    u = {
        desc = 'Brightness Up', idx = 1,
        action = function() shader.adjust_brightness('up') end,
    },
    d = {
        desc = 'Brightness Down', idx = 2,
        action = function() shader.adjust_brightness('down') end,
    },
    p = {
        desc = 'Print Brightness', idx = 3,
        action = function() shader.print_values() end,
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
    local curr_screen = hs.mouse.getCurrentScreen() or hs.screen.primaryScreen()
    local frame = curr_screen:fullFrame()

    local popup = hs.canvas.new({
        x = (frame.x + 20),
        y = (frame.y + 20),
        w = 220,
        h = 90
    })

    local binding_menu = build_binding_menu(M.bindings)

    popup:appendElements(
        {
            type = 'rectangle',
            action = 'strokeAndFill',
            fillColor = { alpha = 0.85 },
            strokeColor = { white = 1 },
            roundedRectRadii = { xRadius = 8, yRadius = 8 },
        },
        {
            type = 'text',
            text = binding_menu,
            textSize = 18,
            textColor = { white = 1 },
            frame = { x = 10, y = 10, w = 200, h = 70 },
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
