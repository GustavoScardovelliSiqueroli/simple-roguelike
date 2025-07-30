local Enemy = {}
Enemy.__index = Enemy

function Enemy:new(x, y, speed, size)
	self = setmetatable({}, Enemy)

	self.x = x
	self.y = y
	self.size = size
	self.speed = speed

	return self
end

function Enemy:update(dt) end

function Enemy:draw()
	love.graphics.rectangle("fill", self.x, self.y, self.size, self.size)
end

return Enemy
