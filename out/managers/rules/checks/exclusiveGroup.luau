-- Compiled with roblox-ts v3.0.0
local TS = _G[script]
-- Types
-- Helpers
local getAppEntry = TS.import(script, script.Parent.Parent.Parent.Parent, "helpers", "getAppEntry").default
local getAppSource = TS.import(script, script.Parent.Parent.Parent.Parent, "helpers", "getAppSource").default
local hasAppSource = TS.import(script, script.Parent.Parent.Parent.Parent, "helpers", "hasAppSource").default
-- Registries
local AppRegistry = TS.import(script, script.Parent.Parent.Parent.Parent, "registries", "apps").AppRegistry
--[[
	*
	 * ExclusiveGroupRule
	 *
	 * When an app with an `exclusiveGroup` becomes visible, all other apps
	 * sharing the same `exclusiveGroup` value are automatically closed.
	 * This ensures only one app in the group is visible at a time.
	 
]]
local function ExclusiveGroupRule(forge, name, group)
	local entry = getAppEntry(name, group)
	if not entry then
		return nil
	end
	local _myExclusiveGroup = entry.rules
	if _myExclusiveGroup ~= nil then
		_myExclusiveGroup = _myExclusiveGroup.exclusiveGroup
	end
	local myExclusiveGroup = _myExclusiveGroup
	if not (myExclusiveGroup ~= "" and myExclusiveGroup) then
		return nil
	end
	if not hasAppSource(name, group) then
		return nil
	end
	local isVisible = getAppSource(name, group)()
	if not isVisible then
		return nil
	end
	-- Close all other apps in the same exclusiveGroup
	-- ▼ ReadonlyMap.forEach ▼
	local _callback = function(entryMap, entryName)
		-- ▼ ReadonlyMap.forEach ▼
		local _callback_1 = function(otherEntry, entryGroup)
			-- Skip self
			if entryName == name and entryGroup == group then
				return nil
			end
			-- Skip entries without matching exclusiveGroup
			local _result = otherEntry.rules
			if _result ~= nil then
				_result = _result.exclusiveGroup
			end
			if _result ~= myExclusiveGroup then
				return nil
			end
			-- Skip entries without a source
			if not hasAppSource(entryName, entryGroup) then
				return nil
			end
			-- Skip already hidden entries
			local visible = getAppSource(entryName, entryGroup)()
			if not visible then
				return nil
			end
			forge:close(entryName, entryGroup)
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
return {
	default = ExclusiveGroupRule,
}
