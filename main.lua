local Player = require("player")

local player

function love.load()
	player = Player:new(10, 10)
end

function love.update(dt)
	player:update(dt)
end

function love.draw()
	player:draw()
end

function love.keypressed(key)
	if key == "q" then
		love.event.quit()
	end
end
