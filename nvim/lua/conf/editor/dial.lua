--       _ _       _
--    __| (_) __ _| |
--   / _` | |/ _` | |
--  | (_| | | (_| | |
--   \__,_|_|\__,_|_|
-- =============================================================================

local M = {}

-- CONFIG
--------------------------------------------------------------------------------
function M.config()
    local status_ok = pcall(require, "dial.config")
    if not status_ok then return end

    -- Setup
    local augend = require("dial.augend")
    require("dial.config").augends:register_group({
        default = {

            -- Numbers
            augend.integer.alias.decimal,
            augend.integer.alias.decimal_int,

            -- Date
            augend.date.alias["%d/%m/%Y"],
            augend.date.alias["%d/%m/%y"],
            augend.date.alias["%d.%m.%Y"],
            augend.date.alias["%d.%m.%y"],

            -- Time
            augend.date.alias["%H:%M:%S"],
            augend.date.alias["%H:%M"],

            -- Constants
            augend.constant.alias.bool,
            augend.constant.new({
                elements = { "and", "or" },
                word = true,  -- If false, "sand" is incremented into "sor", etc.
                cyclic = true,
            }),
            augend.constant.new({
                elements = { "&&", "||" },
                word = false,
                cyclic = true,
            }),
            augend.constant.new({
                elements = { "==", "!=" },
                word = false,
                cyclic = true,
            }),
            augend.constant.new({
                elements = { "<", ">" },
                word = false,
                cyclic = true,
            }),
            augend.constant.new({
                elements = { "++", "+=", "-=", "*=", "--" },
                word = false,
                cyclic = true,
            }),
            augend.constant.new({
                elements = { "horizontal", "vertical" },
                word = true,
                cyclic = true,
            }),
            augend.constant.new({
                elements = { "forward", "backward" },
                word = true,
                cyclic = true,
            }),
            augend.constant.new({
                elements = { "up", "down", "left", "right" },
                word = true,
                cyclic = true,
            }),
            augend.constant.new({
                elements = { "Up", "Down", "Left", "Right" },
                word = true,
                cyclic = true,
            }),
            augend.constant.new({
                elements = {
                    "mon",
                    "tue",
                    "wed",
                    "thu",
                    "fri",
                    "sat",
                    "sun"
                },
                word = true,
                cyclic = true,
            }),
            augend.constant.new({
                elements = {
                    "Mon",
                    "Tue",
                    "Wed",
                    "Thu",
                    "Fri",
                    "Sat",
                    "Sun"
                },
                word = true,
                cyclic = true,
            }),
            augend.constant.new({
                elements = {
                    "monday",
                    "tuesday",
                    "wednesday",
                    "thursday",
                    "friday",
                    "saturday",
                    "sunday"
                },
                word = true,
                cyclic = true,
            }),
            augend.constant.new({
                elements = {
                    "Monday",
                    "Tuesday",
                    "Wednesday",
                    "Thursday",
                    "Friday",
                    "Saturday",
                    "Sunday"
                },
                word = true,
                cyclic = true,
            })
        }
    })
end

return M
