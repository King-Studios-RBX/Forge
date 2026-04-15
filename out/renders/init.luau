-- Compiled with roblox-ts v3.0.0
local TS = _G[script]
-- Services
local Workspace = TS.import(script, TS.getModule(script, "@rbxts", "services")).Workspace
-- Types
-- Components
local AppRegistry = TS.import(script, script.Parent, "registries", "apps").AppRegistry
-- Hooks
local usePx = TS.import(script, script.Parent, "hooks", "usePx").usePx
-- Classes
local Rules = TS.import(script, script.Parent, "managers", "rules").default
-- Helpers
local isChildAppRules = TS.import(script, script.Parent, "helpers", "isChildAppRules").default
local isChildEntry = TS.import(script, script.Parent, "helpers", "isChildEntry").default
local getAppEntry = TS.import(script, script.Parent, "helpers", "getAppEntry").default
local hasAppSource = TS.import(script, script.Parent, "helpers", "hasAppSource").default
local setAppSource = TS.import(script, script.Parent, "helpers", "setAppSource").default
-- Renders
local createInstance = TS.import(script, script, "createInstance").default
-- Logger
local Logger = TS.import(script, script.Parent, "logger").default
local Renders
do
	local super = Rules
	Renders = setmetatable({}, {
		__tostring = function()
			return "Renders"
		end,
		__index = super,
	})
	Renders.__index = Renders
	function Renders.new(...)
		local self = setmetatable({}, Renders)
		return self:constructor(...) or self
	end
	function Renders:constructor()
		super.constructor(self)
		self.Loaded = {}
		self.__initalize = false
	end
	function Renders:Initialize(props)
		if not self.__initalize then
			local _result = props.config
			if _result ~= nil then
				_result = _result.px
				if _result ~= nil then
					_result = _result.target
				end
			end
			local _condition = _result
			if not _condition then
				_condition = Workspace.CurrentCamera
			end
			local _result_1 = props.config
			if _result_1 ~= nil then
				_result_1 = _result_1.px
				if _result_1 ~= nil then
					_result_1 = _result_1.resolution
				end
			end
			local _result_2 = props.config
			if _result_2 ~= nil then
				_result_2 = _result_2.px
				if _result_2 ~= nil then
					_result_2 = _result_2.minScale
				end
			end
			usePx(_condition, _result_1, _result_2)
			self.__initalize = true
		end
		return self:Load(props)
	end
	function Renders:Load(props)
		local renders = props.renders
		local _result = renders
		if _result ~= nil then
			_result = _result.name
		end
		local _result_1
		if _result ~= nil then
			_result_1 = {
				[renders.name] = true,
			}
		else
			local _result_2 = renders
			if _result_2 ~= nil then
				_result_2 = _result_2.names
			end
			local _result_3
			if _result_2 ~= nil then
				local _set = {}
				for _, _v in renders.names do
					_set[_v] = true
				end
				_result_3 = _set
			else
				_result_3 = nil
			end
			_result_1 = _result_3
		end
		local names = _result_1
		local _result_2 = renders
		if _result_2 ~= nil then
			_result_2 = _result_2.group
		end
		local _result_3
		if _result_2 ~= nil then
			_result_3 = {
				[renders.group] = true,
			}
		else
			local _result_4 = renders
			if _result_4 ~= nil then
				_result_4 = _result_4.groups
			end
			local _result_5
			if _result_4 ~= nil then
				local _set = {}
				for _, _v in renders.groups do
					_set[_v] = true
				end
				_result_5 = _set
			else
				_result_5 = nil
			end
			_result_3 = _result_5
		end
		local groups = _result_3
		local load = {}
		local rendered = {}
		-- Time the entire load pass
		local start = os.clock()
		local renderEntry
		renderEntry = function(name, group)
			local key = `{name}:{group}`
			if rendered[key] ~= nil then
				return nil
			end
			rendered[key] = true
			-- Create source for this app if it doesn't exist yet
			if not hasAppSource(name, group) then
				local entry = getAppEntry(name, group)
				local _exp = name
				local _exp_1 = group
				local _condition = entry.visible
				if _condition == nil then
					_condition = false
				end
				setAppSource(_exp, _exp_1, _condition)
			end
			-- Collect all direct child containers before building this container
			local childContainers = {}
			-- ▼ ReadonlyMap.forEach ▼
			local _callback = function(groupEntries)
				-- ▼ ReadonlyMap.forEach ▼
				local _callback_1 = function(childEntry, childGroup)
					if not isChildEntry(childEntry) then
						return nil
					end
					if childEntry.rules.detached then
						return nil
					end
					if childEntry.rules.parent ~= name then
						return nil
					end
					local _condition = childEntry.rules.parentGroup
					if _condition == nil then
						_condition = "None"
					end
					local childParentGroup = _condition
					if childParentGroup ~= group then
						return nil
					end
					local childContainer = renderEntry(childEntry.name, childGroup)
					if childContainer then
						table.insert(childContainers, childContainer)
					end
				end
				for _k, _v in groupEntries do
					_callback_1(_v, _k, groupEntries)
				end
				-- ▲ ReadonlyMap.forEach ▲
			end
			for _k, _v in AppRegistry do
				_callback(_v, _k, AppRegistry)
			end
			-- ▲ ReadonlyMap.forEach ▲
			local render = createInstance(props, name, group, childContainers, self.Loaded)
			if not render then
				return nil
			end
			local _rules = getAppEntry(name, group)
			if _rules ~= nil then
				_rules = _rules.rules
			end
			local rules = _rules
			if not isChildAppRules(rules) or rules.detached then
				local _container = render.container
				table.insert(load, _container)
			end
			return render.container
		end
		-- ▼ ReadonlyMap.forEach ▼
		local _callback = function(groupEntries, appName)
			-- ▼ ReadonlyMap.forEach ▼
			local _callback_1 = function(entry, group)
				if isChildEntry(entry) and not entry.rules.detached then
					return nil
				end
				local _condition = names
				if _condition then
					local _appName = appName
					_condition = not (names[_appName] ~= nil)
				end
				if _condition then
					return nil
				end
				local _condition_1 = groups
				if _condition_1 then
					local _group = group
					_condition_1 = not (groups[_group] ~= nil)
				end
				if _condition_1 then
					return nil
				end
				renderEntry(appName, group)
			end
			for _k, _v in groupEntries do
				_callback_1(_v, _k, groupEntries)
			end
			-- ▲ ReadonlyMap.forEach ▲
		end
		for _k, _v in AppRegistry do
			_callback(_v, _k, AppRegistry)
		end
		-- ▲ ReadonlyMap.forEach ▲
		local elapsed = os.clock() - start
		local _exp = string.format("%.4f", elapsed)
		-- ▼ ReadonlySet.size ▼
		local _size = 0
		for _ in rendered do
			_size += 1
		end
		-- ▲ ReadonlySet.size ▲
		Logger.debug("Renders", `Load completed in {_exp}s — {_size} app(s) rendered`)
		return load
	end
end
return {
	default = Renders,
}
