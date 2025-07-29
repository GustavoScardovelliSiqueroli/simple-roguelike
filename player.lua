local Collision = require("collision")
local ScreenShake = require("screen_shake")

local Player = {}
Player.__index = Player

local function get_movement_vector()
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
	local magnitude = math.sqrt(x * x + y * y)
	if magnitude == 0 then
		return 0, 0
	end
	return x / magnitude, y / magnitude
end

function Player:new(x, y, size)
	self = setmetatable({}, Player)

	self.health = 100
	self.maxHealth = 100

	self.x = x
	self.y = y
	self.size = size
	self.speed = 200

	return self
end

function Player:update(dt)
	local ix, iy = get_movement_vector()
	self.x = self.x + ix * self.speed * dt
	self.y = self.y + iy * self.speed * dt

	self.x, self.y = Collision.satayInBounds(self.x, self.y, self.size, self.size)
end

function Player:draw()
	love.graphics.rectangle("fill", self.x, self.y, self.size, self.size)
end

function Player:takeDamage(damage)
	ScreenShake.trigger(0.3, 7)
	self.health = self.health - damage
	if self.health < 0 then
		self.health = 0
	end
end

return Player
