-- backpack, worn equipment and bank access. the only file that reads inventories from the
-- client.
--
-- how the client hands inventories over:
-- - inventory events carry a proxy that only has an id, Inventory.Find gets the real one
-- - the bank only exists while its open, so its contents get snapshotted while it is
-- - backpack and worn equipment are always there and are read live
-- - InventoryUpdated lists the slots that changed (slotsUpdated), so after one full read only
--   those slots need looking at again. slot numbers start at 1

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

-- what the open bank holds, slot number -> { item, category } (false for an empty slot).
-- nil when the bank isnt open or hasnt been read yet
local bank_slots

-- the real inventory for "INV", "WORN" or "BANK", nil when its not available right now
local function find(inv_type_name)
    local ok, inv = pcall(function()
        local found = Inventory.Find(config.Inv[inv_type_name])
        return found and found.isValid and found or nil
    end)

    return ok and inv or nil
end

local function count_item(inv, item)
    local ok, total = pcall(function()
        return inv:GetTotal(config.Obj[item])
    end)

    return ok and type(total) == "number" and total or 0
end

local function count_category(inv, category)
    local ok, total = pcall(function()
        return inv:GetCategoryTotal(category)
    end)

    return ok and type(total) == "number" and total or 0
end

-- { item = config name, category = number } for an InvSlot, nil for an empty slot
local function describe_slot(slot)
    local ok, item, category = pcall(function()
        local obj = slot and slot.obj
        return obj and obj.configName, obj and obj.category
    end)

    if ok and type(item) == "string" and item ~= "" then
        return { item = item, category = category }
    end

    return nil
end

-- one slot (slot numbers start at 1)
local function read_slot(inv, slot_number)
    local ok, slot = pcall(function()
        return inv:GetSlot(slot_number)
    end)

    return ok and describe_slot(slot) or nil
end

-- every slot in one GetSlots call, as slot number -> description (false for empty slots)
local function read_all_slots(inv)
    local ok, slots = pcall(function()
        return inv:GetSlots()
    end)
    local described = {}

    for slot_number, slot in pairs(ok and type(slots) == "table" and slots or {}) do
        described[slot_number] = describe_slot(slot) or false
    end

    return described
end

-- does this event proxy belong to the named inventory
local function is_inventory(proxy, inv_type_name)
    local ok, matches = pcall(function()
        return proxy.id == config.Inv[inv_type_name].id
    end)

    return ok and matches == true
end

-- "INV" or "WORN" for an event proxy, nil for anything else
local function live_inventory_name(proxy)
    for _, name in ipairs(LIVE_INVENTORIES) do
        if is_inventory(proxy, name) then
            return name
        end
    end

    return nil
end

function inventories.is_backpack(proxy)
    return is_inventory(proxy, "INV")
end

-- only the backpack, worn equipment and bank can teach item ownership
function inventories.is_ownership_inventory(proxy)
    return is_inventory(proxy, "INV") or is_inventory(proxy, "WORN") or is_inventory(proxy, "BANK")
end

function inventories.bank_is_open()
    return find("BANK") ~= nil
end

function inventories.backpack_free_slots()
    local inv = find("INV")
    local ok, free = pcall(function()
        return inv and inv.freeSlotCount
    end)

    if ok and math.type(free) == "integer" and free >= 0 then
        return free
    end

    return nil
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

    if not slot_numbers then
        for _, entry in pairs(read_all_slots(inv)) do
            if entry then
                items[#items + 1] = entry
            end
        end

        return items
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

-- brings bank_slots up to date. the first read after the bank opens covers every slot, after
-- that only the slots an update says changed. a deposit-all touches a handful of slots, so
-- this is a few reads per click instead of checking every tip item against the whole bank
local function read_bank(bank, slot_numbers)
    if not bank_slots or not slot_numbers then
        bank_slots = read_all_slots(bank)
        return
    end

    for _, slot_number in ipairs(slot_numbers) do
        bank_slots[slot_number] = read_slot(bank, slot_number) or false
    end
end

-- slot_numbers is the changed slot list from an update, nil to read the whole bank
local function snapshot_bank(slot_numbers)
    local character = character_key.current()
    local bank = character and find("BANK")

    if not bank then
        bank_slots = nil
        return
    end

    read_bank(bank, slot_numbers)

    local items, categories = {}, {}
    for _, entry in pairs(bank_slots) do
        if entry then
            items[entry.item] = true

            if entry.category then
                categories[entry.category] = true
            end
        end
    end

    -- inventory updates can beat the app to noticing a character change
    owned_items.use_character(character)

    local relevant_items, relevant_categories = catalogue.relevant_items()
    owned_items.update_from_bank(relevant_items, relevant_categories, function(item)
        return items[item] and 1 or 0
    end, function(category)
        return categories[category] and 1 or 0
    end)

    if bank_snapshot_listener then
        bank_snapshot_listener()
    end
end

local function on_bank_added(event)
    if is_inventory(event.inv, "BANK") then
        -- a freshly opened bank, start the slot map again from a full read
        bank_slots = nil
        snapshot_bank(nil)
    end
end

local function on_bank_updated(event)
    if is_inventory(event.inv, "BANK") then
        snapshot_bank(event.slotsUpdated)
    end
end

function inventories.start()
    if owner then
        return
    end

    owner = event_owner.new(SUBSCRIPTION)
    owner.subscribe(Event.InventoryAdded, on_bank_added)
    owner.subscribe(Event.InventoryUpdated, on_bank_updated)

    -- the bank might already be open when the plugin starts
    snapshot_bank(nil)
end

-- full re-read, used when the character changes
function inventories.refresh_bank()
    bank_slots = nil
    snapshot_bank(nil)
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

    bank_slots = nil
end

return inventories
