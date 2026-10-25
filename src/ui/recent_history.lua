-- rows for the recent tips window: the last 10 tips shown, newest first, each with a pin
-- button (greyed out once its pinned)

local catalogue = require("src/tips/catalogue")
local progress = require("src/storage/tip_progress")

local recent_history = {}

function recent_history.rows()
    local rows = {}

    for _, entry in ipairs(progress.recent_tips()) do
        local tip = catalogue.get(entry.id)

        -- a tip removed in a later version just drops out of the list
        if tip then
            local pinned = progress.is_pinned(tip.id)

            rows[#rows + 1] = {
                id = tip.id,
                title = tip.title,
                icon_item = tip.icon_item,
                icon_item_id = tip.icon_item_id,
                body = tip.hook,
                order = entry.order,
                icon = "pin",
                disabled = pinned,
                tooltip = pinned and "Already pinned" or "Pin tip",
                action = function()
                    progress.pin(tip.id)
                end,
            }
        end
    end

    return rows
end

return recent_history
