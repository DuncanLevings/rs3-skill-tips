-- item tips use probed config names; resource illustrations can use verified wiki item ids.
local item_icon = {}

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
