--[[
    CS50 2D
    Legend of Zelda

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

PlayerCarryPotState = Class{__includes = EntityWalkState}

function PlayerCarryPotState:init(player, dungeon)
    self.entity = player
    self.dungeon = dungeon
    self.entity.offsetY = 5
    self.entity.offsetX = 0
end

function PlayerCarryPotState:enter(params)
    self.pot = params.pot
end

function PlayerCarryPotState:update(dt)
    if love.keyboard.isDown('left') then
        self.entity.direction = 'left'
        self.entity:changeAnimation('pot-walk-left')
    elseif love.keyboard.isDown('right') then
        self.entity.direction = 'right'
        self.entity:changeAnimation('pot-walk-right')
    elseif love.keyboard.isDown('up') then
        self.entity.direction = 'up'
        self.entity:changeAnimation('pot-walk-up')
    elseif love.keyboard.isDown('down') then
        self.entity.direction = 'down'
        self.entity:changeAnimation('pot-walk-down')
    else
        self.entity:changeState('carry-pot-idle', {pot = self.pot})
        return
    end

    -- FIX: continues walking non stopping with pot, should stop and idle when no movement keys are pressed

    if love.keyboard.wasPressed('space') then
        self.entity:throwPot(self.pot, self.dungeon.currentRoom)
    end

    local oldX, oldY = self.entity.x, self.entity.y
    -- perform base collision detection against walls
    EntityWalkState.update(self, dt)

        -- block movement through other solid objects
    for k, object in pairs(self.dungeon.currentRoom.objects) do
        if object.solid and self.entity:collides(object) then
            self.entity.x, self.entity.y = oldX, oldY
            break
        end
    end

    self.entity:checkDoorwayWalking(self.dungeon, self.bumped, dt)

    self:trackPot()
end

-- keep the pot riding above the player's head
function PlayerCarryPotState:trackPot()
    self.pot.x = self.entity.x
    self.pot.y = self.entity.y - 8
end

function PlayerCarryPotState:render()
    EntityWalkState.render(self)
    love.graphics.draw(gTextures[self.pot.texture], gFrames[self.pot.texture][self.pot.frame],
        math.floor(self.entity.x), math.floor(self.entity.y - 8))
end