-- Compiled with roblox-ts v3.0.0
local TS = _G[script]
-- Packages
local AppForge = TS.import(script, script.Parent, "forge").AppForge
local Vide = TS.import(script, TS.getModule(script, "@rbxts", "vide").src)
local Logger = TS.import(script, script.Parent, "logger").default
-- Types
local function Story(_param)
	local debug = _param.debug
	local props = _param.props
	local target = _param.target
	local render = _param.render
	local callback = _param.callback
	if debug then
		Logger.setDebug(true)
	end
	local forge = AppForge.new()
	local rendered = Vide.jsx(forge.story, {
		props = props,
		target = target,
		renders = render,
	})
	if callback then
		callback(props, forge)
	end
	return rendered
end
return {
	default = Story,
}
