local public = {}

local known_trains = {}

local FUEL_MAP = {
	{2.0, "rtc:hot-water3"},
	{1.8, "rtc:hot-water2"},
	{1.2, "rtc:hot-water1"},
	{0.0, "rtc:hot-water"}
}

function find_tender(locomotive)
	local function find(table, loco)
		for i, v in pairs(table) do
			if v.unit_number == loco.unit_number then
				return true
			end
		end
		return false
	end

	local saved_train = get_known_train(locomotive)
	if saved_train and saved_train.train and saved_train.train.valid then
		local t = saved_train.train
		for i, carriage in pairs(t.carriages) do
			if carriage.unit_number and carriage.unit_number == locomotive.unit_number then
				if find(t.locomotives["front_movers"], locomotive) then
					local tender = t.carriages[i+1]
					if tender and tender.prototype.name == "rtc:tender" and find(t.locomotives["front_movers"], tender) then
						saved_train.tender = tender
						return tender
					end
				else
					local tender = t.carriages[i-1]
					if tender and tender.prototype.name == "rtc:tender" and find(t.locomotives["back_movers"], tender) then
						saved_train.tender = tender
						return tender
					end
				end
				return nil
			end
		end
	end
end

function get_known_train(locomotive)
	local candidate = known_trains[locomotive.unit_number]
	if (candidate and candidate.train and candidate.train.valid) then
		return candidate
	else
		known_trains[locomotive.unit_number] = nil
	end
	--TODO: More optimal method?
	for _, surface in pairs(game.surfaces) do
		for _, t in pairs(surface.get_trains()) do
			for i, carriage in pairs(t.carriages) do
				if carriage.unit_number and carriage.unit_number == locomotive.unit_number then
					local saved_train = {}
					saved_train.train = t
					known_trains[locomotive.unit_number] = saved_train
					return saved_train
				end
			end
		end
    end
    return nil
end

function map_fuel_to_steam(fuel)
	for _, mapped in pairs(FUEL_MAP) do
		if fuel.fuel_acceleration_multiplier >= mapped[1] then
			return mapped[2]
		end
	end
end

function public:update_fluid(v)
	local tender = find_tender(v.locomotive)
	local current_water_count = v.locomotive.burner.inventory.get_item_count()
	local known_train = get_known_train(v.locomotive)
	if not (known_train and known_train.train and known_train.train.valid) then return end
	if current_water_count > 0 then
		local new_water_type
		if tender and tender.burner.currently_burning then
			new_water_type = map_fuel_to_steam(tender.burner.currently_burning)
		else
			new_water_type = "rtc:cold-water"
		end
		--shitty hack to get fluid locomotives to work
		if known_train.train.speed == 0 and new_water_type ~= "rtc:cold-water" then
			new_water_type = "rtc:hot-water"
		end
		if new_water_type ~= (v.locomotive.burner.currently_burning and v.locomotive.burner.currently_burning.name)
			and v.locomotive.burner.inventory.get_item_count(new_water_type) == 0 then
			--set stack?
			v.locomotive.burner.inventory.clear()
			v.locomotive.burner.inventory.insert({name = new_water_type, count = current_water_count})
			v.locomotive.burner.remaining_burning_fuel = 0
		end

		if new_water_type == "rtc:cold-water" then
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
		--prevent tender from wasting fuel when water is empty
	elseif v.locomotive.burner.remaining_burning_fuel == 0 then
		if not known_train.train.manual_mode then
			known_train.train.manual_mode = true
		end
	end
end

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

--[[
commands.add_command("fluid_dump", nil, function(command)
	remote.call("fluidTrains_hook", "dumpConfig")
end)
]]

script.on_init(on_init)
script.on_configuration_changed(on_init)
script.on_event(defines.events.on_player_main_inventory_changed, on_inventory_changed)

return public
