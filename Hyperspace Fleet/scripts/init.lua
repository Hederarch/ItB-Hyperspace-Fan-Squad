
-- init.lua is the entry point of every mod

local mod = {
	id = "hedera_sleeper_games_fan_mod",
	name = "Hyperspace Fleet",
	version = "1.0.0",
	requirements = {},
	modApiVersion = "2.3.0",
	icon = "img/mod_icon.png"
}

function mod:init()
	-- look in template/mech to see how to code mechs.
	require(self.scriptPath .."palettes")
	require(self.scriptPath .."pawns")
	require(self.scriptPath .."weapons")
	
end

--New shop
    --modApi:addWeaponDrop("VS_Prime_Driver")
    --modApi:addWeaponDrop("VS_Ranged_ShieldArti")
    --modApi:addWeaponDrop("VS_Brute_Magnum")

function mod:load(options, version)
	-- after we have added our mechs, we can add a squad using them.
	modApi:addSquad(
		{
			"Hyperspace Fleet",		-- title
			"HS_Paw",			-- mech #1
			"HS_Tether",			-- mech #2
			"HS_Swirl"			-- mech #3
		},
		"Hyperspace Fleet",
		"A group of far future fighter jets from a far-off galaxy. Fitted for taking down much larger cruisers, they were turned loose on the colossal Vek.",
		self.resourcePath .."img/mod_icon.png"
	)
end

return mod
