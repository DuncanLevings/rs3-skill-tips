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
local tip_card = require("src/ui/tip_card")
local coach_window = require("src/ui/coach_window")
local settings_page = require("src/ui/settings_page")

local app = {}

local CHARACTER_SUBSCRIPTION = "skilling_coach_character"

local started = false
local current_character
local character_events

local function show_card(tip, handlers)
    tip_card.show(tip, handlers, {
        state = player_state,
        animate = settings.get("animate_card"),
    })
end

local function start_engine()
    engine.start({ state = player_state, now = clock.now, show_card = show_card })
end

-- Check before activity as well as on server ticks: XP can arrive before the login poll.
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
    inventories.refresh_bank()
end

local function reset_tips()
    tip_progress.reset_dismissed()
    engine.reset_pacing()
end

function app.start()
    if started then
        return
    end

    assert(
        prettyui and prettyui.SimpleView,
        "Skilling Coach needs PrettyUI, get it from the Plugin Hub"
    )

    catalogue.load()
    clock.start()
    inventories.start()

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
        on_backpack_full = function(skill)
            if current_character then
                engine.on_backpack_full(skill)
            end
        end,
    })

    update_character()
    character_events = event_owner.new(CHARACTER_SUBSCRIPTION)
    character_events.subscribe(Event.ServerLogic, update_character)
    coach_window.start()
    settings_page.start(reset_tips)

    started = true

    log("Skilling Coach started.")
end

function app.stop()
    if not started then
        return
    end

    started = false

    settings_page.stop()
    coach_window.stop()
    character_events.destroy()
    character_events = nil
    activity_watch.stop()
    engine.stop()
    tip_card.destroy()
    inventories.stop()
    clock.stop()
    current_character = nil
    tip_progress.use_character(nil)
    owned_items.use_character(nil)

    log("Skilling Coach stopped.")
end

return app
