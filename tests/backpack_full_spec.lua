local lu = require("luaunit")
local client = require("tests/support/client")

local function setup(root, verb, skill)
    local fake = client.new(root)
    local shown = {}
    local clock = fake.load("src/game/clock")
    local watch = fake.load("src/game/activity_watch")
    local ticks = 0
    local function slots(used)
        fake.inventories[93] = {}
        for index = 1, used do
            fake.inventories[93][index] = { item = "ORE" }
        end
    end
    local function advance(count)
        for _ = 1, count do
            ticks = ticks + 1
            fake.fire("Logic", { logicTick = ticks })
        end
    end
    local function xp()
        fake.fire("SkillTransmit", { skill = skill or 14, oldXP = 100, newXP = 110 })
    end

    slots(26)
    clock.start()
    watch.start({
        on_training = function() end,
        on_combat = function() end,
        on_backpack_full = function(name)
            shown[#shown + 1] = name
        end,
    })
    fake.fire("MiniMenuEntrySelected", { entry = { verbText = verb or "Mine", locData = {} } })
    xp()
    advance(150)
    xp()
    advance(150)

    return { fake = fake, watch = watch, shown = shown, slots = slots, advance = advance, xp = xp }
end

return function(root)
    local suite = {}

    function suite:test_inventory_then_xp_fires_once_when_the_last_slot_fills()
        local world = setup(root)
        world.slots(28)
        world.advance(1)
        world.xp()
        world.advance(100)
        world.xp()
        lu.assertEquals(world.shown, { "MINING" })
    end

    function suite:test_xp_then_inventory_is_also_detected()
        local world = setup(root)
        world.xp()
        world.slots(28)
        world.advance(2)
        lu.assertEquals(world.shown, { "MINING" })
    end

    function suite:test_early_ores_and_xp_without_full_inventory_do_not_fire()
        local world = setup(root)
        world.slots(27)
        world.xp()
        world.advance(2)
        lu.assertEquals(world.shown, {})
    end

    function suite:test_full_inventory_without_matching_xp_does_not_fire_later()
        local world = setup(root)
        world.slots(28)
        world.advance(100)
        world.xp()
        lu.assertEquals(world.shown, {})
    end

    function suite:test_pickup_click_and_bank_updates_do_not_count_as_mining()
        local world = setup(root)
        world.fake.fire("MiniMenuEntrySelected", { entry = { verbText = "Take", objData = {} } })
        world.slots(28)
        world.xp()
        world.advance(2)
        lu.assertEquals(world.shown, {})

        world = setup(root)
        world.fake.inventories[95] = {}
        world.slots(28)
        world.xp()
        world.advance(2)
        lu.assertEquals(world.shown, {})
    end

    function suite:test_already_full_backpack_does_not_trigger()
        local world = setup(root)
        world.slots(28)
        world.fake.fire("MiniMenuEntrySelected", { entry = { verbText = "Mine", locData = {} } })
        world.xp()
        world.advance(2)
        lu.assertEquals(world.shown, {})
    end

    function suite:test_woodcutting_uses_its_own_signal_and_stop_cleans_up()
        local world = setup(root, "Chop down", 8)
        world.slots(28)
        world.xp()
        world.advance(2)
        lu.assertEquals(world.shown, { "WOODCUTTING" })
        world.watch.stop()
        lu.assertEquals(world.fake.subscription_count("SkillTransmit"), 0)
        lu.assertEquals(world.fake.subscription_count("Logic"), 1)
    end

    return suite
end
