-- slides the tip card in from (and back out to) the screen edge its closest to.
--
-- docked cards (right up against an edge) start fully off screen, floating ones only move a
-- short way in from that side while fading in. theres no built in tween, so the position is
-- set by hand every frame from Event.Draw. 0.5s was picked in game, 0.18 looked rushed

local card_motion = {}

card_motion.SLIDE_SECONDS = 0.5
-- within this many pixels of an edge counts as docked to it
card_motion.DOCK_DISTANCE = 40
card_motion.FLOAT_DISTANCE = 24

local DRAW_SUBSCRIPTION = "skilling_coach_card_motion"

local active

-- which edge the card is nearest, and how far away it is
function card_motion.nearest_edge(card, area)
    local distances = {
        left = card.x,
        right = area.width - (card.x + card.width),
        top = card.y,
        bottom = area.height - (card.y + card.height),
    }
    local best_edge, best_distance = "left", math.huge

    -- fixed order so ties always pick the same edge
    for _, edge in ipairs({ "left", "right", "top", "bottom" }) do
        if distances[edge] < best_distance then
            best_edge, best_distance = edge, distances[edge]
        end
    end

    return best_edge, best_distance
end

-- where the card sits while hidden, for a card resting at card.x/card.y
function card_motion.hidden_position(card, area)
    local edge, distance = card_motion.nearest_edge(card, area)
    local docked = distance <= card_motion.DOCK_DISTANCE
    local x, y = card.x, card.y

    if edge == "left" then
        x = docked and -card.width or card.x - card_motion.FLOAT_DISTANCE
    elseif edge == "right" then
        x = docked and area.width or card.x + card_motion.FLOAT_DISTANCE
    elseif edge == "top" then
        y = docked and -card.height or card.y - card_motion.FLOAT_DISTANCE
    else
        y = docked and area.height or card.y + card_motion.FLOAT_DISTANCE
    end

    -- docked cards slide in fully opaque, floating ones fade so they dont pop in mid screen
    return x, y, not docked
end

-- slower at the end feels less mechanical than a straight line
local function ease_out(progress)
    return 1 - (1 - progress) ^ 3
end

local function set_alpha(root, alpha)
    pcall(function()
        root.alpha = alpha
    end)
end

local function step(event)
    local slide = active

    if not slide then
        Event.Draw.Unsubscribe(DRAW_SUBSCRIPTION)
        return
    end

    slide.elapsed = slide.elapsed + (event.timeDeltaSecs or 0.016)
    local progress = math.min(slide.elapsed / slide.seconds, 1)
    local eased = ease_out(progress)
    local x = slide.from_x + (slide.to_x - slide.from_x) * eased
    local y = slide.from_y + (slide.to_y - slide.from_y) * eased

    pcall(function()
        slide.root:SetPos(math.floor(x + 0.5), math.floor(y + 0.5))
    end)

    if slide.fade then
        set_alpha(slide.root, slide.fade_in and eased or 1 - eased)
    end

    if progress >= 1 then
        active = nil
        Event.Draw.Unsubscribe(DRAW_SUBSCRIPTION)

        if slide.on_done then
            slide.on_done()
        end
    end
end

-- moves root from one spot to another. animate = false jumps straight there (the Animate
-- card setting). only one slide runs at a time, a new one replaces the old
local function run(slide, animate)
    active = nil

    if not animate then
        pcall(function()
            slide.root:SetPos(slide.to_x, slide.to_y)
        end)
        set_alpha(slide.root, slide.fade_in == false and 0 or 1)

        if slide.on_done then
            slide.on_done()
        end

        return
    end

    slide.elapsed = 0
    slide.seconds = card_motion.SLIDE_SECONDS
    active = slide
    Event.Draw.Subscribe(DRAW_SUBSCRIPTION, step)
end

-- card = { x, y, width, height } where it should end up, area = { width, height }
function card_motion.slide_in(root, card, area, animate, on_done)
    local from_x, from_y, fade = card_motion.hidden_position(card, area)

    pcall(function()
        root:SetPos(from_x, from_y)
    end)

    if fade and animate then
        set_alpha(root, 0)
    end

    run({
        root = root,
        from_x = from_x,
        from_y = from_y,
        to_x = card.x,
        to_y = card.y,
        fade = fade,
        fade_in = true,
        on_done = on_done,
    }, animate)
end

function card_motion.slide_out(root, card, area, animate, on_done)
    local to_x, to_y, fade = card_motion.hidden_position(card, area)

    run({
        root = root,
        from_x = card.x,
        from_y = card.y,
        to_x = to_x,
        to_y = to_y,
        fade = fade,
        fade_in = false,
        on_done = on_done,
    }, animate)
end

function card_motion.is_sliding()
    return active ~= nil
end

function card_motion.stop()
    active = nil
    Event.Draw.Unsubscribe(DRAW_SUBSCRIPTION)
end

return card_motion
