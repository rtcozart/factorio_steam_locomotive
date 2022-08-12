require("constants")

local custom_smoke = table.deepcopy(data.raw["trivial-smoke"]["train-smoke"])
custom_smoke.name = "rtc:train-smoke"
custom_smoke.start_scale = 0.2
custom_smoke.end_scale = 3

local fuel_category = "rtc:water"

if settings.startup["rtc:steamtrain-disable"].value then
	fuel_category = "chemical"
end

local steam_locomotive = table.deepcopy(data.raw["locomotive"]["locomotive"])
local custom_properties = {
	name = "rtc:steam-locomotive",
	type = "locomotive",
	placeable_by = {
		item = "rtc:steam-locomotive-item",
		count = 1
	},
	weight = 2000,
	connection_distance = 2.5,
	energy_source = {
		type = "burner",
		emissions_per_minute = 10,
		render_no_power_icon = settings.startup["rtc:steamtrain-disable"].value,
		render_no_network_icon = false,
		fuel_inventory_size = 1,
		fuel_category = fuel_category,
		smoke = {
		  {
			--duration = 1,

			frequency = 50,
			name = "rtc:train-smoke",
			north_position = {
			  0,
			  -3
			},
			south_position = {
			  0,
			  0
			},
			east_position = {
			  2.4,
			  -2
			},
			west_position = {
			  -2.4,
			  -2
			},
			starting_frame_deviation = 10,
			deviation = {
				0.05,
				0.1
			},
			starting_vertical_speed = 0.15,
			starting_vertical_speed_deviation = 0.1,
		  }
		},
	},
	working_sound = {
		sound = {
			filename = SOUND_PATH.."steam-engine-45bpm.ogg",
			volume = 0.6
		},
		match_speed_to_activity = true,
		idle_sound = {
			filename = SOUND_PATH.."idle.ogg",
			volume = 0.4
		},
		match_volume_to_activity = true
	},
	sound_scaling_ratio = 0.6,
	sound_minimum_speed = 0.2;
	flags = {
		"placeable-neutral",
		"player-creation",
		"placeable-off-grid"
	},
	icon = SPRITE_PATH.."icon/steam-locomotive.png",
	icon_size = 64,
	icon_mipmaps = 4,
	pictures = {
		layers = {
			--base image
			{
				direction_count = 128,
				line_length = 8,
				lines_per_file = 8,
				width = 512,
				height = 512,
				filenames = {
					SPRITE_PATH.."steam-locomotive/body/sheet_0.gif",
					SPRITE_PATH.."steam-locomotive/body/sheet_1.gif"
				},
				scale = 0.45,
				shift = util.by_pixel(0, -18)
			},
			--color mask
			{
				apply_runtime_tint = true,
				direction_count = 128,
				line_length = 8,
				lines_per_file = 8,
				width = 512,
				height = 512,
				blend_mode = "additive",
				filenames = {
					SPRITE_PATH.."steam-locomotive/body/mask_0.gif",
					SPRITE_PATH.."steam-locomotive/body/mask_1.gif"
				},
				scale = 0.45,
				shift = util.by_pixel(0, -18)
			},
			--shadow
			{
				draw_as_shadow = true,
				direction_count = 128,
				line_length = 8,
				lines_per_file = 8,
				width = 512,
				height = 512,
				filenames = {
					SPRITE_PATH.."steam-locomotive/shadow_0.gif",
					SPRITE_PATH.."steam-locomotive/shadow_1.gif"
				},
				scale = 0.5,
				shift = util.by_pixel(35, 30)
			},

		}
	},
	minable = {
		mining_time = 1,
		result = "rtc:steam-locomotive-item"
	},
	front_light = {
	type = "oriented",
	minimum_darkness = 0.3,
	picture =
	{
		filename = "__core__/graphics/light-cone.png",
		priority = "extra-high",
		flags = { "light" },
		scale = 1.5,
		width = 200,
		height = 200
	},
	shift = {0, -13.5},
	size = 2,
	intensity = 0.6,
	color = {r = 0.92, g = 0.77, b = 0.2}
  },
}

table.insert(steam_locomotive.stop_trigger, {
	type = "create-trivial-smoke",
	smoke_name = "turbine-smoke"
})

table.insert(steam_locomotive.stop_trigger, {
	type = "play-sound",
	sound = {
		filename = SOUND_PATH.."steam.ogg",
		volume = 0.2
	}
})

for k,v in pairs(custom_properties) do
	steam_locomotive[k] = v
end

steam_locomotive.wheels = nil
steam_locomotive.front_light_pictures = nil

--used to show wheel graphics when placing locomotive
local placement_entity = table.deepcopy(steam_locomotive)
placement_entity.name = "rtc:steam-locomotive-placement-entity"
placement_entity.pictures = {
	direction_count = 64,
	line_length = 8,
	lines_per_file = 8,
	width = 512,
	height = 512,
	filename = SPRITE_PATH.."steam-locomotive/placement_entity.gif",
	scale = 0.45,
	shift = util.by_pixel(0, -18)
}

data:extend({custom_smoke, steam_locomotive, placement_entity})
