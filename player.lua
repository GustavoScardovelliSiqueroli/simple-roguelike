local Collision = require("collision")
local ScreenShake = require("effects.screen_shake")
local SizeEffect = require("effects.size_effect")
local KeyBoardEvents = require("keyboard_events")
local Bullet = require("bullet")

local Player = {}
Player.__index = Player

function Player:new(x, y, size)
	self = setmetatable({}, Player)

	self.health = 100
	self.maxHealth = 100

	self.bullets = {}

	self.x = x
	self.y = y
	self.size = size
	self.speed = 200
	self.taking_damage_time = 0
	self.taking_damage_duration = 0.3
	self.ivulnerable_time = 0

	self.size_effect = SizeEffect:new(self)
	return self
end

function Player:update(dt)
	self.size_effect:update(dt)

	if self.taking_damage_time > 0 then
		self.taking_damage_time = self.taking_damage_time - dt
	end

	if self.ivulnerable_time > 0 then
		self.ivulnerable_time = self.ivulnerable_time - dt
	end

	local dx, dy = KeyBoardEvents.get_movement_vector()
	self.x = self.x + dx * self.speed * dt
	self.y = self.y + dy * self.speed * dt

	self.x, self.y = Collision.satayInBounds(self.x, self.y, self.size, self.size)

	for i = #self.bullets, 1, -1 do
		local bullet = self.bullets[i]
		bullet:update(dt)
	end
end

function Player:draw()
	self.size_effect:preDraw()
	ScreenShake.preDraw()

	love.graphics.rectangle("fill", self.x, self.y, self.size, self.size)
	if self.taking_damage_time > 0 then
		love.graphics.setColor(255, 0, 0, 0.6)
		love.graphics.rectangle("fill", self.x, self.y, self.size, self.size)
	end

	self.size_effect:postDraw()
	ScreenShake.postDraw()
end

function Player:takeDamage(damage)
	if self.ivulnerable_time > 0 then
		return
	end
	self.ivulnerable_time = 0.5
	ScreenShake.trigger(0.3, 2)
	self.size_effect:trigger(0.3, 0.8)

	self.taking_damage_time = self.taking_damage_duration
	self.health = self.health - damage
	if self.health < 0 then
		self.health = 0
	end
end

return Player
