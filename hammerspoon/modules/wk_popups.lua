local M = {}

local registry = require('wk_registry')
local state    = require('state')
local cache    = require('cache')
local util     = require('util')


-- Create popup
--------------------------------------------------------------------------------
local function create_popup(content, frame)
    local popup = hs.canvas.new(frame)

    popup:appendElements(
        {
            type        = 'rectangle',
            action      = 'strokeAndFill',
            fillColor   = util.rgb(1, 2, 3),        -- Black
            strokeColor = util.rgb(255, 255, 255),  -- White
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
local function fmt_popup_frame(text)
    local size          = hs.drawing.getTextDrawingSize(text)
    local width  = math.max(size.w)
    local height = math.max(size.h)

    return {
        w = (width + 10),
        h = (height + 10),
    }
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
                key           = key:upper()
                consume_shift = true
            elseif shift_chars[key] then
                key           = shift_chars[key]
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
        title = { font = title_font, color = util.rgb(205, 205, 205) },
        group = { font = base_font,  color = util.rgb(150, 200, 255) },
        key   = { font = base_font,  color = util.rgb(0, 255, 0)     },
        arrow = { font = base_font,  color = util.rgb(100, 100, 100) },
        desc  = { font = base_font,  color = util.rgb(255, 255, 255) },
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
    local frame   = fmt_popup_frame(content)
    local popup   = create_popup(content, frame)

    return {
        popup = popup,
        frame = frame,
    }
end


-- Queue chained actions (i.e. launch window then display related popup)
--------------------------------------------------------------------------------
local function queue_actions(...)
    local actions = { ... }

    return function()
        local aq = state.action_queue

        for _, action in ipairs(actions) do
            if type(action) == 'function' then
                table.insert(aq.items, action)

            elseif type(action) == 'table' then
                for _, job in ipairs(action) do
                    table.insert(aq.items, job)
                end
            end
        end

        if aq.running then
            return
        end

        aq.running = true

        local function next_job()
            local job = table.remove(aq.items, 1)

            if not job then
                aq.running = false
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
            local lookup_key = util.binding_id(
                binding.key,
                binding.mods
            )

            lookup[lookup_key] = queue_actions(binding.action)
        end
    end

    return lookup
end


--------------------------------------------------------------------------------
-- Init
--------------------------------------------------------------------------------
function M.init()
    -- Main eventtap bindings
    for app, bindings in pairs(registry.apps) do
        if app == 'insert' then
            cache.assets[app] = fmt_binding_popups(app, bindings)
        else
            cache.lookup[app] = fmt_binding_tbl(bindings)
            cache.assets[app] = fmt_binding_popups(app, bindings)
        end
    end
end

return M
