local M = {}

local registry = require('registry')
local util     = require('util')
local state    = require('state')
local cache    = require('cache')


-- Normalize bindings with modifiers
--------------------------------------------------------------------------------
local function binding_id(key, mods)
    if not mods or #mods == 0 then
        return key
    end

    table.sort(mods)

    return table.concat(mods, '+') .. '+' .. key
end


-- Format rgb table
--------------------------------------------------------------------------------
local function rgb(r, g, b, opacity)
    opacity = opacity or 1.0

    local color_table = {
        red   = r / 255,
        green = g / 255,
        blue  = b / 255,
        alpha = opacity,
    }

    return color_table
end


-- Create popup
--------------------------------------------------------------------------------
local function create_popup(content, frame)
    local popup = hs.canvas.new(frame)

    popup:appendElements(
        {
            type        = 'rectangle',
            action      = 'strokeAndFill',
            fillColor   = rgb(1, 2, 3),        -- Black
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
    local size          = hs.drawing.getTextDrawingSize(text)
    local canvas_width  = math.max(size.w)
    local canvas_height = math.max(size.h)

    local frame = {
        w = (canvas_width + 10),
        h = (canvas_height + 10),
    }

    return frame
end


-- Format bindings with mods
--------------------------------------------------------------------------------
local function fmt_key_combinations(binding)
    local mods = binding.mods or {}
    local key  = binding.key

    local shift_chars = {
        ['`'] = '~',
        ['1'] = '!',
        ['2'] = '@',
        ['3'] = '#',
        ['4'] = '$',
        ['5'] = '%',
        ['6'] = '^',
        ['7'] = '&',
        ['8'] = '*',
        ['9'] = '(',
        ['0'] = ')',
        ['-'] = '_',
        ['='] = '+',
        ['['] = '{',
        [']'] = '}',
        [';'] = ':',
        ["'"] = '"',
        [','] = '<',
        ['.'] = '>',
        ['/'] = '?',
        ['\\'] = '|',
    }

    local mod_names = {
        cmd   = 'cmd',
        ctrl  = 'ctrl',
        alt   = 'alt',
        shift = 'shift',
    }

    local consume_shift = false

    for _, mod in ipairs(mods) do
        if mod == 'shift' then
            if key:match('^[a-z]$') then
                key = key:upper()
                consume_shift = true
            elseif shift_chars[key] then
                key = shift_chars[key]
                consume_shift = true
            end
            break
        end
    end

    local parts = {}

    for _, mod in ipairs(mods) do
        if mod ~= 'shift' or not consume_shift then
            table.insert(parts, mod_names[mod] or mod)
        end
    end

    table.insert(parts, key)

    return table.concat(parts, ' ')
end


-- Format menu contents
--------------------------------------------------------------------------------
local function fmt_menu_text(app, binding_tbl)
    local len = 0

    -- Find longest key across all categories
    for _, category in ipairs(binding_tbl) do
        for _, binding in ipairs(category.bindings) do
            len = math.max(len, #fmt_key_combinations(binding))
        end
    end

    -- Text styling
    local title_font = { name = 'Menlo-BoldItalic', size = 18 }
    local base_font  = { name = 'Menlo', size = 14 }

    local styles = {
        title = { font = title_font, color = rgb(205, 205, 205) },
        group = { font = base_font,  color = rgb(150, 200, 255) },
        key   = { font = base_font,  color = rgb(0, 255, 0) },
        arrow = { font = base_font,  color = rgb(100, 100, 100) },
        desc  = { font = base_font,  color = rgb(255, 255, 255) },
    }

    local styled_text = require('hs.styledtext')
    local fmt         = ' %' .. len .. 's '
    local title       = ('* %s'):format(app)
    local text        = styled_text.new(title, styles.title)
                     .. styled_text.new('\n\n', styles.title)

    for c, category in ipairs(binding_tbl) do
        -- Category heading
        text = text
            .. styled_text.new(category.category .. ':', styles.group)
            .. styled_text.new('\n', styles.group)

        -- Category bindings
        for i, binding in ipairs(category.bindings) do
            local display = fmt_key_combinations(binding)

            text = text
                .. styled_text.new(fmt:format(display), styles.key)
                .. styled_text.new('-> ', styles.arrow)
                .. styled_text.new(binding.desc, styles.desc)
                .. ' '

            if i < #category.bindings then
                text = text .. styled_text.new('\n', styles.desc)
            end
        end

        -- Blank line between categories
        if c < #binding_tbl then
            text = text .. styled_text.new('\n\n', styles.desc)
        end
    end

    return text
end


-- Create binding popup menus
--------------------------------------------------------------------------------
local function fmt_binding_popups(app, bindings)
    local content = fmt_menu_text(app, bindings)
    local frame   = get_popup_frame(content)
    local popup   = create_popup(content, frame)

    local binding_data = {
        popup = popup,
        frame = frame,
    }

    return binding_data
end


-- Queue chained actions (i.e. launch window then display related popup)
--------------------------------------------------------------------------------
local function queue_actions(...)
    local actions = { ... }

    return function()
        for _, action in ipairs(actions) do
            if type(action) == 'function' then
                table.insert(state.action_queue.items, action)

            elseif type(action) == 'table' then
                for _, job in ipairs(action) do
                    table.insert(state.action_queue.items, job)
                end
            end
        end

        if state.action_queue.running then
            return
        end

        state.action_queue.running = true

        local function next_job()
            local job = table.remove(state.action_queue.items, 1)

            if not job then
                state.action_queue.running = false
                return
            end

            job(next_job)
        end

        next_job()
    end
end


-- Pack binding lookup table
--------------------------------------------------------------------------------
local function fmt_binding_tbl(bindings)
    local lookup = {}

    for _, category in ipairs(bindings) do
        for _, binding in ipairs(category.bindings) do
            local lookup_key = binding_id(
                binding.key,
                binding.mods
            )
            lookup[lookup_key] = queue_actions(binding.action)
        end
    end

    return lookup
end


-- Create event tap
--------------------------------------------------------------------------------
local function create_event_tap()
    local event_types = {
        hs.eventtap.event.types.keyDown,
        hs.eventtap.event.types.flagsChanged
    }

    local tap = hs.eventtap.new(event_types, function(event)
        local flags   = event:getFlags()
        local keycode = event:getKeyCode()
        local key     = hs.keycodes.map[keycode]

        local win = hs.window.focusedWindow()
        local app = win:application():name()

        local mods = {}

        if flags.cmd   then table.insert(mods, 'cmd') end
        if flags.alt   then table.insert(mods, 'alt') end
        if flags.ctrl  then table.insert(mods, 'ctrl') end
        if flags.shift then table.insert(mods, 'shift') end

        local lookup_key   = binding_id(key, mods)
        local app_lookup   = cache.lookup[app] or {}
        local bound_action = cache.lookup.system[lookup_key]
                          or app_lookup[lookup_key]

        if bound_action then
            bound_action()
        end

        return true
    end)

    return tap
end


--------------------------------------------------------------------------------
-- Init
--------------------------------------------------------------------------------
function M.init()
    -- Init bindings/assets if required
    if not util.tbl(cache.assets) or not util.tbl(cache.lookup) then
        -- Main eventtap bindings
        for app, bindings in pairs(registry.apps) do
            if app == 'insert' then
                cache.assets[app] = fmt_binding_popups(app, bindings)
            else
                cache.lookup[app] = fmt_binding_tbl(bindings)
                cache.assets[app] = fmt_binding_popups(app, bindings)
            end
        end

        -- Create event tap
        cache.assets.tap = create_event_tap()
    end
end

return M
