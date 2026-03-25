-- Compiled with roblox-ts v3.0.0
local TS = _G[script]
-- Types
-- Dependencies
local AppRegistry = TS.import(script, script.Parent.Parent, "registries", "apps").AppRegistry
local function Fade(period, dampeningRatio)
	return function(ctor)
		local _object = {}
		local _left = "period"
		local _condition = period
		if _condition == nil then
			_condition = 0.5
		end
		_object[_left] = _condition
		local _left_1 = "dampeningRatio"
		local _condition_1 = dampeningRatio
		if _condition_1 == nil then
			_condition_1 = 0.75
		end
		_object[_left_1] = _condition_1
		ctor.__forge_fade = _object
		-- ▼ ReadonlyMap.forEach ▼
		local _callback = function(groupMap)
			-- ▼ ReadonlyMap.forEach ▼
			local _callback_1 = function(entry)
				if (entry.constructor) == ctor then
					entry.fade = ctor.__forge_fade
				end
			end
			for _k, _v in groupMap do
				_callback_1(_v, _k, groupMap)
			end
			-- ▲ ReadonlyMap.forEach ▲
		end
		for _k, _v in AppRegistry do
			_callback(_v, _k, AppRegistry)
		end
		-- ▲ ReadonlyMap.forEach ▲
		return ctor
	end
end
return {
	default = Fade,
}
