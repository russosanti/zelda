--[[
    CS50 2D
    Legend of Zelda

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

PlayerWalkState = Class{__includes = EntityWalkState}

function PlayerWalkState:init(player, dungeon)
    self.entity = player
    self.dungeon = dungeon

    -- render offset for spaced character sprite; negated in render function of state
    self.entity.offsetY = 5
    self.entity.offsetX = 0
end

function PlayerWalkState:update(dt)
    if love.keyboard.isDown('left') then
        self.entity.direction = 'left'
        self.entity:changeAnimation('walk-left')
    elseif love.keyboard.isDown('right') then
        self.entity.direction = 'right'
        self.entity:changeAnimation('walk-right')
    elseif love.keyboard.isDown('up') then
        self.entity.direction = 'up'
        self.entity:changeAnimation('walk-up')
    elseif love.keyboard.isDown('down') then
        self.entity.direction = 'down'
        self.entity:changeAnimation('walk-down')
    else
        self.entity:changeState('idle')
    end

    if love.keyboard.wasPressed('space') then
        self.entity:changeState('swing-sword')
    end

    if love.keyboard.wasPressed('f') then
        self.entity:changeState('lift-pot')
    end

    local oldX, oldY = self.entity.x, self.entity.y
    -- perform base collision detection against walls
    EntityWalkState.update(self, dt)

    -- perform collision against objects
    for k, object in pairs(self.dungeon.currentRoom.objects) do
        if object.solid and self.entity:collides(object) then
            self.entity.x, self.entity.y = oldX, oldY
            break
        end
    end

    -- if we bumped something when checking collision, check any object collisions
    self.entity:checkDoorwayWalking(self.dungeon, self.bumped, dt)
end