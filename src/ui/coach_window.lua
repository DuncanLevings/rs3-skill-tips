-- the ribbon window. lists the tips the player pinned as goals, each with an Unpin button.
-- Phase 5 replaces this with narrow title/Unpin rows; dismissed-tip restore lives in settings.
--
-- the list redraws itself whenever a pin changes, so pinning a tip while this window is open
-- shows up straight away

local catalogue = require("src/tips/catalogue")
local tip_progress = require("src/storage/tip_progress")

local coach_window = {}

local SUBSCRIPTION = "skilling_coach_content"
local view
local layer

local function destroy_view()
    if view then
        local old = view
        view = nil
        pcall(function()
            old:Destroy()
        end)
    end
end

local function populate_pinned()
    view:AddText("Pinned goals")

    local pinned = tip_progress.pinned_ids()

    if #pinned == 0 then
        view:AddText("Nothing pinned yet. Press Pin on a tip to keep it here as a goal.")
        return
    end

    for _, tip_id in ipairs(pinned) do
        local tip = catalogue.get(tip_id)

        -- a pinned tip that was removed in an update just isnt listed
        if tip then
            view:AddText(tip.title .. ": " .. tip.hook)
            view:AddSimpleButton("Unpin " .. tip.title, function()
                tip_progress.unpin(tip_id)
            end)
        end
    end
end

local function populate()
    destroy_view()

    if not layer then
        return
    end

    -- the client may have thrown the layer away once the ribbon panel closed, in that case
    -- theres nothing to draw into until it opens again
    local ok = pcall(function()
        view = prettyui.SimpleView.new(layer, {
            width = 0,
            height = 0,
            widthAnchor = 1,
            heightAnchor = 1,
        })

        view:AddText("Skilling Coach")
        populate_pinned()
    end)

    if not ok then
        destroy_view()
        layer = nil
    end
end

function coach_window.start()
    -- the client hands over a fresh empty layer each time the ribbon panel opens
    Event.ContentLayerReady.Subscribe(SUBSCRIPTION, function(event)
        layer = event.component
        populate()
    end)

    tip_progress.listen(SUBSCRIPTION, populate)
end

function coach_window.stop()
    tip_progress.stop_listening(SUBSCRIPTION)
    Event.ContentLayerReady.Unsubscribe(SUBSCRIPTION)
    destroy_view()
    layer = nil
end

return coach_window
