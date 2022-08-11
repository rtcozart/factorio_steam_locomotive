local WheelControl = require("script/handle_wheels.lua")
local FluidControl = require("script/handle_fluid.lua")

local locomotives = nil

function on_tick(event)
	--TODO: implement without a check every tick?
	if not locomotives then
		locomotives = {}
		on_start()
	end
	for i, v in pairs(locomotives) do
		if is_locomotive_valid(i, v) then
			WheelControl:update_wheel_position(v.locomotive, v.wheels)
		end
	end

	if event.tick % 60 == 30 then
		for i, v in pairs(locomotives) do
			if is_locomotive_valid(i, v) then
				FluidControl:update_fluid(v)
			end
		end
	end
end

function is_locomotive_valid(i, v)
	--TODO: handle possible condition where wheels exist but not locomotive?
	if not v.locomotive or not v.locomotive.valid then
		table.remove(locomotives, i)
		if v.wheels then
			v.wheels.destroy()
		end
		return false
	else
		return true
	end
end

function on_build(event)
	if (event.created_entity.name == 'rtc:steam-locomotive-placement-entity') then
		local position = event.created_entity.position
		local orientation = event.created_entity.orientation
		local surface = event.created_entity.surface
		event.created_entity.destroy()
		local locomotive = surface.create_entity({
			name = "rtc:steam-locomotive",
			position = position,
			orientation = orientation,
			force = game.forces.neutral
		})
		local wheels = WheelControl:apply_wheels(locomotive)
		table.insert(locomotives, {
			locomotive = locomotive,
			wheels = wheels,
			boiler = {
				last_water_amount = 0
			}
		})
	end
end

function on_start()
	for _, surface in pairs(game.surfaces) do
		for _, v in pairs(surface.find_entities_filtered({name="rtc:steam-locomotive-placement-entity"})) do
			v.destroy()
		end
		for _, v in pairs(surface.find_entities_filtered({name="rtc:steam-wheels"})) do
			v.destroy()
		end
		for _, locomotive in pairs(surface.find_entities_filtered({name="rtc:steam-locomotive"})) do
			local wheels = WheelControl:apply_wheels(locomotive)
			table.insert(locomotives, {
				locomotive = locomotive,
				wheels = wheels,
				boiler = {
					last_water_amount = locomotive.burner.inventory.get_item_count()
				}
			})
		end
	end
end

script.on_event(defines.events.on_tick, on_tick)
script.on_event(defines.events.on_built_entity, on_build)
script.on_event(defines.events.on_robot_built_entity, on_build)
