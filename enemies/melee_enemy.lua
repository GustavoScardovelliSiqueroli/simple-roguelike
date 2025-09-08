local SizeEffect = require("effects.size_effect")

local Enemy = {}
Enemy.__index = Enemy

function Enemy:new(x, y, speed, size, damage, health)
	self = setmetatable({}, Enemy)

	self.x = x
	self.y = y
	self.size = size
	self.speed = speed
	self.damage = damage
	self.health = health

	self.take_damage_duration = 0.2
	self.take_damage_time = 0
	self.offset_angle = (math.random() - 0.5) * math.rad(30) -- até 30° para cada lado

	self.size_effect = SizeEffect:new(self)
	return self
end

function Enemy:update(dt, distance, vx, vy)
	self.size_effect:update(dt)

	if self.take_damage_time > 0 then
		self.take_damage_time = self.take_damage_time - dt
	end

	if distance > 0 then
		local cosA = math.cos(self.offset_angle)
		local sinA = math.sin(self.offset_angle)
		local angled_vx = vx * cosA - vy * sinA
		local angled_vy = vx * sinA + vy * cosA
		self.x = self.x + angled_vx * self.speed * dt
		self.y = self.y + angled_vy * self.speed * dt
	end
end

function Enemy:draw()
	self.size_effect:preDraw()
	love.graphics.rectangle("line", self.x, self.y, self.size, self.size)
	love.graphics.printf(self.health, self.x, self.y - (self.size / 2) - 3, self.size, "center")

	if self.take_damage_time > 0 then
		love.graphics.push("all")
		love.graphics.setColor(255, 0, 0, 0.6)
		love.graphics.rectangle("fill", self.x, self.y, self.size, self.size)
		love.graphics.pop()
	end
	self.size_effect:postDraw()
end

function Enemy:take_damage(damage)
	self.health = self.health - damage
	self.take_damage_time = self.take_damage_duration
	self.size_effect:trigger(self.take_damage_duration, 0.94)
	if self.health < 0 then
		self.health = 0
	end
end

return Enemy
