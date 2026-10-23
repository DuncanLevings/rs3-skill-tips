-- only unmet requirements belong on a discovery card.
local requirement_list = {}

-- "SMITHING" -> "Smithing"
local function skill_label(skill)
    return skill:sub(1, 1) .. skill:sub(2):lower()
end

-- only what the player hasnt got yet, met requirements are just clutter
function requirement_list.missing(tip, state)
    local lines = {}
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

    for _, quest in ipairs((tip.requirements or {}).quests or {}) do
        if not state.quest_done(quest) then
            lines[#lines + 1] = "- " .. (state.quest_name(quest) or quest)
        end
    end

    return lines
end

return requirement_list
