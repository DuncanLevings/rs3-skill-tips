-- hooks the client's xp and click events up to skill_activity and reports "training <skill>".
--
-- combat skills arent reported as training, they go to on_combat instead (the coach stays quiet
-- for a bit after combat xp)

local clock = require("src/game/clock")
local skills = require("src/data/skills")
local skill_activity = require("src/game/skill_activity")
local inventories = require("src/game/inventories")
local event_owner = require("src/game/event_owner")

local activity_watch = {}

local SUBSCRIPTION = "skilling_coach_activity"

local tracker
local listeners
local owner
local gathering_skill
local previous_free_slots
local full_at
local last_activity_at
local gathering_action
local gathering_xp_at
-- inventory and xp updates can arrive in either order within a server tick
local FULL_MATCH_SECONDS = 1.2

function activity_watch.reset()
    tracker = skill_activity.new()
    gathering_skill = nil
    previous_free_slots = nil
    full_at = nil
    gathering_xp_at = nil
    last_activity_at = clock.now()
    gathering_action = false
end

local function before_event()
    if listeners.before_activity then
        listeners.before_activity()
    end
    if not Player.IsAvailable() then
        activity_watch.reset()
        return false
    end
    return true
end

local function check_backpack()
    if not listeners or not gathering_skill then
        return
    end
    if not before_event() or not gathering_skill then
        return
    end

    local free_slots = inventories.backpack_free_slots()
    local now = clock.now()

    if inventories.bank_is_open() or free_slots == nil then
        previous_free_slots = nil
        full_at = nil
        gathering_xp_at = nil
        return
    end

    if free_slots == 0 and previous_free_slots and previous_free_slots > 0 then
        full_at = now
    elseif free_slots > 0 then
        full_at = nil
    end

    previous_free_slots = free_slots

    if full_at and now - full_at > FULL_MATCH_SECONDS then
        full_at = nil
    end

    if
        full_at
        and gathering_xp_at
        and math.abs(full_at - gathering_xp_at) <= FULL_MATCH_SECONDS
    then
        full_at = nil
        gathering_xp_at = nil
        if listeners.on_backpack_full then
            listeners.on_backpack_full(gathering_skill)
        end
    end
end

local function on_entry_selected(event)
    if not before_event() then
        return
    end
    local entry = event.entry
    last_activity_at = clock.now()
    gathering_action = entry.locData ~= nil and entry.verbText ~= "Examine"

    -- unrelated clicks (banking, picking up, rewards) must not inherit a mining signal
    gathering_skill = nil
    if entry.locData then
        if entry.verbText == "Mine" then
            gathering_skill = "MINING"
        elseif entry.verbText == "Chop down" then
            gathering_skill = "WOODCUTTING"
        end
    end
    previous_free_slots = inventories.backpack_free_slots()
    full_at = nil
    gathering_xp_at = nil

    local click = {
        action_type = entry.actionType,
        verb = entry.verbText,
        -- clicks on backpack items carry the item, checked in game
        is_item = entry.componentData ~= nil and entry.componentData.objConfig ~= nil,
    }

    tracker.click(click, clock.now())
end

local function on_skill_transmit(event)
    if not before_event() then
        return
    end
    local old_xp = event.oldXP or 0
    local gained = (event.newXP or 0) - old_xp

    -- at login every skill reports its whole xp from 0, thats not a drop
    if gained <= 0 or old_xp == 0 then
        return
    end

    last_activity_at = clock.now()
    local skill = skills.name(event.skill)

    if not skill then
        return
    end

    -- These are the same gameplay level fields used by the in-game probe.
    -- Report crossings even when the reward guard rejects this XP as training.
    if listeners.on_level_up then
        local old_level, new_level = event.oldGameplayLevel, event.newGameplayLevel
        if
            type(old_level) == "number"
            and type(new_level) == "number"
            and new_level > old_level
        then
            listeners.on_level_up(skill, old_level, new_level)
        end
    end

    if skills.COMBAT[skill] then
        listeners.on_combat()
        return
    end

    if tracker.xp(skill, clock.now()) then
        if skill == gathering_skill then
            gathering_xp_at = clock.now()
            check_backpack()
        end
        listeners.on_training(skill)
    end
end

-- A quiet pause is conservative: no XP/clicks for 5s and no outstanding gathering click.
-- Walking/non-location clicks release that gathering latch, so a bank run can show queued tips.
local function check_quiet(event)
    if not listeners or not listeners.on_quiet or (event.logicTick or 0) % 25 ~= 0 then
        return
    end
    if not before_event() then
        return
    end
    local now = clock.now()
    if
        not gathering_action
        and now - last_activity_at >= 5
        and not tracker.reward_guard_active(now)
    then
        listeners.on_quiet()
    end
end

-- handlers = { on_training = function(skill), on_combat = function() }
function activity_watch.start(handlers)
    if owner then
        owner.destroy()
    end
    activity_watch.reset()
    listeners = handlers
    owner = event_owner.new(SUBSCRIPTION)

    owner.subscribe(Event.Logic, function(event)
        check_backpack()
        check_quiet(event)
    end)
    owner.subscribe(Event.MiniMenuEntrySelected, on_entry_selected)
    owner.subscribe(Event.SkillTransmit, on_skill_transmit)
end

function activity_watch.stop()
    if owner then
        owner.destroy()
        owner = nil
    end
    tracker = nil
    listeners = nil
end

return activity_watch
