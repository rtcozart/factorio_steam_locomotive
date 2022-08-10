require("constants")
data:extend({
	{
		type = "technology",
		name = "rtc:steam-locomotion-technology",
		icon = SPRITE_PATH.."steam-locomotive/512x512.png",
		icon_size = 512,
		effects = {
			{
				type = "unlock-recipe",
				recipe = "rtc:steam-locomotive-recipe"
			},
			{
				type = "unlock-recipe",
				recipe = "rtc:tender-recipe"
			}
		},
		prerequisites = {"fluid-handling","railway"},
		unit = {
			count = 50,
			ingredients = {
				{"automation-science-pack", 1},
				{"logistic-science-pack", 1}
			},
			time = 30
		},
		order = "e-g"
	}
})
