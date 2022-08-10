data:extend({{
	type = "recipe",
	name = "rtc:steam-locomotive-recipe",
	enabled = false,
	energy_required = 16.5,
	normal = {
		enabled = false,
		ingredients = {{"steam-engine",1},{"steel-plate",10}},
		result = "rtc:steam-locomotive-item"
	},
	expensive = {
		enabled = false,
		ingredients = {{"boiler",1},{"steam-engine",1},{"steel-plate",15}},
		result = "rtc:steam-locomotive-item"
	},
	energy_required =  16.5,
	show_amount_in_title = false
}})
