local public = {}

local known_trains = {}

function find_tender(locomotive)
	--attempt to get from known trains first
	local candidate = known_trains[locomotive.unit_number]
	if (candidate and candidate.train and candidate.train.valid and candidate.tender and candidate.tender.valid) then
		return candidate.tender
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

					for _,l in pairs(t.locomotives["front_movers"]) do
						if l.unit_number == locomotive.unit_number then
							isFrontMover = true
						end
					end

					local seekDirection = isFrontMover and 1 or -1

					local next = i + seekDirection
					if #t.carriages < next or next < 1 then return nil end
					if t.carriages[next].prototype.name == "rtc:tender" then
						local tender = t.carriages[next]
						saved_train.tender = tender
						known_trains[locomotive.unit_number] = saved_train
						return tender
					else
						return nil
					end
				end
			end
		end
    end
end


function public:consume_energy(v)
	local tender = find_tender(v.locomotive)

	local cold_water_count = v.locomotive.burner.inventory.get_item_count("rtc:cold-water")
	local hot_water_count = v.locomotive.burner.inventory.get_item_count("rtc:hot-water")

	if cold_water_count > 0 then
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
		if not tender then return end
		if tender.burner.inventory.get_item_count() > 0 or tender.burner.remaining_burning_fuel > 0 then
			local removed_count = v.locomotive.burner.inventory.remove({name = "rtc:cold-water", count = cold_water_count})
			v.locomotive.burner.inventory.insert({name = "rtc:hot-water", count = removed_count})
			v.locomotive.burner.remaining_burning_fuel = 0
			return
		end
	end
	if hot_water_count > 0 then
		if not tender or (tender.burner.inventory.get_item_count() == 0 and tender.burner.remaining_burning_fuel == 0) then
			local removed_count = v.locomotive.burner.inventory.remove({name = "rtc:hot-water", count = hot_water_count})
			v.locomotive.burner.inventory.insert({name = "rtc:cold-water", count = removed_count})
			return
		end
	end
end

return public
