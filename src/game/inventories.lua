-- backpack, worn equipment and bank access.
--
-- things learnt in game (docs/api-findings.md, check 1):
-- - inventory events hand over a proxy that only has an id, Inventory.Find(id) gets the real one
-- - the bank only exists while its open, so it gets snapshotted every time its sent
-- - backpack and worn are always there and are read live

local catalogue = require("src/tips/catalogue")
local owned_items = require("src/storage/owned_items")

local inventories = {}

local SUBSCRIPTION = "skilling_coach_inventories"
-- inventories that are always around, read live when a tip asks
local LIVE_INVENTORIES = { "INV", "WORN" }

local function find(inv_type_name)
    local ok, inv = pcall(function()
        return Inventory.Find(config.Inv[inv_type_name])
    end)

    if ok and inv and inv.isValid then
        return inv
    end

    return nil
end

local function count_item(inv, item)
    local ok, total = pcall(function()
        return inv:GetTotal(config.Obj[item])
    end)

    return ok and total or 0
end

function inventories.backpack_free_slots()
    local inv = find("INV")
    return inv and inv.freeSlotCount or nil
end

function inventories.bank_is_open()
    return find("BANK") ~= nil
end

local function count_category(inv, category)
    local ok, total = pcall(function()
        return inv:GetCategoryTotal(category)
    end)

    return ok and total or 0
end

-- is it in the backpack or being worn right now
function inventories.carrying_item(item)
    for _, name in ipairs(LIVE_INVENTORIES) do
        local inv = find(name)

        if inv and count_item(inv, item) > 0 then
            return true
        end
    end

    return false
end

function inventories.carrying_category(category)
    for _, name in ipairs(LIVE_INVENTORIES) do
        local inv = find(name)

        if inv and count_category(inv, category) > 0 then
            return true
        end
    end

    return false
end

local function snapshot_bank()
    local bank = find("BANK")

    if not bank then
        return
    end

    local relevant_items, relevant_categories = catalogue.relevant_items()

    owned_items.update_from_bank(relevant_items, relevant_categories, function(item)
        return count_item(bank, item)
    end, function(category)
        return count_category(bank, category)
    end)
end

local function bank_id()
    local ok, inv_type = pcall(function()
        return config.Inv.BANK
    end)

    return ok and inv_type and inv_type.id or nil
end

local function on_inventory_event(event)
    local ok, inv_id = pcall(function()
        return event.inv.id
    end)

    if ok and inv_id ~= nil and inv_id == bank_id() then
        snapshot_bank()
    end
end

function inventories.start()
    Event.InventoryAdded.Subscribe(SUBSCRIPTION, on_inventory_event)
    Event.InventoryUpdated.Subscribe(SUBSCRIPTION, on_inventory_event)
end

function inventories.stop()
    Event.InventoryAdded.Unsubscribe(SUBSCRIPTION)
    Event.InventoryUpdated.Unsubscribe(SUBSCRIPTION)
end

return inventories
