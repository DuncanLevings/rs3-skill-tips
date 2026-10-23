-- the plugin hub settings page. for now just the reset button, the full set of settings
-- (cooldown, filters and so on) gets controls here later

local settings_page = {}

local SUBSCRIPTION = "skilling_coach_settings"
local view
local on_reset

local function destroy_view()
    if view then
        view:Destroy()
        view = nil
    end
end

local function populate(component)
    view = prettyui.SimpleView.new(component, {
        width = 0,
        height = 0,
        widthAnchor = 1,
        heightAnchor = 1,
    })

    view:AddText("Tips you dismissed with Already know this stay hidden for good.")
    view:AddSimpleButton("Bring back dismissed tips", function()
        on_reset()
        view:AddText("Done, dismissed tips can show again.")
    end)
end

-- reset_tips is called when the player presses the reset button
function settings_page.start(reset_tips)
    on_reset = reset_tips

    Event.SettingsLayerReady.Subscribe(SUBSCRIPTION, function(event)
        destroy_view()
        populate(event.component)
    end)
end

function settings_page.stop()
    Event.SettingsLayerReady.Unsubscribe(SUBSCRIPTION)
    destroy_view()
    on_reset = nil
end

return settings_page
