-- Compiled with roblox-ts v3.0.0
local TS = _G[script]
-- Contexts
local ChildAppContext = TS.import(script, script.Parent.Parent, "contexts").ChildAppContext
local function useChildAppContext()
	local ctx = ChildAppContext()
	if not ctx then
		error(`Failed to retrieve App Forge Context Data for Context\n{debug.traceback()}`, 2)
	end
	return ctx
end
return {
	default = useChildAppContext,
}
