-- only unmet requirements belong on a discovery card.
local quest_readiness = require("src/coach/quest_readiness")
local requirement_list = {}

function requirement_list.hook(tip, state)
    if tip.aspiration then
        local readiness = quest_readiness.assess(tip, state)
        if readiness.eligible and not readiness.fully_met then
            return tip.aspiration_hook
        end
    end
    return tip.hook
end

function requirement_list.label(tip, state)
    if tip.aspiration then
        local readiness = quest_readiness.assess(tip, state)
        if readiness.eligible and not readiness.fully_met then
            return "Still need:"
        end
    end
    return "Needs:"
end

-- an unfinished quest is a discovery pointer, rather than a reason to hide the card.
function requirement_list.steps(tip, state)
    if tip.quest_how then
        for _, quest in ipairs((tip.requirements or {}).quests or {}) do
            if state.quest_done(quest) ~= true then
                return tip.quest_how
            end
        end
    end
    return tip.how
end

-- "SMITHING" -> "Smithing"
local function skill_label(skill)
    return skill:sub(1, 1) .. skill:sub(2):lower()
end

-- only what the player hasnt got yet, met requirements are just clutter
function requirement_list.missing(tip, state)
    local lines = {}
    if tip.kind == "quest" then
        local readiness = quest_readiness.assess(tip, state)
        for _, need in ipairs(readiness.missing) do
            if need.alternative then
                local mandatory = (tip.requirements.skills or {})[need.skill]
                if mandatory and need.current < mandatory then
                    lines[#lines + 1] = "- "
                        .. skill_label(need.skill)
                        .. " "
                        .. mandatory
                        .. " (you're level "
                        .. need.current
                        .. ")"
                end
                local options = {}
                for _, skill in ipairs(readiness.alternatives or {}) do
                    options[#options + 1] = skill_label(skill)
                        .. " "
                        .. tip.requirements.any_skills[skill]
                end
                lines[#lines + 1] = "- " .. table.concat(options, " or ")
            else
                lines[#lines + 1] = "- "
                    .. skill_label(need.skill)
                    .. " "
                    .. need.needed
                    .. " (you're level "
                    .. need.current
                    .. ")"
            end
        end
        return lines
    end
    local required_skills = (tip.requirements or {}).skills or {}
    local names = {}

    for skill in pairs(required_skills) do
        names[#names + 1] = skill
    end

    table.sort(names)

    for _, skill in ipairs(names) do
        local needed = required_skills[skill]
        local level = state.level(skill)

        if not level or level < needed then
            local current = level and (" (you're level " .. level .. ")") or ""
            lines[#lines + 1] = "- " .. skill_label(skill) .. " " .. needed .. current
        end
    end

    -- quest_how already names the quest in the discovery paragraph.
    for _, quest in ipairs(not tip.quest_how and (tip.requirements or {}).quests or {}) do
        if not state.quest_done(quest) then
            lines[#lines + 1] = "- " .. (state.quest_name(quest) or quest)
        end
    end

    return lines
end

return requirement_list
