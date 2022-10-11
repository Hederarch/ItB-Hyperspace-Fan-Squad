
local mod = modApi:getCurrentMod()
local autoOffset = 0
local id = modApi:getPaletteImageOffset(mod.id)
if id ~= nil then
	autoOffset = id
end
-- this line just gets the file path for your mod, so you can find all your files easily.
local path = mod_loader.mods[modApi.currentMod].resourcePath

-- locate our mech assets.
local mechPath = path .."img/units/paw/"

-- make a list of our files.
local files = {
	"mech.png",
	"mech_a.png",
	--"mech_w.png",
	"mech_w_broken.png",
	"mech_broken.png",
	"mech_ns.png",
	"mech_h.png"
}

-- iterate our files and add the assets so the game can find them.
for _, file in ipairs(files) do
	modApi:appendAsset("img/units/player/paw_".. file, mechPath .. file)
end

-- create animations for our mech with our imported files.
-- note how the animations starts searching from /img/
local a = ANIMS
a.paw_mech =			a.MechUnit:new{Image = "units/player/paw_mech.png", PosX = -20, PosY = -10} 
a.paw_mecha =			a.MechUnit:new{Image = "units/player/paw_mech_a.png", PosX = -21, PosY = -10, NumFrames = 4 }
--a.paw_mechw =			a.MechUnit:new{Image = "units/player/paw_mech_w.png", PosX = -19, PosY = 6 } 
a.paw_mech_broken =	a.MechUnit:new{Image = "units/player/paw_mech_broken.png", PosX = -19, PosY = -9 }
a.paw_mechw_broken =	a.MechUnit:new{Image = "units/player/paw_mech_w_broken.png", PosX = -21, PosY = 2 }
a.paw_mech_ns =		a.MechIcon:new{Image = "units/player/paw_mech_ns.png"}

mechPath = path .."img/units/tether/"

for _, file in ipairs(files) do
	modApi:appendAsset("img/units/player/tether_".. file, mechPath .. file)
end

a.tether_mech =			a.MechUnit:new{Image = "units/player/tether_mech.png", PosX = -20, PosY = -6} 
a.tether_mecha =			a.MechUnit:new{Image = "units/player/tether_mech_a.png", PosX = -25, PosY = -15, NumFrames = 4 }
--a.tether_mechw =			a.MechUnit:new{Image = "units/player/tether_mech_w.png", PosX = -19, PosY = 8 }
a.tether_mech_broken =	a.MechUnit:new{Image = "units/player/tether_mech_broken.png", PosX = -22, PosY = -5  }
a.tether_mechw_broken =	a.MechUnit:new{Image = "units/player/tether_mech_w_broken.png", PosX = -21, PosY = 5 }
a.tether_mech_ns =		a.MechIcon:new{Image = "units/player/tether_mech_ns.png"}

mechPath = path .."img/units/swirl/"

for _, file in ipairs(files) do
	modApi:appendAsset("img/units/player/swirl_".. file, mechPath .. file)
end

a.swirl_mech =			a.MechUnit:new{Image = "units/player/swirl_mech.png", PosX = -20, PosY = -20} 
a.swirl_mecha =			a.MechUnit:new{Image = "units/player/swirl_mech_a.png", PosX = -20, PosY = -10, NumFrames = 4 }
--a.swirl_mechw =			a.MechUnit:new{Image = "units/player/swirl_mech_w.png", PosX = -22, PosY = 5 } 
a.swirl_mech_broken =	a.MechUnit:new{Image = "units/player/swirl_mech_broken.png", PosX = -20, PosY = -10 }
a.swirl_mechw_broken =	a.MechUnit:new{Image = "units/player/swirl_mech_w_broken.png", PosX = -20, PosY = -10 }
a.swirl_mech_ns =		a.MechIcon:new{Image = "units/player/swirl_mech_ns.png"}


HS_Paw = Pawn:new{
	Name = "Paw Mech",
	Class = "Brute",
	Health = 3,
	MoveSpeed = 3,
	Massive = true,
	Flying = true,
	Image = "paw_mech", 
	
	-- ImageOffset specifies which color scheme we will be using.
	-- (only apporpirate if you draw your mechs with Archive olive green colors)
	ImageOffset = autoOffset,

	SkillList = { "HS_Chaingun"},
	SoundLocation = "/mech/prime/punch_mech/",
	ImpactMaterial = IMPACT_METAL,
	DefaultTeam = TEAM_PLAYER,
}

HS_Tether = Pawn:new{
	Name = "Tether Mech",
	Class = "Prime",
	Health = 3,
	MoveSpeed = 3,
	Massive = true,
	Flying = true,
	Image = "tether_mech", 
	
	-- ImageOffset specifies which color scheme we will be using.
	-- (only apporpirate if you draw your mechs with Archive olive green colors)
	ImageOffset = autoOffset,

	SkillList = { "HS_Harpoon"},
	SoundLocation = "/mech/prime/punch_mech/",
	ImpactMaterial = IMPACT_METAL,
	DefaultTeam = TEAM_PLAYER,
}

HS_Swirl = Pawn:new{
	Name = "Swirl Mech",
	Class = "Ranged",
	Health = 2,
	MoveSpeed = 4,
	Massive = true,
	Flying = true,
	Image = "swirl_mech", 
	
	-- ImageOffset specifies which color scheme we will be using.
	-- (only apporpirate if you draw your mechs with Archive olive green colors)
	ImageOffset = autoOffset,

	SkillList = { "HS_FlareGun"},
	SoundLocation = "/mech/prime/punch_mech/",
	ImpactMaterial = IMPACT_METAL,
	DefaultTeam = TEAM_PLAYER,
}