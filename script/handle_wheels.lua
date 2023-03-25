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
	if locomotive.speed == 0 and wheels.speed == 0 and wheels.orientation == locomotive.orientation then
		return
	end
	wheels.orientation = locomotive.orientation
	local offset = {x = 0, y = 0.5}
	local b = locomotive.selection_box
	local bx = (b.left_top.x + b.right_bottom.x) * 0.5
	local by = (b.left_top.y + b.right_bottom.y) * 0.5
	wheels.speed = locomotive.speed
	wheels.teleport({x = bx + offset.x, y = by + offset.y}, locomotive.surface)
end

return public
