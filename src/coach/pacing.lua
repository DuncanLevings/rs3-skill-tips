-- how often cards are allowed to appear. each engine session (one character login) gets its
-- own gate, so switching character starts the counts again.
--
-- a card can show when tips are on, combat ended long enough ago, the time between tips has
-- passed and the session cap isnt reached

local settings = require("src/storage/settings")
local development = require("src/development")

local pacing = {}

function pacing.new()
    local last_shown, last_combat
    local shown_count = 0
    local gate = {}

    -- now is in seconds, from clock.now
    function gate.allows(now)
        if not settings.get("tips_enabled") then
            return false
        end

        if last_combat and now - last_combat < settings.get("combat_quiet_seconds") then
            return false
        end

        -- the development switch skips the time between tips, every other rule still applies
        local cooldown = settings.get("cooldown_minutes") * 60
        if not development.ENABLED and last_shown and now - last_shown < cooldown then
            return false
        end

        local cap = settings.get("session_cap")
        return cap == 0 or shown_count < cap
    end

    function gate.shown(now)
        last_shown = now
        shown_count = shown_count + 1
    end

    function gate.combat(now)
        last_combat = now
    end

    function gate.reset()
        last_shown = nil
        shown_count = 0
    end

    return gate
end

return pacing
