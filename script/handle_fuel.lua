local public = {}

local known_trains = {}

local FUEL_MAP = {
	{2.0, "rtc:hot-water3"},
	{1.8, "rtc:hot-water2"},
	{1.2, "rtc:hot-water1"},
	{0.0, "rtc:hot-water"}
}

function find_tender(locomotive)
	--attempt to get from known trains first
	local candidate = known_trains[locomotive.unit_number]
	if (candidate and candidate.train and candidate.train.valid and candidate.tender and candidate.tender.valid) then
		return candidate.tender
	else
		known_trains[locomotive.unit_number] = nil
	end

	local function find(table, loco)
		for i, v in pairs(table) do
			if v.unit_number == loco.unit_number then
				return true
			end
		end
		return false
	end

	--TODO: More optimal method?
	for _, surface in pairs(game.surfaces) do
		for _, t in pairs(surface.get_trains()) do
			for i, carriage in pairs(t.carriages) do
				if carriage.unit_number and carriage.unit_number == locomotive.unit_number then
					local saved_train = {}
					saved_train.train = t
					if find(t.locomotives["front_movers"], locomotive) then
						local tender = t.carriages[i+1]
						if tender and tender.prototype.name == "rtc:tender" and find(t.locomotives["front_movers"], tender) then
							saved_train.tender = tender
							known_trains[locomotive.unit_number] = saved_train
							return tender
						end
					else
						local tender = t.carriages[i-1]
						if tender and tender.prototype.name == "rtc:tender" and find(t.locomotives["back_movers"], tender) then
							saved_train.tender = tender
							known_trains[locomotive.unit_number] = saved_train
							return tender
						end
					end
					return nil
				end
			end
		end
    end
end

function map_fuel_to_steam(fuel)
	for _, mapped in pairs(FUEL_MAP) do
		if fuel.fuel_acceleration_multiplier >= mapped[1] then
			return mapped[2]
		end
	end
end

function public:consume_energy(v)
	local tender = find_tender(v.locomotive)
	local current_water_count = v.locomotive.burner.inventory.get_item_count()
	local known_train = known_trains[v.locomotive.unit_number]
	if not known_train and known_train.train.valid then return end
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
		if new_water_type ~= (v.locomotive.burner.currently_burning and v.locomotive.burner.currently_burning.name) then
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
				x_scale = 0.25,
				y_scale = 0.25,
				target_offset = {0, -0.6}
			})
		end
	elseif v.locomotive.burner.remaining_burning_fuel == 0 then
		-- I don't think this will cause any errors...
		if known_train and not known_train.train.manual_mode then
			known_train.train.manual_mode = true
		end
	end
end

return public
