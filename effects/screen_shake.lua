local ScreenShake = { time = 0, duration = 0.5, magnitude = 5 }

function ScreenShake.trigger(duration, magnitude)
	ScreenShake.time = duration or ScreenShake.duration
	ScreenShake.magnitude = magnitude or ScreenShake.magnitude
end

function ScreenShake.update(dt)
	if ScreenShake.time > 0 then
		ScreenShake.time = ScreenShake.time - dt
	end
end

function ScreenShake.preDraw()
	if ScreenShake.time > 0 then
		local dx = math.random(-ScreenShake.magnitude, ScreenShake.magnitude)
		local dy = math.random(-ScreenShake.magnitude, ScreenShake.magnitude)
		love.graphics.push()
		love.graphics.translate(dx, dy)
	end
end

function ScreenShake.postDraw()
	if ScreenShake.time > 0 then
		love.graphics.pop()
	end
end

return ScreenShake
