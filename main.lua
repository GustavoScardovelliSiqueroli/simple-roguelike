local Player = require("player")
local Map = require("map")

local player
local map

function love.load()
	player = Player:new(10, 10)
	map = Map:new(50)
end

function love.update(dt)
	player:update(dt)
end

function love.draw()
	player:draw()
	map:draw()
end

function love.keypressed(key)
	if key == "q" then
		love.event.quit()
	end
end
