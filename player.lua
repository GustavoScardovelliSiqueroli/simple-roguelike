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
	self.bullet_speed = 400
	self.bullet_size = 10

	self.bullet_time = 0
	self.atack_speed = 3
	self.atack_speed_base = 0.5
	self.damage = 10

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
	self:manage_timers(dt)
	self:update_movement(dt)
	self:update_bullets(dt)
end

function Player:draw()
	for i = #self.bullets, 1, -1 do
		local bullet = self.bullets[i]
		bullet:draw()
	end

	self.size_effect:preDraw()
	ScreenShake.preDraw()

	love.graphics.push("all")
	love.graphics.setColor(0, 0.4, 1, 1)
	love.graphics.rectangle("fill", self.x, self.y, self.size, self.size)
	love.graphics.pop()
	if self.taking_damage_time > 0 then
		love.graphics.push("all")
		love.graphics.setColor(1, 0, 0, 0.6)
		love.graphics.rectangle("fill", self.x, self.y, self.size, self.size)
		love.graphics.pop()
	end

	ScreenShake.postDraw()
	self.size_effect:postDraw()
end

function Player:take_damage(damage)
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

function Player:shoot(bullet_x, bullet_y)
	if self.bullet_time > 0 then
		return
	end
	local bullet_p_second = self.atack_speed_base * (self.atack_speed + 1)
	self.bullet_time = 1 / bullet_p_second

	local new_bullet = Bullet:new(self.x, self.y, bullet_x, bullet_y, self.bullet_speed, self.bullet_size, self.damage)
	table.insert(self.bullets, new_bullet)
end

function Player:manage_timers(dt)
	if self.taking_damage_time > 0 then
		self.taking_damage_time = self.taking_damage_time - dt
	end

	if self.ivulnerable_time > 0 then
		self.ivulnerable_time = self.ivulnerable_time - dt
	end

	if self.bullet_time > 0 then
		self.bullet_time = self.bullet_time - dt
	end
end

function Player:update_movement(dt)
	local dx, dy = KeyBoardEvents.get_movement_vector()
	self.x = self.x + dx * self.speed * dt
	self.y = self.y + dy * self.speed * dt

	self.x, self.y = Collision.satayInBounds(self.x, self.y, self.size, self.size)
end

function Player:update_bullets(dt)
	local bullet_x, bullet_y = KeyBoardEvents.get_direction_vector()
	if bullet_x ~= 0 or bullet_y ~= 0 then
		self:shoot(bullet_x, bullet_y)
	end

	for i = #self.bullets, 1, -1 do
		local bullet = self.bullets[i]
		bullet:update(dt)
	end
end

return Player
