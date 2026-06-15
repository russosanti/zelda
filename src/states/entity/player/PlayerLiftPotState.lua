--[[
    CS50 2D
    Legend of Zelda

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

PlayerLiftPotState = Class{__includes = EntityWalkState}

function PlayerLiftPotState:init(player, dungeon)
    self.entity = player
    self.dungeon = dungeon
    self.entity.offsetY = 5
    self.entity.offsetX = 0
end

function PlayerLiftPotState:enter(params)
    self.pot = self:getPot()

    -- if no pot collided
    if not self.pot then
        self.entity:changeState('idle')
    end

    -- delete pot from room as it is now being carried by player
    for i = #self.dungeon.currentRoom.objects, 1, -1 do
        local object = self.dungeon.currentRoom.objects[i]
        if object == self.pot then
            table.remove(self.dungeon.currentRoom.objects, i)
            break
        end
    end

    self.entity:changeAnimation('pot-lift-' .. self.entity.direction)
    self.entity.currentAnimation:refresh()
end

function PlayerLiftPotState:update(dt)
    -- same as swing sword, animate once
    if self.entity.currentAnimation.timesPlayed > 0 then
        self.entity.currentAnimation.timesPlayed = 0
        self.entity:changeState('carry-pot-idle', {pot = self.pot})
    end
end

function PlayerLiftPotState:getPot()
    local potZone = self.entity:facingHitbox(6)

    for k, object in pairs(self.dungeon.currentRoom.objects) do
        if object.type == 'pot' and object:collides(potZone) then
            return object
        end
    end

    return nil
end