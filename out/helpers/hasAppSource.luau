-- Compiled with roblox-ts v3.0.0
local TS = _G[script]
-- Components
local AppSources = TS.import(script, script.Parent.Parent, "registries", "apps").AppSources
local function hasAppSource(name, group)
	local _name = name
	local sourceMap = AppSources[_name]
	if not sourceMap then
		return false
	end
	local _source = sourceMap
	if _source ~= nil then
		local _group = group
		_source = _source[_group]
	end
	local source = _source
	if not source then
		return false
	end
	return true
end
return {
	default = hasAppSource,
}
