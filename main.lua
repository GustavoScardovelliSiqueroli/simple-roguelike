local Player = require("player")
local ScreenShake = require("effects.screen_shake")
local Enemy = require("enemies.melee_enemy")
local RangedEnemy = require("enemies.ranged_enemy")
local Collision = require("collision")

local enemies_bullets = {}
local enemies = {}
local player
local w_width, w_height = love.graphics.getDimensions()
local emoji_font
local text_font
local health_text
local player_size = 20
local paused = false
local lose = false

function love.load()
	emoji_font = love.graphics.newFont("statics/fonts/NotoEmoji-VariableFont_wght.ttf", 20)
	text_font = love.graphics.newFont("statics/fonts/PublicPixel-rv0pA.ttf", 12)

	local enemy = Enemy:new(100, 100, 100, 50, 40, 50)
	local enemy_2 = Enemy:new(800, 600, 100, 50, 40, 50)
	local ranged_enemy = RangedEnemy:new(400, 400, 100, 30, 20, 20, 0.5, 350)
	local ranged_enemy_2 = RangedEnemy:new(20, 600, 100, 30, 20, 20, 0.5, 350)
	local ranged_enemy_3 = RangedEnemy:new(200, -50, 100, 30, 20, 20, 0.5, 350)
	table.insert(enemies, enemy)
	table.insert(enemies, enemy_2)
	table.insert(enemies, ranged_enemy)
	table.insert(enemies, ranged_enemy_2)
	table.insert(enemies, ranged_enemy_3)

	player = Player:new((w_width - player_size) / 2, (w_height - player_size) / 2, player_size)
end

function love.update(dt)
	if paused then
		return
	end
	player:update(dt)

	for ei = #enemies, 1, -1 do
		local enemy = enemies[ei]
		local dx = player.x + (player.size / 2) - enemy.x - (enemy.size / 2)
		local dy = player.y + (player.size / 2) - enemy.y - (enemy.size / 2)
		local distance = math.sqrt(dx * dx + dy * dy)
		local vx = dx / distance
		local vy = dy / distance

		enemy:update(dt, distance, vx, vy)
		if enemy.shoot then
			if distance <= enemy.range and distance > 0 then
				local bullet = enemy:shoot(vx, vy)
				table.insert(enemies_bullets, bullet)
			end
		end

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

	for ebi = #enemies_bullets, 1, -1 do
		local bullet = enemies_bullets[ebi]
		if
			bullet.x > w_width + bullet.size
			or bullet.x < 0 - bullet.size
			or bullet.y < 0 - bullet.size
			or bullet.y > w_height + bullet.size
		then
			table.remove(enemies_bullets, ebi)
			break
		end
		bullet:update(dt)
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
			table.remove(enemies_bullets, ebi)
			player:take_damage(bullet.damage)
			if player.health <= 0 then
				lose = true
			end
			break
		end
	end

	health_text = string.format("%03d/%03d", player.health, player.maxHealth)
	ScreenShake.update(dt)
end

function love.draw()
	if lose then
		local text_font_big = love.graphics.newFont("statics/fonts/PublicPixel-rv0pA.ttf", 40)
		love.graphics.setFont(text_font_big)
		love.graphics.printf("PERDEU PLAYBOY", (w_width / 2) - 146.7, (w_height / 2) - 40, 293.4, "center")
		return
	end

	for ei = #enemies, 1, -1 do
		local enemy = enemies[ei]
		enemy:draw()
	end
	for i = #enemies_bullets, 1, -1 do
		local bullet = enemies_bullets[i]
		bullet:draw()
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
	if key == "e" then
		lose = true
		paused = not paused
	end
end
