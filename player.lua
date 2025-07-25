local Player = {}
Player.__index = Player

function Player:new(x, y)
	self = setmetatable({}, Player)
	self.x = x
	self.y = y
	self.velocity = 200
	return self
end

function Player:update(dt)
	if love.keyboard.isDown("w") and love.keyboard.isDown("d") then
		self.y = self.y - self.velocity * dt / 2
		self.x = self.x + self.velocity * dt / 2
		return
	end
	if love.keyboard.isDown("w") and love.keyboard.isDown("a") then
		self.y = self.y - self.velocity * dt / 2
		self.x = self.x - self.velocity * dt / 2
		return
	end
	if love.keyboard.isDown("s") and love.keyboard.isDown("d") then
		self.y = self.y + self.velocity * dt / 2
		self.x = self.x + self.velocity * dt / 2
		return
	end
	if love.keyboard.isDown("s") and love.keyboard.isDown("a") then
		self.y = self.y + self.velocity * dt / 2
		self.x = self.x - self.velocity * dt / 2
		return
	end
	if love.keyboard.isDown("w") then
		self.y = self.y - self.velocity * dt
	end
	if love.keyboard.isDown("s") then
		self.y = self.y + self.velocity * dt
	end
	if love.keyboard.isDown("a") then
		self.x = self.x - self.velocity * dt
	end
	if love.keyboard.isDown("d") then
		self.x = self.x + self.velocity * dt
	end
end

function Player:draw()
	love.graphics.rectangle("fill", self.x, self.y, 10, 10)
end

return Player
