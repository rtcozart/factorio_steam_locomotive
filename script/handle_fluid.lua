local function on_init()
	remote.call("fluidTrains_hook", "addLocomotive", "rtc:steam-locomotive", 3000)
	remote.call("fluidTrains_hook", "addFluid", "rtc:water", "water", {{item = "rtc:hot-water"}})

	remote.call("fluidTrains_hook", "addFluid", "rtc:water", "steam", {{item = "rtc:hot-water3", temp = 600}})
	remote.call("fluidTrains_hook", "addFluid", "rtc:water", "steam", {{item = "rtc:hot-water2", temp = 400}})
	remote.call("fluidTrains_hook", "addFluid", "rtc:water", "steam", {{item = "rtc:hot-water1", temp = 200}})
	--remote.call("fluidTrains_hook", "addFluid", "rtc:water", "water", {{item = "rtc:cold-water"}})
end

function on_inventory_changed(event)
	local player = game.get_player(event.player_index)
	if player and player.valid then
		local inventory = player.get_main_inventory()
		local forbidden_items = {"rtc:cold-water","rtc:hot-water","rtc:hot-water1","rtc:hot-water2","rtc:hot-water3"}
		for _,name in pairs(forbidden_items) do
			local item_count = inventory.get_item_count(name)
			if item_count > 0 then
				local removed_count = inventory.remove({name=name, count=item_count})
				--game.print("Removed "..item_count.." of item "..name)
			end
		end
	end
end

script.on_init(on_init)
script.on_configuration_changed(on_init)
script.on_event(defines.events.on_player_main_inventory_changed, on_inventory_changed)

commands.add_command("fluid_dump", nil, function(command)
	remote.call("fluidTrains_hook", "dumpConfig")
end)
