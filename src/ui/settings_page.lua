-- native settings controls save immediately. Recent tips is read-only; reset is dev-only.
local tip_card = require("src/ui/tip_card")
local settings = require("src/storage/settings")
local skills = require("src/data/skills")
local coach_window = require("src/ui/coach_window")
local card_placement = require("src/ui/card_placement")
local event_owner = require("src/game/event_owner")
local internals = require("src/ui/prettyui_internals")
local settings_page = {}
local owner, view
local NAME = "skilling_coach_settings"

local function destroy_view()
    if view then
        local old = view
        view = nil
        old:Destroy()
    end
end

local function populate(component, options)
    destroy_view()
    view = prettyui.SimpleView.new(
        component,
        { width = 0, height = 0, widthAnchor = 1, heightAnchor = 1 }
    )
    local current = view
    local function alive()
        return view == current
    end

    local function checks(choices)
        current:AddCheckboxButton(choices, {
            onChange = function(_, _, key, selected)
                if alive() then
                    settings.set(key, selected)
                    if key == "animate_card" then
                        tip_card.set_animation(selected)
                    end
                end
            end,
        })
    end

    local function choice(key, text)
        return { text = text, value = key, selected = settings.get(key) }
    end

    current:AddText("Skill Tips")
    checks({ choice("tips_enabled", "Show tips"), choice("animate_card", "Animate popup") })
    current:AddText("Tip categories")
    checks({
        choice("show_convenience", "Useful items"),
        choice("show_methods", "Training methods"),
        choice("show_general", "Quality of life"),
        choice("show_quests", "Quest tips"),
    })
    current:AddText("Progression")
    checks({
        choice("show_early", "Early game"),
        choice("show_mid", "Mid game"),
        choice("show_late", "Late game"),
        choice("show_members", "Members tips"),
    })

    local function slider(key, label, minimum, maximum, suffix)
        local function text(value)
            return label .. ": " .. tostring(value) .. (suffix or "")
        end

        local caption = current:AddText(text(settings.get(key)))
        current:AddSlider({
            min = minimum,
            max = maximum,
            step = 1,
            value = settings.get(key),
            onChange = function(_, value)
                if alive() then
                    value = math.floor(value + 0.5)
                    settings.set(key, value)
                    internals.set_text(caption, text(value))
                end
            end,
        })
    end

    current:AddText("Pacing")
    slider("cooldown_minutes", "Time between tips", 2, 60, " min")
    slider("session_cap", "Tips per session (0 = unlimited)", 0, 50)
    slider("combat_quiet_seconds", "Quiet time after combat", 0, 600, " sec")
    slider("dismiss_hours", "Hide dismissed tips for", 0, 8, " hr of game time")
    current:AddText("Muted skills")
    local choices = {}
    local muted = settings.get("muted_skills")
    for number = 0, #skills.NAMES do
        local name = skills.NAMES[number]

        -- combat skills never get tips, so a mute box for them would do nothing
        if not skills.COMBAT[name] then
            choices[#choices + 1] = {
                text = name:sub(1, 1) .. name:sub(2):lower(),
                value = name,
                selected = muted[name] == true,
            }
        end
    end

    current:AddCheckboxButton(choices, {
        onChange = function(_, _, skill, selected)
            if alive() then
                local next_muted = settings.get("muted_skills")
                next_muted[skill] = selected and true or nil
                settings.set("muted_skills", next_muted)
            end
        end,
    })
    current:AddText("Toggle pinned tips shortcut (optional)")
    current:AddKeybindField({
        value = settings.get("pinned_keybind"),
        defaultValue = {},
        onChange = function(_, value)
            if alive() then
                settings.set("pinned_keybind", value)
            end
        end,
    })
    current:AddSimpleButton("Reset popup position", function()
        if alive() then
            card_placement.reset()
        end
    end)
    current:AddSimpleButton("Recent tips", function()
        if alive() then
            coach_window.open_history()
        end
    end)
    current:AddText(
        "Dismissal timers pause while the plugin is stopped. 0 adds no dismissal delay."
    )
    if options.reset_tips then
        current:AddText("Development testing")
        current:AddText("Time between tips: 0 min (development override).")
        current:AddSimpleButton("Reset dismissals (development)", function()
            if alive() then
                options.reset_tips()
            end
        end)
    end
end

function settings_page.start(options)
    options = options or {}
    owner = event_owner.new(NAME)
    owner.subscribe(Event.SettingsLayerReady, function(event)
        populate(event.component, options)
    end)
end

function settings_page.stop()
    if owner then
        owner.destroy()
        owner = nil
    end

    destroy_view()
end

return settings_page
