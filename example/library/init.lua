local sysl 		= {}
local path 		= ...
local folder 	= (...):match("(.-)[^%.]+$")
sysl.frame		= require(folder .. "slog-frame"	)
sysl.icon		= require(folder .. "slog-icon"		)
sysl.pixel		= require(folder .. "slog-pixel"	)
sysl.text		= require(folder .. "slog-text"		)
return sysl
