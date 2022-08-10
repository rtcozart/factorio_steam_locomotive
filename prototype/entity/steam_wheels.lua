--steam_wheels.lua
local SPRITE_PATH = '__steamtrain__/graphics/steam-locomotive'

--dirty hack
data:extend({{
	name = "rtc:steam-wheels",
	type = "car",
	effectivity = 0,
	consumption = "0kW",
	rotation_speed = 100,
	weight = 1e-5,
	braking_force = 1e-5,
	friction_force = 1e-5,
	energy_per_hit_point = 0,
	allow_passengers = false,
	flags = {"placeable-off-grid", "not-on-map"},
	render_layer = "lower-object-above-shadow",
	energy_source = {
		type = "void",
		emissions_per_minute = 0,
		render_no_power_icon = false,
		render_no_network_icon = false
	},
	inventory_size = 0,
	collision_box = {{0,0},{0,0}},
	collision_mask = {},
	animation = {
		animation_speed = 1,
		direction_count = 128,
		frame_count = 8,
		height = 512,
		width = 512,
		scale = 0.45,
		shift = util.by_pixel(0, -18),
		stripes = {
			{
				filename = SPRITE_PATH.."/wheels/sheet_0.gif",
				height_in_frames = 8,
				width_in_frames = 8
			},{
				filename = SPRITE_PATH.."/wheels/sheet_1.gif",
				height_in_frames = 8,
				width_in_frames = 8
			},{
				filename = SPRITE_PATH.."/wheels/sheet_2.gif",
				height_in_frames = 8,
				width_in_frames = 8
			},{
				filename = SPRITE_PATH.."/wheels/sheet_3.gif",
				height_in_frames = 8,
				width_in_frames = 8
			},{
				filename = SPRITE_PATH.."/wheels/sheet_4.gif",
				height_in_frames = 8,
				width_in_frames = 8
			},{
				filename = SPRITE_PATH.."/wheels/sheet_5.gif",
				height_in_frames = 8,
				width_in_frames = 8
			},{
				filename = SPRITE_PATH.."/wheels/sheet_6.gif",
				height_in_frames = 8,
				width_in_frames = 8
			},{
				filename = SPRITE_PATH.."/wheels/sheet_7.gif",
				height_in_frames = 8,
				width_in_frames = 8
			},{
				filename = SPRITE_PATH.."/wheels/sheet_8.gif",
				height_in_frames = 8,
				width_in_frames = 8
			},{
				filename = SPRITE_PATH.."/wheels/sheet_9.gif",
				height_in_frames = 8,
				width_in_frames = 8
			},{
				filename = SPRITE_PATH.."/wheels/sheet_10.gif",
				height_in_frames = 8,
				width_in_frames = 8
			},{
				filename = SPRITE_PATH.."/wheels/sheet_11.gif",
				height_in_frames = 8,
				width_in_frames = 8
			},{
				filename = SPRITE_PATH.."/wheels/sheet_12.gif",
				height_in_frames = 8,
				width_in_frames = 8
			},{
				filename = SPRITE_PATH.."/wheels/sheet_13.gif",
				height_in_frames = 8,
				width_in_frames = 8
			},{
				filename = SPRITE_PATH.."/wheels/sheet_14.gif",
				height_in_frames = 8,
				width_in_frames = 8
			},{
				filename = SPRITE_PATH.."/wheels/sheet_15.gif",
				height_in_frames = 8,
				width_in_frames = 8
			}
		}
	}
}})
