-- history of displayed tips, with pinning; no dismissal restore or replay.
local catalogue = require("src/tips/catalogue")
local progress = require("src/storage/tip_progress")
local recent_history = {}

function recent_history.rows()
    local rows = {}
    for _, entry in ipairs(progress.recent_tips()) do
        local tip = catalogue.get(entry.id)
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

function recent_history.text()
    local lines = {}
    for _, entry in ipairs(progress.recent_tips()) do
        local tip = catalogue.get(entry.id)
        if tip then
            lines[#lines + 1] = tip.title .. "<br>" .. tip.hook
        end
    end

    return #lines > 0 and table.concat(lines, "<br><br>") or "No tips shown yet."
end

return recent_history
