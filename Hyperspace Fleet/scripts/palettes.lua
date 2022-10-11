local mod = modApi:getCurrentMod()

local palette = {
    id = mod.id,
    name = "Hyper Hot Neon", 
    image = "img/units/player/tether_mech_ns.png", --change MyMech by the name of the mech you want to display
    colorMap = {
        lights =         { 79, 164, 184 }, --PlateHighlight
        main_highlight = { 255, 137,  51 }, --PlateLight
        main_light =     {  230,  69,  57 }, --PlateMid
        main_mid =       {  120,  29,  79 }, --PlateDark
        main_dark =      {  79,  29,  76 }, --PlateOutline
        metal_light =    { 163,  167,  194 }, --BodyHighlight
        metal_mid =      {  64,  73,  115 }, --BodyColor
        metal_dark =     {  20, 24, 46 }, --PlateShadow
    },
}

modApi:addPalette(palette)

 