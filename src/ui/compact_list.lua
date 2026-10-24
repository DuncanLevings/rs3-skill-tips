-- independently positioned, content-sized native lists with guarded row controls.
local progress = require("src/storage/tip_progress")
local placement = require("src/ui/list_placement")
local layout = require("src/ui/list_layout")
local event_owner = require("src/game/event_owner")
local action_icon = require("src/ui/action_icon")
local internals = require("src/ui/prettyui_internals")
local item_icon = require("src/ui/item_icon")
local compact_list = {}

function compact_list.new(options)
    local controller, opened = {}, nil
    local place = {
        key = options.key,
        default_x = options.default_x,
        default_y = options.default_y,
        remember_size = options.resizable,
        height = options.default_height,
    }
    local function release(current)
        current.owner.destroy()
        for _, button in ipairs(current.buttons) do
            pcall(function()
                button:Destroy()
            end)
        end

        current.buttons = {}
    end

    function controller.close(skip_save)
        local current = opened
        if not current then
            return
        end

        opened = nil
        release(current)
        if not skip_save then
            pcall(function()
                placement.save(current.window.root, current.area, place)
            end)
        end

        current.window:Destroy()
    end

    local function rows_and_signature()
        local rows = options.rows()
        local parts = {}
        for _, row in ipairs(rows) do
            parts[#parts + 1] = table.concat({
                row.id,
                row.title,
                row.body or "",
                row.order or "",
                row.icon or "",
                tostring(row.disabled),
            }, "\t")
        end

        if #rows == 0 then
            rows = { { id = "empty", title = options.empty, empty = true } }
        end

        return rows, table.concat(parts, "\n")
    end

    function controller.open()
        if opened then
            internals.show_window(opened.window)
            return true
        end

        local ok, area = pcall(function()
            return ui.Interfaces:GetComponent(id.Component.TOPLEVEL_V2__GAME_AREA)
        end)
        if
            not ok
            or not area
            or area.width <= 0
            or area.height <= 0
            or not progress.character()
        then
            return false
        end

        local rows, signature = rows_and_signature()
        for _, row in ipairs(rows) do
            row.icon_id = item_icon.id(row)
        end

        local measured = layout.measure(rows, area, options)
        place.width = options.resizable and options.default_width or measured.width
        local rect = placement.rect(area, measured.height, place)
        if options.resizable then
            measured =
                layout.measure(rows, area, { min_width = rect.width, max_width = rect.width })
        end

        local current = {
            character = progress.character(),
            signature = signature,
            area = area,
            buttons = {},
            owner = event_owner.new(options.name .. "_geometry"),
        }
        opened = current
        local function alive()
            return opened == current
        end

        local function save()
            placement.save(current.window.root, area, place)
        end

        current.window = prettyui.Window.new(area, {
            title = options.title,
            x = rect.x,
            y = rect.y,
            width = rect.width,
            height = rect.height,
            minWidth = options.resizable and math.min(260, area.width) or rect.width,
            maxWidth = options.resizable and area.width or rect.width,
            minHeight = options.resizable and math.min(180, area.height)
                or math.min(64, rect.height),
            maxHeight = options.resizable and area.height
                or math.min(420, math.floor(area.height * 0.6)),
            resizable = options.resizable == true,
            scrollable = true,
            destroyOnClose = true,
            onClose = function()
                if alive() then
                    opened = nil
                    release(current)
                    save()
                end
            end,
        })
        local window = current.window
        local content = internals.content_layer(window)

        -- without the content layer (prettyui changed) theres nowhere to put rows, so dont
        -- leave an empty window behind
        if not content then
            log("Skill Tips: couldn't open " .. options.title .. ", window layout changed")
            controller.close(true)
            return false
        end

        -- raw text is measured before overflow can narrow the native content layer.
        -- history reserves the scrollbar width up front so later clipping cannot cut words.
        measured = layout.measure(rows, area, {
            min_width = rect.width,
            max_width = rect.width,
            content_width = math.max(
                1,
                content.width - layout.INSET * 2 - (options.text_right_padding or 0)
            ),
        })

        local y = layout.INSET
        for index, row in ipairs(rows) do
            local heading_height = row.body and row.heading_height or row.height
            local title_y = y + math.floor((heading_height - row.title_height) / 2)
            if row.icon_id then
                local icon = ui.Sprite.new(content)
                icon:SetPos(layout.INSET, y + math.floor((heading_height - layout.ICON_SIZE) / 2))
                icon:SetSize(layout.ICON_SIZE, layout.ICON_SIZE)
                icon:SetAssociatedObject(row.icon_id)
                icon.clickthrough = true
            end

            prettyui.Text.new(content, {
                text = row.title,
                x = layout.INSET + row.icon_offset,
                y = title_y,
                width = row.title_width,
                height = row.title_height,
                colour = 0xE8D9B5FF,
            })
            if row.body then
                prettyui.Text.new(content, {
                    text = row.body,
                    x = layout.INSET,
                    y = y + row.heading_height + 4,
                    width = measured.content_width,
                    height = row.body_height,
                    colour = 0xC4B99FFF,
                })
            end

            if row.action then
                local button = action_icon.new(window, area, row, function()
                    if alive() and not row.disabled then
                        row.action()
                    end
                end, {
                    x = -layout.ACTION_WIDTH - layout.INSET,
                    x_anchor = 1,
                    y = row.body and y or y + math.floor((row.height - 24) / 2),
                    width = layout.ACTION_WIDTH,
                    height = 24,
                })
                current.buttons[#current.buttons + 1] = button
            end

            if options.dividers and index < #rows then
                -- one thin native line in the gap between rows, prettyui's divider is far too tall
                local divider = ui.Rectangle.new(content)
                divider:SetPos(layout.INSET, y + row.height - 4)
                divider:SetSize(measured.content_width, 1)
                divider.colour = Vector4.new(0.45, 0.36, 0.22, 0.7)
                divider.fill = true
                divider.clickthrough = true
            end

            y = y + row.height
        end

        internals.set_content_height(window, measured.content_height)
        local last_width, last_height = area.width, area.height
        local last_x, last_y = window.root.x, window.root.y
        local last_window_width, last_window_height = window.root.width, window.root.height
        local resize_pending
        current.owner.subscribe(Event.Logic, function(event)
            for _, button in ipairs(current.buttons) do
                button.update()
            end

            if (event.logicTick or 0) % 25 ~= 0 then
                return
            end

            if area.width ~= last_width or area.height ~= last_height then
                placement.save(window.root, { width = last_width, height = last_height }, place)
                controller.close(true)
                controller.open()
                return
            end

            if
                options.resizable
                and (
                    window.root.width ~= last_window_width
                    or window.root.height ~= last_window_height
                )
            then
                local size = { width = window.root.width, height = window.root.height }
                save()
                if
                    resize_pending
                    and resize_pending.width == size.width
                    and resize_pending.height == size.height
                then
                    controller.close()
                    controller.open()
                else
                    resize_pending = size
                end

                return
            end

            placement.clamp(window.root, area)
            if window.root.x ~= last_x or window.root.y ~= last_y then
                save()
                last_x, last_y = window.root.x, window.root.y
            end
        end)
        return true
    end

    function controller.toggle()
        if opened then
            controller.close()
        else
            controller.open()
        end
    end

    function controller.refresh()
        if not opened then
            return
        end

        local _, signature = rows_and_signature()
        if opened.character ~= progress.character() or opened.signature ~= signature then
            controller.close()
            controller.open()
        end
    end

    return controller
end

return compact_list
