local Map = {}
Map.__index = Map

function Map:new(tile_size, map_sheet)
	self = setmetatable({}, Map)

	self.map_sheet = map_sheet
	self.tile_size = tile_size

	return self
end

function Map:draw()
	for y = 1, #self.map_sheet do
		for x = 1, #self.map_sheet[y] do
			if self.map_sheet[y][x] == 1 then
				love.graphics.rectangle(
					"fill",
					(x - 1) * self.tile_size,
					(y - 1) * self.tile_size,
					self.tile_size,
					self.tile_size
				)
			end
		end
	end
end

return Map
