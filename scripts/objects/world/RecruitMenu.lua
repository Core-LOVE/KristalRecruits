local RecruitMenu, super = Class(Object)

function RecruitMenu:initEnemies()
	self.page = 1
	self.enemy = 1
	
	self.enemies = 0
	
	self.pages = {
		[1] = {},
	}
	
	local Recruits = Game:getFlag("Recruits", {})
	
	local page = 1
	local nextPage = 0
	
	for name, data in pairs(Recruits) do
		if nextPage >= 9 then
			page = page + 1
			self.pages[page] = {}
			nextPage = 0
		end
		
		local actor = ActorSprite(name)
		actor:setScale(2)
		
		actor.x = (actor.x + 103) - actor.width
		actor.x = actor.x + 369
		actor.y = (actor.y + 161) - actor.height
		
		local enemy = Utils.copy(data)
		enemy.idx = self.enemies + 1
		enemy.actor = actor
		enemy.gradient = Assets.getTexture(enemy.gradient)
		
		table.insert(self.pages[page], enemy)
		
		self.enemies = self.enemies + 1
		nextPage = nextPage + 1
	end
end

function RecruitMenu:initHeart()
    self.heart = Sprite("player/heart")
    self.heart:setOrigin(0.5, 0.5)
    self.heart:setColor(Game:getSoulColor())
    self.heart.layer = 100
    self:addChild(self.heart)
	
	self.heart_og_x = 58
	self.heart_og_y = 110 - 4
	self.heart_target_x = self.heart_og_x 
	self.heart_target_y = self.heart_og_y
	
	self.heart:setPosition(self.heart_target_x, self.heart_target_y)
	
	self.heartTimer = 0
end

function RecruitMenu:init()
    super:init(self, 0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)

	self.canPress = 0
	self.state = 1
	
    self.parallax_x = 0
    self.parallax_y = 0
	
	self.layer = 100
	
    self.font = Assets.getFont("main")
    self.font2 = Assets.getFont("plain")
	
	self.arrow_left = Assets.getTexture("ui/flat_arrow_left")
	self.arrow_right = Assets.getTexture("ui/flat_arrow_right")
	
	self:initEnemies()
	self:initHeart()
end

function RecruitMenu:drawEnemy(enemy)
	love.graphics.setColor(enemy.gradientColor)
	love.graphics.draw(enemy.gradient, 370, 75)
	love.graphics.setColor(PALETTE["world_text"])
	love.graphics.rectangle('line', 370, 75, 207, 152)
	
	enemy.actor:drawSelf()
	
	love.graphics.print('CHAPTER ' .. enemy.chapter, 368, 280)
	love.graphics.print('LV ' .. enemy.lv, 528, 280)
end

function RecruitMenu:drawState1()
	if self.state ~= 1 then return end
	
	-- all the text
	love.graphics.print("Recruits", 80, 30)
	
	love.graphics.setColor(0, 1, 0)
	love.graphics.print('PROGRESS', 270, 38, 0, 0.5, 1)
    love.graphics.setColor(PALETTE["world_text"])
	
	love.graphics.print('[Z]: More Info', 380, 320)
	love.graphics.print('[X]: Quit', 380, 352)
		
	local currentPage = self.pages[self.page]
	local dy = -8
	
	for idx, enemy in ipairs(currentPage) do
		local selected = (self.enemy == idx)
		
		love.graphics.setColor(0, 1, 0)
		love.graphics.print('Recruited!', 275, 100 + dy, 0, 0.5, 1)
		love.graphics.setColor(PALETTE["world_text"])
	
		if selected then
			self:drawEnemy(enemy)
			love.graphics.setColor(1, 1, 0)
		end
		
		love.graphics.print(enemy.name, 80, 100 + dy)
		
		dy = dy + 35
	end
end

function RecruitMenu:drawState2()
	if self.state ~= 2 then return end
	
	local enemy = self.pages[self.page][self.enemy]
	
	love.graphics.setColor(enemy.gradientColor)
	love.graphics.draw(enemy.gradient, 80, 70)
	love.graphics.setColor(PALETTE["world_text"])
	love.graphics.rectangle('line', 80, 70, 207, 152)
	
	enemy.actor:drawSelf()
	
	love.graphics.print("CHAPTER " .. enemy.chapter, 300, 30, 0, 0.5, 1)
	love.graphics.print(enemy.name, 300, 70)	
	
	love.graphics.print("LIKE", 80, 240)
	love.graphics.print("DISLIKE", 80, 280, 0, 0.8196, 1)
	love.graphics.print("?????", 80, 320, 0, 1.15, 1)
	love.graphics.print("?????", 80, 360, 0, 1.15, 1)
	
	love.graphics.print(enemy.like, 180, 240)
	love.graphics.print(enemy.dislike, 180, 280)
	love.graphics.print("?????????", 180, 320)
	love.graphics.print("?????????", 180, 360)
		
	love.graphics.print("Press [X] to Return", 80, 400)

	love.graphics.printf("LEVEL", 240, 240, 640, "right", 0, 0.5, 1)
	love.graphics.printf("ATTACK", 240, 280, 640, "right", 0, 0.5, 1)
	love.graphics.printf("DEFENSE", 240, 320, 640, "right", 0, 0.5, 1)

	love.graphics.printf(enemy.lv, 270, 240, 640, "right", 0, 0.5, 1)
	love.graphics.printf(enemy.attack, 270, 280, 640, "right", 0, 0.5, 1)
	love.graphics.printf(enemy.defense, 270, 320, 640, "right", 0, 0.5, 1)
	love.graphics.printf("ELEMENT " .. enemy.element, 270, 360, 640, "right", 0, 0.5, 1)
	
	love.graphics.printf(enemy.idx .. "/" .. tostring(self.enemies), 270, 38, 640, "right", 0, 0.5, 1)
	
    love.graphics.setFont(self.font2)
	love.graphics.print(enemy.description or "A ERROR", 301, 120)
	
    love.graphics.setFont(self.font)
end

function RecruitMenu:drawArrows()
	if (self.state == 1 and self.enemies < 9) or (self.state == 2 and self.enemies == 1) then return end
	
	local x, y = 20, 213
	local offsetX = 0
	
	if self.state == 2 then
		y = 218
		offsetX = 8
	end
	
    local offset = Utils.round(math.sin(Kristal.getTime() * 5)) * 2
		
	love.graphics.draw(self.arrow_left, x - offset, y, 0, 2, 2)
	love.graphics.draw(self.arrow_right, (640 - x - 8 - offsetX) + (offset), y, 0, 2, 2)
end

function RecruitMenu:draw()
    love.graphics.setFont(self.font)
	
	local x, y = 32, 12
	local w, h = 587, 427
	
	if self.state == 2 then
		w, h = 577, 437
	end
	
	-- box
    love.graphics.setColor(0, 0, 0, 1)
	love.graphics.rectangle('fill', x, y, w, h)
    love.graphics.setColor(PALETTE["world_text"])
	love.graphics.setLineWidth(4)
	love.graphics.rectangle('line', x, y, w, h)
	love.graphics.setLineWidth(1)
	
	self:drawState1()
	self:drawState2()
	
    love.graphics.setColor(PALETTE["world_text"])
	
	self:drawArrows()
	
	super:draw(self)
end

function RecruitMenu:updateEnemy(enemy)
	enemy.actor:update()
end

function RecruitMenu:getCurrentPage()
	return self.pages[self.page]
end

function RecruitMenu:updateHeart()
    -- Move the heart closer to the target
    if (math.abs((self.heart_target_x - self.heart.x)) <= 2) then
        self.heart.x = self.heart_target_x
    end
    if (math.abs((self.heart_target_y - self.heart.y)) <= 2)then
        self.heart.y = self.heart_target_y
    end
    self.heart.x = self.heart.x + ((self.heart_target_x - self.heart.x) / 2) * DTMULT
    self.heart.y = self.heart.y + ((self.heart_target_y - self.heart.y) / 2) * DTMULT
	
	-- local heart = self.heart
	-- local mode = 'out-cubic'
	
	-- self.heartTimer = self.heartTimer + 0.07
	
	-- if self.heartTimer >= 1 then
		-- self.heartTimer = 1
	-- elseif self.heartTimer < 0 then
		-- self.heartTimer = 0
	-- end
	
	-- local t = self.heartTimer
	
	-- heart.y = Utils.ease(heart.y, self.heart_target_y, t, mode)
	-- heart.x = Utils.ease(heart.x, self.heart_target_x, t, mode)
end

function RecruitMenu:moveHeart(x, y)
	local heart = self.heart
	
	return self:moveHeartTo(heart.x + x, heart.y + y)
end

function RecruitMenu:moveHeartTo(x, y)
	self.heartTimer = 0
	local heart = self.heart
	
	self.heart_target_x = x or heart.x
	self.heart_target_y = y or heart.y
end

function RecruitMenu:updatePages()
	if #self.pages == 1 then return end
	
	if Input.pressed("left") then
		self.page = self.page - 1
		
		if self.page <= 0 then
			self.page = #self.pages
		end
	elseif Input.pressed("right") then
		self.page = self.page + 1
		
		if self.page > #self.pages then
			self.page = 1
		end	
	end
end

local function updateEnemyPlacement(self)
	local enemy = self.pages[self.page][self.enemy].actor
	enemy.x = enemy.x - 290
	enemy.y = enemy.y - 5
end

local function updateEnemyPlacement2(self)
	local enemy = self.pages[self.page][self.enemy].actor
	enemy.x = enemy.x + 290
	enemy.y = enemy.y + 5
end

function RecruitMenu:updateState1()
	if self.state ~= 1 then return end
	
	self.canPress = math.min(self.canPress + 1, 10)
	
	if Input.pressed("cancel") and self.canPress >= 10 then
		Game.world:closeMenu()
		self:remove()
	end
	
	self:updatePages()
	
	if Input.pressed("up") then
		self.enemy = self.enemy - 1
		
		if self.enemy <= 0 then
			self.enemy = #self:getCurrentPage()
		end
	elseif Input.pressed("down") then
		self.enemy = self.enemy + 1
		
		if self.enemy > #self:getCurrentPage() then
			self.enemy = 1
		end
	end
	
	if Input.pressed('down') or Input.pressed('up') then
		self:moveHeartTo(nil, self.heart_og_y + (35 * (self.enemy - 1)))	
	end
	
	if Input.pressed("confirm") and self.canPress >= 10 then
		local heart = self.heart
		
		self:moveHeartTo(self.heart_og_x, 417)
		
		updateEnemyPlacement(self)
		
		self.state = 2
	end
end

function RecruitMenu:updateState2()
	if self.state ~= 2 then return end
	
	if Input.pressed("cancel") then
		updateEnemyPlacement2(self)
		
		self.canPress = 0
		self:moveHeartTo(nil, self.heart_og_y + (35 * (self.enemy - 1)))	
		self.state = 1
	end
	
	if Input.pressed("left") then
		updateEnemyPlacement2(self)
		self.enemy = self.enemy - 1
		
		if self.enemy <= 0 then
			self.page = self.page - 1
			
			if self.page < 1 then
				self.page = #self.pages
			end
			
			self.enemy = #self.pages[self.page]
		end
	elseif Input.pressed("right") then
		updateEnemyPlacement2(self)
		self.enemy = self.enemy + 1
		
		if self.enemy > #self.pages[self.page] then
			self.page = self.page + 1
			
			if self.page > #self.pages then
				self.page = 1
			end
			
			self.enemy = 1
		end
	end
	
	if Input.pressed("left") or Input.pressed("right") then
		updateEnemyPlacement(self)
	end
end

function RecruitMenu:update()
	self:updateState1()
	self:updateState2()
	
	self:updateHeart()
	self:updateEnemy(self.pages[self.page][self.enemy])
	
	super:update(self)
end

return RecruitMenu