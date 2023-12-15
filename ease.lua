--[[
	Ease.lua - is a moonloader library for obtaining a dynamic value using a 
	timeline method with the ability to smooth it with easing-functions.
	For example, it can be used when creating animations of UI elements

	Author: Cosmo

	VK: https://vk.com/id331638453
	TG: http://t.me/cosmo_way
	GitHub: https://github.com/c0sui
	Source: https://easings.net
]]

local Ease = {
	__version = 1.2,
	__author = "Cosmo"
}

Ease.linear = function(x)
	return x
end

Ease.inSine = function(x)
	return 1 - math.cos((x * math.pi) / 2)
end

Ease.outSine = function(x)
	return math.sin((x * math.pi) / 2)
end

Ease.inOutSine = function(x)
	return -(math.cos(math.pi * x) - 1) / 2
end

Ease.inQuad = function(x)
	return x^2
end

Ease.outQuad = function(x)
	return 1 - (1 - x) * (1 - x)
end

Ease.inOutQuad = function(x)
	return x < 0.5 and 2 * x^2 or 1 - (-2 * x + 2)^2 / 2
end

Ease.inCubic = function(x)
	return x^3
end

Ease.outCubic = function(x)
	return 1 - (1 - x)^3
end

Ease.inOutCubic = function(x)
	return x < 0.5 and 4 * x^3 or 1 - (-2 * x + 2)^3 / 2
end

Ease.inQuart = function(x)
	return x^4
end

Ease.outQuart = function(x)
	return 1 - (1 - x)^4
end

Ease.inOutQuart = function(x)
	return x < 0.5 and 8 * x^4 or 1 - (-2 * x + 2)^4 / 2
end

Ease.inQuint = function(x)
	return x^5
end

Ease.outQuint = function(x)
	return 1 - (1 - x)^5
end

Ease.inOutQuint = function(x)
	return x < 0.5 and 16 * x^5 or 1 - (-2 * x + 2)^5 / 2
end

Ease.inExpo = function(x)
	return x == 0 and 0 or 2^(10 * x - 10)
end

Ease.outExpo = function(x)
	return x == 1 and 1 or 1 - 2^(-10 * x)
end

Ease.inOutExpo = function(x)
	if x == 0 then
		return 0
	elseif x == 1 then
		return 1
	else
		return x < 0.5 and 2^(20 * x - 10) / 2 or (2 - 2^(-20 * x + 10)) / 2
	end
end

Ease.inCirc = function(x)
	return 1 - math.sqrt(1 - x^2)
end

Ease.outCirc = function(x)
	return math.sqrt(1 - (x - 1)^2)
end

Ease.inOutCirc = function(x)
	if x < 0.5 then
		return (1 - math.sqrt(1 - (2 * x)^2)) / 2
	else
		return (math.sqrt(1 - (-2 * x + 2)^2) + 1) / 2
	end
end

Ease.inBack = function(x)
	local c1 = 1.70158
	local c3 = c1 + 1
	return c3 * x^3 - c1 * x^2
end

Ease.outBack = function(x)
	local c1 = 1.70158
	local c3 = c1 + 1
	return 1 + c3 * (x - 1)^3 + c1 * (x - 1)^2
end

Ease.inOutBack = function(x)
	local c1 = 1.70158
	local c2 = c1 * 1.525

	if x < 0.5 then
		return ((2 * x)^2 * ((c2 + 1) * 2 * x - c2)) / 2
	else
		return ((2 * x - 2)^2 * ((c2 + 1) * (x * 2 - 2) + c2) + 2) / 2
	end
end

Ease.inElastic = function(x)
	local c4 = (2 * math.pi) / 3

	if x == 0 then
		return 0
	elseif x == 1 then
		return 1
	else
		return -2^(10 * x - 10) * math.sin((x * 10 - 10.75) * c4)
	end
end

Ease.outElastic = function(x)
	local c4 = (2 * math.pi) / 3

	if x == 0 then
		return 0
	elseif x == 1 then
		return 1
	else
		return 2^(-10 * x) * math.sin((x * 10 - 0.75) * c4) + 1
	end
end

Ease.inOutElastic = function(x)
	local c5 = (2 * math.pi) / 4.5

	if x == 0 then
		return 0
	elseif x == 1 then
		return 1
	elseif x < 0.5 then
		return -(2^(20 * x - 10) * math.sin((20 * x - 11.125) * c5)) / 2
	else
		return (2^(-20 * x + 10) * math.sin((20 * x - 11.125) * c5)) / 2 + 1
	end
end

Ease.inBounce = function(x)
	return 1 - Ease.outBounce(1 - x)
end

Ease.outBounce = function(x)
	local n1 = 7.5625
	local d1 = 2.75

	if x < 1 / d1 then
		return n1 * x * x
	elseif x < 2 / d1 then
		x = x - 1.5 / d1
		return n1 * x * x + 0.75
	elseif x < 2.5 / d1 then
		x = x - 2.25 / d1
		return n1 * x * x + 0.9375
	else
		x = x - 2.625 / d1
		return n1 * x * x + 0.984375
	end
end

Ease.inOutBounce = function(x)
	if x < 0.5 then
		return (1 - Ease.outBounce(1 - 2 * x)) / 2
	else
		return (1 + Ease.outBounce(2 * x - 1)) / 2
	end
end

function Ease:run(from, dest, start_time, duration, easing, callback)
	local efun = self[easing] or self.linear
	start_time = start_time or os.clock()

	if type(callback) == "function" then
		return self:createThread(from, dest, start_time, duration, efun, callback)
	else
		return self:calculate(from, dest, start_time, duration, efun)
	end
end

function Ease:createThread(from, dest, start_time, duration, efun, callback)
	return lua_thread.create(function()
		while true do
			local value, status = self:calculate(from, dest, start_time, duration, efun)
			callback(value, status)
			if status == 2 then
				break
			end
			wait(0)
		end
	end)
end

function Ease:calculate(from, dest, start_time, duration, efun)
	local timer = os.clock() - start_time
	if timer >= 0 and timer <= duration then
		local proc = 100 * efun(timer / duration)
		return from + ((dest - from) / 100 * proc), 1
	elseif timer > duration then
		return dest, 2
	else
		return from, 0
	end
end

setmetatable(Ease, {
	__call = Ease.run
})

return Ease