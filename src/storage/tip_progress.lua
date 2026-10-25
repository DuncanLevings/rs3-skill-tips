-- per character memory of what happened to each tip, saved in PersistentDB:
--
--   dismissed          tip id -> dismiss_elapsed when it was dismissed. hidden until
--                      dismiss_hours of play have passed since
--   dismiss_elapsed    seconds of play counted while the plugin runs, the dismissal clock
--   known              tip ids the player already knows, from owning the item once
--   starting_levels    skill -> level when the plugin first saw this character, main method
--                      tips for brackets at or below it are skipped
--   pinned             tip ids kept in the pinned tips window
--   pending_level_ups  skill -> { old, new } levels gained since its last method tip
--   recent_tips        the last 10 tips shown, newest first
--   queued_quests      quest tip ids waiting for a quiet pause
--
-- "already shown this session" is kept in memory only, so a tip the player clicked Later on
-- can come back another day. fields added after the first release just start empty in older
-- saves, so the save version hasnt needed to change

local skills = require("src/data/skills")
local saved_table = require("src/storage/saved_table")
local settings = require("src/storage/settings")
local event_owner = require("src/game/event_owner")

local tip_progress = {}

local KEY_PREFIX = "skilling_coach_progress_"
local VERSION = 1

local current_character
local progress
local shown_this_session = {}

-- dismissal clock: the last logic tick seen, and dismiss_elapsed at the last save
local timer_owner, last_tick
local checkpoint = 0

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

-- a pending level up looks right: both levels whole numbers and the new one higher
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
    -- keep the newest copy of each tip before cutting to 10, older saves can have duplicates
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

-- older saves stored dismissals as true with no time, those start their timer now (once)
local function clean_dismissals(saved, elapsed)
    local result, migrated = {}, false
    for tip_id, value in pairs(type(saved) == "table" and saved or {}) do
        if type(tip_id) == "string" then
            if value == true then
                result[tip_id], migrated = elapsed, true
            elseif type(value) == "number" and value >= 0 and value <= elapsed then
                result[tip_id] = value
            end
        end
    end
    return result, migrated
end

local function elapsed_value(value)
    return type(value) == "number" and value >= 0 and value < math.huge and value or 0
end

-- keeps valid starting levels. 0 is allowed, the development reset saves it so every
-- bracket counts as new
local function clean_starting_levels(saved)
    local result = {}
    for skill, level in pairs(type(saved) == "table" and saved or {}) do
        if
            skills.is_skill(skill)
            and math.type(level) == "integer"
            and level >= 0
            and level <= 120
        then
            result[skill] = level
        end
    end
    return result
end

local function load_character(character)
    local saved = character and saved_table.load(KEY_PREFIX .. character, VERSION) or {}

    local elapsed = elapsed_value(saved.dismiss_elapsed)
    local dismissed, migrated = clean_dismissals(saved.dismissed, elapsed)
    current_character = character
    shown_this_session = {}
    last_tick, checkpoint = nil, elapsed
    progress = {
        version = VERSION,
        dismissed = dismissed,
        dismiss_elapsed = elapsed,
        known = clean_set(saved.known),
        starting_levels = clean_starting_levels(saved.starting_levels),
        pinned = clean_set(saved.pinned),
        pending_level_ups = clean_pending(saved.pending_level_ups),
        recent_tips = clean_history(saved.recent_tips),
        queued_quests = clean_set(saved.queued_quests),
    }
    if migrated and character then
        saved_table.save(KEY_PREFIX .. character, progress)
    end
end

-- switches to a character's saved progress. call again whenever the logged in character changes
function tip_progress.use_character(character)
    if character == current_character and progress then
        return
    end

    if current_character and progress and progress.dismiss_elapsed ~= checkpoint then
        saved_table.save(KEY_PREFIX .. current_character, progress)
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

function tip_progress.starting_level(skill)
    return ensure_loaded().starting_levels[skill]
end

-- saves the current level for any skill that doesnt have a starting level yet. a level that
-- cant be read yet is just tried again next time, captured levels are never changed
function tip_progress.capture_starting_levels(state)
    if not current_character then
        return
    end

    local levels, changed = ensure_loaded().starting_levels, false
    for _, skill in pairs(skills.NAMES) do
        if not skills.COMBAT[skill] and levels[skill] == nil then
            local level = state.level(skill)
            if math.type(level) == "integer" and level >= 1 and level <= 120 then
                levels[skill], changed = level, true
            end
        end
    end
    if changed then
        save()
    end
end

-- development switch only: sets every starting level to 0 so all brackets show again
function tip_progress.allow_existing_methods()
    if not current_character then
        return
    end

    local levels, changed = ensure_loaded().starting_levels, false
    for _, skill in pairs(skills.NAMES) do
        if not skills.COMBAT[skill] and levels[skill] ~= 0 then
            levels[skill], changed = 0, true
        end
    end
    if changed then
        save()
    end
end

-- true once the player has owned an item that explains this tip
function tip_progress.is_known(tip_id)
    return ensure_loaded().known[tip_id] == true
end

function tip_progress.mark_known(tip_ids)
    if not current_character then
        return
    end

    local loaded, changed = ensure_loaded(), false
    for _, tip_id in ipairs(tip_ids) do
        if not loaded.known[tip_id] then
            loaded.known[tip_id] = true
            changed = true
        end
    end

    if changed then
        save()
    end
end

function tip_progress.is_dismissed(tip_id)
    local loaded = ensure_loaded()
    local dismissed_at = loaded.dismissed[tip_id]
    return dismissed_at ~= nil
        and loaded.dismiss_elapsed - dismissed_at < settings.get("dismiss_hours") * 3600
end

function tip_progress.is_pinned(tip_id)
    return ensure_loaded().pinned[tip_id] == true
end

function tip_progress.dismiss(tip_id)
    local loaded = ensure_loaded()
    loaded.dismissed[tip_id] = loaded.dismiss_elapsed
    -- the dismissal timer replaces the session-only block for this specific tip.
    shown_this_session[tip_id] = nil
    loaded.pinned[tip_id] = nil
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

-- level ups for a skill merge together until a method tip for that skill gets shown
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

-- development switch only: forgets which items the player has owned, pins and history stay
function tip_progress.reset_known()
    if not current_character then
        return
    end

    local loaded = ensure_loaded()
    if next(loaded.known) then
        loaded.known = {}
        save()
    end
end

-- counts play time for the current character while the plugin runs. saves once a minute
-- (and on character switch or stop) rather than on every logic tick
function tip_progress.start()
    if timer_owner then
        return
    end
    timer_owner = event_owner.new("skilling_coach_dismiss_timer")
    last_tick = nil
    timer_owner.subscribe(Event.Logic, function(event)
        local tick = event.logicTick
        if type(tick) ~= "number" then
            return
        end
        if last_tick and current_character then
            local loaded = ensure_loaded()
            loaded.dismiss_elapsed = loaded.dismiss_elapsed + math.max(0, tick - last_tick) / 50
            if loaded.dismiss_elapsed - checkpoint >= 60 then
                checkpoint = loaded.dismiss_elapsed
                if next(loaded.dismissed) then
                    for tip_id in pairs(loaded.dismissed) do
                        if not tip_progress.is_dismissed(tip_id) then
                            loaded.dismissed[tip_id] = nil
                        end
                    end
                    saved_table.save(KEY_PREFIX .. current_character, loaded)
                end
            end
        end
        last_tick = tick
    end)
end

function tip_progress.stop()
    if timer_owner then
        timer_owner.destroy()
        timer_owner = nil
    end
    if current_character and progress then
        saved_table.save(KEY_PREFIX .. current_character, progress)
    end
    last_tick = nil
end

return tip_progress
