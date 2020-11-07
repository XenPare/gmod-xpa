XPA = XPA or {}

XPA.Version = "4.0"
XPA.Build = "08/11/20"
XPA.Author = "crester"

AddCSLuaFile("xpa/lib/_include.lua")
if SERVER then
	include("xpa/lib/_include.lua")

	util.AddNetworkString("XPA Menu") -- xpa/cl_menu.lua
	util.AddNetworkString("XPA Ban Form") -- xpa/core/menus/cl_banform.lua
	util.AddNetworkString("XPA Ban List") -- xpa/core/menus/cl_banlist.lua
	util.AddNetworkString("XPA Restrictions List") -- xpa/core/menus/cl_restrictions.lua
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
