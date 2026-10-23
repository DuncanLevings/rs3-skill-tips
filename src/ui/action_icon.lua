-- unboxed list actions: native pin artwork and a small red cross for Unpin.

local internals = require("src/ui/prettyui_internals")

local action_icon = {}

function action_icon.new(window, area, row, on_click, options)
    local root = ui.Layer.new(internals.content_layer(window))
    root:SetPos(options.x, options.y, options.x_anchor or 0, 0)
    root:SetSize(24, 24)
    root.enabled = true
    local image = row.icon == "pin" and ui.Sprite.new(root) or ui.Layer.new(root)
    local strokes = {}
    if row.icon == "unpin" then
        for _, inverted in ipairs({ false, true }) do
            local stroke = ui.Line.new(image)
            stroke:SetPos(7, 7)
            stroke:SetSize(10, 10)
            stroke.width = 2
            stroke.invert = inverted
            stroke.clickthrough = true
            strokes[#strokes + 1] = stroke
        end
    end

    image:SetSize(24, 24)
    image.enabled = true
    image.clickthrough = false
    local function draw(hovered)
        if row.icon == "pin" then
            image.sprite = row.disabled and id.Sprite.RS3_ICON_PINNED_24PX_1
                or (
                    hovered and id.Sprite.RS3_ICON_PINNED_24PX_3 or id.Sprite.RS3_ICON_PINNED_24PX_2
                )
        else
            for _, stroke in ipairs(strokes) do
                stroke.colour = hovered and Vector4.new(0.9, 0.4, 0.32, 1)
                    or Vector4.new(0.65, 0.25, 0.2, 0.65)
            end
        end

        image.alpha = row.disabled and 0.55 or (hovered and 1 or (row.subtle and 0.65 or 1))
    end

    draw(false)
    if row.icon == "pin" then
        -- same as the card: cover the sprite's baked in border, never crop it out of the atlas
        for _, edge in ipairs({
            { 0, 0, 24, 2 },
            { 0, 22, 24, 2 },
            { 0, 2, 2, 20 },
            { 22, 2, 2, 20 },
        }) do
            local mask = ui.Sprite.new(root)
            mask.sprite = internals.background_sprite(window)
            mask.isTiling = true
            mask:SetPos(edge[1], edge[2])
            mask:SetSize(edge[3], edge[4])
            mask.clickthrough = true
        end
    end

    local tooltip = prettyui.Tooltip.attach(image, area, {
        parent = area,
        text = row.tooltip,
        maxWidth = 180,
    })
    local hovered, destroyed = false, false
    local control = { root = root }
    function control.update()
        if not hovered or destroyed then
            return
        end

        local popup = internals.tooltip_root(tooltip)
        if not popup then
            return
        end

        local target, origin = image.xyGlobal, area.xyGlobal
        local x = target.x - origin.x + (image.width - popup.width) / 2
        local y = target.y - origin.y - popup.height - 6
        if y < 8 then
            y = target.y - origin.y + image.height + 6
        end

        popup:SetPos(
            math.floor(math.max(8, math.min(x, area.width - popup.width - 8))),
            math.floor(math.max(8, math.min(y, area.height - popup.height - 8)))
        )
    end

    image:Subscribe(ui.Hook.ONCLICK, "skilling_coach_list_action", function()
        if destroyed then
            return false
        end

        hovered = false
        tooltip:Hide()
        if not row.disabled then
            on_click()
        end

        return false
    end)
    image:Subscribe(ui.Hook.ONMOUSEOVER, "skilling_coach_list_action", function()
        if destroyed then
            return
        end

        hovered = true
        draw(not row.disabled)
        tooltip:Show()
        control.update()
    end)
    image:Subscribe(ui.Hook.ONMOUSELEAVE, "skilling_coach_list_action", function()
        if destroyed then
            return
        end

        hovered = false
        draw(false)
        tooltip:Hide()
    end)
    function control:Destroy()
        if destroyed then
            return
        end

        destroyed, hovered = true, false
        tooltip:Destroy()
        root:Destroy()
    end

    return control
end

return action_icon
