function on_init()
    remote.call("fluidTrains_hook", "addLocomotive", "rtc:steam-locomotive", 1500)
    remote.call("fluidTrains_hook", "addFluid", "rtc:water", "water", {{item = "rtc:hot-water"}})
end

--TODO: Prevent player from picking up water?

script.on_init(on_init)
script.on_configuration_changed(on_init)
