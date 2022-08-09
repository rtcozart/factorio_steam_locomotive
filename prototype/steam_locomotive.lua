--steam_locomotive.lua
local SPRITE_PATH = "__steamtrain__/graphics/steam-locomotive"
local SOUND_PATH = "__steamtrain__/sound"

local custom_smoke = table.deepcopy(data.raw["trivial-smoke"]["train-smoke"])
custom_smoke.name = "rtc:train-smoke"
custom_smoke.start_scale = 0.2
custom_smoke.end_scale = 3

local placement_entity = table.deepcopy(data.raw["locomotive"]["locomotive"])
placement_entity.name = "rtc:steam-locomotive-placement-entity"
placement_entity.wheels = nil
placement_entity.pictures = {
    direction_count = 64,
    line_length = 8,
    lines_per_file = 8,
    width = 512,
    height = 512,
    filename = SPRITE_PATH.."/placement_entity.gif",
    scale = 0.45,
    shift = util.by_pixel(0, -18)
}

local steam_locomotive = table.deepcopy(data.raw["locomotive"]["locomotive"])
local custom_properties = {
    name = "rtc:steam-locomotive",
    type = "locomotive",
    placeable_by = {
        item = "rtc:steam-locomotive-item",
        count = 1
    },
    --max_power =
    --max_speed =
    weight = 5000,
    --braking_force = 3,
    --friction_force = 0.5,
    --energy_per_hit_point = 5,
    --reversing_power_modifier = 0.5,
    --air_resistance = 0.01,
    --joint_distance = 4,
    --connection_distance = 3,
    --vertical_selection_shift = -0.796875,
    energy_source = {
        type = "burner",
        emissions_per_minute = 10,
        render_no_power_icon = true,
        render_no_network_icon = false,
        fuel_inventory_size = 1,
        fuel_category = "chemical",
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
            filename = SOUND_PATH.."/steam-engine-45bpm.ogg",
            volume = 0.6
        },
        match_speed_to_activity = true,
        idle_sound = {
            filename = SOUND_PATH.."/idle.ogg",
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
    icon = SPRITE_PATH.."/64x64.png",
    icon_size = 64,
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
                    SPRITE_PATH.."/body/sheet_0.gif",
                    SPRITE_PATH.."/body/sheet_1.gif"
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
                    SPRITE_PATH.."/body/mask_0.gif",
                    SPRITE_PATH.."/body/mask_1.gif"
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
                    SPRITE_PATH.."/shadow_0.gif",
                    SPRITE_PATH.."/shadow_1.gif"
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
    --[[
    drive_over_tie_trigger = {
        {
            type = "create-trivial-smoke",
            smoke_name = "turbine-smoke",
            starting_frame_deviation = 30,
            offset_deviation = {{-0.5,0.5},{-1,0.1}}
        }
    },
    tie_distance = 3
    --]]
}

table.insert(steam_locomotive.stop_trigger, {
    type = "create-trivial-smoke",
    smoke_name = "turbine-smoke"
})

table.insert(steam_locomotive.stop_trigger, {
    type = "play-sound",
    sound = {
        filename = SOUND_PATH.."/steam.ogg",
        volume = 0.25
    }
})

for k,v in pairs(custom_properties) do
    steam_locomotive[k] = v
end

steam_locomotive.wheels = nil


local recipe = {
    type = "recipe",
    name = "rtc:steam-locomotive-recipe",
    energy_required = 16.5,
    normal = {
        ingredients = {{"steam-engine",1},{"steel-plate",10}},
        result = "rtc:steam-locomotive-item"
    },
    expensive = {
        ingredients = {{"boiler",1},{"steam-engine",1},{"steel-plate",15}},
        result = "rtc:steam-locomotive-item"
    },
    energy_required =  16.5,
    enabled = false,
    hide_from_stats =  true,
    show_amount_in_title =  false
}


local item = {
    type = "item",
    name = "rtc:steam-locomotive-item",
    icon = SPRITE_PATH.."/64x64.png",
    icon_size = 64,
    subgroup = "train-transport",
    place_result = "rtc:steam-locomotive-placement-entity",
    stack_size = 5
}

data:extend{custom_smoke, steam_locomotive, placement_entity, item, recipe};
