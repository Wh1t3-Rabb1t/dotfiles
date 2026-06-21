local M = {}

function M.all()
    return hs.screen.allScreens()
end

function M.primary()
    return hs.screen.mainScreen()
end

function M.current()
    return hs.mouse.getCurrentScreen()
end

function M.id(screen)
    return screen:getUUID()
end

function M.frame(screen)
    return screen:fullFrame()
end

function M.current_id()
    return M.id(M.current())
end

function M.count()
    return #M.all()
end

function M.dump(value)
    hs.alert.show(hs.inspect(value))
end

return M
