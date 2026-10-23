-- the ribbon window. later this holds the Pinned / Browse / Dismissed tabs, for now its just a
-- placeholder so the ribbon icon opens something

local coach_window = {}

local SUBSCRIPTION = "skilling_coach_content"
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

    view:AddText("Skilling Coach")
    view:AddText("Tips you pin will show up here.")
end

function coach_window.start()
    -- the client hands over a fresh empty layer each time the ribbon panel opens
    Event.ContentLayerReady.Subscribe(SUBSCRIPTION, function(event)
        destroy_view()
        populate(event.component)
    end)
end

function coach_window.stop()
    Event.ContentLayerReady.Unsubscribe(SUBSCRIPTION)
    destroy_view()
end

return coach_window
