-- fake client for specs. loads plugin files into a sandbox with stand-ins for Event, prettyui
-- and log, and keeps track of what got subscribed so specs can fire events by hand

local client = {}

-- Event.<Name>.Subscribe/Unsubscribe that remember the handlers per event
local function create_events()
    local handlers = {}
    local events = {}

    setmetatable(events, {
        __index = function(_, event_name)
            handlers[event_name] = handlers[event_name] or {}
            local event = {
                Subscribe = function(reference, handler)
                    handlers[event_name][reference] = handler
                end,
                Unsubscribe = function(reference)
                    handlers[event_name][reference] = nil
                end,
            }

            return event
        end,
    })

    return events, handlers
end

-- just enough of prettyui for views: remembers added text and whether its been destroyed
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
        end

        function view:AddSimpleButton(text, action)
            self.buttons[#self.buttons + 1] = { text = text, action = action }
        end

        function view:Destroy()
            self.destroyed = true
        end

        context.views[#context.views + 1] = view

        return view
    end

    return { SimpleView = SimpleView }
end

function client.new(root)
    local events, handlers = create_events()
    local context = {
        views = {},
        logs = {},
        handlers = handlers,
    }
    local modules = {}
    local environment = setmetatable({}, { __index = _G })

    environment.Event = events
    environment.prettyui = create_prettyui(context)
    environment.log = function(message)
        context.logs[#context.logs + 1] = message
    end

    -- plugin files require each other by path from the plugin root, same as the client
    environment.require = function(path)
        if modules[path] == nil then
            local chunk = assert(loadfile(root .. "/" .. path .. ".lua", "t", environment))
            modules[path] = chunk()
        end

        return modules[path]
    end

    context.environment = environment
    context.load = environment.require

    -- calls every handler subscribed to an event, like the client would
    function context.fire(event_name, payload)
        for _, handler in pairs(handlers[event_name] or {}) do
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

    return context
end

return client
