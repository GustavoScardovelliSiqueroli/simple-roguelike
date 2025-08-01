local SizeEffect = {}
SizeEffect.__index = SizeEffect

function SizeEffect:new(obj)
	self = setmetatable({}, SizeEffect)

	self.obj = obj
	self.time = 0
	self.min_scale = 0.5
	self.duration = 0.5

	return self
end

function SizeEffect:update(dt)
	if self.time > 0 then
		self.time = self.time - dt
	end
end

function SizeEffect:trigger(duration, min_scale)
	self.min_scale = min_scale
	self.time = duration
	self.duration = duration
end

function SizeEffect:preDraw()
	if self.time > 0 then
		local t = 1 - (self.time / self.duration)
		local scale = 1 - (1 - self.min_scale) * math.sin(t * math.pi)
		love.graphics.push()
		love.graphics.translate(self.obj.x + (self.obj.size / 2), self.obj.y + (self.obj.size / 2))
		love.graphics.scale(scale, scale)
		love.graphics.translate(-(self.obj.x + (self.obj.size / 2)), -(self.obj.y + (self.obj.size / 2)))
	end
end

function SizeEffect:postDraw()
	if self.time > 0 then
		love.graphics.pop()
	end
end
return SizeEffect
