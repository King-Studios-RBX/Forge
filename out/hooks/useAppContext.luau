-- Compiled with roblox-ts v3.0.0
local TS = _G[script]
-- Contexts
local AppContext = TS.import(script, script.Parent.Parent, "contexts").AppContext
local function useForgeContext()
	local ctx = AppContext()
	if not ctx then
		error(`Failed to retrieve App Forge Context Data for Context\n{debug.traceback()}`, 2)
	end
	return ctx
end
return {
	default = useForgeContext,
}
