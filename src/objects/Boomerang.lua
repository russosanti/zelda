
-- Boomerang class

Boomerang = Class{__includes = GameObject}

function Boomerang:init(player)
    GameObject.init(self, GAME_OBJECT_DEFS['boomerang'], player.x, player.y)

     -- set boomerang to be a projectile

    self.player = player
    self.active = false
    self.isProjectile = false
    self.returning = false
    self.canDamage = false
    self.rotation = 0
end

function Boomerang:fire(player)
    self.player = player
    self.x = player.x + player.width / 2 - self.width / 2
    self.y = player.y + player.height / 2 - self.height / 2

    if player.direction == 'left' then
        GameObject.fire(self, -BOOMERANG_SPEED, 0)
    elseif player.direction == 'right' then
        GameObject.fire(self, BOOMERANG_SPEED, 0)
    elseif player.direction == 'up' then
        GameObject.fire(self, 0, -BOOMERANG_SPEED)
    else
        GameObject.fire(self, 0, BOOMERANG_SPEED)
    end

    self.active = true
    self.returning = false
    self.canDamage = true
    self.rotation = 0
end

function Boomerang:update(dt)
    if self.active then
        self.rotation = self.rotation + BOOMERANG_ROTATION_SPEED * dt
        if self.returning then
            self:correctReturn(dt)
        else
            GameObject.update(self, dt)
        end
    end
end

function Boomerang:correctReturn(dt)
    local targetX = self.player.x + self.player.width / 2 - self.width / 2
    local targetY = self.player.y + self.player.height / 2 - self.height / 2
    local vx, vy = targetX - self.x, targetY - self.y
    local distance = math.sqrt(vx^2 + vy^2)

    if distance <= BOOMERANG_CATCH_DISTANCE then
        self:catch()
        return
    end

    self.x = self.x + vx / distance * BOOMERANG_SPEED * dt
    self.y = self.y + vy / distance * BOOMERANG_SPEED * dt
end

function Boomerang:returnToPlayer()
    self.returning = true
    self.canDamage = false
    self.dx, self.dy = 0, 0
end

function Boomerang:catch()
    self.active = false
    self.remove = true
    self.isProjectile = false
    self.returning = false
    self.canDamage = false
    self.dx, self.dy = 0, 0
end

function Boomerang:render(adjacentOffsetX, adjacentOffsetY)
    if self.active then
        local texture = gTextures[self.texture]
        love.graphics.draw(
            texture,
            self.x + adjacentOffsetX + self.width / 2,
            self.y + adjacentOffsetY + self.height / 2,
            self.rotation,
            self.scale,
            self.scale,
            texture:getWidth() / 2,
            texture:getHeight() / 2
        )
    end
end

function Boomerang:onProjectileFinished()
    self:returnToPlayer()
end

function Boomerang:onProjectileHitEntity()
    self.canDamage = false
    self:returnToPlayer()
end