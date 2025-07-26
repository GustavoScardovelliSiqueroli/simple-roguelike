local Player = {}
Player.__index = Player

function Player:new(x, y)
	self = setmetatable({}, Player)
	self.x = x
	self.y = y
	self.speed = 200
	return self
end

function Player:update(dt)
	local ix, iy = make_movement_vector()
	self.x = self.x + ix * self.speed * dt
	self.y = self.y + iy * self.speed * dt
end

function Player:draw()
	love.graphics.rectangle("fill", self.x, self.y, 10, 10)
end

function make_movement_vector()
	local x = 0
	local y = 0
	if love.keyboard.isDown("a") then
		x = -1
	end
	if love.keyboard.isDown("d") then
		x = 1
	end
	if love.keyboard.isDown("w") then
		y = -1
	end
	if love.keyboard.isDown("s") then
		y = 1
	end
	local magnitude = math.sqrt(x ^ 2 + y ^ 2)
	if magnitude == 0 then
		return 0, 0
	end
	return x / magnitude, y / magnitude
end

return Player
