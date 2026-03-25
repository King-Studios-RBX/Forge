-- Compiled with roblox-ts v3.0.0
local TS = _G[script]
-- Components
local AppSources = TS.import(script, script.Parent.Parent, "registries", "apps").AppSources
local function getAppSource(name, group)
	if group == nil then
		group = "None"
	end
	local _name = name
	local sourceMap = AppSources[_name]
	local _source = sourceMap
	if _source ~= nil then
		local _group = group
		_source = _source[_group]
	end
	local source = _source
	if not source then
		error(`Failed to find source for name: {name} group: {group} \n {debug.traceback()}`)
	end
	return source
end
return {
	default = getAppSource,
}
