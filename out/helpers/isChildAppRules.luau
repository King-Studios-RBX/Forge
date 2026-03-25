-- Compiled with roblox-ts v3.0.0
-- helpers/isChild.ts
--[[
	*
	 * Type guard to check if a rules object is a ChildApp (i.e., has a parent or is a child type)
	 
]]
local function isChildAppRules(rules)
	local _condition = rules ~= nil and rules.parent ~= nil
	if _condition then
		local _parent = rules.parent
		_condition = type(_parent) == "string"
	end
	return _condition
end
return {
	default = isChildAppRules,
}
