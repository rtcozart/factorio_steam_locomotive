data:extend({{
    type = "fuel-category",
    name = "rtc:water"
}})

local fluid = data.raw["fluid"]["water"]

data:extend({{
	type = "item",
	icon = fluid.icon,
	icon_size = fluid.icon_size,
	icon_mipmaps = fluid.icon_mipmaps,
	icons = fluid.icons,
	stack_size = 1500,
	fuel_category = "rtc:water",
	flags = {"hidden","hide-from-fuel-tooltip"},
	name = "rtc:hot-water",
	fuel_value = "0.4MJ",
	fuel_acceleration_multiplier = 1.0,
	fuel_top_speed_multiplier = 1.0
}})

data:extend({{
	type = "item",
	icon = fluid.icon,
	icon_size = fluid.icon_size,
	icon_mipmaps = fluid.icon_mipmaps,
	icons = fluid.icons,
	stack_size = 1500,
	fuel_category = "rtc:water",
	flags = {"hidden","hide-from-fuel-tooltip"},
	name = "rtc:cold-water",
	fuel_value = "100GJ",
	fuel_acceleration_multiplier = 0.0,
	fuel_top_speed_multiplier = 0.0
}})
