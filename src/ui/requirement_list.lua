-- the parts of a card that depend on the player rather than the tip alone: which hook and
-- steps to show, and the list of requirements they havent met yet. met requirements are left
-- off, theyre just clutter

local quest_readiness = require("src/coach/quest_readiness")

local requirement_list = {}

-- a quest tip shown early (the player is a few levels short) uses its aspiration text
local function shown_early(tip, state)
    if not tip.aspiration then
        return false
    end

    local readiness = quest_readiness.assess(tip, state)
    return readiness.eligible and not readiness.fully_met
end

function requirement_list.hook(tip, state)
    return shown_early(tip, state) and tip.aspiration_hook or tip.hook
end

-- heading above the unmet requirements
function requirement_list.label(tip, state)
    return shown_early(tip, state) and "Still need:" or "Needs:"
end

-- while a required quest isnt done, quest_how points the player at it instead of showing how
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

-- "- Smithing 40 (you're level 35)"
local function level_line(skill, needed, current)
    local suffix = current and (" (you're level " .. current .. ")") or ""
    return "- " .. skill_label(skill) .. " " .. needed .. suffix
end

-- quest tips go through quest_readiness, which also handles either/or requirements like
-- "Magic 76 or Ranged 76"
local function missing_quest_levels(tip, state)
    local lines = {}
    local readiness = quest_readiness.assess(tip, state)

    for _, need in ipairs(readiness.missing) do
        if need.alternative then
            -- the skill might also have its own required level below the either/or one
            local required = (tip.requirements.skills or {})[need.skill]
            if required and need.current < required then
                lines[#lines + 1] = level_line(need.skill, required, need.current)
            end

            local options = {}
            for _, skill in ipairs(readiness.alternatives or {}) do
                options[#options + 1] = skill_label(skill)
                    .. " "
                    .. tip.requirements.any_skills[skill]
            end

            lines[#lines + 1] = "- " .. table.concat(options, " or ")
        else
            lines[#lines + 1] = level_line(need.skill, need.needed, need.current)
        end
    end

    return lines
end

-- every unmet requirement as a "- " line, skills A to Z then quests
function requirement_list.missing(tip, state)
    if tip.kind == "quest" then
        return missing_quest_levels(tip, state)
    end

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
            lines[#lines + 1] = level_line(skill, needed, level)
        end
    end

    -- with quest_how the quest is already named in the steps, no need to list it twice
    if not tip.quest_how then
        for _, quest in ipairs((tip.requirements or {}).quests or {}) do
            if not state.quest_done(quest) then
                lines[#lines + 1] = "- " .. (state.quest_name(quest) or quest)
            end
        end
    end

    return lines
end

return requirement_list
