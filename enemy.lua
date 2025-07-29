local Enemy = {}
Enemy.__index = Enemy

function Enemy:new(x, y, speed)
	self = setmetatable({}, Enemy)

	self.x = x
	self.y = y
	self.speed = speed

	return self
end

return Enemy
