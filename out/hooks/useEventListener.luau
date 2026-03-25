-- Compiled with roblox-ts v3.0.0
local TS = _G[script]
-- Packages
local cleanup = TS.import(script, TS.getModule(script, "@rbxts", "vide").src).cleanup
local connect = function(event, callback)
	local _event = event
	if typeof(_event) == "RBXScriptSignal" then
		local connection
		connection = event:Connect(function(...)
			local args = { ... }
			if connection.Connected then
				return callback(unpack(args))
			end
		end)
		return connection
	elseif event.Connect ~= nil then
		return event:Connect(callback)
	elseif event.connect ~= nil then
		return event:connect(callback)
	elseif event.subscribe ~= nil then
		return event:subscribe(callback)
	else
		error("Event-like object does not have a supported connect method.")
	end
end
local disconnect = function(connection)
	local _connection = connection
	if type(_connection) == "function" then
		connection()
	else
		local _connection_1 = connection
		local _condition = typeof(_connection_1) == "RBXScriptConnection"
		if not _condition then
			_condition = connection.Disconnect ~= nil
		end
		if _condition then
			connection:Disconnect()
		elseif connection.disconnect ~= nil then
			connection:disconnect()
		else
			error("Connection-like object does not have a supported disconnect method.")
		end
	end
end
--[[
	*
	 * Subscribes to an event-like object. The subscription is automatically
	 * disconnected when the scope cleans up.
	 *
	 * @param event The event-like object to subscribe to.
	 * @param listener The listener to subscribe with.
	 * @returns The connection object.
	 
]]
local function useEventListener(event, listener)
	local connection = connect(event, listener)
	cleanup(function()
		return disconnect(connection)
	end)
	return connection
end
return {
	default = useEventListener,
}
