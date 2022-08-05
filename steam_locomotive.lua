--steam_loco.lua

local function sprite(name)
    return '__steamtrain__/graphics/'..name
end

--TODO will probably create full prototype instead but this will do for now
local steamLocomotive = table.deepcopy(data.raw["locomotive"]["locomotive"])
steamLocomotive.name = "steam-locomotive"
steamLocomotive.animation = {
    layers = {
        {
            direction_count = 64,
            frame_count = 8,
            line_length = 8,
            height = 512,
            stripes = {
                {
                    filename = sprite("steam-locomotive-1.png"),
                    height_in_frames = 8,
                    width_in_frames = 8
                },{
                    filename = sprite("steam-locomotive-2.png"),
                    height_in_frames = 8,
                    width_in_frames = 8
                },{
                    filename = sprite("steam-locomotive-3.png"),
                    height_in_frames = 8,
                    width_in_frames = 8
                },{
                    filename = sprite("steam-locomotive-4.png"),
                    height_in_frames = 8,
                    width_in_frames = 8
                },{
                    filename = sprite("steam-locomotive-5.png"),
                    height_in_frames = 8,
                    width_in_frames = 8
                },{
                    filename = sprite("steam-locomotive-6.png"),
                    height_in_frames = 8,
                    width_in_frames = 8
                },{
                    filename = sprite("steam-locomotive-7.png"),
                    height_in_frames = 8,
                    width_in_frames = 8
                },{
                    filename = sprite("steam-locomotive-8.png"),
                    height_in_frames = 8,
                    width_in_frames = 8
                },
            }
        },{
            direction_count = 64,
            filename = sprite("steam-locomotive-shadow.png"),
            draw_as_shadow = true,
            line_length = 8,
            lines_per_file = 8,
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
    icon = sprite("steam-locomotive-64x64.png"),
    icon_size = 64,
    --subgroup = "logistics",
    --order = "z",
    place_result = "steam-locomotive",
    stack_size = 5
}

--[[
TODO: tech tree rework
local steamLocomotiveTechnology = {
    name = "steam-locomotive-technology",
    type = "technology",
    icon = sprite sprite("steam-locomotive-128x128.png"),
    icon_size = 128,
    prerequisites = {"fluid-handling"}
}
--]]

data:extend{steamLocomotive, item, recipe};
