-- picks which tip (if any) to show when the player starts training something.
--
-- flow: activity_watch says "training MINING" -> find that skill's tips -> drop the ones the
-- player turned off, already saw, or probably knows -> best priority wins -> card.
--
-- pacing lives here too: one card at a time, a cooldown between cards, a cap per session and
-- a quiet period after combat xp. all of those come from settings

local catalogue = require("src/tips/catalogue")
local conditions = require("src/coach/conditions")
local settings = require("src/storage/settings")
local tip_progress = require("src/storage/tip_progress")
local owned_items = require("src/storage/owned_items")

local engine = {}

-- tip kind -> the setting that turns it on/off
local KIND_SETTINGS = {
    convenience = "show_convenience",
    method = "show_methods",
    general = "show_general",
}

local STAGE_SETTINGS = {
    early = "show_early",
    mid = "show_mid",
    late = "show_late",
}

local deps
local card_open = false
local last_shown_at
local last_combat_at
local shown_count = 0

-- early / mid / late from the level the tip is about: its level range, or the highest skill
-- requirement for item tips
function engine.stage(tip)
    local level = tip.level_range and tip.level_range[1] or 1

    if not tip.level_range then
        for _, required in pairs((tip.requirements or {}).skills or {}) do
            level = math.max(level, required)
        end
    end

    if level < 30 then
        return "early"
    elseif level < 70 then
        return "mid"
    end

    return "late"
end

local function has_trigger(tip, skill, trigger_type)
    for _, trigger in ipairs(tip.triggers) do
        if trigger.type == trigger_type and (trigger.skill == skill or trigger.skill == "ANY") then
            return true
        end
    end

    return false
end

-- settings and saved progress, nothing about the player's account yet
local function allowed(tip)
    local kind_on = settings.get(KIND_SETTINGS[tip.kind])
    local stage_on = settings.get(STAGE_SETTINGS[engine.stage(tip)])

    if not kind_on or not stage_on then
        return false
    end

    if tip.members and not settings.get("show_members") then
        return false
    end

    return not tip_progress.is_dismissed(tip.id)
        and not tip_progress.is_pinned(tip.id)
        and not tip_progress.was_shown(tip.id)
end

-- does the player probably know this already. tips about owning something wait for the first
-- bank visit, until then it cant tell if the item is sitting in the bank
local function probably_known(tip)
    if conditions.needs_bank(tip.known_when) and not owned_items.bank_seen() then
        return true
    end

    return conditions.any(tip.known_when, deps.state)
end

local function by_priority(left, right)
    if left.priority ~= right.priority then
        return left.priority < right.priority
    end

    return left.id < right.id
end

function engine.pick_tip(skill, trigger_type)
    trigger_type = trigger_type or "training"
    local candidates = {}

    for _, tip in ipairs(catalogue.for_skill(skill)) do
        if has_trigger(tip, skill, trigger_type) and allowed(tip) and not probably_known(tip) then
            candidates[#candidates + 1] = tip
        end
    end

    table.sort(candidates, by_priority)

    return candidates[1]
end

local function pacing_allows(now)
    if card_open or not settings.get("tips_enabled") then
        return false
    end

    if last_combat_at and now - last_combat_at < settings.get("combat_quiet_seconds") then
        return false
    end

    if last_shown_at and now - last_shown_at < settings.get("cooldown_minutes") * 60 then
        return false
    end

    local cap = settings.get("session_cap")

    return cap == 0 or shown_count < cap
end

local function show(tip, now)
    card_open = true
    last_shown_at = now
    shown_count = shown_count + 1
    tip_progress.mark_shown(tip.id)

    deps.show_card(tip, {
        on_pin = function()
            tip_progress.pin(tip.id)
        end,
        on_dismiss = function()
            tip_progress.dismiss(tip.id)
        end,
        -- Later needs nothing saved, the tip just isnt shown again this session
        on_later = function() end,
        on_closed = function()
            card_open = false
        end,
    })
end

local function on_signal(skill, trigger_type)
    if not deps then
        return
    end

    local now = deps.now()

    if settings.get("muted_skills")[skill] or not pacing_allows(now) then
        return
    end

    local tip = engine.pick_tip(skill, trigger_type)

    if tip then
        show(tip, now)
    end
end

function engine.on_training(skill)
    on_signal(skill, "training")
end

function engine.on_backpack_full(skill)
    on_signal(skill, "backpack_full")
end

function engine.on_combat()
    if deps then
        last_combat_at = deps.now()
    end
end

-- options = { state = player_state, now = function() seconds, show_card = function(tip, handlers) }
function engine.start(options)
    deps = options
    card_open = false
    last_shown_at = nil
    last_combat_at = nil
    shown_count = 0
end

function engine.stop()
    deps = nil
end

-- the settings reset button: lets tips show again straight away
function engine.reset_pacing()
    last_shown_at = nil
    shown_count = 0
end

return engine
