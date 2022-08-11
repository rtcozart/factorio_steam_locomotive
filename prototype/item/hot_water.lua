local fluid = data.raw["fluid"]["steam"]

data:extend({{
	type = "item",
	icon = fluid.icon,
	icon_size = fluid.icon_size,
	icon_mipmaps = fluid.icon_mipmaps,
	icons = fluid.icons,
	stack_size = 3000,
	fuel_category = "rtc:water",
	flags = {"hidden","hide-from-fuel-tooltip"},
	name = "rtc:hot-water",
	fuel_value = "0.4MJ",
	fuel_acceleration_multiplier = 1.0,
	fuel_top_speed_multiplier = 1.0
}})

--extra variants to apply acceleration bonuses
data:extend({{
	type = "item",
	icon = fluid.icon,
	icon_size = fluid.icon_size,
	icon_mipmaps = fluid.icon_mipmaps,
	icons = fluid.icons,
	stack_size = 3000,
	fuel_category = "rtc:water",
	flags = {"hidden","hide-from-fuel-tooltip"},
	name = "rtc:hot-water1",
	fuel_value = "0.4MJ",
	fuel_acceleration_multiplier = 1.2,
	fuel_top_speed_multiplier = 1.05
}})

data:extend({{
	type = "item",
	icon = fluid.icon,
	icon_size = fluid.icon_size,
	icon_mipmaps = fluid.icon_mipmaps,
	icons = fluid.icons,
	stack_size = 3000,
	fuel_category = "rtc:water",
	flags = {"hidden","hide-from-fuel-tooltip"},
	name = "rtc:hot-water2",
	fuel_value = "0.4MJ",
	fuel_acceleration_multiplier = 1.8,
	fuel_top_speed_multiplier = 1.10
}})

data:extend({{
	type = "item",
	icon = fluid.icon,
	icon_size = fluid.icon_size,
	icon_mipmaps = fluid.icon_mipmaps,
	icons = fluid.icons,
	stack_size = 3000,
	fuel_category = "rtc:water",
	flags = {"hidden","hide-from-fuel-tooltip"},
	name = "rtc:hot-water3",
	fuel_value = "0.4MJ",
	fuel_acceleration_multiplier = 2,
	fuel_top_speed_multiplier = 1.10
}})
