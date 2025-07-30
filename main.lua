local Player = require("player")
local ScreenShake = require("screen_shake")
local Enemy = require("enemy")

local enemy
local enemy_2
local player
local w_width, w_height = love.graphics.getDimensions()
local emoji_font
local text_font
local health_text
local player_size = 20

function love.load()
	emoji_font = love.graphics.newFont("statics/fonts/NotoEmoji-VariableFont_wght.ttf", 20)
	text_font = love.graphics.newFont("statics/fonts/PublicPixel-rv0pA.ttf", 12)

	enemy = Enemy:new(100, 100, 100, 50)
	enemy_2 = Enemy:new(120, 500, 100, 50)
	player = Player:new((w_width - player_size) / 2, (w_height - player_size) / 2, player_size)
end

function love.update(dt)
	player:update(dt)
	enemy:update(dt)
	health_text = string.format("%03d/%03d", player.health, player.maxHealth)
	ScreenShake.update(dt)
end

function love.draw()
	enemy_2:draw()
	enemy:draw()

	ScreenShake.preDraw()
	player:draw()
	love.graphics.setFont(text_font)
	love.graphics.setColor(1, 1, 1)
	love.graphics.printf(health_text, 40, 5, 90, "right")
	love.graphics.setFont(emoji_font)
	love.graphics.print("❤", 10, 2)
	love.graphics.setFont(text_font)
	ScreenShake.postDraw()

	love.graphics.printf("fps: " .. string.format("%02d", love.timer.getFPS()), w_width - 100, 5, 90, "right")
end

function love.keypressed(key)
	if key == "q" then
		love.event.quit()
	end
	if key == "e" then
		player:takeDamage(10)
	end
end
