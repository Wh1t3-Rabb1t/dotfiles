local M = {}

local state = require('state').sys_menu
local shader = require('shaders')

-- Popup bindings
--------------------------------------------------------------------------------
local bindings = {
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
    }
}

-- Build popup menu text content
--------------------------------------------------------------------------------
local function build_bindings_menu()
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

-- Show popup
--------------------------------------------------------------------------------
local function show_popup()
    local curr_screen = hs.mouse.getCurrentScreen() or hs.screen.primaryScreen()
    local frame = curr_screen:fullFrame()

    local popup = hs.canvas.new({
        x = (frame.x + 20),
        y = (frame.y + 20),
        w = 220,
        h = 90
    })

    local binding_menu = build_bindings_menu()

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
local function hide_popup()
    local popup = state.popup

    if popup then
        popup:delete()
        state.popup = false
    end
end

-- Handle keystrokes
--------------------------------------------------------------------------------
function M.handle_keys()
    if state.menu_active then
        return
    end

    state.menu_active = true
    show_popup()

    local tap

    tap = hs.eventtap.new({ hs.eventtap.event.types.keyDown }, function(event)
        local keycode = event:getKeyCode()
        local key = hs.keycodes.map[keycode]

        if key == 'escape' then
            state.menu_active = false
            tap:stop()
            hide_popup()
            return true
        end

        local binding = bindings[key]

        if binding and binding.action then
            binding.action()
        end

        return true
    end)
    tap:start()
end

return M
