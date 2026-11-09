local M = {}


--------------------------------------------------------------------------------
-- Display console if not visible.
--------------------------------------------------------------------------------
function M.show_if_hidden()
    local console = hs.console.hswindow()

    if not console or not console:isVisible() then
        hs.openConsole()
    end
end


--------------------------------------------------------------------------------
-- Apply darkmode to the HS console.
--------------------------------------------------------------------------------
function M.init()
    hs.console.darkMode(true)
    hs.console.consoleFont({ name = 'Courier', size = 20 })
    hs.console.consoleCommandColor({ blue = 1 })
    hs.console.consoleResultColor({ red = 1 })
    hs.console.windowBackgroundColor({ white = 0 })
    hs.console.inputBackgroundColor({ white = 0 })
    hs.console.outputBackgroundColor({ white = 0 })
    hs.console.consolePrintColor({ white = 1 })
    hs.console.alpha(1)
    hs.console.clearConsole()
end

return M
