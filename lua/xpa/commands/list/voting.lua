return "Voting", "sandbox/groundcontrol/terrortown/classicjb/fbl", {
	--[[
		xpa votekick <steamid/name/userid>
	]]

	["votekick"] = {
		name = "VoteKick",
		icon = "icon16/user_delete.png",
		visible = true,
		init = function()
			XPA.VoteKicks = XPA.VoteKicks or {}
			hook.Add("PlayerDisconnected", "XPA VoteKick", function(pl)
				if XPA.VoteKicks[pl] then
					XPA.VoteKicks[pl] = nil
				end
			end)
		end,
		func = function(pl, args)
			local target = XPA.FindPlayer(args[1])
			if not IsValid(target) or not IsValid(pl) then
				return
			end

			if target:GetImmunity() > pl:GetImmunity() then
				return
			end

			if target == pl then
				XPA.SendMsg(pl, "You can't kick yourself")
				return
			end

			if not XPA.VoteKicks[target] then
				XPA.VoteKicks[target] = {
					voted = 0,
					voters = {}
				}
			else
				if table.HasValue(XPA.VoteKicks[target].voters, pl) then
					XPA.SendMsg(pl, "You can't vote twice")
					return
				end
			end

			XPA.VoteKicks[target].voted = XPA.VoteKicks[target].voted + 1
			table.insert(XPA.VoteKicks[target].voters, pl)

			local required = math.Round(#player.GetAll() / 2) + 1
			local str = " has voted for the kick of " .. target:Name() .. " (" .. XPA.VoteKicks[target].voted .. "/" .. required .. " remains)"
			XPA.ChatLogCompounded(pl:Name() .. str, pl:Name() .. str)

			if XPA.VoteKicks[target].voted >= required then
				target:Kick("Kicked by society")
				XPA.VoteKicks[target] = nil
			end
		end
	},

	--[[
		xpa votemap <map>
	]]

	["votemap"] = {
		name = "VoteMap",
		icon = "icon16/map.png",
		visible = true,
		string = true,
		self = true,
		gamemode = "sandbox/groundcontrol/terrortown/fbl",
		init = function()
			XPA.VoteMaps = {}
			local maps = XPA.MapList
			for _, map in pairs(maps) do
				if not string.find(map, "gm") then
					XPA.VoteMaps[map] = {
						voted = 0,
						voters = {}
					}
				end
			end
		end,
		autocompletion = function(arg)
			local t = string.Explode(" ", arg)
			local w = t[2]
			local tbl = {}
			for _, map in pairs(XPA.MapList) do
				table.insert(tbl, "xpa " .. w .. ' "' .. map .. '"')
			end
			return tbl
		end,
		func = function(pl, args)
			local map = args[1] 
			if not IsValid(pl) or not map then
				return
			end

			if not XPA.VoteMaps[map] then
				XPA.SendMsg(pl, "There is no such map installed")
				return
			end

			if engine.ActiveGamemode() == "groundcontrol" then
				local curgametype = GetConVar("gc_gametype"):GetInt()
				if not table.HasValue(GAMEMODE.Gametypes[curgametype].mapRotation, map) then
					XPA.SendMsg(pl, "A current gametype doesn't support such a map")
					return
				end
			end

			if table.HasValue(XPA.VoteMaps[map].voters, pl) then
				XPA.SendMsg(pl, "You can't vote twice")
				return
			end

			XPA.VoteMaps[map].voted = XPA.VoteMaps[map].voted + 1
			table.insert(XPA.VoteMaps[map].voters, pl)

			local required = math.Round(#player.GetAll() / 2)
			local str = " has voted for changing map to " .. map .. " (" .. XPA.VoteMaps[map].voted .. "/" .. required .. " remains)"
			XPA.ChatLogCompounded(pl:Name() .. str, pl:Name() .. str)

			if XPA.VoteMaps[map].voted >= required then
				RunConsoleCommand("changelevel", map)
			end
		end
	},

	--[[
		xpa votegame <gametype id>
	]]

	["votegame"] = {
		name = "VoteGame",
		icon = "icon16/controller.png",
		visible = true,
		string = true,
		self = true,
		gamemode = "groundcontrol",
		init = function()
			XPA.VoteGames = XPA.VoteGames or {}
			XPA.GameTypes = {
				"Rush",
				"Assault",
				"Urban Warfare",
				"Ghetto Drug Bust"
			}

			for id in pairs(XPA.GameTypes) do
				XPA.VoteGames[id] = {
					voted = 0,
					voters = {}
				}
			end
		end,
		func = function(pl, args)
			local game = tonumber(args[1])
			if not IsValid(pl) or not game then
				return
			end

			if not XPA.GameTypes[game] then
				XPA.SendMsg(pl, "There is no such gametype on the Ground Control")
				return
			end

			if table.HasValue(XPA.VoteGames[game].voters, pl) then
				XPA.SendMsg(pl, "You can't vote for this gametype twice")
				return
			end

			for gm, data in pairs(XPA.VoteGames) do
				if table.HasValue(data.voters, pl) then
					table.RemoveByValue(XPA.VoteGames[gm].voters, pl)
					XPA.VoteGames[gm].voted = XPA.VoteGames[gm].voted - 1
					XPA.SendMsg(pl, "Your previous vote to [" .. gm .. "] " .. XPA.GameTypes[gm] .. " has been annulled")
				end
			end

			XPA.VoteGames[game].voted = XPA.VoteGames[game].voted + 1
			table.insert(XPA.VoteGames[game].voters, pl)

			local required = math.Round(#player.GetAll() / 2)
			local str = " has voted for changing gametype to [" .. game .. "] " .. XPA.GameTypes[game] .. " (" .. XPA.VoteGames[game].voted .. "/" .. required .. " remains)"
			XPA.ChatLogCompounded(pl:Name() .. str, pl:Name() .. str)

			if XPA.VoteGames[game].voted >= required then
				RunConsoleCommand("gc_gametype", game)
				local fstr = "Changing a gametype to [" .. game .. "] " .. XPA.GameTypes[game] .. ". You guys can change the map via !votemap <map_name> command to start playing the featured gametype immediately."
				XPA.ChatLogCompounded(fstr, fstr)
			end
		end
	}
}, false
