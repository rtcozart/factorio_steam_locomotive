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
	if not locomotive or not locomotive.valid or not wheels or not wheels.valid then return end
	wheels.orientation = locomotive.orientation
	local offset = {x = 0, y = 0}
	--when connected behind another engine, the position not accurate for some reason
	local in_front = locomotive.get_connected_rolling_stock(defines.rail_direction.front)
	if in_front and in_front.valid then
		local angle = math.pi*2*in_front.orientation
		offset = { x = math.sin(angle) * math.cos(angle) * -0.5, y = 0 }
	end
	wheels.speed = locomotive.speed
	wheels.teleport({x = locomotive.position.x + offset.x, y = locomotive.position.y + offset.y})
end

return public
