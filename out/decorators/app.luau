-- Compiled with roblox-ts v3.0.0
local TS = _G[script]
-- Types
-- Dependencies
local AppRegistry = TS.import(script, script.Parent.Parent, "registries", "apps").AppRegistry
local function App(props)
	return function(constructor)
		local _condition = props.group
		if _condition == nil then
			_condition = "None"
		end
		local groupKey = _condition
		-- Ensure uniqueness
		local _name = props.name
		local _result = AppRegistry[_name]
		if _result ~= nil then
			_result = _result[groupKey] ~= nil
		end
		if _result then
			error(`Duplicate registered App name "{props.name}" in same Group "{groupKey}". ` .. `App names must be globally unique.`, 2)
		end
		local _value = props.name
		if not (_value ~= "" and _value) then
			error("App registration failed: missing app name", 2)
		end
		-- Initialize registry map if missing
		local _name_1 = props.name
		if not (AppRegistry[_name_1] ~= nil) then
			local _name_2 = props.name
			AppRegistry[_name_2] = {}
		end
		local fadeConfig = constructor.__forge_fade
		-- Register app
		local _name_2 = props.name
		local _exp = AppRegistry[_name_2]
		local _arg1 = {
			constructor = constructor,
			name = props.name,
			group = props.group,
			visible = props.visible,
			rules = props.rules,
			fade = fadeConfig,
		}
		_exp[groupKey] = _arg1
		return constructor
	end
end
return {
	default = App,
}
