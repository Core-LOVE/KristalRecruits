local EnemyBattler, super = Class("EnemyBattler")

function EnemyBattler:defineRecruit(maxAmount, data)
	local data = data or {}
	
	if not Game:getFlag("Recruits") then
		Game:setFlag("Recruits", {})
	end
	
	local Recruits = Game:getFlag("Recruits", {})
	local name = self.id
	
	Recruits[name] = Recruits[name] or {
		maxAmount = (maxAmount or 1),
		count = 0,
		name = data.name or self.name,
		description = data.description or "A ERROR",
		
		lv = tostring(data.lv or 1),
		chapter = tostring(data.chapter or 1),
		attack = tostring(data.attack or 1),
		defense = tostring(data.defense or 1),
		
		like = data.like or "nil",
		dislike = data.dislike or "nil",
		
		element = data.element or "SOMETHING",
		
		gradient = "ui/recruitBox",
		gradientColor = {1, 0, 1, 1},
	}
end

function EnemyBattler:onRecruit()
	local enemyRecruits = Game:getFlag("Recruits", {})[self.id]
	
	if enemyRecruits and enemyRecruits.count < enemyRecruits.maxAmount then
		enemyRecruits.count = enemyRecruits.count + 1
	end
	
    local msg = DamageNumber("msg", "recruit", self.x, self.y - 40)
	
    local numbers = DamageNumber("recruitNumbers", nil, -30, 35)
	numbers.x = numbers.x + numbers.width
    numbers.font = Assets.getFont("goldnumbers")
	numbers.text = (enemyRecruits.count .. "/" .. enemyRecruits.maxAmount)
	msg:addChild(numbers)
	
    self.parent:addChild(msg)
end

function EnemyBattler:isRecruitable()
	local Recruits = Game:getFlag("Recruits", {})
	
	return (Recruits[self.id] and not self.cantRecruit)
end

function EnemyBattler:spare(...)
	if self:isRecruitable() then
		self:onRecruit()
	end
	
	super:spare(self, ...)
end

function EnemyBattler:getDebugOptions(context)
    context:addMenuItem("Mercy", "Adds 100 mercy points.", function()
        self:addMercy(100)
    end)
	
    context:addMenuItem("Merch & Spare", "Name says it", function()
        self:addMercy(100)
		self:spare()
    end)
	
	return super:getDebugOptions(self, context)
end

return EnemyBattler