--[[
    CS50 2D
    Legend of Zelda

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

Player = Class{__includes = Entity}

function Player:init(def)
    Entity.init(self, def)
end

function Player:update(dt)
    Entity.update(self, dt)
end

function Player:collides(target)
    local selfY, selfHeight = self.y + self.height / 2, self.height - self.height / 2
    
    return not (self.x + self.width < target.x or self.x > target.x + target.width or
                selfY + selfHeight < target.y or selfY > target.y + target.height)
end

function Player:render()
    Entity.render(self)
    
    -- love.graphics.setColor(255, 0, 255, 255)
    -- love.graphics.rectangle('line', self.x, self.y, self.width, self.height)
    -- love.graphics.setColor(255, 255, 255, 255)
end

-- Extract waking through doorways into a separate function to be called in both PlayerWalkState and PlayerCarryPotState
function Player:checkDoorwayWalking(dungeon, bumped, dt)
	if bumped then
		if self.direction == "left" then
			self.x = self.x - self.walkSpeed * dt

			for k, doorway in pairs(dungeon.currentRoom.doorways) do
				if self:collides(doorway) and doorway.open then
					self.y = doorway.y + 4
					Event.dispatch("shift-left")
				end
			end

			self.x = self.x + self.walkSpeed * dt
		elseif self.direction == "right" then
			self.x = self.x + self.walkSpeed * dt

			for k, doorway in pairs(dungeon.currentRoom.doorways) do
				if self:collides(doorway) and doorway.open then
					self.y = doorway.y + 4
					Event.dispatch("shift-right")
				end
			end

			self.x = self.x - self.walkSpeed * dt
		elseif self.direction == "up" then
			self.y = self.y - self.walkSpeed * dt

			for k, doorway in pairs(dungeon.currentRoom.doorways) do
				if self:collides(doorway) and doorway.open then
					self.x = doorway.x + 8
					Event.dispatch("shift-up")
				end
			end

			self.y = self.y + self.walkSpeed * dt
		else
			self.y = self.y + self.walkSpeed * dt

			for k, doorway in pairs(dungeon.currentRoom.doorways) do
				if self:collides(doorway) and doorway.open then
					self.x = doorway.x + 8
					Event.dispatch("shift-down")
				end
			end

			self.y = self.y - self.walkSpeed * dt
		end
	end
end

function Player:throwPot(pot, currentRoom)
    if self.direction == 'left' then
        pot:fire(-POT_THROW_SPEED, 0)
    elseif self.direction == 'right' then
        pot:fire(POT_THROW_SPEED, 0)
    elseif self.direction == 'up' then
        pot:fire(0, -POT_THROW_SPEED)
    else
        pot:fire(0, POT_THROW_SPEED)
    end

    -- Check to see if pot will collide with top wall, if so move the pot down so it doesn't get stuck in the wall and disappear
    if pot.y < MAP_RENDER_OFFSET_Y + TILE_SIZE then
        pot.y = pot.y + pot.height + 3
    end
    
    table.insert(currentRoom.objects, pot)
    self:changeState('idle')
end
