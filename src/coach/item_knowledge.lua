-- once an item explains a tip, remember it even after storage, destruction or reclaim.
--
-- known is permanent, so only items turning up matter, taking one away never un-knows a tip.
-- that means an inventory update only has to look at the slots that changed, and each item
-- is one lookup in the catalogue's ownership index. levels and quest progress are live
-- conditions, not evidence of owning something, so they never end up here

local catalogue = require("src/tips/catalogue")
local progress = require("src/storage/tip_progress")
local owned_items = require("src/storage/owned_items")
local inventories = require("src/game/inventories")
local event_owner = require("src/game/event_owner")

local item_knowledge = {}

local owner

local function collect(learned, tip_ids)
    for _, tip_id in ipairs(tip_ids or {}) do
        if not progress.is_known(tip_id) then
            learned[tip_id] = true
        end
    end
end

-- entries are { item = config name, category = number } pairs
local function learn_from(entries)
    if not progress.character() then
        return
    end

    local index = catalogue.ownership_index()
    local learned = {}

    for _, entry in ipairs(entries) do
        collect(learned, entry.item and index.items[entry.item])
        collect(learned, entry.category and index.categories[entry.category])
    end

    local tip_ids = {}
    for tip_id in pairs(learned) do
        tip_ids[#tip_ids + 1] = tip_id
    end

    -- mark_known only saves when something new got added
    progress.mark_known(tip_ids)
end

local function bank_entries()
    local entries = {}

    owned_items.each_in_bank(function(item)
        entries[#entries + 1] = { item = item }
    end, function(category)
        entries[#entries + 1] = { category = category }
    end)

    return entries
end

-- the bank snapshot only holds tip items, so this never touches the game
function item_knowledge.learn_from_bank()
    learn_from(bank_entries())
end

-- full check of the backpack, worn slots and remembered bank. only on startup and character
-- changes, inventory updates look at the changed slots instead
function item_knowledge.observe()
    if not progress.character() then
        return
    end

    learn_from(inventories.carried_items())
    item_knowledge.learn_from_bank()
end

function item_knowledge.start(options)
    item_knowledge.stop()
    owner = event_owner.new("skilling_coach_item_knowledge")

    local function on_inventory(event)
        if not inventories.is_ownership_inventory(event.inv) then
            return
        end

        options.before_observe()

        if Player.IsAvailable() then
            -- no slot list (InventoryAdded) reads the whole thing. bank events give nothing
            -- here, the bank snapshot listener below covers those
            learn_from(inventories.items_in(event.inv, event.slotsUpdated))
        end
    end

    owner.subscribe(Event.InventoryAdded, on_inventory)
    owner.subscribe(Event.InventoryUpdated, on_inventory)

    -- inventories reads the bank, this hears about it once that snapshot is done so the bank
    -- only gets read once per update
    inventories.on_bank_snapshot(function()
        options.before_observe()
        item_knowledge.learn_from_bank()
    end)

    item_knowledge.observe()
end

function item_knowledge.stop()
    if owner then
        owner.destroy()
        owner = nil
    end

    inventories.on_bank_snapshot(nil)
end

return item_knowledge
