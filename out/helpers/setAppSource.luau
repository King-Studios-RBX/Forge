-- Compiled with roblox-ts v3.0.0
local TS = _G[script]
-- Packages
local source = TS.import(script, TS.getModule(script, "@rbxts", "vide").src).source
-- Components
local AppSources = TS.import(script, script.Parent.Parent, "registries", "apps").AppSources
local function setAppSource(name, group, value)
	local _name = name
	if not AppSources[_name] then
		local _name_1 = name
		AppSources[_name_1] = {}
	end
	local _name_1 = name
	local _src = AppSources[_name_1]
	if _src ~= nil then
		local _group = group
		_src = _src[_group]
	end
	local src = _src
	if not src then
		local newSource = source(value)
		local _name_2 = name
		local _result = AppSources[_name_2]
		if _result ~= nil then
			local _group = group
			_result[_group] = newSource
		end
	else
		src(false)
	end
end
return {
	default = setAppSource,
}
