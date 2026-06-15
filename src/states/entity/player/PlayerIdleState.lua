--[[
    CS50 2D
    Legend of Zelda

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

PlayerIdleState = Class{__includes = EntityIdleState}

function PlayerIdleState:init(player, dungeon)
    EntityIdleState.init(self, player)
    self.dungeon = dungeon
end

function PlayerIdleState:enter(params)
    -- render offset for spaced character sprite (negated in render function of state)
    self.entity.offsetY = 5
    self.entity.offsetX = 0
end

function PlayerIdleState:update(dt)
    if love.keyboard.isDown('left') or love.keyboard.isDown('right') or
       love.keyboard.isDown('up') or love.keyboard.isDown('down') then
        self.entity:changeState('walk')
    end

    if love.keyboard.wasPressed('space') then
        self.entity:changeState('swing-sword')
    end

    if love.keyboard.wasPressed('f') then
        if self.dungeon.currentRoom:openChestInFrontOfPlayer() then
            return
        end
        self.entity:changeState('lift-pot')
    end

    if love.keyboard.wasPressed('e') then
        self.entity:throwBoomerang(self.dungeon.currentRoom)
    end
end