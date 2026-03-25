-- Compiled with roblox-ts v3.0.0
local TS = _G[script]
-- Packages
local _vide = TS.import(script, TS.getModule(script, "@rbxts", "vide").src)
local effect = _vide.effect
local untrack = _vide.untrack
-- Types
-- Rules
local ParentRule = TS.import(script, script, "checks", "parent").default
local ExclusiveGroupRule = TS.import(script, script, "checks", "exclusiveGroup").default
-- Components
local AppRegistry = TS.import(script, script.Parent.Parent, "registries", "apps").AppRegistry
-- Helpers
local hasAppSource = TS.import(script, script.Parent.Parent, "helpers", "hasAppSource").default
local getAppSource = TS.import(script, script.Parent.Parent, "helpers", "getAppSource").default
local Rules
do
	Rules = setmetatable({}, {
		__tostring = function()
			return "Rules"
		end,
	})
	Rules.__index = Rules
	function Rules.new(...)
		local self = setmetatable({}, Rules)
		return self:constructor(...) or self
	end
	function Rules:constructor()
		self.processing = {}
	end
	function Rules:setupRuleEffects(forge)
		-- ▼ ReadonlyMap.forEach ▼
		local _callback = function(entryMap, name)
			-- ▼ ReadonlyMap.forEach ▼
			local _callback_1 = function(_, group)
				if not hasAppSource(name, group) then
					return nil
				end
				effect(function()
					getAppSource(name, group)()
					untrack(function()
						return self:checkRules(forge, name, group)
					end)
				end)
			end
			for _k, _v in entryMap do
				_callback_1(_v, _k, entryMap)
			end
			-- ▲ ReadonlyMap.forEach ▲
		end
		for _k, _v in AppRegistry do
			_callback(_v, _k, AppRegistry)
		end
		-- ▲ ReadonlyMap.forEach ▲
	end
	function Rules:checkRules(forge, name, group)
		local key = `{name}:{group}`
		if self.processing[key] ~= nil then
			return nil
		end
		self.processing[key] = true
		TS.try(function()
			ParentRule(forge, name, group)
			ExclusiveGroupRule(forge, name, group)
		end, nil, function()
			self.processing[key] = nil
		end)
	end
end
return {
	default = Rules,
}
