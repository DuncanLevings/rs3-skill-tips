-- owns startup and shutdown. every module that subscribes to something gets started and
-- stopped from here so theres one place to see what the plugin is hooked into.
--
-- it also keeps track of which character is logged in, saved progress and the bank snapshot
-- are per character and get switched over when that changes

local event_owner = require("src/game/event_owner")
local clock = require("src/game/clock")
local inventories = require("src/game/inventories")
local activity_watch = require("src/game/activity_watch")
local player_state = require("src/game/player_state")
local character_key = require("src/storage/character_key")
local settings = require("src/storage/settings")
local tip_progress = require("src/storage/tip_progress")
local owned_items = require("src/storage/owned_items")
local catalogue = require("src/tips/catalogue")
local engine = require("src/coach/engine")
local item_knowledge = require("src/coach/item_knowledge")
local tip_card = require("src/ui/tip_card")
local coach_window = require("src/ui/coach_window")
local keybind = require("src/ui/keybind")
local development = require("src/development")
local eligibility = require("src/coach/eligibility")
local conditions = require("src/coach/conditions")
local settings_page = require("src/ui/settings_page")

local app = {}

local CHARACTER_SUBSCRIPTION = "skilling_coach_character"

local started = false
local current_character
local character_events

local function show_card(tip, handlers)
    return tip_card.show(tip, handlers, {
        state = player_state,
        animate = settings.get("animate_card"),
    })
end

local function start_engine()
    engine.start({ state = player_state, now = clock.now, show_card = show_card })
end

-- local testing only: logs whats blocking the ore box card instead of guessing why it didnt show
local function report_ore_box(context)
    if not development.ENABLED or not current_character then
        return
    end

    local tip = catalogue.get("mining.ore_box")
    if not tip then
        return
    end

    log("Skill Tips [ore-box " .. context .. "]: " .. table.concat({
        "known=" .. tostring(tip_progress.is_known(tip.id)),
        "dismissed=" .. tostring(tip_progress.is_dismissed(tip.id)),
        "pinned=" .. tostring(tip_progress.is_pinned(tip.id)),
        "seen=" .. tostring(tip_progress.was_shown(tip.id)),
        "bank_seen=" .. tostring(owned_items.bank_seen()),
        "owns_box=" .. tostring(conditions.any(tip.known_when, player_state)),
        "eligible=" .. tostring(eligibility.allows(tip, "MINING", player_state)),
    }, ", "))
end

-- checked before every activity event as well as on server ticks, xp can beat the login poll
local function update_character()
    local character = character_key.current()
    if character == current_character then
        return
    end

    tip_card.destroy()
    activity_watch.reset()
    current_character = character
    tip_progress.use_character(character)
    owned_items.use_character(character)
    start_engine()
    -- learn from the saved bank snapshot before an open bank replaces it, the refresh then
    -- tells item_knowledge about the new one
    item_knowledge.observe()
    inventories.refresh_bank()
end

local function reset_tips()
    tip_progress.reset_dismissed()
    engine.reset_pacing()
    report_ore_box("reset")
end

function app.start()
    if started then
        return
    end

    assert(
        prettyui and prettyui.SimpleView,
        "Skill Tips needs PrettyUI, get it from the Plugin Hub"
    )

    catalogue.load()
    clock.start()
    tip_progress.start()

    start_engine()

    activity_watch.start({
        before_activity = update_character,
        on_training = function(skill)
            -- nothing to compare against until a character is logged in
            if current_character then
                engine.on_training(skill)
            end
        end,
        on_combat = engine.on_combat,
        on_quiet = function()
            if current_character then
                engine.on_quiet()
            end
        end,
        on_level_up = function(skill, old_level, new_level)
            if current_character then
                engine.on_level_up(skill, old_level, new_level)
            end
        end,
        on_backpack_full = function(skill)
            if current_character then
                if skill == "MINING" then
                    report_ore_box("backpack full")
                end

                engine.on_backpack_full(skill)
            end
        end,
    })

    update_character()
    inventories.start()
    item_knowledge.start({ before_observe = update_character, state = player_state })
    report_ore_box("startup")
    character_events = event_owner.new(CHARACTER_SUBSCRIPTION)
    character_events.subscribe(Event.ServerLogic, update_character)
    coach_window.start()
    settings_page.start({
        reset_tips = development.ENABLED and reset_tips or nil,
    })
    keybind.start(coach_window.toggle)

    started = true

    log("Skill Tips started.")
end

function app.stop()
    if not started then
        return
    end

    started = false

    keybind.stop()
    settings_page.stop()
    coach_window.stop()
    character_events.destroy()
    character_events = nil
    activity_watch.stop()
    item_knowledge.stop()
    engine.stop()
    tip_card.destroy()
    inventories.stop()
    tip_progress.stop()
    clock.stop()
    current_character = nil
    tip_progress.use_character(nil)
    owned_items.use_character(nil)

    log("Skill Tips stopped.")
end

return app
