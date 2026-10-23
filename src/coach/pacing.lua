-- pacing is session state, reset when the app changes character or restarts.
local settings = require("src/storage/settings")
local pacing = {}

function pacing.new()
    local last_shown, last_combat
    local count = 0
    local gate = {}
    function gate.allows(now)
        if not settings.get("tips_enabled") then
            return false
        end
        if last_combat and now - last_combat < settings.get("combat_quiet_seconds") then
            return false
        end
        if last_shown and now - last_shown < settings.get("cooldown_minutes") * 60 then
            return false
        end
        local cap = settings.get("session_cap")
        return cap == 0 or count < cap
    end
    function gate.shown(now)
        last_shown = now
        count = count + 1
    end
    function gate.combat(now)
        last_combat = now
    end
    function gate.reset()
        last_shown = nil
        count = 0
    end
    return gate
end

return pacing
