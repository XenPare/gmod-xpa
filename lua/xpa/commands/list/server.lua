return "Server", "*", {
	["rcon"] = {
		name = "RCON",
		icon = "icon16/server.png",
		--visible = true, -- pretty buggy
		self = true,
		string = true,
		immunity = 99999999,
		func = function(pl, args)
			RunConsoleCommand(unpack(args))
		end
	},

	["map"] = {
		name = "Change map",
		icon = "icon16/map.png",
		visible = true,
		self = true,
		string = true,
		immunity = 10000,
		func = function(pl, args)
			RunConsoleCommand("changelevel", args[1] or "gm_flatgrass")
		end
	},

	["maplist"] = {
		name = "Map list",
		icon = "icon16/layout.png",
		visible = true,
		self = true,
		init = function()
			XPA.MapList = XPA.MapList or {}
			local maps = file.Find("maps/*", "GAME")
			for _, map in pairs(maps) do
				if string.find(map, ".bsp") then
					table.insert(XPA.MapList, string.StripExtension(map))
				end
			end
		end,
		func = function(pl)
			pl:ChatPrint("Check your console for the info")
			pl:SendLua("print('Available maps:')")
			for _, map in pairs(XPA.MapList) do
				pl:SendLua("print('     " .. map .. "')")
			end
		end
	},

	["teamlist"] = {
		name = "Team list",
		icon = "icon16/folder_database.png",
		visible = true,
		self = true,
		func = function(pl)
			pl:ChatPrint("Check your console for the info")
			pl:SendLua("print('Available teams:')")
			for index, data in pairs(team.GetAllTeams()) do
				pl:SendLua("print('     [" .. index .. "]: " .. data.Name .. "')")
			end
		end
	},
}, false