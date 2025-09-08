local WaveManager = {}
WaveManager.__index = WaveManager

function WaveManager:new()
	self = setmetatable({}, WaveManager)

	self.current_wave = 0
	self.enemies_spawned = 0
	self.enemies_to_spawn = 0
	self.enemies_killed = 0
	self.wave_active = false
	self.wave_complete = false
	self.between_waves = false

	self.spawn_timer = 0
	self.spawn_delay = 1.5
	self.wave_start_timer = 0
	self.wave_start_delay = 3

	self.base_enemies = 3
	self.enemies_per_wave = 2
	self.difficulty_multiplier = 1.0

	self.spawn_zones = {
		{ side = "top", y = -50 },
		{ side = "bottom", y = love.graphics.getHeight() + 50 },
		{ side = "left", x = -50 },
		{ side = "right", x = love.graphics.getWidth() + 50 },
	}

	self.enemy_types = {
		{ type = "melee", weight = 60, min_wave = 1 },
		{ type = "ranged", weight = 40, min_wave = 1 },
	}

	return self
end

function WaveManager:start_next_wave()
	self.current_wave = self.current_wave + 1
	self.wave_active = false
	self.wave_complete = false
	self.between_waves = true
	self.wave_start_timer = self.wave_start_delay

	self.enemies_to_spawn = self.base_enemies + (self.current_wave - 1) * self.enemies_per_wave
	self.enemies_spawned = 0
	self.enemies_killed = 0

	self.difficulty_multiplier = 1.0 + (self.current_wave - 1) * 0.15

	self.spawn_delay = math.max(0.5, 1.5 - (self.current_wave - 1) * 0.1)
end

function WaveManager:get_random_spawn_position()
	local zone = self.spawn_zones[math.random(#self.spawn_zones)]
	local x, y

	if zone.side == "top" or zone.side == "bottom" then
		x = math.random(50, love.graphics.getWidth() - 50)
		y = zone.y
	else
		x = zone.x
		y = math.random(50, love.graphics.getHeight() - 50)
	end

	return x, y
end

function WaveManager:select_enemy_type()
	local available_enemies = {}
	local total_weight = 0

	for _, enemy_data in ipairs(self.enemy_types) do
		if self.current_wave >= enemy_data.min_wave then
			table.insert(available_enemies, enemy_data)
			total_weight = total_weight + enemy_data.weight
		end
	end

	local random_value = math.random() * total_weight
	local current_weight = 0

	for _, enemy_data in ipairs(available_enemies) do
		current_weight = current_weight + enemy_data.weight
		if random_value <= current_weight then
			return enemy_data.type
		end
	end

	return available_enemies[1].type -- fallback
end

function WaveManager:create_enemy(enemy_type, x, y)
	local Enemy = require("enemies.melee_enemy")
	local RangedEnemy = require("enemies.ranged_enemy")

	local health = math.floor(50 * self.difficulty_multiplier)
	local speed = math.min(100, 50 * (1 + (self.difficulty_multiplier - 1) * 0.5))
	local damage = math.floor(15 * self.difficulty_multiplier)

	if enemy_type == "melee" then
		local size = 45
		return Enemy:new(x, y, speed, size, damage, health)
	elseif enemy_type == "ranged" then
		health = math.floor(health * 0.7)
		local size = 35
		local fire_rate = math.max(0.3, 0.5 - (self.current_wave - 1) * 0.02) -- ?
		local range = math.min(350, 200 + (self.current_wave - 1) * 10) -- ?
		return RangedEnemy:new(x, y, speed, size, health, damage, fire_rate, range)
	end
end

function WaveManager:update(dt, enemies)
	if self.between_waves then
		self.wave_start_timer = self.wave_start_timer - dt
		if self.wave_start_timer <= 0 then
			self.between_waves = false
			self.wave_active = true
			self.spawn_timer = 0
		end
		return
	end

	if self.wave_active then
		if self.enemies_spawned >= self.enemies_to_spawn and #enemies == 0 then
			self.wave_complete = true
			self.wave_active = false
			return "wave_complete"
		end

		if self.enemies_spawned < self.enemies_to_spawn then
			self.spawn_timer = self.spawn_timer - dt
			if self.spawn_timer <= 0 then
				local enemy_type = self:select_enemy_type()
				local x, y = self:get_random_spawn_position()
				local new_enemy = self:create_enemy(enemy_type, x, y)

				self.enemies_spawned = self.enemies_spawned + 1
				self.spawn_timer = self.spawn_delay

				return "spawn_enemy", new_enemy
			end
		end
	end

	return
end

function WaveManager:enemy_killed()
	self.enemies_killed = self.enemies_killed + 1
end

function WaveManager:get_wave_info()
	return {
		wave = self.current_wave,
		enemies_remaining = self.enemies_to_spawn - self.enemies_killed,
		enemies_total = self.enemies_to_spawn,
		wave_active = self.wave_active,
		wave_complete = self.wave_complete,
		between_waves = self.between_waves,
		time_to_next_wave = self.between_waves and math.ceil(self.wave_start_timer) or 0,
	}
end

function WaveManager:draw_ui(font, w_width)
	local info = self:get_wave_info()

	love.graphics.push("all")
	love.graphics.setFont(font)
	love.graphics.setColor(1, 1, 1)

	love.graphics.printf("Wave: " .. info.wave, w_width / 2 - 50, 10, 100, "center")

	if info.wave_active then
		love.graphics.printf(
			"Enemies: " .. info.enemies_remaining .. "/" .. info.enemies_total,
			w_width / 2 - 75,
			30,
			150,
			"center"
		)
	elseif info.between_waves then
		love.graphics.printf("Next wave in: " .. info.time_to_next_wave, w_width / 2 - 100, 30, 200, "center")
	elseif info.wave_complete then
		love.graphics.printf("Wave Complete!", w_width / 2 - 75, 30, 150, "center")
	end
	love.graphics.pop()
end

return WaveManager
