--steam_locomotive.lua

local function sprite(name)
    return '__steamtrain__/graphics/'..name
end

--TODO will probably create full prototype instead but this will do for now
local steam_locomotive = table.deepcopy(data.raw["locomotive"]["locomotive"])
steam_locomotive.name = "steam-locomotive"

steam_locomotive.pictures = {
    layers = {
        {
            direction_count = 128,
            line_length = 8,
            lines_per_file = 8,
            width = 512,
            height = 512,
            filenames = {
                sprite("steam-locomotive/body/sheet_0.gif"),
                sprite("steam-locomotive/body/sheet_1.gif")
            },
            scale = 0.48,
            shift = util.by_pixel(0, -18)
        }--,
        --{
        --    direction_count = 128,
        --    filename = sprite("steam-locomotive/shadow.png"),
        --    draw_as_shadow = true,
        --    line_length = 8,
        --    lines_per_file = 8,
        --    height = 512,
        --    width = 512,
        --    scale = 0.6,
        --    shift = util.by_pixel(0, 5)
        --}
    }
}

steam_locomotive.wheels = nil

--dirty hack
local steam_wheels = {
    name = "steam-wheels",
    type = "car",
    effectivity = 0,
    consumption = "0kW",
    rotation_speed = 100,
    weight = 1e-5,
    braking_force = 1e-5,
    friction_force = 1e-5,
    energy_per_hit_point = 0,
    allow_passengers = false,
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
        scale = 0.48,
        shift = util.by_pixel(0, -18),
        stripes = {
            {
                filename = sprite("steam-locomotive/wheels/sheet_0.gif"),
                height_in_frames = 8,
                width_in_frames = 8
            },{
                filename = sprite("steam-locomotive/wheels/sheet_1.gif"),
                height_in_frames = 8,
                width_in_frames = 8
            },{
                filename = sprite("steam-locomotive/wheels/sheet_2.gif"),
                height_in_frames = 8,
                width_in_frames = 8
            },{
                filename = sprite("steam-locomotive/wheels/sheet_3.gif"),
                height_in_frames = 8,
                width_in_frames = 8
            },{
                filename = sprite("steam-locomotive/wheels/sheet_4.gif"),
                height_in_frames = 8,
                width_in_frames = 8
            },{
                filename = sprite("steam-locomotive/wheels/sheet_5.gif"),
                height_in_frames = 8,
                width_in_frames = 8
            },{
                filename = sprite("steam-locomotive/wheels/sheet_6.gif"),
                height_in_frames = 8,
                width_in_frames = 8
            },{
                filename = sprite("steam-locomotive/wheels/sheet_7.gif"),
                height_in_frames = 8,
                width_in_frames = 8
            },{
                filename = sprite("steam-locomotive/wheels/sheet_8.gif"),
                height_in_frames = 8,
                width_in_frames = 8
            },{
                filename = sprite("steam-locomotive/wheels/sheet_9.gif"),
                height_in_frames = 8,
                width_in_frames = 8
            },{
                filename = sprite("steam-locomotive/wheels/sheet_10.gif"),
                height_in_frames = 8,
                width_in_frames = 8
            },{
                filename = sprite("steam-locomotive/wheels/sheet_11.gif"),
                height_in_frames = 8,
                width_in_frames = 8
            },{
                filename = sprite("steam-locomotive/wheels/sheet_12.gif"),
                height_in_frames = 8,
                width_in_frames = 8
            },{
                filename = sprite("steam-locomotive/wheels/sheet_13.gif"),
                height_in_frames = 8,
                width_in_frames = 8
            },{
                filename = sprite("steam-locomotive/wheels/sheet_14.gif"),
                height_in_frames = 8,
                width_in_frames = 8
            },{
                filename = sprite("steam-locomotive/wheels/sheet_15.gif"),
                height_in_frames = 8,
                width_in_frames = 8
            }
        }
    }
}


local recipe = {
    type = "recipe",
    name = "steam-locomotive-recipe",
    energy_required = 16.5,
    normal = {
        ingredients = {{"steam-engine",1},{"steel-plate",10}},
        result = "steam-locomotive-item"
    },
    expensive = {
        ingredients = {{"boiler",1},{"steam-engine",1},{"steel-plate",15}},
        result = "steam-locomotive-item"
    },
    energy_required =  16.5,
    enabled = false,
    hide_from_stats =  true,
    show_amount_in_title =  false
}


local item = {
    type = "item",
    name = "steam-locomotive-item",
    icon = sprite("steam-locomotive/64x64.png"),
    icon_size = 64,
    --subgroup = "logistics",
    --order = "z",
    place_result = "steam-locomotive",
    stack_size = 5
}

data:extend{steam_locomotive, item, recipe, steam_wheels};
