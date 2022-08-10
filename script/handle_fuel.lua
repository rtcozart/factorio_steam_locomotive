local FUEL_PRIORITY = {"nuclear-fuel","rocket-fuel","solid-fuel","coal","wood"}

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

--[[
function get_energy_from_fuel(tender)
    if not tender then return 0 end
    for _, fuel_name in pairs(FUEL_PRIORITY) do
        if tender.burner.get_item_count(fuel_name) > 0 then
            tender.remove_item({name = fuel_name, count = 1})
            return 100 --TODO: return energy of consumed fuel
        end
    end
    return 0
end
]]

function public:consume_energy(v)
--[[
    --TODO: get energy of rtc:hot-water entity
    local water_energy = 400
    local water_amount = v.locomotive.burner.inventory.get_item_count()
    local consumed_energy = (v.boiler.last_water_amount - water_amount) * water_energy
    local current_energy = v.boiler.remaining_energy - consumed_energy
    if current_energy <= 0 then
        local tender = find_tender(v.locomotive)
        current_energy = get_energy_from_fuel(tender)
        if (current_energy <= 0) then
            game.print("Out of fuel!")
            --stop the train
            --show out of fuel symbol on the tender
        end
    end
    v.boiler.last_water_amount = water_amount
    v.boiler.remaining_energy = current_energy
    ]]
end

return public
