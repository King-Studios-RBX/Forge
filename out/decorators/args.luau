-- Compiled with roblox-ts v3.0.0
local TS = _G[script]
-- Packages
local source = TS.import(script, TS.getModule(script, "@rbxts", "vide").src).source
-- Types
-- Helpers
local getAppSource = TS.import(script, script.Parent.Parent, "helpers", "getAppSource").default
-- Hooks
local _usePx = TS.import(script, script.Parent.Parent, "hooks", "usePx")
local px = _usePx.px
local screen = _usePx.screen
local BaseArgs
do
	BaseArgs = {}
	function BaseArgs:constructor(entry, props)
		self.name = entry.name
		local _condition = entry.group
		if _condition == nil then
			_condition = "None"
		end
		self.group = _condition
		self.source = getAppSource(self.name, self.group)
		self.forge = props.forge
		local _object = table.clone(props.props)
		setmetatable(_object, nil)
		_object.screen = screen
		_object.px = px
		self.props = _object
	end
end
local Args
do
	local super = BaseArgs
	Args = setmetatable({}, {
		__tostring = function()
			return "Args"
		end,
		__index = super,
	})
	Args.__index = Args
	function Args:constructor(entry, props)
		super.constructor(self, entry, props)
	end
end
local ChildArgs
do
	local super = BaseArgs
	ChildArgs = setmetatable({}, {
		__tostring = function()
			return "ChildArgs"
		end,
		__index = super,
	})
	ChildArgs.__index = ChildArgs
	function ChildArgs:constructor(entry, props)
		super.constructor(self, entry, props)
		self.childrenSources = function()
			return { source(false) }
		end
		self.closeChildren = function() end
		local _result = entry.rules
		if _result ~= nil then
			_result = _result.parent
		end
		local _result_1 = entry.rules
		if _result_1 ~= nil then
			_result_1 = _result_1.parentGroup
		end
		self.parentSource = getAppSource(_result, _result_1)
	end
end
return {
	Args = Args,
	ChildArgs = ChildArgs,
}
