if settings.startup["rtc:steamtrain-harder-diesel"].value then
	local railway = data.raw.technology["railway"]
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

	--if settings.startup["bobmods-logistics-trains"].value == true then
	--bob-railway-2
	--bob-railway-3
	--bob-railway-4?

	data:extend({diesel_technology})
end

local tankApi = require "__fluidTrains__/api/data"

tankApi.generateTank(3000)
