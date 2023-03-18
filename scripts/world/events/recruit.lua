local MyEvent, super = Class(Event)

local function checkRecruit(self, name)
	local Recruits = Game:getFlag("Recruits", {})
	local enemyRecruits = Recruits[name] or {}
	
	print(enemyRecruits.count, enemyRecruits.maxAmount)
	
	if enemyRecruits.count == nil then return end
	
	if enemyRecruits.count ~= enemyRecruits.maxAmount then
		self:remove()
	else
		return true
	end
end

function MyEvent:init(data)
	local Recruits = Game:getFlag("Recruits", {})
	local properties = data.properties
	local name = properties.actor

	local spawnNPC = false
	
	if name then
		spawnNPC = checkRecruit(self, name)
	end
	
	properties.actor = self:getFlag("RecruitActor", properties.actor)
	
	if spawnNPC then
		local npc = Game.world:spawnNPC(properties.actor, data.x, data.y, properties)
		self.npc = npc
	end
	
	self.data = data
	
	super:init(self, data)
end

return MyEvent