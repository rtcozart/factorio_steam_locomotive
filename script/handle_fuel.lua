local public = {}

function find_tender(locomotive)
    local train
    local index
    --TODO: not optimized!
    local function get_index()
        for _, surface in pairs(game.surfaces) do
            for _, t in pairs(surface.get_trains()) do
                for i, carriage in pairs(t.carriages) do
                    if carriage.unit_number and carriage.unit_number == locomotive.unit_number then
                        train = t
                        index = i
                        return
                    end
                end
            end
        end
    end

    get_index()

	local isFrontMover = false

	for _,l in pairs(train.locomotives["front_movers"]) do
		if l.unit_number == locomotive.unit_number then
			isFrontMover = true
		end
	end

	local seekDirection = isFrontMover and 1 or -1

	local next = index + seekDirection
	if #train.carriages < next or next < 1 then return nil end

	if train.carriages[next].prototype.name == "rtc:tender" then
		return train.carriages[next]
	else
		return nil
	end
end


function public:consume_energy(v)
    local tender = find_tender(v.locomotive)

    local cold_water_count = v.locomotive.burner.inventory.get_item_count("rtc:cold-water")
    local hot_water_count = v.locomotive.burner.inventory.get_item_count("rtc:hot-water")
    --game.print("Cold "..cold_water_count..", Hot "..hot_water_count)

    if cold_water_count > 0 then
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
            game.print("Removed "..removed_count)
            v.locomotive.burner.inventory.insert({name = "rtc:cold-water", count = removed_count})
            return
        end
    end
end

function ass(bool)
    return bool and "true" or "false"
end

return public
