-- Compiled with roblox-ts v3.0.0
local TS = _G[script]
-- Components
local AppRegistry = TS.import(script, script.Parent.Parent, "registries", "apps").AppRegistry
local function getAppEntry(name, group)
	local _name = name
	local entryMap = AppRegistry[_name]
	local _entry = entryMap
	if _entry ~= nil then
		local _group = group
		_entry = _entry[_group]
	end
	local entry = _entry
	if not entry then
		error(`Failed to get entry for name {name} and group {group}`)
	end
	return entry
end
return {
	default = getAppEntry,
}
