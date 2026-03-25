-- Compiled with roblox-ts v3.0.0
local TS = _G[script]
-- Services
local Workspace = TS.import(script, TS.getModule(script, "@rbxts", "services")).Workspace
-- Packages
local source = TS.import(script, TS.getModule(script, "@rbxts", "vide").src).source
-- Helpers
local useEventListener = TS.import(script, script.Parent, "useEventListener").default
--* Default reference resolution for px calculations 
local BASE_RESOLUTION = source(Vector2.new(1920, 1080))
--* Minimum allowed scale to prevent unreadable UI 
local MIN_SCALE = source(0.5)
--* 0 = width-based, 1 = height-based 
local DOMINANT_AXIS = 0.5
local TARGET = source(Workspace.CurrentCamera)
local SCALE = source(1)
local INITIALIZED = false
local function callable(callback, object)
	return setmetatable(object, {
		__call = function(_, ...)
			local args = { ... }
			return callback(unpack(args))
		end,
	})
end
local screen = source(Vector2.new(0, 0))
local px = callable(function(value)
	return math.round(value * SCALE())
end, {
	scale = function(value)
		return value * SCALE()
	end,
	even = function(value)
		return math.round(value * SCALE() * 0.5) * 2
	end,
	floor = function(value)
		return math.floor(value * SCALE())
	end,
	ceil = function(value)
		return math.ceil(value * SCALE())
	end,
})
local function calculateScale()
	local target = TARGET()
	if not target then
		return screen(Vector2.new(0, 0))
	end
	if target:IsA("Camera") then
		screen(target.ViewportSize)
	elseif target:IsA("GuiObject") then
		screen(target.AbsoluteSize)
	end
	local size = if target:IsA("Camera") then target.ViewportSize elseif target:IsA("GuiObject") then target.AbsoluteSize else nil
	if not size then
		return nil
	end
	local res = BASE_RESOLUTION()
	if res.X <= 0 or res.Y <= 0 then
		return nil
	end
	local min = MIN_SCALE()
	local width = math.log(size.X / res.X, 2)
	local height = math.log(size.Y / res.Y, 2)
	local centered = width + (height - width) * DOMINANT_AXIS
	local scale = 2 ^ centered
	SCALE(math.max(scale, min))
end
--[[
	*
	 * Initializes global px scaling.
	 * Must be called exactly once.
	 
]]
local function usePx(target, baseResolution, minScale)
	if INITIALIZED then
		return warn("usePx() called more than once")
	end
	INITIALIZED = true
	if baseResolution then
		BASE_RESOLUTION(baseResolution)
	end
	if minScale ~= 0 and minScale == minScale and minScale then
		MIN_SCALE(minScale)
	end
	if target then
		TARGET(target)
	end
	local resolvedTarget = TARGET()
	if not resolvedTarget then
		return warn("usePx(): no valid target to observe")
	end
	local signal = if resolvedTarget:IsA("Camera") then resolvedTarget:GetPropertyChangedSignal("ViewportSize") else resolvedTarget:GetPropertyChangedSignal("AbsoluteSize")
	useEventListener(signal, calculateScale)
	calculateScale()
end
return {
	usePx = usePx,
	screen = screen,
	px = px,
}
