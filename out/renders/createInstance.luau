-- Compiled with roblox-ts v3.0.0
local TS = _G[script]
-- Packages
local _vide = TS.import(script, TS.getModule(script, "@rbxts", "vide").src)
local Vide = _vide
local spring = _vide.spring
-- Types
-- Components
local FadeComponent = TS.import(script, script.Parent.Parent, "components", "fade").default
-- Helpers
local isChildAppRules = TS.import(script, script.Parent.Parent, "helpers", "isChildAppRules").default
local isChildEntry = TS.import(script, script.Parent.Parent, "helpers", "isChildEntry").default
local getAppSource = TS.import(script, script.Parent.Parent, "helpers", "getAppSource").default
local getAppEntry = TS.import(script, script.Parent.Parent, "helpers", "getAppEntry").default
-- Renders
local createAnchor = TS.import(script, script.Parent, "createAnchor").default
-- Logger
local Logger = TS.import(script, script.Parent.Parent, "logger").default
local function createInstance(props, name, group, childContainers, Loaded)
	local entry = getAppEntry(name, group)
	if not entry then
		return nil
	end
	local entryInstance
	local anchor
	local parentContainer
	if isChildEntry(entry) then
		-- Time the child app render
		entryInstance = Logger.time("Renders", `{group}:{name}`, function()
			return entry.constructor.new(entry, props):render()
		end)
		local _condition = entry.rules.parentGroup
		if _condition == nil then
			_condition = "None"
		end
		local parentGroup = _condition
		local _loaded = Loaded
		local _parent = entry.rules.parent
		local parentMap = _loaded[_parent]
		if parentMap then
			local parentEntry = parentMap[parentGroup]
			if parentEntry then
				parentContainer = parentEntry.container
			end
		end
		if entry.rules.anchor then
			anchor = createAnchor(entry, props, entryInstance, Loaded)
		end
	else
		-- Time the root app render
		entryInstance = Logger.time("Renders", `{group}:{name}`, function()
			return entry.constructor.new(entry, props):render()
		end)
	end
	entryInstance.Name = "Render"
	local _result
	if isChildAppRules(entry.rules) then
		local _condition = entry.zIndex
		if _condition == nil then
			_condition = 0
		end
		_result = _condition
	else
		local _condition = entry.zIndex
		if _condition == nil then
			_condition = 1
		end
		_result = _condition
	end
	local zIndex = _result
	local container
	if entry.fade then
		local source = getAppSource(name, group)
		local transparencySpring = spring(function()
			return if source() then 0 else 1
		end, entry.fade.period, entry.fade.dampeningRatio)
		container = (Vide.jsx(FadeComponent, {
			name = `{group}_{name}_Container`,
			groupTransparency = transparencySpring,
			visible = function()
				return transparencySpring() < 0.99
			end,
			anchor = Vector2.new(0.5, 0.5),
			position = UDim2.fromScale(0.5, 0.5),
			size = UDim2.fromScale(1, 1),
			parent = parentContainer,
			zIndex = zIndex,
		}, anchor or entryInstance, unpack(childContainers)))
	else
		container = (Vide.jsx("frame", {
			Name = `{group}_{name}_Container`,
			BackgroundTransparency = 1,
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5),
			Size = UDim2.fromScale(1, 1),
			Parent = parentContainer,
			ZIndex = zIndex,
		}, anchor or entryInstance, unpack(childContainers)))
	end
	local render = {
		container = container,
		instance = entryInstance,
		entry = entry,
		anchor = anchor,
	}
	local newMap = {}
	local _group = group
	newMap[_group] = render
	local _loaded = Loaded
	local _name = name
	_loaded[_name] = newMap
	return render
end
return {
	default = createInstance,
}
