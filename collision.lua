local Collision = {}

function Collision.satayInBounds(x, y, width, height)
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

function Collision.checkCollision(x1, y1, w1, h1, x2, y2, w2, h2)
	return x1 < x2 + w2 and x1 + w1 > x2 and y1 < y2 + h2 and y1 + h1 > y2
end

return Collision
