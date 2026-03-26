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
			-- Only cache if we don't already have a saved state from the parent's close pass.
			-- The parent's close flow (lines 44-48) captures the correct pre-close state.
			-- Without this guard, the child's deferred effect would overwrite with false.
			if not (cache[key] ~= nil) then
				cache[key] = isVisible
			end
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
					-- If no cached state exists (e.g. during initialization),
					-- keep the child's current visibility instead of defaulting to false
					if cached ~= nil then
						forge:set(childEntry.name, childGroup, cached)
						cache[childKey] = nil
					end
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
