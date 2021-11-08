return "Voting", "sandbox/groundcontrol/terrortown/classicjb/fbl", {
	--[[
		xpa votekick <steamid/name/userid>
	]]

	["votekick"] = {
		name = "VoteKick",
		icon = "icon16/user_delete.png",
		visible = true,
		init = function()
			XPA.Commands.VoteKicks = XPA.Commands.VoteKicks or {}
			hook.Add("PlayerDisconnected", "XPA VoteKick", function(pl)
				if XPA.Commands.VoteKicks[pl] then
					XPA.Commands.VoteKicks[pl] = nil
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

			if not XPA.Commands.VoteKicks[target] then
				XPA.Commands.VoteKicks[target] = {
					voted = 0,
					voters = {}
				}
			else
				if table.HasValue(XPA.Commands.VoteKicks[target].voters, pl) then
					XPA.SendMsg(pl, "You can't vote twice")
					return
				end
			end

			XPA.Commands.VoteKicks[target].voted = XPA.Commands.VoteKicks[target].voted + 1
			table.insert(XPA.Commands.VoteKicks[target].voters, pl)

			local required = math.Round(#player.GetAll() / 2) + 1
			local str = " has voted for the kick of " .. target:Name() .. " (" .. XPA.Commands.VoteKicks[target].voted .. "/" .. required .. " remains)"
			XPA.ChatLogCompounded(pl:Name() .. str, pl:Name() .. str)

			if XPA.Commands.VoteKicks[target].voted >= required then
				target:Kick("Kicked by society")
				XPA.Commands.VoteKicks[target] = nil
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
		gamemode = "groundcontrol/terrortown/fbl",
		init = function()
			XPA.Commands.VoteMaps = XPA.Commands.VoteMaps or {}
			local maps = XPA.MapList
			for _, map in pairs(maps) do
				if not string.find(map, "gm") then
					XPA.Commands.VoteMaps[map] = {
						voted = 0,
						voters = {}
					}
				end
			end
		end,
		func = function(pl, args)
			local map = args[1] 
			if not IsValid(pl) or not map then
				return
			end

			if not XPA.Commands.VoteMaps[map] then
				XPA.SendMsg(pl, "There is no such map installed")
				return
			end

			if engine.ActiveGamemode() == "groundcontrol" and not table.HasValue(GAMEMODE.curGametype.mapRotation, map) then
				XPA.SendMsg(pl, "A current gametype doesn't support such map")
				return
			end

			if table.HasValue(XPA.Commands.VoteMaps[map].voters, pl) then
				XPA.SendMsg(pl, "You can't vote twice")
				return
			end

			XPA.Commands.VoteMaps[map].voted = XPA.Commands.VoteMaps[map].voted + 1
			table.insert(XPA.Commands.VoteMaps[map].voters, pl)

			local required = math.Round(#player.GetAll() / 2)
			local str = " has voted for changing map to " .. map .. " (" .. XPA.Commands.VoteMaps[map].voted .. "/" .. required .. " remains)"
			XPA.ChatLogCompounded(pl:Name() .. str, pl:Name() .. str)

			if XPA.Commands.VoteMaps[map].voted >= required then
				RunConsoleCommand("changelevel", map)
			end
		end
	}
}, false
