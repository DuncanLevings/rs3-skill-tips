-- fake client for specs. loads plugin files into a sandbox with stand-ins for the client api
-- (Event, PersistentDB, Player, inventories, prettyui...) and keeps track of what happened so
-- specs can fire events by hand and check the results.
--
-- every client.new() is a fresh sandbox, modules dont leak state between specs

local client = {}

-- Event.<Name>.Subscribe/Unsubscribe that remember the handlers per event
local function create_events()
    local handlers = {}
    local order = {}
    local events = {}

    setmetatable(events, {
        __index = function(_, event_name)
            handlers[event_name] = handlers[event_name] or {}
            order[event_name] = order[event_name] or {}

            return {
                Subscribe = function(reference, handler)
                    if not handlers[event_name][reference] then
                        order[event_name][#order[event_name] + 1] = reference
                    end
                    handlers[event_name][reference] = handler
                end,
                Unsubscribe = function(reference)
                    handlers[event_name][reference] = nil
                    for index, name in ipairs(order[event_name]) do
                        if name == reference then
                            table.remove(order[event_name], index)
                            break
                        end
                    end
                end,
            }
        end,
    })

    return events, handlers, order
end

local function create_persistent_db(context)
    local db = {}

    function db:GetStructuredData(key)
        return context.saved[key]
    end

    function db:SetStructuredData(key, value)
        if context.fail_saves then
            return false
        end

        context.saved[key] = value
        return true
    end

    return db
end

-- a native-ish component: position and size, SetPos remembers where it was put
local function create_component(width, height)
    local component = { x = 0, y = 0, width = width or 0, height = height or 0, alpha = 1 }
    component.positions = {}

    function component:SetPos(x, y, x_anchor, y_anchor)
        self.x = x
        self.y = y
        self.x_anchor = x_anchor
        self.y_anchor = y_anchor
        self.positions[#self.positions + 1] = { x = x, y = y }
    end

    function component:SetSize(new_width, new_height)
        self.width = new_width
        self.height = new_height
    end

    component.hooks = {}
    function component:Subscribe(hook, _, callback)
        self.hooks[hook] = callback
    end
    function component:Destroy()
        self.destroyed = true
    end
    function component:SetAssociatedObject(object_id)
        self.object_id = object_id
    end

    return component
end

local function create_prettyui(context)
    local SimpleView = {}

    function SimpleView.new(component, options)
        local view = {
            component = component,
            options = options,
            texts = {},
            buttons = {},
            destroyed = false,
        }

        function view:AddText(text)
            self.texts[#self.texts + 1] = text
            local label = create_component()
            label.content = type(text) == "table" and text.text or text
            context.texts[#context.texts + 1] = label.content
            return label
        end

        function view:AddTitle(text)
            return self:AddText(text)
        end
        function view:AddSimpleButton(text, action, options)
            self.buttons[#self.buttons + 1] = { text = text, action = action, options = options }
        end

        function view:AddCheckboxButton(choices, options)
            local control = { choices = choices, options = options }
            context.checkboxes[#context.checkboxes + 1] = control
            return control
        end
        function view:AddSlider(options)
            context.sliders[#context.sliders + 1] = options
            return options
        end
        function view:AddKeybindField(options)
            context.keybind_fields[#context.keybind_fields + 1] = options
            return options
        end
        function view:Destroy()
            self.destroyed = true
        end

        context.views[#context.views + 1] = view

        return view
    end

    local Panel = {}

    function Panel.new(_, options)
        local panel = {
            options = options,
            root = create_component(options.width, options.height),
            content = create_component(options.width, options.height),
            destroyed = false,
        }
        panel.root:SetPos(options.x, options.y)

        function panel:Destroy()
            self.destroyed = true
        end

        context.panels[#context.panels + 1] = panel

        return panel
    end

    -- flow layout window: remembers its texts and buttons. Destroy calls onClose like a real
    -- close would, so the card has to tell its own destroy apart from the player closing it
    local Window = {}

    function Window.new(_, options)
        local window = {
            options = options,
            root = create_component(options.width, options.height),
            texts = {},
            closeButton = {},
            titleDrag = create_component(),
            titleText = {},
            background = create_component(),
            leftBorder = create_component(),
            rightBorder = create_component(),
            destroyed = false,
        }
        window.root:SetPos(options.x, options.y)

        function window:AddText(text_options)
            self.texts[#self.texts + 1] = text_options
            context.texts[#context.texts + 1] = text_options.text
        end

        function window:AddItemSlot(object, slot_options)
            self.item_slots = self.item_slots or {}
            self.item_slots[#self.item_slots + 1] = {
                object = object,
                options = slot_options,
            }
        end

        function window:AddSimpleButton(label, action, button_options)
            context.buttons[label] = action
            self.actions = self.actions or {}
            self.actions[#self.actions + 1] = { label = label, options = button_options }
        end

        function window:AddFancyButton(label, action, button_options)
            context.buttons[label] = action
            self.actions = self.actions or {}
            self.actions[#self.actions + 1] = { label = label, options = button_options }
        end

        function window:AddDivider()
            self.has_divider = true
        end

        function window:SetSize(width, height)
            self.root:SetSize(width, height)
        end

        window.content =
            create_component(options.width - (context.window_content_inset or 0), options.height)
        function window:SetContentHeight(height)
            self.contentHeight = height
        end
        function window:ScrollBy(delta)
            self.scrollY = (self.scrollY or 0) + delta
        end
        function window:Show()
            self.shown = true
        end
        function window:Close()
            if options.onClose then
                options.onClose(self)
            end
            if options.destroyOnClose then
                self.destroyed = true
            end
        end

        function window:Destroy()
            self.destroyed = true
            self:Close()
        end

        context.windows[#context.windows + 1] = window

        return window
    end

    local Text = {}

    function Text.new(_, options)
        context.texts[#context.texts + 1] = options.text
        local label = create_component(options.width, options.height)
        label:SetPos(options.x or 0, options.y or 0)
        label.options = options
        context.labels = context.labels or {}
        context.labels[#context.labels + 1] = label
        return label
    end

    Text.title = Text.new

    local SimpleButton = {}

    function SimpleButton.new(_, label, action, options)
        context.buttons[label] = action
        local button =
            { root = create_component(), label = label, action = action, options = options }
        function button:Destroy()
            self.destroyed = true
        end
        context.native_buttons[#context.native_buttons + 1] = button
        return button
    end

    local SpriteButton = {}
    function SpriteButton.new(_, name, action, options)
        context.buttons[name] = action
        local button = { options = options, spriteName = name }
        function button:Destroy()
            self.destroyed = true
        end
        context.sprite_buttons = context.sprite_buttons or {}
        context.sprite_buttons[#context.sprite_buttons + 1] = button
        return button
    end

    return {
        KeybindField = {
            IsDown = function(binding)
                if context.capturing or context.input_blocked or #binding == 0 then
                    return false
                end
                for _, key in ipairs(binding) do
                    if not context.keys[key] then
                        return false
                    end
                end
                return true
            end,
        },
        SimpleView = SimpleView,
        Panel = Panel,
        Window = Window,
        Text = Text,
        SimpleButton = SimpleButton,
        SpriteButton = SpriteButton,
        Tooltip = {
            attach = function(target, parent, options)
                local tooltip = {
                    target = target,
                    parent = parent,
                    options = options,
                    root = create_component(120, 28),
                }
                function tooltip:Show()
                    self.shown = true
                end
                function tooltip:Hide()
                    self.shown = false
                end
                function tooltip:Destroy()
                    self.destroyed = true
                end
                context.tooltips = context.tooltips or {}
                context.tooltips[#context.tooltips + 1] = tooltip
                return tooltip
            end,
        },
    }
end

-- inventory with a list of { item = config name, category = number, count = number }
local function create_inventory(entries, valid)
    local inv = { isValid = valid ~= false, freeSlotCount = math.max(0, 28 - #entries) }

    function inv:GetTotal(obj)
        local total = 0

        for _, entry in ipairs(entries) do
            if obj and entry.item == obj.configName then
                total = total + (entry.count or 1)
            end
        end

        return total
    end

    function inv:GetCategoryTotal(category)
        local total = 0

        for _, entry in ipairs(entries) do
            if entry.category == category then
                total = total + (entry.count or 1)
            end
        end

        return total
    end

    return inv
end

local INVENTORY_IDS = { INV = 93, WORN = 94, BANK = 95 }

local function create_config(context)
    local inv_types = {}

    for name, inv_id in pairs(INVENTORY_IDS) do
        inv_types[name] = { id = inv_id, configName = name }
    end

    return {
        Inv = inv_types,
        -- any item name exists, it just carries its own config name
        Obj = setmetatable({}, {
            __index = function(_, name)
                return { configName = name, id = 123 }
            end,
        }),
        Quest = context.quests,
        Achievement = context.achievements,
        Font = {},
    }
end

function client.new(root)
    local events, handlers, event_order = create_events()
    local context = {
        keys = {},
        checkboxes = {},
        sliders = {},
        keybind_fields = {},
        native_buttons = {},
        views = {},
        panels = {},
        windows = {},
        texts = {},
        buttons = {},
        logs = {},
        handlers = handlers,
        saved = {},
        -- logged in character, nil = at the login screen
        player = { name = "Test Player", levels = {} },
        -- inventory id -> list of items, BANK only while "open"
        inventories = { [93] = {}, [94] = {} },
        quests = {},
        achievements = {},
        varbits = {},
        game_area = { width = 1920, height = 1009 },
    }
    local modules = {}
    local environment = setmetatable({}, { __index = _G })

    environment.Plugin = { resources = {} }
    environment.Event = events
    environment.prettyui = create_prettyui(context)
    environment.PersistentDB = create_persistent_db(context)
    environment.config = create_config(context)
    environment.id = { Component = { TOPLEVEL_V2__GAME_AREA = 1 } }
    environment.id.Sprite = {
        RS3_ICON_PINNED_24PX_1 = 5,
        RS3_MODAL_WINDOW_1_BOTTOM_TILE = 1,
        RS3_MODAL_WINDOW_1_BOTTOM_CORNER = 2,
        RS3_ICON_PINNED_24PX_2 = 3,
        RS3_ICON_PINNED_24PX_3 = 4,
    }
    environment.Vector4 = {
        new = function(x, y, z, w)
            return { x = x, y = y, z = z, w = w }
        end,
    }
    environment.Rect = {
        new = function(x, y, width, height)
            return { x = x, y = y, width = width, height = height }
        end,
    }
    environment.ui = {
        Hook = {
            ONCLICK = "ONCLICK",
            ONMOUSEOVER = "ONMOUSEOVER",
            ONMOUSELEAVE = "ONMOUSELEAVE",
            ONHOLD = "ONHOLD",
            ONRELEASE = "ONRELEASE",
            ONSCROLLWHEEL = "ONSCROLLWHEEL",
        },
        Layer = {
            new = function(parent)
                local layer = create_component()
                layer.parent = parent
                context.layers = context.layers or {}
                context.layers[#context.layers + 1] = layer
                return layer
            end,
        },
        Line = {
            new = function()
                local line = create_component()
                context.lines = context.lines or {}
                context.lines[#context.lines + 1] = line
                return line
            end,
        },
        Rectangle = {
            new = function()
                return create_component()
            end,
        },
        Sprite = {
            new = function(parent)
                local sprite = create_component()
                sprite.parent = parent
                context.sprites = context.sprites or {}
                context.sprites[#context.sprites + 1] = sprite
                return sprite
            end,
        },
        Canvas = {
            new = function()
                local canvas = create_component()
                canvas.lines = {}
                function canvas:AddLine(...)
                    self.lines[#self.lines + 1] = { ... }
                end
                function canvas:AddSprite(...)
                    self.sprite_args = { ... }
                end
                function canvas:Clear()
                    self.sprite_args = nil
                end
                context.canvases = context.canvases or {}
                context.canvases[#context.canvases + 1] = canvas
                return canvas
            end,
        },
        Interfaces = {
            GetComponent = function()
                return context.game_area
            end,
        },
    }
    environment.var = {
        VarPlayer = setmetatable({}, {
            __index = function(_, name)
                local value = context.varbits[name]
                return value ~= nil and { value = value } or nil
            end,
        }),
    }
    environment.Inventory = {
        Find = function(inv_type)
            local entries = inv_type and context.inventories[inv_type.id]
            return entries and create_inventory(entries) or nil
        end,
    }
    environment.Player = {
        IsAvailable = function()
            return context.player ~= nil
        end,
        GetEntity = function()
            return { displayName = context.player.name }
        end,
        GetLevelUncapped = function(skill_number)
            return context.player.levels[skill_number] or 1
        end,
    }
    environment.log = function(message)
        context.logs[#context.logs + 1] = message
    end

    -- plugin files require each other by path from the plugin root, same as the client
    environment.require = function(path)
        if modules[path] == nil then
            local chunk = assert(loadfile(root .. "/" .. path .. ".lua", "t", environment))
            modules[path] = chunk()
            -- Specs default to release behavior, independent of the developer's local switch.
            if path == "src/development" then
                modules[path].ENABLED = false
            end
        end

        return modules[path]
    end

    context.environment = environment
    context.load = environment.require
    context.create_inventory = create_inventory

    -- calls every handler subscribed to an event, like the client would
    function context.fire(event_name, payload)
        -- native events run in subscription order; snapshot callbacks before dispatch.
        local callbacks = {}
        for _, name in ipairs(event_order[event_name] or {}) do
            callbacks[#callbacks + 1] = handlers[event_name][name]
        end
        for _, handler in ipairs(callbacks) do
            handler(payload)
        end
    end

    function context.subscription_count(event_name)
        local count = 0

        for _ in pairs(handlers[event_name] or {}) do
            count = count + 1
        end

        return count
    end

    function context.total_subscriptions()
        local count = 0

        for event_name in pairs(handlers) do
            count = count + context.subscription_count(event_name)
        end

        return count
    end

    return context
end

return client
