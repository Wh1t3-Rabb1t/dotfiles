local M = {}

local styledtext = require("hs.styledtext")
local state = require('state').sys_menu
local cache = require('state').cache
local shader = require('shaders')


local bindings = {
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
    escape = {
        desc = 'Cancel', idx = 4,
        action = function() M.close_menu() end,
    },
}


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


-- Create new event tap
--------------------------------------------------------------------------------
local function create_tap()
    local tap
    tap = hs.eventtap.new({ hs.eventtap.event.types.keyDown }, function(event)
        local keycode = event:getKeyCode()
        local key = hs.keycodes.map[keycode]
        local binding = bindings[key]

        if binding and binding.action then
            binding.action()
        end

        return true
    end)
    return tap
end


-- Cache menu assets
--------------------------------------------------------------------------------
function M.cache_menu()
    cache.tap = create_tap()
    cache.popup = fmt_popup()
end


-- Close popup
--------------------------------------------------------------------------------
function M.close_menu()
    state.menu_active = false
    state.popup = nil
    state.tap = nil
    cache.popup:delete()
    cache.tap:stop()
end


-- Handle keystrokes
--------------------------------------------------------------------------------
function M.launch_menu()
    if state.menu_active then
        return
    end
    state.menu_active = true

    if not cache.tap or not cache.popup then
        M.cache_menu()
    end
    cache.tap:start()
    cache.popup:show(0.15)
end

return M
