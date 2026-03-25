-- Compiled with roblox-ts v3.0.0
local TS = _G[script]
local exports = {}
local _args = TS.import(script, script, "args")
exports.Args = _args.Args
exports.ChildArgs = _args.ChildArgs
exports.ChildApp = TS.import(script, script, "childApp").default
exports.Fade = TS.import(script, script, "fade").default
exports.App = TS.import(script, script, "app").default
return exports
