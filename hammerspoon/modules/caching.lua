local M = {}

local registry = require('registry')
local state = require('state')
local cache = require('cache')


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
local function create_popup(content, frame)
    local popup = hs.canvas.new(frame)

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
            text = content,
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
        if hs.timer.secondsSinceEpoch() < state.menu.ignore_until then
            state.menu.ignore_until = 0

            return false
        end

        local keycode = event:getKeyCode()
        local key = hs.keycodes.map[keycode]
        local focused_win = hs.window.focusedWindow()
        local app_name = focused_win:application():name()

        -- Lookup system and/or app specific actions
        local bound_action = cache.lookup.system[key] or cache.lookup[app_name][key]

        if bound_action then
            bound_action()
        end

        return true
    end)

    return tap
end


-- Get the width / height of the popup window
--------------------------------------------------------------------------------
local function popup_frame(text)
    local size = hs.drawing.getTextDrawingSize(text)
    local canvas_width = math.max(size.w)
    local canvas_height = math.max(size.h)

    local frame = {
        w = (canvas_width + 10),
        h = (canvas_height + 10),
    }

    return frame
end


-- Calculate the available screen (total screen frame minus the dock)
--------------------------------------------------------------------------------
local function usable_screen_frame(screen)
    local full = screen:fullFrame()
    local usable = screen:frame()

    local frame = {
        x = full.x,
        y = usable.y,
        w = full.w,
        h = full.h - (usable.y - full.y),
    }

    return frame
end


-- Create overlay
--------------------------------------------------------------------------------
local function create_overlay(screen)
    local overlay = hs.canvas.new(screen:fullFrame())

    overlay:appendElements({
        type = 'rectangle',
        action = 'fill',
        fillColor = {
            red = 0,
            green = 0,
            blue = 0,
            alpha = 0,
        }
    })
    overlay:level(hs.canvas.windowLevels.overlay)
    overlay:behavior(hs.canvas.windowBehaviors.canJoinAllSpaces)
    overlay:show()

    return overlay
end


-- Init
--------------------------------------------------------------------------------
function M.init()
    -- Cache data for all connected screens
    for _, screen in ipairs(hs.screen.allScreens()) do
        local id = screen:id()

        cache.screens[id] = {
            overlay = create_overlay(screen),
            frame = usable_screen_frame(screen),
        }

        state.screens[id] = {
            brightness = 100,
            divider = 0.35,
            layout = {
                maximized = false,
                left = false,
                right = false,
            }
        }
    end

    -- Cache bindings/canvases
    for app, bindings in pairs(registry.bindings) do
        -- Init app specific lookup table
        cache.lookup[app] = {}

        for _, binding in ipairs(bindings) do
            local key = binding.key
            local action = binding.action

            -- Pack lookup table
            cache.lookup[app][key] = registry.actions[app][action]
        end

        -- Generate canvases
        local content = create_menu_text(bindings)
        local frame = popup_frame(content)
        local popup = create_popup(content, frame)

        cache.assets[app] = {
            popup = popup,
            frame = frame,
        }
    end

    -- Create event tap
    cache.assets.tap = create_tap()
end

return M
