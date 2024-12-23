
local ScreenWatcher = {
    isActive = false,
    appCachedFrame = {},
    screenCachedFrame = {},
}

local jumpKeyTable = {
    { key = 'w', value = { 6, 1, 6, 1 } }, -- Top left.
    { key = 'e', value = { 2, 1, 6, 1 } }, -- Top center.
    { key = 'r', value = { 6, 5, 6, 1 } }, -- Top right.
    { key = 's', value = { 6, 1, 2, 1 } }, -- Center left.
    { key = 'd', value = { 2, 1, 2, 1 } }, -- Center.
    { key = 'f', value = { 6, 5, 2, 1 } }, -- Center right.
    { key = 'x', value = { 6, 1, 6, 5 } }, -- Bottom left.
    { key = 'c', value = { 2, 1, 6, 5 } }, -- Bottom center.
    { key = 'v', value = { 6, 5, 6, 5 } }, -- Bottom right.
}

-- Callback for mapping the jump coordinates of the chosen screen or app frame.
local function mapJumpCoords(frame, jumpCode)
    local widthDiv = jumpCode[1]
    local widthMul = jumpCode[2]
    local heightDiv = jumpCode[3]
    local heightMul = jumpCode[4]
    local posX = frame.x + (frame.w / widthDiv) * widthMul
    local posY = frame.y + (frame.h / heightDiv) * heightMul
    local pos = { x = posX, y = posY }
    return pos
end

-- Callback for mapping the sub-jump coords that correspond to each initial point.
local function mapSubCoords(jumpCoords, gridSize)
    local function plus(num1, num2) return num1 + num2 end
    local function minus(num1, num2) return num1 - num2 end
    local subPos = {
        w = { -- Top left.
            x = minus(jumpCoords.x, gridSize.width),
            y = minus(jumpCoords.y, gridSize.height),
        },
        e = { -- Top center.
            x = jumpCoords.x,
            y = minus(jumpCoords.y, gridSize.height),
        },
        r = { -- Top right.
            x = plus(jumpCoords.x, gridSize.width),
            y = minus(jumpCoords.y, gridSize.height),
        },
        s = { -- Center left.
            x = minus(jumpCoords.x, gridSize.width),
            y = jumpCoords.y,
        },
        f = { -- Center right.
            x = plus(jumpCoords.x, gridSize.width),
            y = jumpCoords.y,
        },
        x = { -- Bottom left.
            x = minus(jumpCoords.x, gridSize.width),
            y = plus(jumpCoords.y, gridSize.height),
        },
        c = { -- Bottom center.
            x = jumpCoords.x,
            y = plus(jumpCoords.y, gridSize.height),
        },
        v = { -- Bottom right.
            x = plus(jumpCoords.x, gridSize.width),
            y = plus(jumpCoords.y, gridSize.height),
        }
    }
    return subPos
end

-- Callback for caching the relevant grid coords.
local function mapGrid(ChosenModule, frame, Var)
    local gridSize = {
        x = frame.x,
        y = frame.y,
        w = frame.w / 3,
        h = frame.h / 3,
        width = frame.w / 9,
        height = frame.h / 9,
    }

    local subGridPlacement = {
        w = { x = gridSize.x, y = gridSize.y },
        e = { x = gridSize.x + gridSize.w, y = gridSize.y },
        r = { x = gridSize.x + (gridSize.w * 2), y = gridSize.y },
        s = { x = gridSize.x, y = gridSize.y + gridSize.h },
        d = { x = gridSize.x + gridSize.w, y = gridSize.y + gridSize.h },
        f = { x = gridSize.x + (gridSize.w * 2), y = gridSize.y + gridSize.h },
        x = { x = gridSize.x, y = gridSize.y + (gridSize.h * 2) },
        c = { x = gridSize.x + gridSize.w, y = gridSize.y + (gridSize.h * 2) },
        v = { x = gridSize.x + (gridSize.w * 2), y = gridSize.y + (gridSize.h * 2) },
        size = { w = gridSize.w, h = gridSize.h },
    }

    for _, v in ipairs(jumpKeyTable) do
        local letter = v.key
        local jumpCode = v.value
        local jumpCoords = mapJumpCoords(frame, jumpCode)
        local subCoords = mapSubCoords(jumpCoords, gridSize)
        ChosenModule.mappedCoords[letter] = jumpCoords -- Save the coordinates in ChosenModule.mappedCoords table.
        ChosenModule.subGridMappedCoords[letter] = subCoords -- Save the coordinates in ChosenModule.subGridMappedCoords table.
        ChosenModule:mapCoords(letter, jumpCoords, subGridPlacement, Var)
    end
end

-- ! ERROR: LuaSkin: hs.canvas:invalid percentage string specified for field x of frame for element 16
-- ! ERROR: .hammerspoon////vivi_modules/screen_watcher.lua:237: attempt to index a nil value (local 'appFrame')

-- Pass in a reference to the AppGrid module.
function ScreenWatcher:initiate(AppGridModule, ScreenGridModule, Var)
    -- If the timer is already running cancel repeated execution.
    if self.isActive then
        return
    end
    self.isActive = true
    hs.alert('Screen watcher is operational.')
    print('Screen watcher is operational.')

    windowWatcher = hs.timer.new(0.25, function()
        local currentScreen = hs.mouse.getCurrentScreen()
        local screenFrame = currentScreen:fullFrame()
        local desktopWindow = hs.window.desktop()
        local appFrame = nil

        if hs.window.focusedWindow() == desktopWindow then
            appFrame = screenFrame
        elseif not hs.window.focusedWindow() then
            appFrame = screenFrame
        else
            local focusedWindow = hs.window.focusedWindow()
            if focusedWindow then
                appFrame = focusedWindow:frame()
            else
                return -- Avoid further execution if focusedWindow is still nil.
            end
        end

        -- If the currently focused app frame has changed.
        if appFrame.w ~= self.appCachedFrame.w
            or appFrame.h ~= self.appCachedFrame.h
            or appFrame.x ~= self.appCachedFrame.x
            or appFrame.y ~= self.appCachedFrame.y
        then
            AppGridModule:hideGrid()
            self.appCachedFrame = appFrame
            AppGridModule.mappedCoords = {} -- Clear the AppGridModule.mappedCoords table.
            mapGrid(AppGridModule, self.appCachedFrame, Var)
        end

        -- If the currently focused screen frame has changed.
        if screenFrame.w ~= self.screenCachedFrame.w
            or screenFrame.h ~= self.screenCachedFrame.h
        then
            ScreenGridModule:hideGrid()
            self.screenCachedFrame = screenFrame
            ScreenGridModule.mappedCoords = {} -- Clear the ScreenGridModule.mappedCoords table.
            mapGrid(ScreenGridModule, self.screenCachedFrame, Var)
        end
    end)
    windowWatcher:start()
end

function ScreenWatcher:terminate()
    if windowWatcher then
        windowWatcher:stop()
        windowWatcher = nil
        self.isActive = false
        print('Screen watcher has stopped.')
    end
end

-- return ScreenWatcher
