-- owns startup and shutdown. every module that subscribes to something gets started and
-- stopped from here so theres one place to see what the plugin is hooked into

local coach_window = require("src/ui/coach_window")
local settings_page = require("src/ui/settings_page")

local app = {}

local started = false

function app.start()
    if started then
        return
    end

    assert(
        prettyui and prettyui.SimpleView,
        "Skilling Coach needs PrettyUI, get it from the Plugin Hub"
    )

    coach_window.start()
    settings_page.start()

    started = true

    log("Skilling Coach started.")
end

function app.stop()
    if not started then
        return
    end

    started = false

    settings_page.stop()
    coach_window.stop()

    log("Skilling Coach stopped.")
end

return app
