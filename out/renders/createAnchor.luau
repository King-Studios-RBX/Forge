-- Compiled with roblox-ts v3.0.0
local TS = _G[script]
-- Packages
local apply = TS.import(script, TS.getModule(script, "@rbxts", "vide").src).apply
-- Types
-- Helpers
local getAppEntry = TS.import(script, script.Parent.Parent, "helpers", "getAppEntry").default
local function createAnchor(entry, props, entryInstance, Loaded)
	local parentName = entry.rules.parent
	local _condition = entry.rules.parentGroup
	if _condition == nil then
		_condition = "None"
	end
	local parentGroup = _condition
	local parentEntry = getAppEntry(parentName, parentGroup)
	local anchor = parentEntry.constructor.new(parentEntry, props):render()
	-- Clear Descendants
	local _exp = anchor:GetDescendants()
	-- ▼ ReadonlyArray.forEach ▼
	local _callback = function(instance)
		return instance:Destroy()
	end
	for _k, _v in _exp do
		_callback(_v, _k - 1, _exp)
	end
	-- ▲ ReadonlyArray.forEach ▲
	if not entryInstance then
		local _loaded = Loaded
		local _name = entry.name
		local _loaded_1 = _loaded[_name]
		if _loaded_1 ~= nil then
			local _condition_1 = entry.group
			if _condition_1 == nil then
				_condition_1 = "None"
			end
			_loaded_1 = _loaded_1[_condition_1]
		end
		local loaded = _loaded_1
		if loaded then
			entryInstance = loaded.instance
		else
			warn("Failed to get Instance for Anchor")
			return nil
		end
	end
	apply(anchor)({
		Name = "Anchor",
		BackgroundTransparency = 1,
		[0] = entryInstance,
	})
	return anchor
end
return {
	default = createAnchor,
}
