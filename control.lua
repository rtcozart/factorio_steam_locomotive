local WheelControl = require("script/handle_wheels.lua")
local FluidControl = require("script/handle_fluid.lua")

local fluid_disabled = settings.startup["rtc:steamtrain-disable"].value

function on_tick(event)
	for i, v in pairs(global.locomotives) do
		if is_locomotive_valid(i, v) then
			WheelControl:update_wheel_position(v.locomotive, v.wheels)
		end
	end

	--TODO: call on nth_tick event instead? will that improve performance at all?
	--this timing is necessary for custom fuel icons to render
	--if I want to change up the timing, I'll need to split that into a separate event
	if not fluid_disabled and event.tick % 60 == 30 then
		for i, v in pairs(global.locomotives) do
			if is_locomotive_valid(i, v) then
				FluidControl:update_fluid(v)
			end
		end
	end
end

function is_locomotive_valid(i, v)
	if not v.locomotive or not v.locomotive.valid then
		table.remove(global.locomotives, i)
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
			force = player.force or game.forces.neutral,
			raise_script_built = true
		})
		local wheels = WheelControl:apply_wheels(locomotive)
		table.insert(global.locomotives, {
			locomotive = locomotive,
			wheels = wheels
		})
		-- hack to get fluid trains to see the created entity
		locomotive.train.manual_mode = false
		locomotive.train.manual_mode = true
	end
end

function on_load()
--[[
	for _, surface in pairs(game.surfaces) do
		for _, v in pairs(surface.find_entities_filtered({name={"rtc:steam-wheels","rtc:steam-locomotive-placement-entity"}})) do
			v.destroy()
		end
		for _, locomotive in pairs(surface.find_entities_filtered({name="rtc:steam-locomotive"})) do
			local wheels = WheelControl:apply_wheels(locomotive)
			table.insert(global.locomotives, {
				locomotive = locomotive,
				wheels = wheels
			})
		end
	end
	]]
end

function on_init()
	if not global then global = {} end
	if not global.locomotives then global.locomotives = {} end
	if not global.tender_fuel then global.tender_fuel = {} end
	if not settings.startup["rtc:steamtrain-disable"].value then
		remote.call("fluidTrains_hook", "addLocomotive", "rtc:steam-locomotive", 3000)
		remote.call("fluidTrains_hook", "addFluid", "rtc:water", "water", {{item = "rtc:hot-water"}})

		remote.call("fluidTrains_hook", "addFluid", "rtc:water", "steam", {{item = "rtc:hot-water3", temp = 600}})
		remote.call("fluidTrains_hook", "addFluid", "rtc:water", "steam", {{item = "rtc:hot-water2", temp = 400}})
		remote.call("fluidTrains_hook", "addFluid", "rtc:water", "steam", {{item = "rtc:hot-water1", temp = 200}})
		--remote.call("fluidTrains_hook", "addFluid", "rtc:water", "water", {{item = "rtc:cold-water"}})
	end
end
commands.add_command("fluid_dump", nil, function(command)
	remote.call("fluidTrains_hook", "dumpConfig")
end)


script.on_configuration_changed(on_init)
script.on_init(on_init)
script.on_load(on_load)
script.on_event(defines.events.on_tick, on_tick)
script.on_event(defines.events.on_built_entity, on_build)
script.on_event(defines.events.on_robot_built_entity, on_build)
