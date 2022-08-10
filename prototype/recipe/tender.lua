data:extend({{
	type = "recipe",
	name = "rtc:tender-recipe",
	energy_required = 16.5,
	normal = {
		enabled = false,
		ingredients = {{"iron-plate",20},{"steel-plate",10}},
		result = "rtc:tender-item"
	},
	expensive = {
		enabled = false,
		ingredients = {{"iron-plate",40},{"steel-plate",20}},
		result = "rtc:tender-item"
	},
	energy_required =  16.5,
	enabled = false,
	show_amount_in_title = false
}})
