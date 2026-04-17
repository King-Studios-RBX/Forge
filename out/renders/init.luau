-- Compiled with roblox-ts v3.0.0
local TS = _G[script]
-- Services
local Workspace = TS.import(script, TS.getModule(script, "@rbxts", "services")).Workspace
-- Packages
local _vide = TS.import(script, TS.getModule(script, "@rbxts", "vide").src)
local show = _vide.show
local source = _vide.source
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
local getAppSource = TS.import(script, script.Parent, "helpers", "getAppSource").default
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
		local _result = props.config
		if _result ~= nil then
			_result = _result.render
			if _result ~= nil then
				_result = _result.mountWhenVisible
			end
		end
		local _condition = _result
		if _condition == nil then
			_condition = false
		end
		local mountWhenVisible = _condition
		local _result_1 = props.config
		if _result_1 ~= nil then
			_result_1 = _result_1.render
			if _result_1 ~= nil then
				_result_1 = _result_1.unmountOnHide
			end
		end
		local _condition_1 = _result_1
		if _condition_1 == nil then
			_condition_1 = true
		end
		local unmountOnHide = _condition_1
		local _result_2 = renders
		if _result_2 ~= nil then
			_result_2 = _result_2.name
		end
		local _result_3
		if _result_2 ~= nil then
			_result_3 = {
				[renders.name] = true,
			}
		else
			local _result_4 = renders
			if _result_4 ~= nil then
				_result_4 = _result_4.names
			end
			local _result_5
			if _result_4 ~= nil then
				local _set = {}
				for _, _v in renders.names do
					_set[_v] = true
				end
				_result_5 = _set
			else
				_result_5 = nil
			end
			_result_3 = _result_5
		end
		local names = _result_3
		local _result_4 = renders
		if _result_4 ~= nil then
			_result_4 = _result_4.group
		end
		local _result_5
		if _result_4 ~= nil then
			_result_5 = {
				[renders.group] = true,
			}
		else
			local _result_6 = renders
			if _result_6 ~= nil then
				_result_6 = _result_6.groups
			end
			local _result_7
			if _result_6 ~= nil then
				local _set = {}
				for _, _v in renders.groups do
					_set[_v] = true
				end
				_result_7 = _set
			else
				_result_7 = nil
			end
			_result_5 = _result_7
		end
		local groups = _result_5
		local load = {}
		local rendered = {}
		-- Time the entire load pass
		local start = os.clock()
		local removeLoadedRender = function(name, group, render)
			render.container:Destroy()
			local _loaded = self.Loaded
			local _name = name
			local entryMap = _loaded[_name]
			if not entryMap then
				return nil
			end
			local _group = group
			entryMap[_group] = nil
			-- ▼ ReadonlyMap.size ▼
			local _size = 0
			for _ in entryMap do
				_size += 1
			end
			-- ▲ ReadonlyMap.size ▲
			if _size == 0 then
				local _loaded_1 = self.Loaded
				local _name_1 = name
				_loaded_1[_name_1] = nil
			end
		end
		local renderEntry
		renderEntry = function(name, group)
			local key = `{name}:{group}`
			if rendered[key] ~= nil then
				return nil
			end
			rendered[key] = true
			local entry = getAppEntry(name, group)
			if not entry then
				return nil
			end
			local shouldPushToRoot = not isChildAppRules(entry.rules) or entry.rules.detached
			-- Create source for this app if it doesn't exist yet
			if not hasAppSource(name, group) then
				local _exp = name
				local _exp_1 = group
				local _condition_2 = entry.visible
				if _condition_2 == nil then
					_condition_2 = false
				end
				setAppSource(_exp, _exp_1, _condition_2)
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
					local _condition_2 = childEntry.rules.parentGroup
					if _condition_2 == nil then
						_condition_2 = "None"
					end
					local childParentGroup = _condition_2
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
			if not mountWhenVisible then
				local render = createInstance(props, name, group, childContainers, self.Loaded)
				if not render then
					return nil
				end
				if shouldPushToRoot then
					local _container = render.container
					table.insert(load, _container)
				end
				return render.container
			end
			local activeRender
			local node = if unmountOnHide then show(function()
				return getAppSource(name, group)()
			end, function()
				if not activeRender then
					activeRender = createInstance(props, name, group, childContainers, self.Loaded)
				end
				local _result_6 = activeRender
				if _result_6 ~= nil then
					_result_6 = _result_6.container
				end
				return _result_6
			end, function()
				if activeRender then
					removeLoadedRender(name, group, activeRender)
					activeRender = nil
				end
				return nil
			end) else (function()
				local keepMounted = source(false)
				return show(function()
					return getAppSource(name, group)() or keepMounted()
				end, function()
					if not activeRender then
						activeRender = createInstance(props, name, group, childContainers, self.Loaded)
					end
					if activeRender then
						keepMounted(true)
					end
					local _result_6 = activeRender
					if _result_6 ~= nil then
						_result_6 = _result_6.container
					end
					return _result_6
				end)
			end)()
			if shouldPushToRoot then
				table.insert(load, node)
			end
			return node
		end
		-- ▼ ReadonlyMap.forEach ▼
		local _callback = function(groupEntries, appName)
			-- ▼ ReadonlyMap.forEach ▼
			local _callback_1 = function(entry, group)
				if isChildEntry(entry) and not entry.rules.detached then
					return nil
				end
				local _condition_2 = names
				if _condition_2 then
					local _appName = appName
					_condition_2 = not (names[_appName] ~= nil)
				end
				if _condition_2 then
					return nil
				end
				local _condition_3 = groups
				if _condition_3 then
					local _group = group
					_condition_3 = not (groups[_group] ~= nil)
				end
				if _condition_3 then
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
		Logger.debug("Renders", `Load completed in {_exp}s — {_size} app node(s) prepared`)
		return load
	end
end
return {
	default = Renders,
}
