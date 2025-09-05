local Bullet = require("bullet")
local SizeEffect = require("effects.size_effect")

local RangedEnemy = {}
RangedEnemy.__index = RangedEnemy

function RangedEnemy:new(x, y, speed, size, health, damage, atack_speed, range)
	self = setmetatable({}, RangedEnemy)

	self.x = x
	self.y = y
	self.speed = speed
	self.size = size
	self.damage = damage
	self.health = health
	self.atack_speed = atack_speed
	self.range = range

	self.atack_speed_base = 0.5
	self.bullet_speed = 200
	self.bullet_size = 10
	self.bullet_time = 0

	self.take_damage_duration = 0.2
	self.take_damage_time = 0

	self.size_effect = SizeEffect:new(self)
	return self
end

function RangedEnemy:update(dt, distance, vx, vy)
	self:update_movement(dt, distance, vx, vy)

	if self.take_damage_time > 0 then
		self.take_damage_time = self.take_damage_time - dt
	end

	if self.bullet_time > 0 then
		self.bullet_time = self.bullet_time - dt
	end
end

function RangedEnemy:draw()
	self.size_effect:preDraw()
	love.graphics.rectangle("fill", self.x, self.y, self.size, self.size)
	love.graphics.printf(self.health, self.x, self.y - (self.size / 2) - 3, self.size, "center")

	if self.take_damage_time > 0 then
		love.graphics.push("all")
		love.graphics.setColor(255, 0, 0, 0.6)
		love.graphics.rectangle("fill", self.x, self.y, self.size, self.size)
		love.graphics.pop()
	end
	self.size_effect:postDraw()
end

function RangedEnemy:take_damage(damage)
	self.health = self.health - damage
	self.take_damage_time = self.take_damage_duration
	self.size_effect:trigger(self.take_damage_duration, 0.94)
	if self.health < 0 then
		self.health = 0
	end
end

function RangedEnemy:update_movement(dt, distance, vx, vy)
	if distance <= self.range then
		return
	end
	if distance > 0 then
		self.x = self.x + vx * self.speed * dt
		self.y = self.y + vy * self.speed * dt
	end
end

function RangedEnemy:shoot(bullet_x, bullet_y)
	if self.bullet_time > 0 then
		return
	end

	local bullet_p_second = self.atack_speed_base * (self.atack_speed + 1)
	self.bullet_time = 1 / bullet_p_second

	local new_bullet = Bullet:new(self.x, self.y, bullet_x, bullet_y, self.bullet_speed, self.bullet_size, self.damage)
	return new_bullet
end

return RangedEnemy
