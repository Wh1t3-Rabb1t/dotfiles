local M = {}

local state    = require('state')
local cache    = require('cache')
local util     = require('util')
local registry = require('wk_registry')
local wk       = require('wk')
local mouse    = require('mouse')

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

local queue = {
    running = false,
    items   = {},
}


-- Create popup.
--
-- Calls:
--   util.rgb()
--
-- Returns:
--   popup (table):  hs.canvas object
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


-- Get the width / height of the popup window.
--
-- Returns:
--   (table):  Frame data corresponding to the 'size' of the text block passed
--------------------------------------------------------------------------------
local function fmt_popup_frame(text)
    local size   = hs.drawing.getTextDrawingSize(text)
    local width  = math.max(size.w)
    local height = math.max(size.h)

    return {
        w = (width + 10),
        h = (height + 10),
    }
end


-- Format bindings with mods.
--
-- Returns:
--   parts (table):  The formatted string representation of each binding
--------------------------------------------------------------------------------
local function fmt_key_combinations(binding)
    local mods = binding.mods or {}
    local key  = binding.key

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


-- Format menu contents.
--
-- Calls:
--   fmt_key_combinations()
--   util.rgb()
--
-- Returns:
--   text (string):  Text portion of the popup menus
--------------------------------------------------------------------------------
local function fmt_menu_text(app_name, binding_tbl)
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
    local title       = ('* %s'):format(app_name)
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


-- Create binding popup menus.
--
-- Calls:
--   fmt_menu_text()
--   fmt_popup_frame()
--   create_popup()
--
-- Returns:
--   (table):  Popup contents and frame data
--------------------------------------------------------------------------------
local function fmt_binding_popups(app_name, bindings)
    local content = fmt_menu_text(app_name, bindings)
    local frame   = fmt_popup_frame(content)
    local popup   = create_popup(content, frame)

    return {
        popup = popup,
        frame = frame,
    }
end


-- Queue chained actions (i.e. launch window then display related popup).
--
-- State changes:
--   queue
--------------------------------------------------------------------------------
local function queue_actions( ... )
    local actions = { ... }

    return function()
        for _, action in ipairs(actions) do
            if type(action) == 'function' then
                table.insert(queue.items, action)

            elseif type(action) == 'table' then
                for _, job in ipairs(action) do
                    table.insert(queue.items, job)
                end
            end
        end

        if queue.running then
            return
        end

        queue.running = true

        local function next_job()
            local job = table.remove(queue.items, 1)

            if not job then
                queue.running = false
                return
            end

            job(next_job)
        end

        next_job()
    end
end


-- Pack binding lookup table.
--
-- Calls:
--   util.binding_id()
--   queue_actions()
--
-- Returns:
--   lookup (table):  Key/fn pairs to be executed by the eventtap at runtime
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


-- Create the main orchestrator event tap.
--
-- Calls:
--   util.binding_id()
--   mouse.press()
--   mouse.release()
--   wk.refresh_state()()
--
-- Return:
--   tap (fn):  hs.eventtap function
--------------------------------------------------------------------------------
local function create_event_tap()
    local events = hs.eventtap.event

    local event_types = {
        events.types.keyDown,
        events.types.flagsChanged,
        events.types.leftMouseUp,
        events.types.leftMouseDown,
        events.types.leftMouseDragged,
        -- events.types.mouseMoved,
    }

    local tap = hs.eventtap.new(event_types, function(event)
        -- hs.timer.usleep(10000)

        -- Mouse events
        --
        -- NOTE: Do not consume mouse click events unless manually invoking
        --       them within the 'mouse' fns otherwise clicks won't work.
        if event:getType() == events.types.leftMouseDown then
            mouse.press()

        elseif event:getType() == events.types.leftMouseDragged then
            mouse.drag(event:location())

        elseif event:getType() == events.types.leftMouseUp then
            mouse.release(event:location())
            wk.refresh_state()()

        -- Keyboard events
        else
            local flags    = event:getFlags()
            local keycode  = event:getKeyCode()
            local key      = hs.keycodes.map[keycode]
            local win      = state.windows.curr_win or hs.window.focusedWindow()
            local app_name = win:application():name()

            local mods = {}

            if flags.cmd   then table.insert(mods, 'cmd') end
            if flags.alt   then table.insert(mods, 'alt') end
            if flags.ctrl  then table.insert(mods, 'ctrl') end
            if flags.shift then table.insert(mods, 'shift') end

            local lookup_key   = util.binding_id(key, mods)
            local app_lookup   = cache.lookup[app_name] or {}
            local bound_action = cache.lookup.system[lookup_key]
                              or app_lookup[lookup_key]

            if bound_action then
                bound_action()
            end

            return true
        end
    end)

    return tap
end


--------------------------------------------------------------------------------
-- Init module.
--
-- Calls:
--   fmt_binding_popups()
--   fmt_binding_tbl()
--   create_event_tap()
--
-- State changes:
--   cache.lookup
--   cache.assets
--   cache.wk_tap
--   state.initialized
--------------------------------------------------------------------------------
function M.init()
    -- Temporary insert bindings
    cache.assets.insert = fmt_binding_popups('insert', {
        {
            category = 'Bound until invoked',
            bindings = {
                { key = 'enter',  desc = 'Relaunch menu' },
                { key = 'escape', desc = 'Cancel'        }
            }
        }
    })

    for app_name, bindings in pairs(registry.apps) do
        cache.lookup[app_name] = fmt_binding_tbl(bindings)
        cache.assets[app_name] = fmt_binding_popups(app_name, bindings)
    end

    cache.wk_tap = create_event_tap()

    state.initialized = true
end

return M
