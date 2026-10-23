-- the plugin hub settings page. placeholder until the settings module exists

local settings_page = {}

local SUBSCRIPTION = "skilling_coach_settings"
local view

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

    view:AddText("Skilling Coach settings are coming in a later version.")
end

function settings_page.start()
    Event.SettingsLayerReady.Subscribe(SUBSCRIPTION, function(event)
        destroy_view()
        populate(event.component)
    end)
end

function settings_page.stop()
    Event.SettingsLayerReady.Unsubscribe(SUBSCRIPTION)
    destroy_view()
end

return settings_page
