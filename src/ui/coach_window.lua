-- the ribbon is a launcher only. Pinned tips and recent tips are independent compact windows.
local catalogue = require("src/tips/catalogue")
local progress = require("src/storage/tip_progress")
local compact_list = require("src/ui/compact_list")
local history = require("src/ui/recent_history")
local event_owner = require("src/game/event_owner")
local coach_window = {}
local NAME = "skilling_coach_content"
local owner, ribbon

local pinned = compact_list.new({
    name = NAME,
    key = "skilling_coach_goals", -- Preserve existing saved placement.
    title = "Pinned tips",
    min_width = 200,
    max_width = 320,
    empty = "No pinned tips.",
    empty_width = 240,
    empty_height = 100,
    rows = function()
        local rows = {}
        for _, tip_id in ipairs(progress.pinned_ids()) do
            local tip = catalogue.get(tip_id)
            if tip then
                rows[#rows + 1] = {
                    id = tip.id,
                    title = tip.title,
                    icon_item = tip.icon_item,
                    icon = "unpin",
                    subtle = true,
                    tooltip = "Unpin " .. tip.title,
                    action = function()
                        progress.unpin(tip_id)
                    end,
                }
            end
        end
        return rows
    end,
})
local recent = compact_list.new({
    name = "skilling_coach_history",
    key = "skilling_coach_history",
    title = "Recent tips",
    min_width = 240,
    max_width = 360,
    default_x = 0,
    resizable = true,
    default_width = 360,
    default_height = 400,
    dividers = true,
    empty = "No tips shown yet.",
    rows = history.rows,
})

coach_window.open = pinned.open
coach_window.close = pinned.close
coach_window.toggle = pinned.toggle
coach_window.open_history = recent.open

local function destroy_ribbon()
    if ribbon then
        local old = ribbon
        ribbon = nil
        old:Destroy()
    end
end

function coach_window.start()
    owner = event_owner.new(NAME)
    owner.subscribe(Event.ContentLayerReady, function(event)
        destroy_ribbon()
        ribbon = prettyui.SimpleView.new(event.component, {
            x = 12,
            y = 12,
            width = -24,
            height = -24,
            widthAnchor = 1,
            heightAnchor = 1,
        })
        local current = ribbon
        ribbon:AddTitle({ text = "Skilling Coach", height = 24, marginTop = 0, marginBottom = 8 })
        local button_width = math.max(1, math.min(240, (event.component.width or 288) - 48))
        ribbon:AddText({
            text = "Your tips and recent discoveries.",
            colour = 0xC8BDA5FF,
            height = 24,
            marginTop = 0,
            marginBottom = 8,
        })
        local function launch(label, description, action)
            ribbon:AddSimpleButton(label, function()
                if ribbon == current then
                    action()
                end
            end, {
                width = button_width,
                height = 32,
                marginTop = 8,
                marginBottom = 4,
                tooltip = description,
            })
        end
        launch("Pinned tips", "Keep the tips you pin beside your game.", pinned.open)
        launch("Recent tips", "Look back at your last 10 tips, or pin one for later.", recent.open)
    end)
    progress.listen(NAME, function()
        pinned.refresh()
        recent.refresh()
    end)
end

function coach_window.stop()
    if owner then
        owner.destroy()
        owner = nil
    end
    progress.stop_listening(NAME)
    pinned.close()
    recent.close()
    destroy_ribbon()
end

return coach_window
