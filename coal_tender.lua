--coal_tender.lua

local function sprite(name)
    return '__steamtrain__/graphics/'..name
end

local coalTender = table.deepcopy(data.raw["cargo-wagon"]["cargo-wagon"])
coalTender.name = "coal-tender"

coalTender.pictures = {
    layers = {
        {
            direction_count = 128,
            line_length = 8,
            lines_per_file = 8,
            width = 512,
            height = 512,
            filenames = {
                sprite("coal-tender/sheet_0.gif"),
                sprite("coal-tender/sheet_1.gif")
            },
            scale = 0.45,
            shift = util.by_pixel(0, -18)
        }
        --todo: generate shadow
    }
}

coalTender.horizontal_doors = nil
coalTender.vertical_doors = nil

local recipe = {
    type = "recipe",
    name = "coal-tender-recipe",
    energy_required = 16.5,
    normal = {
        ingredients = {{"iron-plate",20},{"steel-plate",10}},
        result = "coal-tender-item"
    },
    expensive = {
        ingredients = {{"iron-plate",40},{"steel-plate",20}},
        result = "coal-tender-item"
    },
    energy_required =  16.5,
    enabled = false,
    hide_from_stats =  true,
    show_amount_in_title =  false
}

local item = {
    type = "item",
    name = "coal-tender-item",
    icon = sprite("coal-tender/64x64.png"),
    icon_size = 64,
    place_result = "coal-tender",
    stack_size = 5
}

data:extend{coalTender, item, recipe};
