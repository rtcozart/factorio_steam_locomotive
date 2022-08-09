data:extend({
    {
        type = "technology",
        name = "rtc:steam-locomotion-technology",
        icon = '__steamtrain__/graphics/steam-locomotive/512x512.png',
        icon_size = 512,
        effects = {
            {
                type = "unlock-recipe",
                recipe = "rtc:steam-locomotive-recipe"
            },
            {
                type = "unlock-recipe",
                recipe = "rtc:tender-recipe"
            }
        },
        prerequisites = {"railway"},
        unit = {
            count = 50,
            ingredients = {
                {"automation-science-pack", 1},
                {"logistic-science-pack", 1}
            },
            time = 30
        },
        order = "e-g"
    }
})