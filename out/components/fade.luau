-- Compiled with roblox-ts v3.0.0
local TS = _G[script]
local _vide = TS.import(script, TS.getModule(script, "@rbxts", "vide").src)
local Vide = _vide
local read = _vide.read
local source = _vide.source
local function FadeComponent(props)
	local frameRef = source()
	local canvasGroupRef = source()
	local transitioning = function()
		local color = read(props.groupColor) or Color3.new(1, 1, 1)
		local _condition = read(props.groupTransparency)
		if _condition == nil then
			_condition = 0
		end
		local transparency = _condition
		return transparency > 0.01 or color ~= Color3.new(1, 1, 1)
	end
	Vide.jsx("frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 1, 0),
		Parent = function()
			return if transitioning() then canvasGroupRef() else frameRef()
		end,
	}, props.children)
	local _attributes = {}
	local _condition = props.name
	if _condition == nil then
		_condition = "Transition"
	end
	_attributes.Name = _condition
	_attributes.BackgroundTransparency = 1
	_attributes.AnchorPoint = props.anchor
	_attributes.Size = props.size or UDim2.new(1, 0, 1, 0)
	_attributes.Position = props.position
	_attributes.Rotation = props.rotation
	_attributes.LayoutOrder = props.layoutOrder
	_attributes.ZIndex = props.zIndex
	_attributes.Parent = props.parent
	local _attribute = props.events
	if _attribute then
		for _k, _v in _attribute do
			_attributes[_k] = _v
		end
	end
	local _result = props.before
	if _result ~= nil then
		_result = _result()
	end
	local _exp = Vide.jsx("canvasgroup", {
		action = canvasGroupRef,
		GroupTransparency = props.groupTransparency,
		GroupColor3 = props.groupColor,
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 1, 0),
	}, _result)
	local _result_1 = props.before
	if _result_1 ~= nil then
		_result_1 = _result_1()
	end
	return Vide.jsx("frame", _attributes, _exp, Vide.jsx("frame", {
		action = frameRef,
		ClipsDescendants = true,
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 1, 0),
	}, _result_1))
end
return {
	default = FadeComponent,
}
