
-- local Var = require('../vivi_modules/global_variables')

local Scrolling = {
    scrollX = 0,
    scrollY = 0,
    acceleration = 1,
    keyIsHeld = false,
    up = false,
    down = false,
    left = false,
    right = false,
    -- throttleEvents = false,
}

function Scrolling:initiate()
    -- Enable scroll speed acceleration when keys are held down.
    if self.keyIsHeld then
        self.acceleration = self.acceleration + 1
        if self.acceleration > 69 then
            self.acceleration = self.acceleration * 1.5
        end
    else
        self.acceleration = 1
    end
    local scrollMultiplier = 2 + math.log(self.acceleration)

    -- Update relevant coords if the corresponding key is pressed.
    if self.up then -- Scroll up.
        self.scrollY = math.floor(1 * scrollMultiplier)
    elseif self.down then -- Scroll down.
        self.scrollY = math.ceil(-1 * scrollMultiplier)
    elseif self.left then -- Scroll left.
        self.scrollX = math.floor(1 * scrollMultiplier)
    elseif self.right then -- Scroll right.
        self.scrollX = math.ceil(-1 * scrollMultiplier)
    end

    -- Post horizontal scroll event.
    if self.scrollX then
        hs.eventtap.event.newScrollEvent({self.scrollX, 0}, {}, 'line'):post()
    end

    -- Post vertical scroll event.
    if self.scrollY then
        hs.eventtap.event.newScrollEvent({0, self.scrollY}, {}, 'line'):post()
    end
end

function Scrolling:terminate()
    self.scrollX = 0
    self.scrollY = 0
    self.acceleration = 1
    self.keyIsHeld = false
    self.up = false
    self.down = false
    self.left = false
    self.right = false
    -- self.throttleEvents = false
end

return Scrolling

-------------------------------------------------------------------------------------------------------------------------------------

-- local scroll_x_delta = 0
-- local scroll_y_delta = 0

-- -- Set key bindings for scrolling events.
-- if (code == 24 or code == 33 or code == 25 or code == 18) then
--     -- Enable scroll speed acceleration when keys are held down.
--     if repeating ~= 0 then
--         scrolling = scrolling + 1
--         if scrolling > 69 then
--             scrolling = scrolling * 1.5
--         end
--     else
--         scrolling = 1
--     end
--     local scroll_mul = 2 + math.log(scrolling)

--     if code == 24 then -- Scroll up.
--         scroll_y_delta = math.floor(1 * scroll_mul)
--     elseif code == 33 then -- Scroll left.
--         scroll_x_delta = math.floor(1 * scroll_mul)
--     elseif code == 25 then -- Scroll down.
--         scroll_y_delta = math.ceil(-1 * scroll_mul)
--     elseif code == 18 then -- Scroll right.
--         scroll_x_delta = math.ceil(-1 * scroll_mul)
--     end
-- end

-- -- log.d("Scrolling", scrolling, '-', scroll_y_delta)
-- -- log.d("Scrolling", scrolling, '-', scroll_x_delta)

-- -- Post vertical scroll events.
-- if scroll_y_delta ~= 0 then
--     hs.eventtap.event.newScrollEvent({0, scroll_y_delta}, flags, 'line'):post()
-- end

-- -- Post horizontal scroll events.
-- if scroll_x_delta ~= 0 then
--     hs.eventtap.event.newScrollEvent({scroll_x_delta, 0}, flags, 'line'):post()
-- end
