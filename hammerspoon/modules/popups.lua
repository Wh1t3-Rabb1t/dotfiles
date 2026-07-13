local M = {}

local registry = require('registry')
local state = require('state')
local cache = require('cache')


-- Format rgb
--------------------------------------------------------------------------------
function M.rgb(r, g, b, opacity)
    opacity = opacity or 1.0

    local color_table = {
        red = r / 255,
        green = g / 255,
        blue = b / 255,
        alpha = opacity,
    }

    return color_table
end


-- Format menu contents
--------------------------------------------------------------------------------
function M.create_menu_text(binding_tbl)
    local len = 0

    -- Find longest key
    for _, binding in ipairs(binding_tbl) do
        local display = ("[%s]"):format(binding.key)
        len = math.max(len, #display)
    end

    -- Define text formatting
    local font_style = {
        name = 'Menlo',
        size = 18,
    }
    local key_style = {
        font = font_style,
        color = M.rgb(0, 255, 0),
    }
    local desc_style = {
        font = font_style,
        color = M.rgb(255, 255, 255),
    }

    local styledtext = require('hs.styledtext')
    local text = styledtext.new("")
    local fmt = "%-" .. len .. "s "

    for i, binding in ipairs(binding_tbl) do
        local display = ("[%s]"):format(binding.key)

        text = text
            .. styledtext.new(fmt:format(display), key_style)
            .. styledtext.new(binding.desc, desc_style)

        if i < #binding_tbl then
            text = text .. styledtext.new("\n", desc_style)
        end
    end

    return text
end


-- Create popup
--------------------------------------------------------------------------------
function M.create_popup(text)
    local size = hs.drawing.getTextDrawingSize(text)
    local canvas_width = math.max(size.w)
    local canvas_height = math.max(size.h)

    local popup = hs.canvas.new({
        w = (canvas_width + 10),
        h = (canvas_height + 10),
    })

    popup:appendElements(
        {
            type = 'rectangle',
            action = 'strokeAndFill',
            fillColor = M.rgb(1, 2, 3),          -- Black
            strokeColor = M.rgb(255, 255, 255),  -- White
            roundedRectRadii = {
                xRadius = 8,
                yRadius = 8,
            }
        },
        {
            type = 'text',
            text = text,
            frame = {
                x = 5,
                y = 5,
                w = '100%',
                h = '100%',
            }
        }
    )

    return popup
end


-- Create event tap
--------------------------------------------------------------------------------
function M.create_tap()
    local e = hs.eventtap

    local tap = e.new({ e.event.types.keyDown }, function(event)
        if hs.timer.secondsSinceEpoch() < state.menu.ignore_until then
            state.menu.ignore_until = 0

            return false
        end

        local keycode = event:getKeyCode()
        local key = hs.keycodes.map[keycode]
        local bound_action = cache.lookup[key]

        if bound_action then
            bound_action()
        end

        return true
    end)

    return tap
end


-- Init
--------------------------------------------------------------------------------
function M.init()
    -- Cache bindings/canvases
    for _, app in pairs(registry.apps) do
        local bindings = app.bindings
        local title = app.title

        -- Pack lookup table
        for _, binding in ipairs(bindings) do
            local key = binding.key
            local action = binding.action

            cache.lookup[key] = registry.actions[title][action]
        end

        -- Generate canvases
        local content = M.create_menu_text(bindings)
        local popup = M.create_popup(content)

        cache.assets[title] = popup
    end

    -- Create event tap
    cache.assets.tap = M.create_tap()
end

return M
