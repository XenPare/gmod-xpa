XPA = XPA or {}

XPA.Version = "4.1"
XPA.Build = "27/09/22"
XPA.Author = "crester"

AddCSLuaFile("xpa/lib/_include.lua")
if SERVER then
	include("xpa/lib/_include.lua")

	util.AddNetworkString("XPA Menu") -- xpa/cl_menu.lua
	util.AddNetworkString("XPA Finder") -- xpa/core/menus/cl_finder.lua
else
	CreateClientConVar("xpa_touchplayers", "1", true, true, "Enable/disable whether you can pick up players with physgun", 0, 1)

	include("xpa/lib/_include.lua")
end

--[[
    Required
]]

XPA.IncludeCompounded("xpa")
XPA.IncludeCompounded("xpa/lib/*")
XPA.IncludeCompounded("xpa/core/*")
XPA.IncludeCompounded("xpa/commands")