local M = {}

local styledtext = require("hs.styledtext")
local state = require('state').sys_menu
local bindings = require('bindings').system


-- Format rgb
--------------------------------------------------------------------------------
local function fmt_rgb(r, g, b, opacity)
    opacity = opacity or 1.0

    local color_table = {
        red = r / 255,
        green = g / 255,
        blue = b / 255,
        alpha = opacity
    }

    return color_table
end


-- Format menu contents
--------------------------------------------------------------------------------
local function fmt_menu_contents(input)
    local keys = {}
    local len = 0

    for k, v in pairs(input) do
        local display = ("[%s]"):format(k)

        len = math.max(len, #display)

        table.insert(keys, {
            display = display,
            idx = v.idx,
            binding = v,
        })
    end

    -- Sort entries in accordance with 'idx'
    table.sort(keys, function(a, b)
        return a.idx < b.idx
    end)

    -- Menu formatting
    local font_style = {
        name = 'Menlo',
        size = 18
    }
    local key_style = {
        font = font_style,
        color = fmt_rgb(0, 255, 0),      -- Green
    }
    local desc_style = {
        font = font_style,
        color = fmt_rgb(255, 255, 255),  -- White
    }

    local fmt = "%-" .. len .. "s "
    local text = styledtext.new("")

    for i, item in ipairs(keys) do
        text = text
            .. styledtext.new(fmt:format(item.display), key_style)
            .. styledtext.new(item.binding.desc, desc_style)

        if i < #keys then
            text = text .. styledtext.new("\n", desc_style)
        end
    end

    return text
end


-- Show popup
--------------------------------------------------------------------------------
local function fmt_popup()
    local screen = hs.mouse.getCurrentScreen() or hs.screen.primaryScreen()
    local frame = screen:fullFrame()

    local canvas_width = 320
    local canvas_height = 40

    local popup = hs.canvas.new({
        x = (frame.w / 2) - (canvas_width / 2),
        y = (frame.h / 2) - (canvas_height / 2),
        w = canvas_width,
        h = canvas_width
    })

    popup:appendElements(
        {
            type = 'rectangle',
            action = 'strokeAndFill',
            fillColor = fmt_rgb(24, 135, 250),
            strokeColor = fmt_rgb(255, 255, 255),
            roundedRectRadii = {
                xRadius = 8,
                yRadius = 8
            }
        },
        {
            type = 'text',
            text = fmt_menu_contents(bindings),
            frame = {
                x = 10,
                y = 10,
                w = "100%",
                h = "100%"
            }
        }
    )

    return popup
end


-- Handle keystrokes
--------------------------------------------------------------------------------
function M.launch_menu()
    if state.menu_active then
        return
    end

    local popup = fmt_popup()

    state.menu_active = true
    state.popup = popup
    popup:show(0.15)

    local tap

    tap = hs.eventtap.new({ hs.eventtap.event.types.keyDown }, function(event)
        local keycode = event:getKeyCode()
        local key = hs.keycodes.map[keycode]

        if key == 'escape' then
            state.menu_active = false
            state.popup = false
            popup:delete()
            tap:stop()
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
