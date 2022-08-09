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
        },
        {
            direction_count = 128,
            draw_as_shadow = true,
            line_length = 8,
            lines_per_file = 8,
            width = 512,
            height = 512,
            filenames = {
                SPRITE_PATH.."/shadow_0.gif",
                SPRITE_PATH.."/shadow_1.gif"
            },
            scale = 0.46,
            shift = util.by_pixel(10, -20)
        }
    }
}

coalTender.horizontal_doors = nil
coalTender.vertical_doors = nil

local recipe = {
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
}

local item = {
    type = "item",
    name = "rtc:tender-item",
    icon = SPRITE_PATH.."/64x64.png",
    subgroup = "train-transport",
    icon_size = 64,
    place_result = "rtc:tender",
    stack_size = 5
}

data:extend{coalTender, item, recipe};
