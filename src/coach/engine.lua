-- turns real training/full-backpack signals into one ranked, paced card.
-- reward level-ups are remembered, but only real training may display their tips.
local catalogue = require("src/tips/catalogue")
local triggers = require("src/coach/triggers")
local eligibility = require("src/coach/eligibility")
local ranking = require("src/coach/ranking")
local catch_up = require("src/coach/catch_up")
local pacing = require("src/coach/pacing")
local progress = require("src/storage/tip_progress")
local engine = {}
local session

engine.stage = eligibility.stage

function engine.pick_tip(skill, trigger_type)
    if not session then
        return
    end
    local level = session.deps.state.level(skill)
    local context = {
        skill = skill,
        kind = trigger_type or "training",
        level = level,
        pending = progress.pending_level_up(skill),
        catch_up_level = (trigger_type == nil or trigger_type == "training")
                and session.catch_up.level(skill, level)
            or nil,
    }
    local candidates = {}
    for _, tip in ipairs(catalogue.for_skill(skill)) do
        if
            triggers.matches(tip, context) and eligibility.allows(tip, skill, session.deps.state)
        then
            candidates[#candidates + 1] = tip
        end
    end
    return ranking.best(candidates, skill, level)
end

local function show(tip, skill)
    local running = session
    local token = {}
    running.card = token
    running.pacing.shown(running.deps.now())
    progress.mark_shown(tip.id)
    -- Keep other skills' level-ups queued. Catch-up still handles other current-bracket tips.
    if tip.kind == "method" then
        progress.clear_level_up(skill)
    end
    local function active()
        return session == running and running.card == token
    end
    running.deps.show_card(tip, {
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
end

local function on_signal(skill, kind)
    if not session then
        return
    end
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
function engine.on_level_up(skill, old_level, new_level)
    if session then
        progress.queue_level_up(skill, old_level, new_level)
    end
end
function engine.on_combat()
    if session then
        session.pacing.combat(session.deps.now())
    end
end
function engine.start(options)
    session = { deps = options, catch_up = catch_up.new(), pacing = pacing.new() }
end
function engine.stop()
    session = nil
end
function engine.reset_pacing()
    if session then
        session.pacing.reset()
        session.catch_up = catch_up.new()
    end
end

return engine
