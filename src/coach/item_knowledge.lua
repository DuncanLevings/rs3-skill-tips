-- once an item explains a tip, remember it even after storage, destruction or reclaim.
local catalogue = require("src/tips/catalogue")
local progress = require("src/storage/tip_progress")
local conditions = require("src/coach/conditions")
local inventories = require("src/game/inventories")
local event_owner = require("src/game/event_owner")

local item_knowledge = {}
local owner

function item_knowledge.observe(state)
    if not progress.character() then
        return
    end

    local learned = {}
    for _, tip in ipairs(catalogue.all()) do
        if not progress.is_known(tip.id) then
            for _, condition in ipairs(tip.known_when or {}) do
                -- levels and quest progress are live conditions, not evidence of item ownership.
                if
                    (condition.type == "owns_any" or condition.type == "owns_category")
                    and conditions.check(condition, state)
                then
                    learned[#learned + 1] = tip.id
                    break
                end
            end
        end
    end

    progress.mark_known(learned)
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
            -- inventory subscribers can run in either order; read the bank snapshot first.
            inventories.refresh_bank()
            item_knowledge.observe(options.state)
        end
    end

    owner.subscribe(Event.InventoryAdded, on_inventory)
    owner.subscribe(Event.InventoryUpdated, on_inventory)
end

function item_knowledge.stop()
    if owner then
        owner.destroy()
        owner = nil
    end
end

return item_knowledge
