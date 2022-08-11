local function on_init()
	remote.call("fluidTrains_hook", "addLocomotive", "rtc:steam-locomotive", 3000)
	remote.call("fluidTrains_hook", "addFluid", "rtc:water", "steam", {{item = "rtc:hot-water3", temp = 600}})
	remote.call("fluidTrains_hook", "addFluid", "rtc:water", "steam", {{item = "rtc:hot-water2", temp = 400}})
	remote.call("fluidTrains_hook", "addFluid", "rtc:water", "steam", {{item = "rtc:hot-water1", temp = 200}})
	remote.call("fluidTrains_hook", "addFluid", "rtc:water", "water", {{item = "rtc:hot-water"}})
	--remote.call("fluidTrains_hook", "addFluid", "rtc:water", "water", {{item = "rtc:cold-water"}})
end

--TODO: prevent fluids from being picked up by player
