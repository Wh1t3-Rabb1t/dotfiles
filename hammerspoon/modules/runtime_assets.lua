local M = {}

local state   = require('state')
local cache   = require('cache')
local wk      = require('wk')
local mouse   = require('mouse')
local keymaps = require('runtime_keymaps')


-- Local state.
--------------------------------------------------------------------------------
local queue = {
    running = false,
    items   = {},
}

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


-- Add shift modifier to a binding declaration using an uppercase letter.
--
-- Parameters:
--   mods (string):  mod name string i.e. 'ctrl'
--
-- Returns:
--   result (table):  A list of mod name strings
--------------------------------------------------------------------------------
local function add_shift(mods)
    local result = {}

    if mods then
        for i, mod in ipairs(mods) do
            result[i] = mod
        end
    end

    table.insert(result, 'shift')

    return result
end


-- Construct a binding field.
--
-- Parameters:
--   (table):  Binding table declared in its respective registry
--
-- Calls:
--   add_shift()
--
-- Returns:
--   binding_field (table):  key, desc, and action data
--------------------------------------------------------------------------------
local function bind( ... )
    local binding_field = {}

    for _, args in ipairs({ ... }) do
        local key
        local mods
        local desc
        local action_start

        -- If a modifier was passed along with the key
        if type(args[1]) == 'table' then
            mods         = args[1]
            key          = args[2]
            desc         = args[3]
            action_start = 4
        else
            key          = args[1]
            desc         = args[2]
            action_start = 3
        end

        -- Uppercase letters and shifted punctuation implicitly mean shift
        if #key == 1 then
            if key:match('%u') then
                key  = key:lower()
                mods = add_shift(mods)
            elseif shift_chars[key] then
                key  = shift_chars[key]
                mods = add_shift(mods)
            end
        end

        local action_count = #args - action_start + 1

        local binding = {
            key  = key,
            desc = desc,
        }

        if mods then
            binding.mods = mods
        end

        -- If one action is passed, store it as a function
        if action_count == 1 then
            binding.action = args[action_start]

        -- If multiple actions are passed, store them as a table of functions
        elseif action_count > 1 then
            binding.action = {}

            for i = action_start, #args do
                table.insert(binding.action, args[i])
            end
        end

        table.insert(binding_field, binding)
    end

    return binding_field
end


-- Normalize bindings with modifiers.
--
-- Parameters:
--   key  (string):  key name string i.e. 'space'
--   mods (table):   mod name strings i.e. 'ctrl'
--
-- Returns:
--   (table):  Formatted key / mod declaration strings
--------------------------------------------------------------------------------
local function binding_id(key, mods)
    if not mods or #mods == 0 then
        return key
    end

    table.sort(mods)

    return table.concat(mods, '+') .. '+' .. key
end


-- Format rgb table.
--
-- Parameters:
--   r       (number): Between 0 and 255
--   g       (number): Between 0 and 255
--   b       (number): Between 0 and 255
--   opacity (number): Between 0 and 1
--
-- Returns:
--   (table):  An rbg table compatible with hs.canvas fields
--------------------------------------------------------------------------------
local function rgb(r, g, b, opacity)
    opacity = opacity or 1.0

    return {
        red   = r / 255,
        green = g / 255,
        blue  = b / 255,
        alpha = opacity,
    }
end


-- Create popup.
--
-- Parameters:
--   content (string):  Formatted key / action bindings list
--   frame   (table):   hs.window:frame()
--
-- Calls:
--   rgb()
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


-- Get the width / height of the popup window.
--
-- Parameters:
--   content (string):  Formatted key / action bindings list
--
-- Returns:
--   (table):  Frame data corresponding to the 'size' of the text block passed
--------------------------------------------------------------------------------
local function fmt_popup_frame(content)
    local size   = hs.drawing.getTextDrawingSize(content)
    local width  = math.max(size.w)
    local height = math.max(size.h)

    return {
        w = (width + 10),
        h = (height + 10),
    }
end


-- Format bindings with mods.
--
-- Parameters:
--   binding_tbl (table):  key, desc, and action data
--
-- Returns:
--   parts (table):  The formatted string representation of each binding
--------------------------------------------------------------------------------
local function fmt_key_combinations(binding_tbl)
    local mods = binding_tbl.mods or {}
    local key  = binding_tbl.key

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
-- Parameters:
--   app_name    (string):  hs.application:name()
--   binding_tbl (table):   All bindings for each declared app/module
--
-- Calls:
--   fmt_key_combinations()
--   rgb()
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
        title = { font = title_font, color = rgb(205, 205, 205) },
        group = { font = base_font,  color = rgb(150, 200, 255) },
        key   = { font = base_font,  color = rgb(0, 255, 0)     },
        arrow = { font = base_font,  color = rgb(100, 100, 100) },
        desc  = { font = base_font,  color = rgb(255, 255, 255) },
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
-- Parameters:
--   app_name    (string):  hs.application:name()
--   binding_tbl (table):   All bindings for each declared app/module
--
-- Calls:
--   fmt_menu_text()
--   fmt_popup_frame()
--   create_popup()
--
-- Returns:
--   (table):  Popup contents and frame data
--------------------------------------------------------------------------------
local function fmt_binding_popups(app_name, binding_tbl)
    local content = fmt_menu_text(app_name, binding_tbl)
    local frame   = fmt_popup_frame(content)
    local popup   = create_popup(content, frame)

    return {
        popup = popup,
        frame = frame,
    }
end


-- Queue chained actions (i.e. launch window then display related popup).
--
-- Parameters:
--   (table):  Action(s) to be queued for execution at runtime
--
-- State changes:
--   queue.items
--   queue.running
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
-- Parameters:
--   binding_tbl (table):
--
-- Calls:
--   binding_id()
--   queue_actions()
--
-- Returns:
--   lookup (table):  Key/fn pairs to be executed by the eventtap at runtime
--------------------------------------------------------------------------------
local function fmt_binding_tbl(binding_tbl)
    local lookup = {}

    for _, category in ipairs(binding_tbl) do
        for _, binding in ipairs(category.bindings) do
            local action    = binding.action
            local direction = mouse.get_move_direction(action)

            local lookup_key = binding_id(
                binding.key,
                binding.mods
            )

            lookup[lookup_key] = {
                action    = queue_actions(action),
                direction = direction,
            }
        end
    end

    return lookup
end


-- Create the main orchestrator event tap.
--
-- Calls:
--   binding_id()
--   mouse.press()
--   mouse.release()
--   wk.refresh()()
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
    }

    local tap = hs.eventtap.new(event_types, function(event)

        -- Key events
        if event:getType() == events.types.keyDown then
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

            local lookup_key = binding_id(key, mods)
            local app_lookup = cache.lookup[app_name] or {}
            local binding    = cache.lookup.wk[lookup_key] or app_lookup[lookup_key]

            if binding then
                binding.action()
            end

            return true

        -- Mouse events
        --
        -- NOTE: Do not consume mouse click events unless manually invoking
        --       them within the 'mouse' fns otherwise clicks won't work.
        else
            local types    = hs.eventtap.event.types
            local evt_type = event:getType(true)

            if evt_type == types.leftMouseDown then
                mouse.press()

            elseif evt_type == types.leftMouseDragged then
                mouse.drag(event:location())

            elseif evt_type == types.leftMouseUp then
                mouse.release(event:location())
                wk.refresh()()
            end
        end
    end)

    return tap
end


-- Create the main orchestrator mouse tap.
--
-- Calls:
--   binding_id()
--   mouse.press()
--   mouse.release()
--   wk.refresh()()
--
-- Return:
--   tap (fn):  hs.eventtap function
--------------------------------------------------------------------------------
local function create_mouse_tap()
    local events = hs.eventtap.event
    local types  = events.types

    local event_types = {
        events.types.keyUp,
        events.types.keyDown,
    }

    local consumed = state.mouse.consumed

    local tap = hs.eventtap.new(event_types, function(event)
        local event_type = event:getType()
        local keycode    = event:getKeyCode()
        local key        = hs.keycodes.map[keycode]
        local directions = state.mouse.active_directions

        if not key then
            return false
        end

        -- Key down
        if event_type == types.keyDown then
            local flags = event:getFlags()
            local mods  = {}

            if flags.cmd   then table.insert(mods, 'cmd') end
            if flags.alt   then table.insert(mods, 'alt') end
            if flags.ctrl  then table.insert(mods, 'ctrl') end
            if flags.shift then table.insert(mods, 'shift') end

            local lookup_key = binding_id(key, mods)
            local binding    = cache.lookup.mouse[lookup_key]

            if binding then
                consumed[keycode] = true

                if binding.direction then
                    -- Ignore autorepeat for an already-held key
                    if not directions[keycode] then
                        directions[keycode] = binding.direction

                        binding.action()
                    end
                else
                    binding.action()
                end

                return true
            elseif consumed[keycode] then
                return true
            end

        -- Key up
        elseif event_type == types.keyUp then
            local was_consumed = consumed[keycode]

            consumed[keycode]   = nil
            directions[keycode] = nil

            -- Stop only when every movement key has been released
            if next(directions) == nil then
                mouse.stop_movement_timer()()
            end

            return was_consumed == true
        end

        return false
    end)

    return tap
end


--------------------------------------------------------------------------------
-- Init module.
--
-- Calls:
--   fmt_binding_tbl()
--   fmt_binding_popups()
--   create_event_tap()
--
-- State changes:
--   cache.initialized
--------------------------------------------------------------------------------
function M.init()
    -- Pass each binding table in apps.* to the bind() fn for processing
    for _, categories in pairs(keymaps.apps) do
        for _, category in ipairs(categories) do
            category.bindings = bind(table.unpack(category.bindings))
        end
    end

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

    -- Runtime bindings/assets
    for app_name, bindings in pairs(keymaps.apps) do
        cache.lookup[app_name] = fmt_binding_tbl(bindings)
        cache.assets[app_name] = fmt_binding_popups(app_name, bindings)
    end

    -- Create taps
    cache.taps.wk    = create_event_tap()
    cache.taps.mouse = create_mouse_tap()

    cache.initialized = true
end

return M
