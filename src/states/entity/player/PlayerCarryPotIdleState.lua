--[[
    CS50 2D
    Legend of Zelda

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

PlayerCarryPotIdleState = Class{__includes = EntityIdleState}

function PlayerCarryPotIdleState:init(player, dungeon)
    self.entity = player
    self.entity.offsetY = 5
    self.entity.offsetX = 0
    self.dungeon = dungeon
end

function PlayerCarryPotIdleState:enter(params)
    self.pot = params.pot
    self.entity:changeAnimation('pot-idle-' .. self.entity.direction)
    self:trackPot()
end

function PlayerCarryPotIdleState:update(dt)
    if love.keyboard.isDown('left') or love.keyboard.isDown('right') or love.keyboard.isDown('up') or
        love.keyboard.isDown('down') then
        self.entity:changeState('carry-pot', {pot = self.pot})
        return
    end

    if love.keyboard.wasPressed('space') then
        self.entity:throwPot(self.pot, self.dungeon.currentRoom)
        return
    end

    self:trackPot()
end

-- keep the pot riding above the player's head
function PlayerCarryPotIdleState:trackPot()
    self.pot.x = self.entity.x
    self.pot.y = self.entity.y - 8
end

function PlayerCarryPotIdleState:render()
    EntityIdleState.render(self)
    love.graphics.draw(gTextures[self.pot.texture], gFrames[self.pot.texture][self.pot.frame],
        math.floor(self.entity.x), math.floor(self.entity.y - 8))
end
