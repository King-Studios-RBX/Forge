-- Compiled with roblox-ts v3.0.0
local PREFIX = "[Forge]"
local DEBUG = false
local Logger = {
	setDebug = function(enabled)
		DEBUG = enabled
	end,
	debug = function(context, message)
		if not DEBUG then
			return nil
		end
		print(`{PREFIX}[{context}]: {message}`)
	end,
	warn = function(context, message)
		warn(`{PREFIX}[{context}]: {message}`)
	end,
	error = function(context, message)
		error(`{PREFIX}[{context}]: {message}`, 2)
	end,
	time = function(context, name, fn)
		if not DEBUG then
			return fn()
		end
		local start = os.clock()
		local result = fn()
		local elapsed = os.clock() - start
		print(`{PREFIX}[{context}]: "{name}" rendered in {string.format("%.4f", elapsed)}s`)
		return result
	end,
}
local default = Logger
return {
	default = default,
}
