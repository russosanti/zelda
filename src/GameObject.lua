--[[
    CS50 2D
    Legend of Zelda

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

GameObject = Class{}

function GameObject:init(def, x, y)
    
    -- string identifying this object type
    self.type = def.type

    self.texture = def.texture
    self.frame = def.frame or 1

    -- whether it acts as an obstacle or not
    self.solid = def.solid

    self.defaultState = def.defaultState
    self.state = self.defaultState
    self.states = def.states

    -- dimensions
    self.x = x
    self.y = y
    self.width = def.width
    self.height = def.height
    self.scale = def.scale or 1

    self.consumable = def.consumable

    -- projectile fields
    self.isProjectile = false
    self.dx = 0
    self.dy = 0
    self.distanceTraveled = 0
    self.maxDistance = def.maxDistance or 0
    self.isBreaking = false
    self.remove = false

    -- default empty collision callback
    self.onCollide = function() end

    -- defaulty on consume callback
    self.onConsume = function(player) end
end

function GameObject:update(dt)
    if self.isBreaking then
        -- For destroying pots particle effect
        if self.psystem then
            self.psystem:update(dt)
        end
        return
    end

    if self.isProjectile then
        self:updateProjectile(dt)
    end
end

function GameObject:updateProjectile(dt)
    self.x = self.x + self.dx * dt
    self.y = self.y + self.dy * dt
    self.distanceTraveled = self.distanceTraveled + math.sqrt(self.dx^2 + self.dy^2) * dt

    -- IF crushed on wall or traveled max distance, remove from play
    if self:hittedWall() or self.distanceTraveled > self.maxDistance then
        self:onProjectileFinished()
    end
end

function GameObject:hittedWall()
    return self.x < MAP_RENDER_OFFSET_X + TILE_SIZE or
        self.x + self.width * self.scale > MAP_RENDER_OFFSET_X + VIRTUAL_WIDTH - TILE_SIZE * 2 or
        self.y < MAP_RENDER_OFFSET_Y + TILE_SIZE or
        self.y + self.height * self.scale > MAP_RENDER_OFFSET_Y + VIRTUAL_HEIGHT - TILE_SIZE
end

-- AABB collision for objects
function GameObject:collides(target)
    return not (self.x + self.width < target.x or self.x > target.x + target.width or
                self.y + self.height < target.y or self.y > target.y + target.height)
end

function GameObject:render(adjacentOffsetX, adjacentOffsetY)
    if self.isBreaking then
        love.graphics.draw(self.psystem,
            self.x + adjacentOffsetX + self.width / 2,
            self.y + adjacentOffsetY + self.height / 2)
        return
    end
    love.graphics.draw(gTextures[self.texture], gFrames[self.texture][self.states[self.state].frame or self.frame],
        self.x + adjacentOffsetX, self.y + adjacentOffsetY, 0, self.scale, self.scale)
end

-- Fire function
function GameObject:fire(dx, dy)
    self.isProjectile = true
    self.isBreaking = false
    self.solid = false
    self.dx = dx
    self.dy = dy
    self.distanceTraveled = 0
    self.remove = false
end

function GameObject:breaking()
    if not self.isBreaking then
        self.isBreaking = true
        self.isProjectile = false
        self.solid = false
        self.dx = 0
        self.dy = 0
    
        self.psystem = love.graphics.newParticleSystem(gTextures['particle'], 200)
        self.psystem:setParticleLifetime(0.4, 1.5)
        self.psystem:setSizes(0.45, 0.2)
        self.psystem:setSpeed(8, 28)
        self.psystem:setLinearAcceleration(-8, -12, 8, 12)
        self.psystem:setEmissionArea('uniform', 8, 8)
        self.psystem:setColors(1, 1, 1, 0.9, 1, 1, 1, 0)
        self.psystem:emit(80)

        Timer.after(1.5, function()
            self.remove = true
        end)
    end
end

function GameObject:onProjectileFinished()
    self:breaking()
end

function GameObject:onProjectileHitEntity()
    self:breaking()
end