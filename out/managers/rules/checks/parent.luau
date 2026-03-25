-- Compiled with roblox-ts v3.0.0
local TS = _G[script]
-- Types
-- Packages
local batch = TS.import(script, TS.getModule(script, "@rbxts", "vide").src).batch
-- Helpers
local getAppSource = TS.import(script, script.Parent.Parent.Parent.Parent, "helpers", "getAppSource").default
local isChildEntry = TS.import(script, script.Parent.Parent.Parent.Parent, "helpers", "isChildEntry").default
local getAppEntry = TS.import(script, script.Parent.Parent.Parent.Parent, "helpers", "getAppEntry").default
-- Registries
local AppRegistry = TS.import(script, script.Parent.Parent.Parent.Parent, "registries", "apps").AppRegistry
local cache = {}
local cachedOnClose = {}
local closingParents = {}
local function ParentRule(forge, name, group)
	local entry = getAppEntry(name, group)
	if not entry then
		return nil
	end
	local isVisible = getAppSource(name, group)()
	local key = `{name}:{group}`
	if isChildEntry(entry) then
		local parentName = entry.rules.parent
		local _condition = entry.rules.parentGroup
		if _condition == nil then
			_condition = "None"
		end
		local parentGroup = _condition
		local parentKey = `{parentName}:{parentGroup}`
		local parentVisible = getAppSource(parentName, parentGroup)()
		if not parentVisible and not (closingParents[parentKey] ~= nil) then
			cache[key] = isVisible
		end
	else
		if not isVisible then
			if closingParents[key] ~= nil or cachedOnClose[key] ~= nil then
				return nil
			end
			cachedOnClose[key] = true
			-- ▼ ReadonlyMap.forEach ▼
			local _callback = function(entryMap)
				-- ▼ ReadonlyMap.forEach ▼
				local _callback_1 = function(childEntry, childGroup)
					if not isChildEntry(childEntry) then
						return nil
					end
					if childEntry.rules.parent ~= name then
						return nil
					end
					local _condition = childEntry.rules.parentGroup
					if _condition == nil then
						_condition = "None"
					end
					if _condition ~= group then
						return nil
					end
					local childKey = `{childEntry.name}:{childGroup}`
					local childVisible = getAppSource(childEntry.name, childGroup)()
					cache[childKey] = childVisible
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
			closingParents[key] = true
			batch(function()
				-- ▼ ReadonlyMap.forEach ▼
				local _callback_1 = function(entryMap)
					-- ▼ ReadonlyMap.forEach ▼
					local _callback_2 = function(childEntry, childGroup)
						if not isChildEntry(childEntry) then
							return nil
						end
						if childEntry.rules.parent ~= name then
							return nil
						end
						local _condition = childEntry.rules.parentGroup
						if _condition == nil then
							_condition = "None"
						end
						if _condition ~= group then
							return nil
						end
						forge:close(childEntry.name, childGroup)
					end
					for _k, _v in entryMap do
						_callback_2(_v, _k, entryMap)
					end
					-- ▲ ReadonlyMap.forEach ▲
				end
				for _k, _v in AppRegistry do
					_callback_1(_v, _k, AppRegistry)
				end
				-- ▲ ReadonlyMap.forEach ▲
			end)
			closingParents[key] = nil
		else
			cachedOnClose[key] = nil
			-- ▼ ReadonlyMap.forEach ▼
			local _callback = function(entryMap)
				-- ▼ ReadonlyMap.forEach ▼
				local _callback_1 = function(childEntry, childGroup)
					if not isChildEntry(childEntry) then
						return nil
					end
					if childEntry.rules.parent ~= name then
						return nil
					end
					local _condition = childEntry.rules.parentGroup
					if _condition == nil then
						_condition = "None"
					end
					if _condition ~= group then
						return nil
					end
					local childKey = `{childEntry.name}:{childGroup}`
					local cached = cache[childKey]
					local _forge = forge
					local _exp = childEntry.name
					local _exp_1 = childGroup
					local _condition_1 = cached
					if _condition_1 == nil then
						_condition_1 = false
					end
					_forge:set(_exp, _exp_1, _condition_1)
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
	end
end
return {
	default = ParentRule,
}
