-- decides when the player is actually training a skill, as opposed to getting xp from a lamp,
-- a book or a quest reward. tips only ever hear "training MINING", never raw xp.
--
-- how reward xp and training xp look different:
-- - lamps, books and quest hand ins all finish with a dialogue button (actionType 30) and the
--   xp lands within a second of it
-- - rubbing/reading an item starts that flow, so xp shortly after one of those is ignored too
-- - real training gives a steady trickle of drops, so it takes 3 drops in 2 minutes
--
-- no client calls in here, the adapters pass clicks and xp in with a time in seconds

local skill_activity = {}

skill_activity.DROPS_NEEDED = 3
skill_activity.WINDOW_SECONDS = 120
skill_activity.DIALOGUE_GUARD_SECONDS = 2
skill_activity.REWARD_ITEM_GUARD_SECONDS = 30

-- the PAUSE_BUTTON action type, used by dialogue Confirm/Continue/Select buttons
local DIALOGUE_BUTTON = 30

-- item verbs that hand out reward xp
local REWARD_VERBS = {
    Rub = true,
    Read = true,
    Claim = true,
    Redeem = true,
}

function skill_activity.new()
    local tracker = {
        last_dialogue_click = nil,
        last_reward_item_click = nil,
        recent_drops = {},
    }

    -- click = { action_type = number, verb = string, is_item = boolean }
    function tracker.click(click, now)
        if click.action_type == DIALOGUE_BUTTON then
            tracker.last_dialogue_click = now
        end

        if click.is_item and REWARD_VERBS[click.verb] then
            tracker.last_reward_item_click = now
        end
    end

    local function within(last, seconds, now)
        return last ~= nil and now - last <= seconds
    end

    local function is_reward_xp(now)
        return within(tracker.last_dialogue_click, skill_activity.DIALOGUE_GUARD_SECONDS, now)
            or within(tracker.last_reward_item_click, skill_activity.REWARD_ITEM_GUARD_SECONDS, now)
    end

    tracker.reward_guard_active = is_reward_xp

    -- forget drops that fell out of the window
    local function trim(drops, now)
        local kept = {}

        for _, time in ipairs(drops) do
            if now - time <= skill_activity.WINDOW_SECONDS then
                kept[#kept + 1] = time
            end
        end

        return kept
    end

    ---@return boolean training true once this drop shows the skill is being trained
    function tracker.xp(skill, now)
        if is_reward_xp(now) then
            return false
        end

        local drops = trim(tracker.recent_drops[skill] or {}, now)
        drops[#drops + 1] = now
        tracker.recent_drops[skill] = drops

        return #drops >= skill_activity.DROPS_NEEDED
    end

    return tracker
end

return skill_activity
