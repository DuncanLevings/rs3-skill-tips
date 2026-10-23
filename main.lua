-- plugin entry point, just hands the client hooks over to src/app.lua

local app = require("src/app")

function PluginShutdown()
    app.stop()
end

app.start()
