local KeyBoardEvents = {}

function KeyBoardEvents.get_movement_vector()
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

function KeyBoardEvents.get_direction_vector()
	local x, y = 0, 0
	if love.keyboard.isDown("up") then
		y = -1
	end
	if love.keyboard.isDown("down") then
		y = 1
	end
	if love.keyboard.isDown("right") then
		x = 1
	end
	if love.keyboard.isDown("left") then
		x = -1
	end
	local magnitude = math.sqrt(x * x + y * y)
	if magnitude == 0 then
		return 0, 0
	end
	return x / magnitude, y / magnitude
end

return KeyBoardEvents
