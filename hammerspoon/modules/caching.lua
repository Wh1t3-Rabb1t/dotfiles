local M = {}

local registry = require('registry')
local state = require('state')
local cache = require('cache')


-- Check if tables have been initialized
--------------------------------------------------------------------------------
local function tbl_initialized(tbl)
    local done = false

    if type(tbl) == 'table' and next(tbl) ~= nil then
        done = true
    end

    return done
end


-- Format rgb table
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
local function get_menu_text(app, binding_tbl)
    local len = 0

    -- Find longest key
    for _, binding in ipairs(binding_tbl) do
        local display = ("%s"):format(binding.key)
        len = math.max(len, #display)
    end

    -- Define text formatting
    local font_style = {
        name = 'Menlo',
        size = 16,
    }
    local title_style = {
        font = {
            name = 'Menlo-BoldItalic',
            size = 18,
        },
        color = rgb(205, 205, 205),
    }
    local key_style = {
        font = font_style,
        color = rgb(0, 255, 0),
    }
    local arrow_style = {
        font = font_style,
        color = rgb(100, 100, 100),
    }
    local desc_style = {
        font = font_style,
        color = rgb(255, 255, 255),
    }

    local fmt = "%" .. len .. "s "  -- "%-" (to align keys at the start)
    local title_length = #app + 2
    local underline = "\n" .. string.rep("-", title_length) .. "\n"
    local styled_text = require('hs.styledtext')
    local text = styled_text.new(("* %s"):format(app), title_style)
        .. styled_text.new(underline, title_style)

    for i, binding in ipairs(binding_tbl) do
        local display = ("%s"):format(binding.key)

        text = text
            .. styled_text.new(fmt:format(display), key_style)
            .. styled_text.new('-> ', arrow_style)
            .. styled_text.new(binding.desc, desc_style)

        if i < #binding_tbl then
            text = text .. styled_text.new("\n", desc_style)
        end
    end

    return text
end


-- Create popup
--------------------------------------------------------------------------------
local function get_popup(content, frame)
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


-- Get the width / height of the popup window
--------------------------------------------------------------------------------
local function get_popup_frame(text)
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
local function get_usable_frame(screen)
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
local function get_overlay(screen)
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

    return overlay
end


-- Init data for all connected screens
--------------------------------------------------------------------------------
local function get_screen_data(screen)
    local screen_data = {
        cache = {
            overlay = get_overlay(screen),
            frame = get_usable_frame(screen),
        },
        state = {
            brightness = 100,
            divider = 0.35,
            layout = {
                maximized = false,
                left = false,
                right = false,
            }
        }
    }

    return screen_data
end


-- Create binding popup menus
--------------------------------------------------------------------------------
local function get_binding_popups(app, bindings)
    local lookup = {}

    -- Pack lookup table
    for _, binding in ipairs(bindings) do
        lookup[binding.key] = registry.actions[app][binding.action]
    end

    local content = get_menu_text(app, bindings)
    local frame = get_popup_frame(content)
    local popup = get_popup(content, frame)

    local binding_data = {
        lookup = lookup,
        assets = {
            popup = popup,
            frame = frame,
        }
    }

    return binding_data
end


-- Create event tap
--------------------------------------------------------------------------------
local function get_event_tap()
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


-- Init
--------------------------------------------------------------------------------
function M.init()
    -- Init screen data if required
    if not tbl_initialized(cache.screens) or
       not tbl_initialized(state.screens)
    then
        for _, screen in ipairs(hs.screen.allScreens()) do
            local id = screen:id()
            local screen_data = get_screen_data(screen)

            cache.screens[id] = screen_data.cache
            state.screens[id] = screen_data.state
        end
    end

    -- Init bindings/assets if required
    if not tbl_initialized(cache.assets) or
       not tbl_initialized(cache.lookup)
    then
        for app, bindings in pairs(registry.bindings) do
            local binding_data = get_binding_popups(app, bindings)

            cache.lookup[app] = binding_data.lookup
            cache.assets[app] = binding_data.assets
        end

        -- Create event tap
        cache.assets.tap = get_event_tap()
    end
end

return M
