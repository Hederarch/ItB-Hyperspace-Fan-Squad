
--[[
	some simple examples of how to start coding weapons.
	to test these weapons, you can - with this mod enabled - write in the console:
	
	weapon Weapon_Template
	weapon Weapon_Template2
	
	you can then look over the code below to see how they were made.
	you'll notice Weapon_Template looks cooler than Weapon_Template2.
	to find out more on why that is, you can look at
	Prime_Punchmech in ITB/scripts/weapons_prime.lua,
	and look at how the GetSkillEffect of this weapon is different.
]]


-- this line just gets the file path for your mod, so you can find all your files easily.
local path = mod_loader.mods[modApi.currentMod].resourcePath

-- add assets from our mod so the game can find them.
modApi:appendAsset("img/weapons/chaingun_icon.png", path .."img/weapons/chaingun_icon.png")
modApi:appendAsset("img/weapons/chaff_icon.png", path .."img/weapons/chaff_icon.png")
modApi:appendAsset("img/weapons/harpoon_icon.png", path .."img/weapons/harpoon_icon.png")
modApi:appendAsset("img/effects/harpoon_grapple_shot_U.png", path .."img/effects/harpoon_grapple_shot_U.png")
modApi:appendAsset("img/effects/harpoon_grapple_shot_R.png", path .."img/effects/harpoon_grapple_shot_R.png")

-- If we want our weapon to not have a base, we usually base it on Skill - the base for all weapons.
HS_Chaingun = TankDefault:new{
	Name = "GC Chaingun",
	Description = "Fires a simple but effective machine gun.",
	Icon = "weapons/chaingun_icon.png",
	LaunchSound = "/weapons/doubleshot",
	ImpactSound = "/impact/generic/explosion",
	ProjectileArt = "effects/shot_pierce",
	Exploart = "explopush1_",
	Class = "Brute",
	ZoneTargeting = DIR,
	Damage = 1,
	Push = 1,
	Upgrades = 2,
	UpgradeCost = {2,2},
	UpgradeList = { "Quickfire",  "+1 Damage"  },
	TipImage = {
		Unit = Point(2,3),
		Enemy = Point(2,1),
		Target = Point(2,1),
	}
}

function HS_Chaingun:GetSkillEffect(p1,p2)
	local ret = SkillEffect()
	local dir = GetDirection(p2 - p1)
	
	local pathing = self.Phase and PATH_PHASING or PATH_PROJECTILE
	local target1 = GetProjectileEnd(p1,p2,pathing)  
	
	ret:AddBounce(p1,3)
	
	local damage = SpaceDamage(target1, self.Damage)
	if self.Push == 1 then
		damage.iPush = dir
	end
	
	local dummy = SpaceDamage(target1, 0)
	dummy.sAnimation = "ExploAir1"
	
	damage.iAcid = self.Acid
	damage.iFrozen = self.Freeze
	damage.iShield = self.Shield
	damage.sAnimation = self.Exploart..dir
	
	for i = -1,1 do
		dummy.loc = target1 + DIR_VECTORS[dir] * i
		ret:AddProjectile(dummy, self.ProjectileArt, NO_DELAY)
		ret:AddDelay(0.2)
	end
	
	ret:AddProjectile(damage, self.ProjectileArt, NO_DELAY)
	return ret
end

HS_Chaingun_A = HS_Chaingun:new{
	UpgradeDescription = "Allows shooting in an additional direction.",
	TwoClick = true,
		TipImage = {
		Unit = Point(1,3),
		Enemy = Point(1,1),
		Enemy2 = Point(3,3),
		Target = Point(1,1),
		Second_Click = Point(3,3),
	}
}
HS_Chaingun_B = HS_Chaingun:new{
	UpgradeDescription = "Increases damage by 1.",
	Damage = 2,
	Exploart = "explopush2_",
}
HS_Chaingun_AB = HS_Chaingun_A:new{
	Damage = 2,
	Exploart = "explopush2_",
}

--this is only used for touch controls, customizing what counts as the same "group" for targeting purposes
function HS_Chaingun_A:GetSecondTargetZone(points)	
	local origin = points:index(1)
	local p1 = points:index(2)
	local p2 = points:index(3)
	
	local targets = self:GetSecondTargetArea(origin, p1)
	local ret = PointList()
		
	local dir = GetDirection(p2-origin)
	for i = 1, targets:size() do
		if GetDirection(targets:index(i) - origin) == dir then
			ret:push_back(targets:index(i))
		end
	end

	return ret
end

function HS_Chaingun_A:GetSecondTargetArea(p1,p2)
	local dir = GetDirection(p2-p1)
	local ret = PointList()
	
	for i = 1, 3 do
		for j = 1, 8 do
			local curr = Point(p1 + DIR_VECTORS[(dir+i)%4] * j)
			if not Board:IsValid(curr) then
				break
			end
			ret:push_back(curr)
			
			if Board:IsBlocked(curr, PATH_PROJECTILE) then
				break
			end
		end
	end
	return ret
end

function HS_Chaingun_A:GetFinalEffect(p1, p2, p3)
	local ret = SkillEffect()
	local dir1 = GetDirection(p2 - p1)
	
	local pathing = self.Phase and PATH_PHASING or PATH_PROJECTILE
	local target1 = GetProjectileEnd(p1,p2,pathing)  
	
	local dir2 = GetDirection(p3-p1)
	local target2 = GetProjectileEnd(p1,p3,pathing)  
	
	ret:AddBounce(p1,3)
	
	local damage = SpaceDamage(target1, self.Damage)
	if self.Push == 1 then
		damage.iPush = dir1
	end
	
	local dummy = SpaceDamage(target1, 0)
	dummy.sAnimation = "ExploAir1"
	
	damage.iAcid = self.Acid
	damage.iFrozen = self.Freeze
	damage.iShield = self.Shield
	damage.sAnimation = self.Exploart..dir1
	
	for i = -1,1 do
		dummy.loc = target1 + DIR_VECTORS[dir1] * i
		ret:AddProjectile(dummy, self.ProjectileArt, NO_DELAY)
		ret:AddDelay(0.1)
		dummy.loc = target2 + DIR_VECTORS[dir2] * i
		ret:AddProjectile(dummy, self.ProjectileArt, NO_DELAY)
		ret:AddDelay(0.1)
	end
	
	ret:AddProjectile(damage, self.ProjectileArt, NO_DELAY)
	
	
	 damage = SpaceDamage(target2, self.Damage)
	if self.Push == 1 then
		damage.iPush = dir2
	end
	
	
	damage.sAnimation = self.Exploart..dir2
	ret:AddProjectile(damage, self.ProjectileArt, NO_DELAY)
	
	return ret
end

HS_Harpoon = {
	Name = "Contemper Harpoon",
	Description = "Pulls your Mech to a nearby target, ramming through them if possible.",
	Class = "Prime",
	Rarity = 1,
	Icon = "weapons/harpoon_icon.png",	
	Explosion = "",
	Damage = 1,
	SelfDamage = 0,
	Fire = 0,
	Range = RANGE_PROJECTILE,--TOOLTIP info
	Cost = "low",
	PowerCost = 0,
	Upgrades = 2,
	UpgradeCost = {1,2},
	UpgradeList = { "Ramming Force",  "Add Fire"  },
	LaunchSound = "/weapons/grapple",
	ImpactSound = "/impact/generic/grapple",
	ZoneTargeting = ZONE_DIR,
	TipImage = {
		Unit = Point(2,3),
		Enemy = Point(2,0),
		Target = Point(2,0),
	}
}
			
HS_Harpoon = Skill:new(HS_Harpoon)

function HS_Harpoon:GetTargetArea(point)
	local ret = PointList()
	for dir = DIR_START, DIR_END do
		local this_path = {}
		
		local target = point + DIR_VECTORS[dir]

		while not Board:IsBlocked(target, PATH_PROJECTILE) do
			this_path[#this_path+1] = target
			target = target + DIR_VECTORS[dir]
		end
		
		if Board:IsValid(target) then
			this_path[#this_path+1] = target
			for i,v in ipairs(this_path) do 
				ret:push_back(v)
			end
		end
	end
	
	return ret
end

function HS_Harpoon:GetSkillEffect(p1,p2)
	local ret = SkillEffect()
	local direction = GetDirection(p2 - p1)

	local target = p1 + DIR_VECTORS[direction]

	while not Board:IsBlocked(target, PATH_PROJECTILE) do
		target = target + DIR_VECTORS[direction]
	end
	
	if not Board:IsValid(target) then
		return ret
	end
	
	local damage = SpaceDamage(target,0)
	damage.bHidePath = true
	ret:AddProjectile(damage,"effects/harpoon_grapple_shot")
	
	if Board:IsPawnSpace(target) and not Board:GetPawn(target):IsGuarding() then

		ret:AddCharge(Board:GetSimplePath(p1, target - DIR_VECTORS[direction]), FULL_DELAY)		
		ret:AddCharge(Board:GetSimplePath(target - DIR_VECTORS[direction],target), NO_DELAY)	
		ret:AddCharge(Board:GetSimplePath(target,target - DIR_VECTORS[direction]), NO_DELAY)	
		local rip = SpaceDamage(target - DIR_VECTORS[direction],self.Damage)
		rip.iFire = self.Fire
		rip.sAnimation = "explopush1_" .. (direction + 2)%4
		if self.SelfDamage > 0 then
			rip.sAnimation = "explopush2_" .. (direction + 2)%4
			local self = SpaceDamage(target,self.SelfDamage)
			self.sAnimation = "explopush1_" .. direction
			ret:AddDamage(self)
		end
		ret:AddDamage(rip)
	else  
		ret:AddCharge(Board:GetSimplePath(p1, target - DIR_VECTORS[direction]), FULL_DELAY)	
		local rip = SpaceDamage(target,self.Damage)
		rip.iFire = self.Fire
		rip.sAnimation = "explopush1_" .. direction
		if self.SelfDamage > 0 then
			rip.sAnimation = "explopush2_" .. direction
			local self = SpaceDamage(target - DIR_VECTORS[direction],self.SelfDamage)
			self.sAnimation = "ExploAir1"
			ret:AddDamage(self)
		end
		ret:AddDamage(rip)
	end
		
	return ret
end

HS_Harpoon_A = HS_Harpoon:new{
	UpgradeDescription = "Increases damage, but adds self damage.",
	Damage = 3,
	SelfDamage = 1,
}

HS_Harpoon_B = HS_Harpoon:new{
	UpgradeDescription = "Adds Fire to the target tile.",
	Fire = 1,
}

HS_Harpoon_AB = HS_Harpoon:new{
	Damage = 3,
	SelfDamage = 1,
	Fire = 1,
}

HS_FlareGun = ArtilleryDefault:new{
	Name = "Chaff Launcher",
	Description = "Launches a smoke bomb that splits into wider shrapnel.",
	Class = "Ranged",
	Icon = "weapons/chaff_icon.png",
	Rarity = 3,
	UpShot = "effects/shotup_tribomb_missile.png",
	ArtilleryStart = 2,
	ArtillerySize = 8,
	AllyDamage = true,
	Push = 1,
	DamageOuter = 0,
	DamageCenter = 2,
	Wider = false,
	PowerCost = 0, --AE Change
	Damage = 1,---USED FOR TOOLTIPS
	BounceAmount = 1,
	Explosion = "",
	ExplosionCenter = "ExploArt1",
	ExplosionOuter = "",
	Upgrades = 2,
	UpgradeCost = {1,2},
	UpgradeList = { "Ally Immune", "+1 Damage"  },
	LaunchSound = "/weapons/fireball",
	ImpactSound = "/props/fire_damage",
	TipImage = {
		Unit = Point(2,4),
		Enemy = Point(2,2),
		Enemy2 = Point(3,2),
		Enemy3 = Point(2,1),
		Target = Point(2,2),
		Mountain = Point(2,3)
	}
}

function HS_FlareGun:GetSkillEffect(p1, p2)	
	local ret = SkillEffect()
	local dir = GetDirection(p2 - p1)
	
	ret:AddBounce(p1, 1)
	
	damage = SpaceDamage(p2,self.DamageCenter)
	damage.iSmoke = 1
	damage.sAnimation = "explopush1_"..dir
	
	if not self.AllyDamage and (Board:IsBuilding(p2) or Board:GetPawnTeam(p2) == TEAM_PLAYER) then
		damage.iDamage = 0
	end
	
	ret:AddArtillery(damage,self.UpShot)
	ret:AddBounce(p2, 2)
	
	damage.iSmoke = 0
	for i = DIR_START, DIR_END do
		damage.loc = p2 + DIR_VECTORS[i]
		damage.iPush = dir
		damage.sAnimation = "explopush1_"..dir
		
		if not self.AllyDamage and (Board:IsBuilding(p2 + DIR_VECTORS[i]) or Board:GetPawnTeam(p2 + DIR_VECTORS[i]) == TEAM_PLAYER) then
			damage.iDamage = 0
		else
			damage.iDamage = self.DamageOuter
		end
		
		ret:AddDamage(damage)
		ret:AddBounce(p2 + DIR_VECTORS[i], 2)
	end
	return ret
end		

HS_FlareGun_A = HS_FlareGun:new{
	UpgradeDescription = "Does not damage Mechs or Buildings.",
	AllyDamage = false,
		TipImage = {
		Unit = Point(2,4),
		Enemy = Point(3,2),
		Friendly = Point(2,1),
		Target = Point(2,2),
		Building = Point(2,2)
	}
}

HS_FlareGun_B = HS_FlareGun:new{
	UpgradeDescription = "Increases damage by 1.",
	DamageOuter = 1,
	DamageCenter = 3,
}

HS_FlareGun_AB = HS_FlareGun:new{
	DamageOuter = 1,
	DamageCenter = 3,
	AllyDamage = false,
		TipImage = {
		Unit = Point(2,4),
		Enemy = Point(2,2),
		Enemy2 = Point(3,2),
		Enemy3 = Point(2,1),
		Target = Point(2,2),
		Building = Point(2,3)
	}
}