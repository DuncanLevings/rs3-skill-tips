-- hooks the client's xp, click and backpack events up to skill_activity and turns them into
-- the signals the coach listens for:
--   on_training(skill)       real training, not reward xp
--   on_level_up(skill, ...)  any level up, reward or not
--   on_backpack_full(skill)  a mining or woodcutting backpack just filled up
--   on_quiet()               the player has been idle for a few seconds
--   on_combat()              combat xp, the coach stays quiet for a while after it

local clock = require("src/game/clock")
local skills = require("src/data/skills")
local skill_activity = require("src/game/skill_activity")
local inventories = require("src/game/inventories")
local event_owner = require("src/game/event_owner")

local activity_watch = {}

local SUBSCRIPTION = "skilling_coach_activity"

-- inventory and xp updates can arrive in either order within a server tick
local FULL_MATCH_SECONDS = 1.2

-- no xp or clicks for this long counts as a quiet pause
local QUIET_SECONDS = 5

local tracker
local listeners
local owner

-- "MINING" or "WOODCUTTING" while the last click was mining a rock or chopping a tree
local gathering_skill

-- true while the last click was on any object (a rock, tree, fishing spot...)
local gathering_action

-- backpack free slots at the last check, to spot the change to full
local previous_free_slots

-- when the backpack became full, and when the last gathering xp landed
local full_at
local gathering_xp_at

-- last click or xp drop, for spotting quiet pauses
local last_activity_at

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

-- the backpack filling and the gathering xp drop arrive in either order, a moment apart.
-- when both have happened close enough together, thats a full backpack from gathering
local function match_full_backpack()
    if
        not full_at
        or not gathering_xp_at
        or math.abs(full_at - gathering_xp_at) > FULL_MATCH_SECONDS
    then
        return
    end

    full_at = nil
    gathering_xp_at = nil

    if listeners.on_backpack_full then
        listeners.on_backpack_full(gathering_skill)
    end
end

-- runs when the backpack changes (the client tells us), not every tick. only cares while a
-- gathering click is the latest thing the player did
local function on_backpack_changed(event)
    if not gathering_skill or not inventories.is_backpack(event.inv) then
        return
    end

    if not before_event() or not gathering_skill then
        return
    end

    local free_slots = inventories.backpack_free_slots()

    if inventories.bank_is_open() or free_slots == nil then
        previous_free_slots = nil
        full_at = nil
        gathering_xp_at = nil
        return
    end

    -- only the change from "one slot left" to "full" counts, an already full backpack doesnt
    if free_slots == 0 and previous_free_slots and previous_free_slots > 0 then
        full_at = clock.now()
    elseif free_slots > 0 then
        full_at = nil
    end

    previous_free_slots = free_slots
    match_full_backpack()
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
        -- clicks on backpack items carry the item they were made on
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

    -- level ups get reported even when the reward guard says this xp wasnt training, a lamp
    -- level still unlocks the next method tip (it just waits for real training to show)
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
            match_full_backpack()
        end

        listeners.on_training(skill)
    end
end

-- a quiet pause is on the careful side: no xp or clicks for a few seconds and no gathering
-- click still going. walking or any non object click ends the gathering, so a bank run can
-- show queued tips. checked twice a second (every 25 logic ticks), not every tick
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
        and now - last_activity_at >= QUIET_SECONDS
        and not tracker.reward_guard_active(now)
    then
        listeners.on_quiet()
    end
end

-- handlers = { before_activity, on_training, on_level_up, on_backpack_full, on_quiet,
-- on_combat }, before_activity runs before every event so the app can notice a new login
function activity_watch.start(handlers)
    if owner then
        owner.destroy()
    end

    activity_watch.reset()
    listeners = handlers
    owner = event_owner.new(SUBSCRIPTION)

    owner.subscribe(Event.Logic, check_quiet)
    owner.subscribe(Event.InventoryUpdated, on_backpack_changed)
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
