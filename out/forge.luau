-- Compiled with roblox-ts v3.0.0
local TS = _G[script]
-- Packages
local _vide = TS.import(script, TS.getModule(script, "@rbxts", "vide").src)
local apply = _vide.apply
local create = _vide.create
local effect = _vide.effect
-- Types
-- Classes
local Renders = TS.import(script, script.Parent, "renders").default
-- Registries
local _apps = TS.import(script, script.Parent, "registries", "apps")
local AppDisplaySources = _apps.AppDisplaySources
local AppSources = _apps.AppSources
-- Helpers
local getAppSource = TS.import(script, script.Parent, "helpers", "getAppSource").default
local AppForge
do
	local super = Renders
	AppForge = setmetatable({}, {
		__tostring = function()
			return "AppForge"
		end,
		__index = super,
	})
	AppForge.__index = AppForge
	function AppForge.new(...)
		local self = setmetatable({}, AppForge)
		return self:constructor(...) or self
	end
	function AppForge:constructor()
		super.constructor(self)
		self.story = function(_param)
			local props = _param.props
			local target = _param.target
			local renders = _param.renders
			local config = _param.config
			local Container = create("Frame")({
				Name = "Story Container",
				BackgroundTransparency = 1,
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.fromScale(0.5, 0.5),
				Size = UDim2.fromScale(1, 1),
			})
			local _fn = apply(Container)
			local _object = {}
			local _left = 0
			local _self = self
			local _object_1 = {
				props = props,
				forge = self,
				renders = renders,
			}
			local _left_1 = "config"
			local _object_2 = {}
			local _left_2 = "px"
			local _object_3 = {
				target = target,
			}
			local _left_3 = "minScale"
			local _result = config
			if _result ~= nil then
				_result = _result.px
				if _result ~= nil then
					_result = _result.minScale
				end
			end
			_object_3[_left_3] = _result
			_object_2[_left_2] = _object_3
			_object_1[_left_1] = _object_2
			_object[_left] = _self:Initialize(_object_1)
			_fn(_object)
			self:setupRuleEffects(self)
			return Container
		end
		self.render = function(_param)
			local props = _param.props
			local _self = self
			local _object = table.clone(props)
			setmetatable(_object, nil)
			_object.forge = self
			local instances = _self:Initialize(_object)
			self:setupRuleEffects(self)
			return instances
		end
	end
	function AppForge:bind(name, group, value)
		if group == nil then
			group = "None"
		end
		local src = getAppSource(name, group)
		if not src then
			return nil
		end
		effect(function()
			src(value())
		end)
	end
	function AppForge:set(name, group, value)
		if group == nil then
			group = "None"
		end
		local src = getAppSource(name, group)
		if not src then
			return nil
		end
		local prev = src()
		if prev == value then
			return nil
		end
		src(value)
	end
	function AppForge:get(name, group)
		if group == nil then
			group = "None"
		end
		local _name = name
		local _source = AppSources[_name]
		if _source ~= nil then
			local _group = group
			_source = _source[_group]
		end
		local source = _source
		if not source then
			return nil
		end
		local _name_1 = name
		local _displaySource = AppDisplaySources[_name_1]
		if _displaySource ~= nil then
			local _group = group
			_displaySource = _displaySource[_group]
		end
		local displaySource = _displaySource
		if not displaySource then
			return source
		end
		return function(value)
			local _value = value
			if type(_value) == "boolean" then
				source(value)
				return value
			end
			return displaySource()
		end
	end
	function AppForge:open(name, group)
		if group == nil then
			group = "None"
		end
		self:set(name, group, true)
	end
	function AppForge:close(name, group)
		if group == nil then
			group = "None"
		end
		self:set(name, group, false)
	end
	function AppForge:toggle(name, group)
		if group == nil then
			group = "None"
		end
		local src = getAppSource(name, group)
		if not src then
			return nil
		end
		self:set(name, group, not src())
	end
end
return {
	AppForge = AppForge,
}
