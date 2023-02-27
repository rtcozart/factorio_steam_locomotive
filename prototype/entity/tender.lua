require("constants")

local tender = table.deepcopy(data.raw["locomotive"]["locomotive"])
local custom_properties = {
	name = "rtc:tender",
	type = "locomotive",
	max_power = "1W",
	weight = 1000,
	energy_source = {
		type = "burner",
		effectivity = 2e-6,
		emissions_per_minute = 0,
		render_no_power_icon = true,
		render_no_network_icon = false,
		fuel_inventory_size = 3,
		fuel_category = "chemical",
		smoke = nil
	},
	icon = SPRITE_PATH.."icon/tender.png",
	icon_size = 64,
	icon_mipmaps = 4,
	pictures = {
		layers = {
			{
				direction_count = 128,
				line_length = 8,
				lines_per_file = 8,
				width = 512,
				height = 512,
				filenames = {
					SPRITE_PATH.."tender/sheet_0.gif",
					SPRITE_PATH.."tender/sheet_1.gif"
				},
				scale = 0.46,
				shift = util.by_pixel(0, -24)
			},
			{
				direction_count = 128,
				draw_as_shadow = true,
				line_length = 8,
				lines_per_file = 8,
				width = 512,
				height = 512,
				filenames = {
					SPRITE_PATH.."tender/shadow_0.gif",
					SPRITE_PATH.."tender/shadow_1.gif"
				},
				scale = 0.46,
				shift = util.by_pixel(10, -20)
			}
		}
	},
	minable = {
		mining_time = 1,
		result = "rtc:tender-item"
	}
}


tender.working_sound = nil
for k,v in pairs(custom_properties) do
	tender[k] = v
end

tender.front_light = nil
tender.front_light_pictures = nil
tender.darkness_to_render_light_animation = 2

if settings.startup["rtc:steamtrain-disable"].value then
	tender.type="cargo-wagon"
	tender.max_power = nil
	tender.weight=2000
	tender.inventory_size = 40
	tender.energy_source = nil
end

data:extend({tender})
