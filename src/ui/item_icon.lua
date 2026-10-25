-- the item id to draw as a tip's icon. tips give either icon_item (an item config name) or
-- icon_item_id (a numeric item id, handy for resources like ores and logs)

local item_icon = {}

-- nil when the tip has no icon or the config name isnt known to the client
function item_icon.id(tip)
    if tip.icon_item_id then
        return tip.icon_item_id
    end

    local ok, item = pcall(function()
        return tip.icon_item and config.Obj[tip.icon_item]
    end)

    return ok and item and item.id or nil
end

return item_icon
