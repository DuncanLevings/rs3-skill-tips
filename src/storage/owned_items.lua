-- per character snapshot of which tip-relevant items are in the bank.
--
-- the bank only exists while its open (checked in game), so this remembers what was in it the
-- last time the player looked. it only keeps items and categories that tips ask about, never
-- the whole bank. bank_seen stays false until the first visit, tips about owning things wait
-- for that

local saved_table = require("src/storage/saved_table")

local owned_items = {}

local KEY_PREFIX = "skilling_coach_owned_"
local VERSION = 1

local current_character
local snapshot

local function clean_set(saved_set, key_type)
    local result = {}

    if type(saved_set) ~= "table" then
        return result
    end

    for key, flag in pairs(saved_set) do
        if type(key) == key_type and flag == true then
            result[key] = true
        end
    end

    return result
end

function owned_items.use_character(character)
    if character == current_character and snapshot then
        return
    end

    local saved = character and saved_table.load(KEY_PREFIX .. character, VERSION) or {}

    current_character = character
    snapshot = {
        version = VERSION,
        bank_seen = saved.bank_seen == true,
        items = clean_set(saved.items, "string"),
        -- PersistentDB tables keep number keys fine, but category ids are stored as strings
        -- anyway so the saved table never turns into an array with holes
        categories = clean_set(saved.categories, "string"),
    }
end

local function ensure_loaded()
    if not snapshot then
        owned_items.use_character(nil)
    end

    return snapshot
end

function owned_items.bank_seen()
    return ensure_loaded().bank_seen
end

function owned_items.in_bank(item)
    return ensure_loaded().items[item] == true
end

function owned_items.category_in_bank(category)
    return ensure_loaded().categories[tostring(category)] == true
end

-- replaces the snapshot with what the bank holds now. count_item / count_category are given
-- the item name or category and return how many the bank has
function owned_items.update_from_bank(
    relevant_items,
    relevant_categories,
    count_item,
    count_category
)
    local loaded = ensure_loaded()
    loaded.bank_seen = true
    loaded.items = {}
    loaded.categories = {}

    for item in pairs(relevant_items) do
        if (count_item(item) or 0) > 0 then
            loaded.items[item] = true
        end
    end

    for category in pairs(relevant_categories) do
        if (count_category(category) or 0) > 0 then
            loaded.categories[tostring(category)] = true
        end
    end

    if current_character then
        saved_table.save(KEY_PREFIX .. current_character, loaded)
    end
end

return owned_items
