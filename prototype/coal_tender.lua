--coal_tender.lua

local SPRITE_PATH = '__steamtrain__/graphics/coal-tender'

local coalTender = table.deepcopy(data.raw["cargo-wagon"]["cargo-wagon"])
coalTender.name = "rtc:tender"

coalTender.pictures = {
    layers = {
        {
            direction_count = 128,
            line_length = 8,
            lines_per_file = 8,
            width = 512,
            height = 512,
            filenames = {
                SPRITE_PATH.."/sheet_0.gif",
                SPRITE_PATH.."/sheet_1.gif"
            },
            scale = 0.46,
            shift = util.by_pixel(0, -24)
        }
        --todo: generate shadow
    }
}

coalTender.horizontal_doors = nil
coalTender.vertical_doors = nil

local recipe = {
    type = "recipe",
    name = "rtc:tender-recipe",
    energy_required = 16.5,
    normal = {
        ingredients = {{"iron-plate",20},{"steel-plate",10}},
        result = "rtc:tender-item"
    },
    expensive = {
        ingredients = {{"iron-plate",40},{"steel-plate",20}},
        result = "rtc:tender-item"
    },
    energy_required =  16.5,
    enabled = false,
    hide_from_stats =  true,
    show_amount_in_title =  false
}

local item = {
    type = "item",
    name = "rtc:tender-item",
    icon = SPRITE_PATH.."/64x64.png",
    icon_size = 64,
    place_result = "rtc:tender",
    stack_size = 5
}

data:extend{coalTender, item, recipe};
