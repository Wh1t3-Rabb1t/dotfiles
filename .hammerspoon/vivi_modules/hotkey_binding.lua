
-- local modules = require('../module_routes')

return function(tmod, tkey)
    local tapmods = {['cmd']=false, ['ctrl']=false, ['alt']=false, ['shift']=false}
    local eventTypes = hs.eventtap.event.types
    local keyStrokeHandler = nil

    -- Bind a selected flag to the key used to toggle mouse control on/off.
    if type(tmod) == 'string' then
        tapmods[tmod] = true
    else
        for i, v in ipairs(tmod) do
            tapmods[v] = true
        end
    end

    keyStrokeHandler = hs.eventtap.new({eventTypes.keyDown, eventTypes.keyUp}, function(event)
        local code = event:getKeyCode()
        local key = hs.keycodes.map[code]
        local flags = event:getFlags()
        local is_tapkey = code == hs.keycodes.map[tkey]

        -- If the mouse control toggle key is pressed set the associated flag in the table to false.
        if is_tapkey == true then
            for i, v in pairs(tapmods) do
                if flags[i] == nil then
                    flags[i] = false
                end
                -- If the current flag is not == the mouse toggle binding then remain in mouse control mode.
                if tapmods[i] ~= flags[i] then
                    is_tapkey = false
                    break
                end
            end
        end

        -- Toggle back to insert mode if the set key binding is pressed.
        if is_tapkey then
            keyStrokeHandler:stop()
            return true
        end

        if key == 'h' then
            print('Hello World!')
        end

        return true
    end)

    -- Bind the flag/key passed into the function as arguments to toggle mouse control on/off.
    hs.hotkey.bind(tmod, tkey, nil, function(event)
        keyStrokeHandler:start()
    end)
end
