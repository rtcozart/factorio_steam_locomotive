global = {}

function apply_wheels(train)
    local wheels = train.surface.create_entity({
        name = "steam-wheels",
        position = train.position,
        orientation = train.orientation,
        force = game.forces.neutral
    })
    global[train] = wheels
    return wheels
end

function on_tick()
    local train
    local wheels
    for i, v in pairs(game.surfaces["nauvis"].find_entities_filtered({name="steam-locomotive"})) do
        if not train then
            train = v
        end
    end
        for i, v in pairs(game.surfaces["nauvis"].find_entities_filtered({name="steam-wheels"})) do
        if not wheels then
            wheels = v
        end
    end
    if not wheels and not train then return end
    if wheels and not train then
        wheels.destroy()
    end
    if train and not wheels then
        wheels = apply_wheels(train)
    end
    --wheels.teleport(train.position)
    --wheels.teleport(0.1,0)
    --game.print(wheels.position.x)
    wheels.orientation = train.orientation
    local x = wheels.position.x - train.position.x
    local y = wheels.position.y - train.position.y
    wheels.speed = train.speed-- + (math.sqrt(x*x + y*y) * 0.2)
    --if math.abs(math.floor(train.position.x) - train.position.x) < 0.01 and math.abs(math.floor(train.position.y) - train.position.y) < 0.01 then
    wheels.teleport(train.position)
    --end
    --for train, wheels in pairs (global) do
     --   if (train and wheels and train.valid and wheels.valid) then
            --local offset = {train.orientation * 10 * 3.14 * 2, train.orientation * 10 * 3.14 * 2}
            --print(train.position.x)
            --wheels.teleport({x = train.position[0] + offset[0], y = train.position[1] + offset[1]})
     --       wheels.orientation = train.orientation
     --   end
   -- end
end

function haha(event)
    if (event.created_entity.name == 'steam-locomotive') then
        apply_wheels(event.created_entity)
    end
end

--script.on_event(defines.events.on_train_created, applyWheels)
script.on_event(defines.events.on_tick, on_tick)
script.on_event(defines.events.on_built_entity, haha)
