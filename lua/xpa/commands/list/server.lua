local db = XPA.Config.Database
return "Server", "*", {
	--[[
		xpa setrank <steamid/name/userid> <rank>
	]]

	["setrank"] = {
		name = "Set rank",
		aliases = {"setgroup", "setusergroup", "setuser", "adduser"},
		icon = "icon16/key.png",
		visible = true,
		string = true,
		immunity = 10000,
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

			if id == "" then
				return
			end

			local function notify()
				local log = (IsValid(pl) and pl:Name() or "Console") .. " has changed " .. (IsValid(target) and target:Name() or id) .. "'s rank to " .. rank

				XPA.MsgC(log)
				XPA.AChatLog(log)
			end

			if rank == "user" then
				if IsValid(target) then
					if IsValid(pl) and target:GetImmunity() > pl:GetImmunity() then
						pl:ChatPrint("Target's rank is higher than yours!")
						return
					end
					target:SetUserGroup(rank)
				end

				if db == "firebase" then
					local cur_rank_pos, cur_rank = 1
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

					local rank_data = XPA.Ranks[cur_rank]
					if IsValid(pl) and pl:GetImmunity() < rank_data.immunity then
						pl:ChatPrint("This rank is higher than yours!")
						return
					end

					local _members = rank_data.members
					_members[cur_rank_pos] = nil
					XPA.DB.Write("xpa-ranks/" .. cur_rank, {
						members = table.ClearKeys(_members)
					})

					notify()
				elseif db == "sqlite" or db == "mysqloo" then
					XPA.DB.GetMemberRank(id, function(data)
						if not table.IsEmpty(data) and pl:GetImmunity() < XPA.Ranks[data.rank] then
							pl:ChatPrint("Target's rank is higher than yours!")
						else
							XPA.DB.AddMember(id, rank)
							notify()
						end
					end)
				end
			else
				local imm = XPA.Ranks[rank]
				if not imm then
					return
				end

				local function setRank()
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

				if IsValid(target) then
					if IsValid(pl) then
						if pl:GetImmunity() < imm then
							pl:ChatPrint("This rank is higher than yours!")
							return
						end
						if target:GetImmunity() > pl:GetImmunity() then
							pl:ChatPrint("Target's rank is higher than yours!")
							return
						end
					end

					target:SetUserGroup(rank)
					setRank()
					notify()
				else
					if IsValid(pl) then
						if pl:GetImmunity() < imm then
							pl:ChatPrint("This rank is higher than yours!")
							return
						end

						if db == "firebase" then
							local cur_rank
							for _rank, data in pairs(XPA.Ranks) do
								if not data.members then
									continue
								end
								if table.HasValue(data.members, id) then
									cur_rank = _rank
									break
								end
							end
							if pl:GetImmunity() < XPA.Ranks[cur_rank] then
								pl:ChatPrint("Target's rank is higher than yours!")
							else
								setRank()
								notify()
							end
						elseif db == "sqlite" or db == "mysqloo" then
							XPA.DB.GetMemberRank(id, function(data)
								if not table.IsEmpty(data) and pl:GetImmunity() < XPA.Ranks[data.rank] then
									pl:ChatPrint("Target's rank is higher than yours!")
								else
									setRank()
									notify()
								end
							end)
						end
					else
						setRank()
						notify()
					end
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
		aliases = {"changelevel", "changemap", "setmap"},
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
		aliases = {"getmaps", "maps"},
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
			if IsValid(pl) then
				pl:ChatPrint("Check your console for the info")
				pl:SendLua("print('Available maps:')")
				for _, map in ipairs(XPA.MapList) do
					pl:SendLua("print('     " .. map .. "')")
				end
			else
				print("Available maps:")
				for _, map in ipairs(XPA.MapList) do
					print("     " .. map)
				end
			end
		end
	},

	--[[
		xpa help
	]]

	["help"] = {
		name = "Help",
		icon = "icon16/help.png",
		self = true,
		func = function(pl)
			if IsValid(pl) then
				pl:ChatPrint("Check your console for the info")
				pl:SendLua("print('Available commands:')")
				for _, cat in ipairs(XPA.GetCommandCategories()) do
					pl:SendLua([[print("\n\n]] .. cat .. [[:")]])
					for cmd, d in pairs(XPA.Commands) do
						if d.category == cat then
							pl:SendLua([[print("	xpa ]] .. cmd .. [[ (]] .. d.name .. [[)")]])
						end
					end
				end
			else
				print('Available commands:')
				for _, cat in ipairs(XPA.GetCommandCategories()) do
					print("\n\n" .. cat .. ":")
					for cmd, d in pairs(XPA.Commands) do
						if d.category == cat then
							print("     xpa " .. cmd .. " (" .. d.name .. ")")
						end
					end
				end
			end
		end
	},

	--[[
		xpa teamlist
	]]

	["teamlist"] = {
		name = "Team list",
		aliases = {"getteams", "teams"},
		icon = "icon16/folder_database.png",
		visible = true,
		self = true,
		func = function(pl)
			if IsValid(pl) then
				pl:ChatPrint("Check your console for the info")
				pl:SendLua("print('Available teams:')")
				for index, data in pairs(team.GetAllTeams()) do
					pl:SendLua("print('     [" .. index .. "]: " .. data.Name .. "')")
				end
			else
				print("Available teams:")
				for index, data in pairs(team.GetAllTeams()) do
					print("    [" .. index .. "]: " .. data.name)
				end
			end
		end
	},
}, false