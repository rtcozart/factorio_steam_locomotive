require("constants")
data:extend({
	{
		type = "technology",
		name = "rtc:steam-locomotion-technology",
		icon = SPRITE_PATH.."technology/steam-locomotion.png",
		icon_size = 256,
		icon_mipmaps = 4,
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
