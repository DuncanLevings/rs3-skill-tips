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
-- told after every bank snapshot, item_knowledge uses it to learn from the bank
local bank_snapshot_listener

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

-- only these inventories can teach item ownership; ignore unrelated transient containers.
function inventories.is_ownership_inventory(proxy)
    local ok, matches = pcall(function()
        local number = proxy.id
        return number == config.Inv.INV.id
            or number == config.Inv.WORN.id
            or number == config.Inv.BANK.id
    end)

    return ok and matches == true
end

function inventories.bank_is_open()
    return find("BANK") ~= nil
end

-- the config name and category of whatever sits in one slot, nil for an empty slot
local function read_slot(inv, slot_number)
    local ok, item, category = pcall(function()
        local slot = inv:GetSlot(slot_number)
        local obj = slot and slot.obj
        return obj and obj.configName, obj and obj.category
    end)

    if ok and type(item) == "string" and item ~= "" then
        return { item = item, category = category }
    end
end

-- "INV" or "WORN" for an event proxy, nil for anything else
local function live_inventory_name(proxy)
    for _, name in ipairs(LIVE_INVENTORIES) do
        local ok, matches = pcall(function()
            return proxy.id == config.Inv[name].id
        end)

        if ok and matches then
            return name
        end
    end
end

-- whats in the backpack or worn slots an event says changed, as { item, category } pairs.
-- with no slot list it reads the whole thing, thats only on login and when the inventory
-- first shows up. empty slots, and anything that isnt the backpack or worn, give nothing
function inventories.items_in(proxy, slot_numbers)
    local name = live_inventory_name(proxy)
    local inv = name and find(name)
    local items = {}

    if not inv then
        return items
    end

    if type(slot_numbers) ~= "table" then
        local ok, slot_count = pcall(function()
            return inv.slotCount
        end)
        slot_count = ok and math.type(slot_count) == "integer" and slot_count or 0
        slot_numbers = {}

        -- not sure if slots start at 0 or 1, reading one extra covers both
        for slot_number = 0, slot_count do
            slot_numbers[#slot_numbers + 1] = slot_number
        end
    end

    for _, slot_number in ipairs(slot_numbers) do
        items[#items + 1] = read_slot(inv, slot_number)
    end

    return items
end

-- every item in the backpack and worn slots right now
function inventories.carried_items()
    local items = {}

    for _, name in ipairs(LIVE_INVENTORIES) do
        local ok, proxy = pcall(function()
            return { id = config.Inv[name].id }
        end)

        for _, entry in ipairs(ok and inventories.items_in(proxy) or {}) do
            items[#items + 1] = entry
        end
    end

    return items
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

    if bank_snapshot_listener then
        bank_snapshot_listener()
    end
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

-- theres only one listener (item_knowledge), nil clears it
function inventories.on_bank_snapshot(listener)
    bank_snapshot_listener = listener
end

function inventories.stop()
    if owner then
        owner.destroy()
        owner = nil
    end
end

return inventories
