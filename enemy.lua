local Enemy = {}
Enemy.__index = Enemy

function Enemy:new(x, y, speed, size, damage)
	self = setmetatable({}, Enemy)

	self.x = x
	self.y = y
	self.size = size
	self.speed = speed
	self.damage = damage

	return self
end

function Enemy:update(dt, player)
	-- d = delta, difference or distance
	-- v = normalized vector
	local dx = player.x + (player.size / 2) - self.x - (self.size / 2)
	local dy = player.y + (player.size / 2) - self.y - (self.size / 2)

	local distance = math.sqrt(dx * dx + dy * dy)

	if distance > 0 then
		local vx = dx / distance
		local vy = dy / distance

		self.x = self.x + vx * self.speed * dt
		self.y = self.y + vy * self.speed * dt
	end
end

function Enemy:draw()
	love.graphics.rectangle("fill", self.x, self.y, self.size, self.size)
end

return Enemy
