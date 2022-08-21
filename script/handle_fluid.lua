local public = {}

local FUEL_MAP = {
	{2.0, "rtc:hot-water3"},
	{1.8, "rtc:hot-water2"},
	{1.2, "rtc:hot-water1"},
	{0.0, "rtc:hot-water"}
}

function find_tender(locomotive)
	local train = locomotive.train
	if train and train.valid then
		local tender = locomotive.get_connected_rolling_stock(defines.rail_direction.back)
		if tender and tender.valid and tender.prototype.name == "rtc:tender" then
			return tender
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
	local train = v.locomotive.train
	if not (train and train.valid) then return end
	v.no_water = current_water_count == 0
	if current_water_count > 0 then
		local new_water_type
		if tender and tender.burner.currently_burning then
			new_water_type = map_fuel_to_steam(tender.burner.currently_burning)
		else
			new_water_type = "rtc:cold-water"
		end
		--shitty hack to get fluid locomotives to work
		if train.speed == 0 and new_water_type ~= "rtc:cold-water" then
			new_water_type = "rtc:hot-water"
		end

		if v.locomotive.burner.currently_burning then
			local water_updated = new_water_type ~= v.locomotive.burner.currently_burning.name
			local should_update_water = v.locomotive.burner.inventory.get_item_count(new_water_type) == 0 or v.locomotive.burner.currently_burning.name == "rtc:cold-water"
			if water_updated and should_update_water then
				v.locomotive.burner.inventory.clear()
				v.locomotive.burner.inventory.insert({name = new_water_type, count = current_water_count})
				if v.locomotive.burner.currently_burning.name == "rtc:cold-water" then
					v.locomotive.burner.remaining_burning_fuel = 0
				end
			end
		end

		local tender_has_fuel = tender and tender.valid and (tender.burner.remaining_burning_fuel > 0 or tender.burner.inventory.get_item_count() > 0)
		v.is_cold = new_water_type == "rtc:cold-water" and not tender_has_fuel
	elseif v.locomotive.burner.remaining_burning_fuel == 0 then
		--prevents tender from wasting fuel when water is empty
		if tender and tender.valid and global.tender_fuel[tender.unit_number] then
			local saved = global.tender_fuel[tender.unit_number]
			local current = get_tender_fuel(tender)
			if saved.remaining_burning_fuel ~= current.remaining_burning_fuel then
				if saved.remaining_burning_fuel < current.remaining_burning_fuel then
					local item_diff = saved.fuel_count - current.fuel_count
					--potentially exploitable? should be ok
					if saved.currently_burning and item_diff == 1 then
						tender.burner.inventory.insert({name = saved.currently_burning, count = 1})
					end
				end
				tender.burner.remaining_burning_fuel = saved.remaining_burning_fuel
			end
		end
	end
	if tender and tender.valid then
		global.tender_fuel[tender.unit_number] = get_tender_fuel(tender)
	end
end

function get_tender_fuel(tender)
	local info = {
		currently_burning = nil,
		remaining_burning_fuel = tender.burner.remaining_burning_fuel,
		fuel_count = 0
	}
	if tender.burner.currently_burning then
		info.currently_burning = tender.burner.currently_burning.name
		info.fuel_count = tender.burner.inventory.get_item_count(info.currently_burning)
	end
	return info
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

script.on_event(defines.events.on_player_main_inventory_changed, on_inventory_changed)

return public
