local M = {}

local state = require('state').menu
local lookup = require('state').lookup
local asset = require('state').assets
local shader = require('shaders')


-- System key bindings (universal)
--------------------------------------------------------------------------------
local sys_bindings = {
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

-- local brave_bindings = {
--     {
--         key = 'l',
--         desc = 'Focus searchbar',
--         action = function()
--             M.send_keys('l', 'cmd')
--             M.close_menu()
--         end
--     },
--     {
--         key = 't',
--         desc = 'Left arrow',
--         action = function() M.send_keys('left') end
--     },
--     {
--         key = 'l',
--         desc = 'Right arrow',
--         action = function() M.send_keys('right') end
--     },
--     {
--         key = 'h',
--         desc = 'Tab left',
--         action = function() M.send_keys('pageup', 'ctrl') end
--     },
--     {
--         key = ';',
--         desc = 'Tab right',
--         action = function() M.send_keys('pagedown', 'ctrl') end
--     },
--     {
--         key = 'w',
--         desc = 'Close tab',
--         action = function() M.send_keys('w', 'cmd') end
--     },
-- }


-- Format rgb
--------------------------------------------------------------------------------
local function rgb(r, g, b, opacity)
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
local function create_menu_text(binding_tbl)
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
        color = rgb(0, 255, 0),
    }
    local desc_style = {
        font = font_style,
        color = rgb(255, 255, 255),
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
local function create_popup(binding_tbl)
    -- Get focused screen frame
    local screen = hs.mouse.getCurrentScreen() or hs.screen.primaryScreen()
    local frame = screen:fullFrame()

    -- Get dimensions of text to be rendered
    local text = create_menu_text(binding_tbl)
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
local function create_tap()
    local e = hs.eventtap

    local tap = e.new({ e.event.types.keyDown }, function(event)
        if hs.timer.secondsSinceEpoch() < state.ignore_until then
            state.ignore_until = 0
            return false
        end

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


-- Create the cached bindings lookup table
--------------------------------------------------------------------------------
local function create_lookup_table(binding_tbl)
    for _, binding in ipairs(binding_tbl) do
        lookup[binding.key] = binding
    end
end


-- Send keystrokes (while bypassing active eventtap)
--------------------------------------------------------------------------------
function M.send_keys(key, mod)
    state.ignore_until = hs.timer.secondsSinceEpoch() + 0.05

    local modifiers = mod or {}

    if type(modifiers) == 'string' then
        modifiers = { modifiers }
    end

    hs.timer.doAfter(0, function()
        hs.eventtap.keyStroke(modifiers, key, 0)
    end)
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
        create_lookup_table(sys_bindings)

        asset.tap = create_tap()
        asset.popup = create_popup(sys_bindings)
    end
    asset.tap:start()
    asset.popup:show(0.15)
end

return M
