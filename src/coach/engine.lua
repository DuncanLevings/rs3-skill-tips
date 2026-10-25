-- the coach itself. turns "training MINING", "backpack full", "level up" and "quiet pause"
-- signals into at most one card at a time:
--
--   signal -> triggers (does a tip fit this signal) -> eligibility (is it allowed and useful)
--          -> ranking (which one is best) -> pacing (is it too soon) -> show the card
--
-- reward level ups (lamps, quests) are remembered as pending, but only real training shows
-- the method tips they unlock. quest tips have their own queue and only show in a quiet pause

local catalogue = require("src/tips/catalogue")
local triggers = require("src/coach/triggers")
local eligibility = require("src/coach/eligibility")
local ranking = require("src/coach/ranking")
local catch_up = require("src/coach/catch_up")
local pacing = require("src/coach/pacing")
local quest_readiness = require("src/coach/quest_readiness")
local progress = require("src/storage/tip_progress")

local engine = {}

-- how often a quiet pause looks through every quest tip for newly ready ones
local QUEST_SCAN_SECONDS = 30

-- one session per character login. holds the deps passed to start (state, now, show_card),
-- the pacing gate, catch-up levels and the card thats open right now, if any
local session

engine.stage = eligibility.stage

-- best tip for this skill and signal, nil when nothing fits
function engine.pick_tip(skill, trigger_type)
    if not session then
        return nil
    end

    local level = session.deps.state.level(skill)
    local kind = trigger_type or "training"
    local context = {
        skill = skill,
        kind = kind,
        level = level,
        pending = progress.pending_level_up(skill),
        catch_up_level = kind == "training" and session.catch_up.level(skill, level) or nil,
    }

    local candidates = {}
    for _, tip in ipairs(catalogue.for_skill(skill)) do
        if
            triggers.matches(tip, context)
            and eligibility.allows(tip, skill, session.deps.state)
        then
            candidates[#candidates + 1] = tip
        end
    end

    return ranking.best(candidates, skill, level)
end

local function show(tip, skill)
    local running = session

    -- each card gets its own token so a late callback from an old card cant clear a newer one
    local token = {}
    running.card = token

    local function active()
        return session == running and running.card == token
    end

    -- if showing the card throws, nothing is open. without the pcall the open card mark stayed
    -- set and no other tip could show for the rest of the session
    local shown_ok, displayed = pcall(running.deps.show_card, tip, {
        on_pin = function()
            if active() then
                progress.pin(tip.id)
            end
        end,
        on_dismiss = function()
            if active() then
                progress.dismiss(tip.id)
            end
        end,
        on_later = function() end,
        on_closed = function()
            if active() then
                running.card = nil
            end
        end,
    })

    if not shown_ok then
        log("Skill Tips: couldn't show tip " .. tip.id .. ": " .. tostring(displayed))
        displayed = false
    end

    if session ~= running then
        return
    end

    if displayed == false then
        running.card = nil
        return
    end

    running.pacing.shown(running.deps.now())
    progress.mark_shown(tip.id)

    if tip.kind == "quest" then
        progress.clear_quest(tip.id)
    elseif tip.kind == "method" then
        progress.clear_level_up(skill)
    end
end

local function on_signal(skill, kind)
    if not session then
        return
    end

    -- the first training signal fixes the catch-up level for this session
    if kind == "training" then
        session.catch_up.level(skill, session.deps.state.level(skill))
    end

    if session.card or not session.pacing.allows(session.deps.now()) then
        return
    end

    local tip = engine.pick_tip(skill, kind)
    if tip then
        show(tip, skill)
    end
end

function engine.on_training(skill)
    on_signal(skill, "training")
end

function engine.on_backpack_full(skill)
    on_signal(skill, "backpack_full")
end

local function queue_if_ready(tip)
    if
        eligibility.quest_ready(tip, session.deps.state)
        and not progress.is_dismissed(tip.id)
        and not progress.is_pinned(tip.id)
        and not progress.was_shown(tip.id)
    then
        progress.queue_quest(tip.id)
    end
end

-- remembers the level up for method tips, and queues any quest it may have made ready
function engine.on_level_up(skill, old_level, new_level)
    if not session then
        return
    end

    progress.queue_level_up(skill, old_level, new_level)

    for _, tip in ipairs(catalogue.quest_tips()) do
        local requirements = tip.requirements
        if requirements.skills[skill] or (requirements.any_skills or {})[skill] then
            queue_if_ready(tip)
        end
    end
end

-- quiet pauses come twice a second while idle, checking every quest's levels that often is
-- wasted work. level ups queue quests straight away (on_level_up), this slower scan picks up
-- the rest: quests qualified for before login, expired dismissals and unpinned tips
local function scan_quests()
    local now = session.deps.now()

    if session.last_quest_scan and now - session.last_quest_scan < QUEST_SCAN_SECONDS then
        return
    end

    session.last_quest_scan = now

    for _, tip in ipairs(catalogue.quest_tips()) do
        queue_if_ready(tip)
    end
end

-- quest tips dont care which skill happens to be trained, they show in a quiet pause. quests
-- the player fully qualifies for go before ones they're only close to (aspirations)
function engine.on_quiet()
    if not session then
        return
    end

    scan_quests()

    if session.card or not session.pacing.allows(session.deps.now()) then
        return
    end

    local state = session.deps.state
    local ready, aspirations = {}, {}

    for id in pairs(progress.queued_quests()) do
        local tip = catalogue.get(id)

        if
            tip
            and tip.kind == "quest"
            and triggers.matches(tip, { kind = "quest_ready" })
            and eligibility.allows(tip, nil, state)
        then
            local pool = quest_readiness.assess(tip, state).fully_met and ready or aspirations
            pool[#pool + 1] = tip
        end
    end

    local tip = ranking.best(#ready > 0 and ready or aspirations, nil, nil)
    if tip then
        show(tip)
    end
end

function engine.on_combat()
    if session then
        session.pacing.combat(session.deps.now())
    end
end

-- options = { state = player_state, now = function() seconds, show_card = function(tip, handlers) }
function engine.start(options)
    session = { deps = options, catch_up = catch_up.new(), pacing = pacing.new() }
end

function engine.stop()
    session = nil
end

-- development reset: lets tips show again straight away and rescans quests
function engine.reset_pacing()
    if session then
        session.pacing.reset()
        session.catch_up = catch_up.new()
        session.last_quest_scan = nil
    end
end

return engine
