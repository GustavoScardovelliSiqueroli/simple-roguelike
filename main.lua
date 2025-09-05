local Player = require("player")
local ScreenShake = require("effects.screen_shake")
local Enemy = require("enemies.melee_enemy")
local RangedEnemy = require("enemies.ranged_enemy")
local Collision = require("collision")

local enemies = {}
local player
local w_width, w_height = love.graphics.getDimensions()
local emoji_font
local text_font
local health_text
local player_size = 20

function love.load()
	emoji_font = love.graphics.newFont("statics/fonts/NotoEmoji-VariableFont_wght.ttf", 20)
	text_font = love.graphics.newFont("statics/fonts/PublicPixel-rv0pA.ttf", 12)

	local enemy = Enemy:new(100, 100, 100, 50, 10, 50)
	local ranged_enemy = RangedEnemy:new(400, 400, 100, 30, 20, 5, 0.5, 200)
	table.insert(enemies, enemy)
	table.insert(enemies, ranged_enemy)

	player = Player:new((w_width - player_size) / 2, (w_height - player_size) / 2, player_size)
end

function love.update(dt)
	player:update(dt)

	for ei = #enemies, 1, -1 do
		local enemy = enemies[ei]
		enemy:update(dt, player)
		if
			Collision.checkCollision(
				player.x,
				player.y,
				player_size,
				player_size,
				enemy.x,
				enemy.y,
				enemy.size,
				enemy.size
			)
		then
			player:take_damage(enemy.damage)
		end
	end

	for bi = #player.bullets, 1, -1 do
		local bullet = player.bullets[bi]
		for ei = #enemies, 1, -1 do
			local enemy = enemies[ei]
			if
				Collision.checkCollision(
					bullet.x,
					bullet.y,
					bullet.size,
					bullet.size,
					enemy.x,
					enemy.y,
					enemy.size,
					enemy.size
				)
			then
				table.remove(player.bullets, bi)
				enemy:take_damage(bullet.damage)
				if enemy.health == 0 then
					table.remove(enemies, ei)
				end
				break
			end
		end
	end

	for ei = #enemies, 1, -1 do
		local enemy = enemies[ei]
		if enemy.bullets then
			for ebi = #enemy.bullets, 1, -1 do
				local bullet = enemy.bullets[ebi]
				if
					Collision.checkCollision(
						bullet.x,
						bullet.y,
						bullet.size,
						bullet.size,
						player.x,
						player.y,
						player.size,
						player.size
					)
				then
					table.remove(enemy.bullets, ebi)
					player:take_damage(bullet.damage)
					break
				end
			end
		end
	end

	health_text = string.format("%03d/%03d", player.health, player.maxHealth)
	ScreenShake.update(dt)
end

function love.draw()
	for ei = #enemies, 1, -1 do
		local enemy = enemies[ei]
		enemy:draw()
	end

	player:draw()

	love.graphics.push()
	ScreenShake.preDraw()
	love.graphics.setFont(text_font)
	love.graphics.setColor(1, 1, 1)
	love.graphics.printf(health_text, 40, 5, 90, "right")
	love.graphics.setFont(emoji_font)
	love.graphics.print("❤", 10, 2)
	love.graphics.setFont(text_font)
	ScreenShake.postDraw()
	love.graphics.pop()

	love.graphics.printf("fps: " .. string.format("%02d", love.timer.getFPS()), w_width - 100, 5, 90, "right")
end

function love.keypressed(key)
	if key == "q" then
		love.event.quit()
	end
	-- if key == "e" then
	-- 	player:takeDamage(10)
	-- end
end
