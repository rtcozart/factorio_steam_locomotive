if settings.startup["rtc:steamtrain-harder-diesel"].value then
	local railway = data.raw["technology"]["railway"]
	for i, v in pairs(railway.effects) do
		if v.type == "unlock-recipe" and v.recipe == "locomotive" then
			table.remove(railway.effects, i)
		end
	end
	local diesel_technology = 	{
		type = "technology",
		name = "rtc:diesel-locomotion-technology",
		icon = railway.icon,
		icon_size = railway.icon_size,
		effects = {
			{
				type = "unlock-recipe",
				recipe = "locomotive"
			}
		},
		prerequisites = {"rtc:steam-locomotion-technology"},
		unit = {
			count = 50,
			ingredients = {
				{"automation-science-pack", 1},
				{"logistic-science-pack", 1},
				{"chemical-science-pack", 1}
			},
			time = 30
		},
		order = "e-g"
	}

	local mods_to_update = {}
	if mods["boblogistics"] and settings.startup["bobmods-logistics-trains"].value then
		table.insert(mods_to_update, data.raw["technology"]["bob-railway-2"])
	end
	if mods["dieselTrains"] then
		table.insert(mods_to_update, data.raw["technology"]["diesel-locomotive"])
	end

	function modify_technology(technology)
		if not technology then return end
		modify_technology(technology.normal)
		modify_technology(technology.expensive)
		if not technology.unit then return end
		table.insert(technology.unit.ingredients, {"chemical-science-pack",1})
		for _, prerequisite in pairs(technology.prerequisites) do
			if prerequisite == "railway" then
				table.insert(technology.prerequisites, "rtc:diesel-locomotion-technology")
				break
			end
		end
	end

	for _, technology in pairs(mods_to_update) do
		modify_technology(technology)
	end

	data:extend({diesel_technology})
end

local tankApi = require "__fluidTrains__/api/data"

tankApi.generateTank(3000)
