global = {}

function apply_wheels(train)
    local wheels = train.surface.create_entity({
        name = "rtc:steam-wheels",
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
    for i, v in pairs(game.surfaces["nauvis"].find_entities_filtered({name="rtc:steam-locomotive"})) do
        if not train then
            train = v
        end
    end
        for i, v in pairs(game.surfaces["nauvis"].find_entities_filtered({name="rtc:steam-wheels"})) do
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
    wheels.orientation = train.orientation
    --position is slightly off when vertical, especially noticable at 45 degrees
    local angle = math.pi*2*train.orientation
    local sin = math.sin(angle)
    local cos = math.cos(angle)
    local offset = { x = sin*math.abs(cos)*-0.2, y = cos*0.15 }
    wheels.speed = train.speed
    wheels.teleport({x = train.position.x + offset.x, y = train.position.y + offset.y})
end

function onbuild(event)
    if (event.created_entity.name == 'rtc:steam-locomotive') then
        apply_wheels(event.created_entity)
    end
end

--script.on_event(defines.events.on_train_created, applyWheels)
script.on_event(defines.events.on_tick, on_tick)
script.on_event(defines.events.on_built_entity, onbuild)
