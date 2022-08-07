--steam_locomotive.lua
local SPRITE_PATH = '__steamtrain__/graphics/steam-locomotive'

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
                SPRITE_PATH.."/body/sheet_0.gif",
                SPRITE_PATH.."/body/sheet_1.gif"
            },
            scale = 0.45,
            shift = util.by_pixel(0, -18)
        }--,
        --{
        --    direction_count = 128,
        --    filename = SPRITE_PATH.."steam-locomotive/shadow.png"),
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
    icon = SPRITE_PATH.."/64x64.png",
    icon_size = 64,
    --subgroup = "logistics",
    --order = "z",
    place_result = "steam-locomotive",
    stack_size = 5
}

data:extend{steam_locomotive, item, recipe};
