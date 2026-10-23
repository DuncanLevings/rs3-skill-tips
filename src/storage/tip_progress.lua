-- per character memory of what happened to each tip: dismissed for good, or pinned as a goal.
--
-- "already shown this session" is kept in memory only, so a tip the player clicked Later on
-- can come back another day

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

local function load_character(character)
    local saved = character and saved_table.load(KEY_PREFIX .. character, VERSION) or {}

    current_character = character
    shown_this_session = {}
    progress = {
        version = VERSION,
        dismissed = clean_set(saved.dismissed),
        pinned = clean_set(saved.pinned),
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

-- pinning also takes the tip off the card queue, its a goal in the coach window now
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
    shown_this_session[tip_id] = true
end

function tip_progress.was_shown(tip_id)
    return shown_this_session[tip_id] == true
end

-- the settings page reset: brings back dismissed tips and anything shown this session
function tip_progress.reset_dismissed()
    ensure_loaded().dismissed = {}
    shown_this_session = {}
    save()
end

return tip_progress
