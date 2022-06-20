local db = XPA.Config.Database
return "Server", "*", {
	--[[
		xpa setrank <steamid/name/userid> <rank>
	]]

	["setrank"] = {
		name = "Set rank",
		icon = "icon16/key.png",
		visible = true,
		string = true,
		immunity = 100000,
		autocompletion = function(arg)
			local t = string.Explode(" ", arg)
			local w = t[2]
			local tbl = {}
			for _, pl in pairs(player.GetAll()) do
				table.insert(tbl, "xpa " .. w .. ' "' .. pl:Name() .. '" "admin"')
			end
			return tbl
		end,
		func = function(pl, args)
			local id = ""
			local target = XPA.FindPlayer(args[1])
			local rank = tostring(args[2])
			if XPA.IsValidSteamID(args[1]) then
				id = args[1]
			elseif IsValid(target) then
				id = target:SteamID()
			end

			if rank == "user" then
				if IsValid(target) then
					target:SetUserGroup(rank)
				end

				if db == "firebase" then
					local cur_rank, cur_rank_pos = ""
					for name, data in pairs(XPA.Ranks) do 
						if not data.members then 
							continue
						end
						if table.HasValue(data.members, id) then
							cur_rank = name
							cur_rank_pos = table.KeyFromValue(data.members, id)
							break
						end
					end

					local _members = XPA.Ranks[cur_rank].members
					_members[cur_rank_pos] = nil

					XPA.DB.Write("xpa-ranks/" .. cur_rank, {
						members = table.ClearKeys(_members)
					})
				elseif db == "sqlite" or db == "mysqloo" then
					XPA.DB.AddMember(id, rank)
				end
			else
				if not XPA.Ranks[rank] then
					return
				end

				if IsValid(target) then
					target:SetUserGroup(rank)
				end

				if db == "firebase" then
					local _members = XPA.Ranks[rank].members
					_members[#_members + 1] = id
					XPA.DB.Write("xpa-ranks/" .. rank, {
						members = table.ClearKeys(_members)
					})
				elseif db == "sqlite" or db == "mysqloo" then
					XPA.DB.AddMember(id, rank)
				end
			end
		end
	},

	--[[
		xpa rcon <args>
	]]

	["rcon"] = {
		name = "RCON",
		icon = "icon16/server.png",
		--visible = true, -- pretty buggy
		self = true,
		string = true,
		immunity = 100000,
		func = function(pl, args)
			RunConsoleCommand(unpack(args))
		end
	},

	--[[
		xpa map <map>
	]]

	["map"] = {
		name = "Change map",
		icon = "icon16/map.png",
		visible = true,
		self = true,
		string = true,
		immunity = 10000,
		autocompletion = function(arg)
			local t = string.Explode(" ", arg)
			local w = t[2]
			local tbl = {}
			for _, map in ipairs(XPA.MapList) do
				table.insert(tbl, "xpa " .. w .. ' "' .. map .. '"')
			end
			return tbl
		end,
		func = function(pl, args)
			RunConsoleCommand("changelevel", args[1] or "gm_flatgrass")
		end
	},

	--[[
		xpa maplist
	]]

	["maplist"] = {
		name = "Map list",
		icon = "icon16/layout.png",
		visible = true,
		self = true,
		init = function()
			XPA.MapList = XPA.MapList or {}
			local maps = file.Find("maps/*", "GAME")
			for _, map in ipairs(maps) do
				local mname = string.Explode(".bsp", map)[1]
				if not map:find(".bsp") or table.HasValue(XPA.MapList, mname) then
					continue
				end
				table.insert(XPA.MapList, mname)
			end
		end,
		func = function(pl)
			pl:ChatPrint("Check your console for the info")
			pl:SendLua("print('Available maps:')")
			for _, map in ipairs(XPA.MapList) do
				pl:SendLua("print('     " .. map .. "')")
			end
		end
	},

	--[[
		xpa teamlist
	]]

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
