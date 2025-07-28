local collisions = {}

function collisions.satayInBounds(x, y, width, height)
	local w_width, w_height = love.graphics.getDimensions()
	if x < 0 then
		x = 0
	end
	if x + width > w_width then
		x = w_width - width
	end

	if y < 0 then
		y = 0
	end
	if y + height > w_height then
		y = w_height - height
	end

	return x, y
end

return collisions
