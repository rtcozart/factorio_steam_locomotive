trains = nil

function apply_wheels(train)
    local wheels = train.surface.create_entity({
        name = "rtc:steam-wheels",
        position = train.position,
        orientation = train.orientation,
        force = game.forces.neutral
    })
    table.insert(trains, {train = train, wheels = wheels})
end

function on_tick(tick_name, tick_number)
    if not trains then
        on_start()
    end
    for i, v in pairs(trains) do
        update_wheel_position(v.train, v.wheels)

        if not v.train or not v.train.valid then
            table.remove(trains, i)
            if v.wheels then
                v.wheels.destroy()
            end
        end

        --TODO: handle wheels and not train cond?
    end
end

function update_wheel_position(train, wheels)
    --TODO: the train sprite sometimes wobbles. can this be read?
    if not train or not train.valid or not wheels or not wheels.valid then return end
    wheels.orientation = train.orientation
    --position is slightly off when vertical, noticeable at 45 degrees
    local angle = math.pi*2*train.orientation
    local sin = math.sin(angle)
    local cos = math.cos(angle)
    local offset = { x = sin*math.abs(cos)*-0.2, y = cos*0.15 }
    wheels.speed = train.speed
    wheels.teleport({x = train.position.x + offset.x, y = train.position.y + offset.y})
end

function on_build(event)
    if (event.created_entity.name == 'rtc:steam-locomotive') then
        apply_wheels(event.created_entity)
    end
end

function get_train_by_key(key, obj)
    for _, v in pairs(trains) do
        if obj == v[key] then
            return v
        end
    end
    return nil
end

function on_start()
    trains = {}
    for _, v in pairs(game.surfaces["nauvis"].find_entities_filtered({name="rtc:steam-wheels"})) do
        v.destroy()
    end
    for _, v in pairs(game.surfaces["nauvis"].find_entities_filtered({name="rtc:steam-locomotive"})) do
        apply_wheels(v)
    end
end

script.on_event(defines.events.on_tick, on_tick)
script.on_event(defines.events.on_built_entity, on_build)
