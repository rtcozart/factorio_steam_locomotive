local WheelControl = require("script/handle_wheels.lua")
local FluidControl = require("script/handle_fluid.lua")

local fluid_disabled = settings.startup["rtc:steamtrain-disable"].value

local WHEEL_UPDATE_TICK = 2
local FLUID_UPDATE_TICK = 30

function on_tick(event)
	for i = 1 + event.tick % WHEEL_UPDATE_TICK, #global.locomotives, WHEEL_UPDATE_TICK do
		local v = global.locomotives[i]
		if is_locomotive_valid(i, v) then
			WheelControl:update_wheel_position(v.locomotive, v.wheels)
		end
	end

	if not fluid_disabled then
		for i = 1 + event.tick % FLUID_UPDATE_TICK, #global.locomotives, FLUID_UPDATE_TICK do
			local locomotive = global.locomotives[i]
			if is_locomotive_valid(i, locomotive) then
				FluidControl:update_fluid(locomotive)
			end
		end

		if event.tick % 60 == 30 then
			for i, v in pairs(global.locomotives) do
				if v.locomotive and v.locomotive.valid then
					if v.no_water then
						rendering.draw_sprite({
							sprite = "rtc:sprite-no-water",
							target = v.locomotive,
							surface = v.locomotive.surface,
							render_layer = "entity-info-icon",
							time_to_live = 30,
							x_scale = 0.5,
							y_scale = 0.5,
							target_offset = {0, -0.6}
						})
					elseif v.is_cold then
						rendering.draw_sprite({
							sprite = "rtc:sprite-cold",
							target = v.locomotive,
							surface = v.locomotive.surface,
							render_layer = "entity-info-icon",
							time_to_live = 30,
							x_scale = 0.5,
							y_scale = 0.5,
							target_offset = {0, -0.6}
						})
					end
				end
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
		local force = game.forces.neutral
		if (event.player_index) then
			local player = game.get_player(event.player_index)
			force = player.force
		end
		local position = event.created_entity.position
		local orientation = event.created_entity.orientation
		local surface = event.created_entity.surface
		event.created_entity.destroy()
		local locomotive = surface.create_entity({
			name = "rtc:steam-locomotive",
			position = position,
			orientation = orientation,
			force = force,
			raise_script_built = true
		})
		local wheels = WheelControl:apply_wheels(locomotive)
		table.insert(global.locomotives, {
			locomotive = locomotive,
			wheels = wheels,
			is_cold = true,
			no_water = true
		})
		-- hack to get fluid trains to see the created entity
		locomotive.train.manual_mode = false
		locomotive.train.manual_mode = true
	end
end

--[[
function on_load()
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
end
]]

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
script.on_event(defines.events.on_tick, on_tick)
script.on_event(defines.events.on_built_entity, on_build)
script.on_event(defines.events.on_robot_built_entity, on_build)
