local M = {}

local state = require('state').menu
local lookup = require('state').lookup
local asset = require('state').assets
local shader = require('shaders')


-- Key bindings
--------------------------------------------------------------------------------
local bindings = {
    {
        key = 'u',
        desc = 'Brightness Up',
        action = function() shader.adjust_brightness('up') end
    },
    {
        key = 'd',
        desc = 'Brightness Down',
        action = function() shader.adjust_brightness('down') end
    },
    {
        key = 'p',
        desc = 'Print Brightness',
        action = function() shader.print_values() end
    },
    {
        key = 'escape',
        desc = 'Cancel',
        action = function() M.close_menu() end
    },
}


-- Format rgb
--------------------------------------------------------------------------------
local function rgb(r, g, b, opacity)
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
local function create_menu_text(input)
    local len = 0

    -- Find longest key
    for _, binding in ipairs(input) do
        local display = ("[%s]"):format(binding.key)
        len = math.max(len, #display)
    end

    local font_style = {
        name = "Menlo",
        size = 18,
    }

    local key_style = {
        font = font_style,
        color = rgb(0, 255, 0),
    }

    local desc_style = {
        font = font_style,
        color = rgb(255, 255, 255),
    }

    local styledtext = require("hs.styledtext")
    local text = styledtext.new("")
    local fmt = "%-" .. len .. "s "

    for i, binding in ipairs(input) do
        local display = ("[%s]"):format(binding.key)

        text = text
            .. styledtext.new(fmt:format(display), key_style)
            .. styledtext.new(binding.desc, desc_style)

        if i < #input then
            text = text .. styledtext.new("\n", desc_style)
        end
    end

    return text
end


-- Create popup
--------------------------------------------------------------------------------
local function create_popup()
    -- Get focused screen frame
    local screen = hs.mouse.getCurrentScreen() or hs.screen.primaryScreen()
    local frame = screen:fullFrame()

    -- Get dimensions of text to be rendered
    local text = create_menu_text(bindings)
    local size = hs.drawing.getTextDrawingSize(text)
    local canvas_width = math.max(size.w)
    local canvas_height = math.max(size.h)

    local popup = hs.canvas.new({
        x = (frame.w / 2),
        y = (frame.h / 2),
        w = (canvas_width + 10),
        h = (canvas_height + 10),
    })

    popup:appendElements(
        {
            type = 'rectangle',
            action = 'strokeAndFill',
            fillColor = rgb(1, 2, 3),          -- Black
            strokeColor = rgb(255, 255, 255),  -- White
            roundedRectRadii = {
                xRadius = 8,
                yRadius = 8
            }
        },
        {
            type = 'text',
            text = text,
            frame = {
                x = 5,
                y = 5,
                w = "100%",
                h = "100%"
            }
        }
    )

    return popup
end


-- Create event tap
--------------------------------------------------------------------------------
local function create_tap()
    local e = hs.eventtap

    local tap = e.new({ e.event.types.keyDown }, function(event)
        local keycode = event:getKeyCode()
        local key = hs.keycodes.map[keycode]
        local binding = lookup[key]

        if binding then
            binding.action()
        end

        return true
    end)

    return tap
end


-- Create menu assets
--------------------------------------------------------------------------------
local function create_menu_assets()
    for _, binding in ipairs(bindings) do
        lookup[binding.key] = binding
    end

    asset.tap = create_tap()
    asset.popup = create_popup()
end


-- Close menu
--------------------------------------------------------------------------------
function M.close_menu()
    state.menu_active = false
    asset.popup:delete()
    asset.tap:stop()
end


-- Launch menu
--------------------------------------------------------------------------------
function M.launch_menu()
    if state.menu_active then
        return
    end
    state.menu_active = true

    if not asset.tap or not asset.popup then
        create_menu_assets()
    end
    asset.tap:start()
    asset.popup:show(0.15)
end

return M
