-- backpack, worn equipment and bank access.
--
-- things learnt in game (docs/api-findings.md, check 1):
-- - inventory events hand over a proxy that only has an id, Inventory.Find(id) gets the real one
-- - the bank only exists while its open, so it gets snapshotted every time its sent
-- - backpack and worn are always there and are read live

local catalogue = require("src/tips/catalogue")
local owned_items = require("src/storage/owned_items")
local character_key = require("src/storage/character_key")
local event_owner = require("src/game/event_owner")

local inventories = {}

local SUBSCRIPTION = "skilling_coach_inventories"
-- inventories that are always around, read live when a tip asks
local LIVE_INVENTORIES = { "INV", "WORN" }
local owner

local function find(inv_type_name)
    local ok, inv = pcall(function()
        local found = Inventory.Find(config.Inv[inv_type_name])
        return found and found.isValid and found or nil
    end)

    if ok then
        return inv
    end

    return nil
end

local function count_item(inv, item)
    local ok, total = pcall(function()
        return inv:GetTotal(config.Obj[item])
    end)

    return ok and type(total) == "number" and total or 0
end

function inventories.backpack_free_slots()
    local inv = find("INV")
    local ok, free = pcall(function()
        return inv and inv.freeSlotCount
    end)
    if ok and math.type(free) == "integer" and free >= 0 then
        return free
    end
end

-- is this inventory event about the backpack. events only carry a proxy with an id
function inventories.is_backpack(proxy)
    local ok, matches = pcall(function()
        return proxy.id == config.Inv.INV.id
    end)

    return ok and matches == true
end

function inventories.bank_is_open()
    return find("BANK") ~= nil
end

local function count_category(inv, category)
    local ok, total = pcall(function()
        return inv:GetCategoryTotal(category)
    end)

    return ok and type(total) == "number" and total or 0
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
    local character = character_key.current()
    if not character then
        return
    end

    local bank = find("BANK")

    if not bank then
        return
    end

    local relevant_items, relevant_categories = catalogue.relevant_items()
    -- inventory updates can beat the app to noticing a character change
    owned_items.use_character(character)

    owned_items.update_from_bank(relevant_items, relevant_categories, function(item)
        return count_item(bank, item)
    end, function(category)
        return count_category(bank, category)
    end)
end

local function bank_id()
    local ok, id = pcall(function()
        return config.Inv.BANK.id
    end)

    return ok and id or nil
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
    if owner then
        return
    end

    owner = event_owner.new(SUBSCRIPTION)
    owner.subscribe(Event.InventoryAdded, on_inventory_event)
    owner.subscribe(Event.InventoryUpdated, on_inventory_event)
    snapshot_bank()
end

function inventories.refresh_bank()
    snapshot_bank()
end

function inventories.stop()
    if owner then
        owner.destroy()
        owner = nil
    end
end

return inventories
