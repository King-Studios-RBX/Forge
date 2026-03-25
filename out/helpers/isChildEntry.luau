-- Compiled with roblox-ts v3.0.0
-- helpers/isChildEntry.ts
--[[
	*
	 * Type guard to check if a registry entry is a ChildEntry
	 
]]
local function isChildEntry(entry)
	local _condition = not not entry and not not entry.rules and entry.rules.parent ~= nil
	if _condition then
		local _parent = entry.rules.parent
		_condition = type(_parent) == "string"
	end
	return _condition
end
return {
	default = isChildEntry,
}
