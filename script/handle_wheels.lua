local public = {}

function public:apply_wheels(locomotive)
    local wheels = locomotive.surface.create_entity({
        name = "rtc:steam-wheels",
        position = locomotive.position,
        orientation = locomotive.orientation,
        force = game.forces.neutral
    })
    return wheels
end

function public:update_wheel_position(locomotive, wheels)
    --TODO: the locomotive sprite sometimes wobbles. can this be read?
    if not locomotive or not locomotive.valid or not wheels or not wheels.valid then return end
    wheels.orientation = locomotive.orientation
    --position is slightly off when vertical, noticeable at 45 degrees
    local angle = math.pi*2*locomotive.orientation
    local sin = math.sin(angle)
    local cos = math.cos(angle)
    local offset = { x = sin*math.abs(cos)*-0.2, y = cos*0.15 }
    wheels.speed = locomotive.speed
    wheels.teleport({x = locomotive.position.x + offset.x, y = locomotive.position.y + offset.y})
end

return public
