local WheelControl = require("script/handle_wheels.lua")
local FluidControl = require("script/handle_fluid.lua")

local locomotives = nil

local fluid_disabled = settings.startup["rtc:steamtrain-disable"].value

function on_tick(event)
	for i, v in pairs(locomotives) do
		if is_locomotive_valid(i, v) then
			WheelControl:update_wheel_position(v.locomotive, v.wheels)
		end
	end

	--TODO: call on nth_tick event instead? will that improve performance at all?
	--this timing is necessary for custom fuel icons to render
	--if I want to change up the timing, I'll need to split that into a separate event
	if not fluid_disabled and event.tick % 60 == 30 then
		for i, v in pairs(locomotives) do
			if is_locomotive_valid(i, v) then
				FluidControl:update_fluid(v)
			end
		end
	end
end

function is_locomotive_valid(i, v)
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
		local player = game.get_player(event.player_index)
		local position = event.created_entity.position
		local orientation = event.created_entity.orientation
		local surface = event.created_entity.surface
		event.created_entity.destroy()
		local locomotive = surface.create_entity({
			name = "rtc:steam-locomotive",
			position = position,
			orientation = orientation,
			force = player.force or game.forces.neutral
		})
		local wheels = WheelControl:apply_wheels(locomotive)
		table.insert(locomotives, {
			locomotive = locomotive,
			wheels = wheels
		})
	end
end

function on_start()
	for _, surface in pairs(game.surfaces) do
		for _, v in pairs(surface.find_entities_filtered({name={"rtc:steam-wheels","rtc:steam-locomotive-placement-entity"}})) do
			v.destroy()
		end
		for _, locomotive in pairs(surface.find_entities_filtered({name="rtc:steam-locomotive"})) do
			local wheels = WheelControl:apply_wheels(locomotive)
			table.insert(locomotives, {
				locomotive = locomotive,
				wheels = wheels
			})
		end
	end

	--overwrites on_start listener
	script.on_event(defines.events.on_tick, on_tick)
end

script.on_event(defines.events.on_tick, function(event)
	--hopefully there's a better implementation than this
	if not locomotives then
		locomotives = {}
		on_start()
	end
end)

script.on_event(defines.events.on_built_entity, on_build)
script.on_event(defines.events.on_robot_built_entity, on_build)
