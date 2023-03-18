local SaveMenu, super = Class("SaveMenu")

function SaveMenu:update()
	super:update(self)
	
    if self.state == "MAIN" and Input.pressed("confirm") and (self.selected_x == 2 and self.selected_y == 2) and Game:getFlag("Recruits") then
		Game.world:openMenu(RecruitMenu())
	end
end

function SaveMenu:draw()
    love.graphics.setFont(self.font)
    if self.state == "MAIN" then
        local data = Game:getSavePreview()

        -- Header
        love.graphics.setColor(PALETTE["world_text"])
        love.graphics.print(data.name, 120, 120)
        love.graphics.print("LV "..data.level, 352, 120)

        local minutes = math.floor(data.playtime / 60)
        local seconds = math.floor(data.playtime % 60)
        local time_text = string.format("%d:%02d", minutes, seconds)
        love.graphics.print(time_text, 520 - self.font:getWidth(time_text), 120)

        -- Room name
        love.graphics.print(data.room_name, 319.5 - self.font:getWidth(data.room_name)/2, 170)

        -- Buttons
        love.graphics.print("Save", 170, 220)
        love.graphics.print("Return", 350, 220)
        if not Game.inventory.storage_enabled then
            love.graphics.setColor(PALETTE["world_gray"])
        end
        love.graphics.print("Storage", 170, 260)
		
		if not Game:getFlag("Recruits") then
			love.graphics.setColor(PALETTE["world_gray"])
		end
		
        love.graphics.print("Recruits", 350, 260)

        -- Heart
        local heart_positions_x = {142, 322}
        local heart_positions_y = {228, 270}
        love.graphics.setColor(Game:getSoulColor())
        love.graphics.draw(self.heart_sprite, heart_positions_x[self.selected_x], heart_positions_y[self.selected_y])
    elseif self.state == "SAVE" or self.state == "OVERWRITE" then
        self:drawSaveFile(0, Game:getSavePreview(), 74, 26, false, true)

        self:drawSaveFile(1, self.saves[1], 74, 138, self.selected_y == 1)
        love.graphics.draw(self.divider_sprite, 74, 208, 0, 493, 2)

        self:drawSaveFile(2, self.saves[2], 74, 222, self.selected_y == 2)
        love.graphics.draw(self.divider_sprite, 74, 292, 0, 493, 2)

        self:drawSaveFile(3, self.saves[3], 74, 306, self.selected_y == 3)
        love.graphics.draw(self.divider_sprite, 74, 376, 0, 493, 2)

        if self.selected_y == 4 then
            love.graphics.setColor(Game:getSoulColor())
            love.graphics.draw(self.heart_sprite, 236, 402)

            love.graphics.setColor(PALETTE["world_text_selected"])
        else
            love.graphics.setColor(PALETTE["world_text"])
        end
        love.graphics.print("Return", 278, 394)
    elseif self.state == "SAVED" then
        self:drawSaveFile(self.saved_file, self.saves[self.saved_file], 74, 26, false, true)

        self:drawSaveFile(1, self.saves[1], 74, 138, self.selected_y == 1)
        love.graphics.draw(self.divider_sprite, 74, 208, 0, 493, 2)

        self:drawSaveFile(2, self.saves[2], 74, 222, self.selected_y == 2)
        love.graphics.draw(self.divider_sprite, 74, 292, 0, 493, 2)

        self:drawSaveFile(3, self.saves[3], 74, 306, self.selected_y == 3)
    end

    Object.draw(self)

    if self.state == "OVERWRITE" then
        love.graphics.setColor(PALETTE["world_text"])
        local overwrite_text = "Overwrite Slot "..self.selected_y.."?"
        love.graphics.print(overwrite_text, SCREEN_WIDTH/2 - self.font:getWidth(overwrite_text)/2, 123)

        local function drawOverwriteSave(data, x, y)
            local w = 478

            -- Header
            love.graphics.print(data.name, x + (w/2) - self.font:getWidth(data.name)/2, y)
            love.graphics.print("LV "..data.level, x, y)

            local minutes = math.floor(data.playtime / 60)
            local seconds = math.floor(data.playtime % 60)
            local time_text = string.format("%d:%02d", minutes, seconds)
            love.graphics.print(time_text, x + w - self.font:getWidth(time_text), y)

            -- Room name
            love.graphics.print(data.room_name, x + (w/2) - self.font:getWidth(data.room_name)/2, y+30)
        end

        love.graphics.setColor(PALETTE["world_text"])
        drawOverwriteSave(self.saves[self.selected_y], 80, 165)
        love.graphics.setColor(PALETTE["world_text_selected"])
        drawOverwriteSave(Game:getSavePreview(), 80, 235)

        if self.selected_x == 1 then
            love.graphics.setColor(Game:getSoulColor())
            love.graphics.draw(self.heart_sprite, 142, 332)

            love.graphics.setColor(PALETTE["world_text_selected"])
        else
            love.graphics.setColor(PALETTE["world_text"])
        end
        love.graphics.print("Save", 170, 324)

        if self.selected_x == 2 then
            love.graphics.setColor(Game:getSoulColor())
            love.graphics.draw(self.heart_sprite, 322, 332)

            love.graphics.setColor(PALETTE["world_text_selected"])
        else
            love.graphics.setColor(PALETTE["world_text"])
        end
        love.graphics.print("Return", 350, 324)
    end
end

return SaveMenu