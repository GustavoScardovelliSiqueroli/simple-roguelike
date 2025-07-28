local Player = require("player")
local basic_map = require("maps.basic_map_64x48")

local player
local map
local w_width, w_height = love.graphics.getDimensions()
local emoji_font
local text_font

function love.load()
	emoji_font = love.graphics.newFont("NotoEmoji-VariableFont_wght.ttf", 20)
	text_font = love.graphics.newFont("Minecraft.ttf", 20)

	player = Player:new(10, 10, 20)
end

function love.update(dt)
	player:update(dt)
end

function love.draw()
	player:draw()

	love.graphics.setFont(text_font)
	love.graphics.setColor(1, 1, 1)
	love.graphics.print(player.health .. " / " .. player.maxHealth, 40, 5)
	love.graphics.print("fps: " .. love.timer.getFPS(), w_width - 70, 5)

	love.graphics.setFont(emoji_font)
	love.graphics.print("❤", 10, 2)
end

function love.keypressed(key)
	if key == "q" then
		love.event.quit()
	end
end
