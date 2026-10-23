-- per character memory of what happened to each tip: dismissed for good, or pinned for later.
--
-- "already shown this session" is kept in memory only, so a tip the player clicked Later on
-- can come back another day

local skills = require("src/data/skills")
local saved_table = require("src/storage/saved_table")

local tip_progress = {}

local KEY_PREFIX = "skilling_coach_progress_"
local VERSION = 1

local current_character
local progress
local shown_this_session = {}
-- things that want to know when pins or dismissals change (the ribbon window's pinned list)
local listeners = {}

-- keeps only entries that look right, so a damaged save loses the bad bits not everything
local function clean_set(saved_set)
    local result = {}

    if type(saved_set) ~= "table" then
        return result
    end

    for tip_id, flag in pairs(saved_set) do
        if type(tip_id) == "string" and flag == true then
            result[tip_id] = true
        end
    end

    return result
end

local function notify()
    for _, listener in pairs(listeners) do
        listener()
    end
end

-- saves and tells anyone listening, every change goes through here
local function save()
    if current_character then
        saved_table.save(KEY_PREFIX .. current_character, progress)
    end

    notify()
end

-- name is so the same listener can be swapped or removed later
function tip_progress.listen(name, listener)
    listeners[name] = listener
end

function tip_progress.stop_listening(name)
    listeners[name] = nil
end

-- Additive version-1 field: older saves simply start with an empty queue.
local function clean_pending(saved)
    local result = {}
    for skill, levels in pairs(type(saved) == "table" and saved or {}) do
        if
            skills.is_skill(skill)
            and type(levels) == "table"
            and math.type(levels.old) == "integer"
            and math.type(levels.new) == "integer"
            and levels.old >= 1
            and levels.new <= 120
            and levels.new > levels.old
        then
            result[skill] = { old = levels.old, new = levels.new }
        end
    end
    return result
end

local function clean_history(saved)
    local history = {}
    for _, entry in ipairs(type(saved) == "table" and saved or {}) do
        if
            type(entry) == "table"
            and type(entry.id) == "string"
            and entry.id ~= ""
            and math.type(entry.order) == "integer"
            and entry.order > 0
        then
            history[#history + 1] = { id = entry.id, order = entry.order }
        end
    end
    table.sort(history, function(a, b)
        return a.order > b.order
    end)
    -- Keep the newest occurrence before applying the cap, including older saved duplicates.
    local unique, seen = {}, {}
    for _, entry in ipairs(history) do
        if not seen[entry.id] then
            seen[entry.id] = true
            unique[#unique + 1] = entry
            if #unique == 10 then
                break
            end
        end
    end
    return unique
end

local function load_character(character)
    local saved = character and saved_table.load(KEY_PREFIX .. character, VERSION) or {}

    current_character = character
    shown_this_session = {}
    progress = {
        version = VERSION,
        dismissed = clean_set(saved.dismissed),
        pinned = clean_set(saved.pinned),
        pending_level_ups = clean_pending(saved.pending_level_ups),
        recent_tips = clean_history(saved.recent_tips),
        queued_quests = clean_set(saved.queued_quests),
    }
end

-- switches to a character's saved progress. call again whenever the logged in character changes
function tip_progress.use_character(character)
    if character == current_character and progress then
        return
    end

    load_character(character)
    notify()
end

-- quietly sets up an empty progress the first time anything asks. no notify here, a listener
-- reading the pins would otherwise get told to redraw while its still drawing
local function ensure_loaded()
    if not progress then
        load_character(nil)
    end

    return progress
end

function tip_progress.is_dismissed(tip_id)
    return ensure_loaded().dismissed[tip_id] == true
end

function tip_progress.is_pinned(tip_id)
    return ensure_loaded().pinned[tip_id] == true
end

function tip_progress.dismiss(tip_id)
    ensure_loaded().dismissed[tip_id] = true
    progress.pinned[tip_id] = nil
    save()
end

-- pinning also takes the tip off the card queue, it stays in the pinned window now
function tip_progress.pin(tip_id)
    ensure_loaded().pinned[tip_id] = true
    save()
end

function tip_progress.unpin(tip_id)
    ensure_loaded().pinned[tip_id] = nil
    save()
end

function tip_progress.pinned_ids()
    local ids = {}

    for tip_id in pairs(ensure_loaded().pinned) do
        ids[#ids + 1] = tip_id
    end

    table.sort(ids)

    return ids
end

function tip_progress.mark_shown(tip_id)
    local loaded = ensure_loaded()
    shown_this_session[tip_id] = true
    local order = #loaded.recent_tips > 0 and loaded.recent_tips[1].order + 1 or 1
    table.insert(loaded.recent_tips, 1, { id = tip_id, order = order })
    loaded.recent_tips = clean_history(loaded.recent_tips)
    save()
end

function tip_progress.recent_tips()
    return clean_history(ensure_loaded().recent_tips)
end

function tip_progress.character()
    return current_character
end

function tip_progress.was_shown(tip_id)
    return shown_this_session[tip_id] == true
end

function tip_progress.queue_quest(tip_id)
    local loaded = ensure_loaded()
    if not loaded.queued_quests[tip_id] then
        loaded.queued_quests[tip_id] = true
        save()
    end
end

function tip_progress.queued_quests()
    return clean_set(ensure_loaded().queued_quests)
end

function tip_progress.clear_quest(tip_id)
    local loaded = ensure_loaded()
    if loaded.queued_quests[tip_id] then
        loaded.queued_quests[tip_id] = nil
        save()
    end
end

-- Merge reward/training level-ups until a method tip is shown for that skill.
function tip_progress.queue_level_up(skill, old_level, new_level)
    if not skills.is_skill(skill) then
        return
    end
    local checked = clean_pending({ [skill] = { old = old_level, new = new_level } })[skill]
    if not checked then
        return
    end
    local loaded = ensure_loaded()
    local pending = loaded.pending_level_ups[skill]
    loaded.pending_level_ups[skill] = {
        old = pending and math.min(pending.old, old_level) or old_level,
        new = pending and math.max(pending.new, new_level) or new_level,
    }
    save()
end

function tip_progress.pending_level_up(skill)
    local pending = ensure_loaded().pending_level_ups[skill]
    return pending and { old = pending.old, new = pending.new } or nil
end

function tip_progress.clear_level_up(skill)
    local loaded = ensure_loaded()
    if loaded.pending_level_ups[skill] then
        loaded.pending_level_ups[skill] = nil
        save()
    end
end

-- the settings page reset: brings back dismissed tips and anything shown this session
function tip_progress.reset_dismissed()
    ensure_loaded().dismissed = {}
    shown_this_session = {}
    save()
end

return tip_progress
