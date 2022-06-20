XPA = XPA or {}

XPA.Version = "4.1"
XPA.Build = "20/06/22"
XPA.Author = "crester"

AddCSLuaFile("xpa/lib/_include.lua")
if SERVER then
	include("xpa/lib/_include.lua")

	util.AddNetworkString("XPA Menu") -- xpa/cl_menu.lua
	util.AddNetworkString("XPA Finder") -- xpa/core/menus/cl_finder.lua
else
	include("xpa/lib/_include.lua")
end

--[[
    Required
]]

XPA.IncludeCompounded("xpa")
XPA.IncludeCompounded("xpa/lib/*")
XPA.IncludeCompounded("xpa/core/*")
XPA.IncludeCompounded("xpa/commands")