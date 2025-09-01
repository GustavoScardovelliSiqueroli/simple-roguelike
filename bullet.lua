local Bullet = {}
Bullet.__index = Bullet

function Bullet:new(x, y, dirx, diry, speed, size, damage)
	self = setmetatable({}, Bullet)
	self.x = x
	self.y = y
	self.dirx = dirx
	self.diry = diry
	self.speed = speed
	self.size = size
	self.damage = damage

	return self
end

function Bullet:update(dt)
	self.x = self.x + self.dirx * self.speed * dt
	self.y = self.y + self.diry * self.speed * dt
end

function Bullet:draw()
	love.graphics.rectangle("fill", self.x, self.y, self.size, self.size)
end

return Bullet
