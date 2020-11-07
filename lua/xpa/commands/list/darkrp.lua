return "DarkRP", "darkrp", {
	--[[
		xpa hg <steamid/name/userid> <number>
	]]

	["hg"] = {
		name = "Set hunger",
		immunity = 1000,
		icon = "icon16/cup_add.png",
		visible = true,
		string = true,
		func = function(pl, args)
			local target = XPA.FindPlayer(args[1])
			if not IsValid(target) or not target:Alive() then
				return
			end

			if IsValid(pl) then
				if target:GetImmunity() > pl:GetImmunity() then
					return
				end
			end

			local number = tonumber(args[2]) or 100
			target:setDarkRPVar("Energy", number)
			XPA.AChatLog(pl:Name() .. " has changed " .. target:Name() .. "'s hunger to " .. number)
		end
	},

	--[[
		xpa setjob <steamid/name/userid> <number>
	]]

	["setjob"] = {
		name = "Set job",
		immunity = 1000,
		icon = "icon16/user.png",
		visible = true,
		string = true,
		func = function(pl, args)
			local target = XPA.FindPlayer(args[1])
			if not IsValid(target) or not target:Alive() then
				return
			end

			if IsValid(pl) then
				if target:GetImmunity() > pl:GetImmunity() then
					return
				end
			end

			local toChange = args[2] or TEAM_CITIZEN        
			for team, data in pairs(team.GetAllTeams()) do
				if team == tonumber(toChange) or string.lower(data.Name) == string.lower(toChange or "") then
					local setTeam = target.changeTeam or target.SetTeam
					setTeam(target, team, true)
					XPA.AChatLog(pl:Name() .. " has changed " .. target:Name() .. "'s job to " .. data.Name)
				end
			end
		end
	},

	--[[
		xpa arrest <steamid/name/userid> <number>
	]]

	["arrest"] = {
		name = "Arrest",
		immunity = 1000,
		icon = "icon16/basket_add.png",
		visible = true,
		string = true,
		func = function(pl, args)
			local target = XPA.FindPlayer(args[1])
			if not IsValid(target) or not target:Alive() then
				return
			end

			if IsValid(pl) then
				if target:GetImmunity() > pl:GetImmunity() then
					return
				end
			end

			local number = tonumber(args[2]) or 300
			target:arrest(number)
			XPA.AChatLog(pl:Name() .. " has arrested " .. target:Name())
		end
	},

	--[[
		xpa unarrest <steamid/name/userid>
	]]

	["unarrest"] = {
		name = "UnArrest",
		immunity = 1000,
		icon = "icon16/basket_delete.png",
		visible = true,
		string = true,
		func = function(pl, args)
			local target = XPA.FindPlayer(args[1])
			if not IsValid(target) or not target:Alive() then
				return
			end

			if IsValid(pl) then
				if target:GetImmunity() > pl:GetImmunity() then
					return
				end
			end

			target:unArrest()
			XPA.AChatLog(pl:Name() .. " has unarrested " .. target:Name())
		end
	},

	--[[
		xpa pban <steamid/name/userid>
	]]

	["pban"] = {
		name = "Police Ban",
		immunity = 1000,
		icon = "icon16/controller_delete.png",
		visible = true,
		init = function()
			hook.Add("PlayerInitialSpawn", "XPA Police Ban", function(pl)
				local id = pl:SteamID()
				if XPA.Restrictions[id] and XPA.Restrictions[id].pban then
					pl:SetNWBool("XPA Police Ban", true)
				end
			end)

			hook.Add("playerCanChangeTeam", "XPA Police Ban", function(pl, team)
				if GAMEMODE.CivilProtection[team] and pl:GetNWBool("XPA Police Ban") then
					return false, DarkRP.getPhrase("banned_or_demoted")
				end
			end)
		end,
		func = function(pl, args)
			local target = XPA.FindPlayer(args[1])
			if not IsValid(target) then
				if XPA.IsValidSteamID(args[1]) then
					target = args[1]
				else
					return
				end
			end

			if IsValid(pl) then
				if target:GetImmunity() > pl:GetImmunity() then
					return
				end
			end

			if not XPA.IsValidSteamID(target) and IsValid(target) then
				-- Server Network
				target:SetNWBool("XPA Police Ban", true)

				-- Local DB Integration
				local id = target:SteamID()
				if XPA.Restrictions[id] then
					XPA.Restrictions[id].pban = true
				else
					XPA.Restrictions[id] = {
						pban = true
					}
				end

				-- DB Integration
				XPA.DB.Write("xpa-restrictions/" .. id, {
					pban = true
				})

				-- Demote
				if GAMEMODE.CivilProtection[target:Team()] then
					target:changeTeam(GAMEMODE.DefaultTeam, true)
				end
			else
				-- Local DB Integration
				if XPA.Restrictions[target] then
					XPA.Restrictions[target].pban = true
				else
					XPA.Restrictions[target] = {
						pban = true,
					}
				end

				-- DB Integration
				XPA.DB.Write("xpa-restrictions/" .. target, {
					pban = true
				})
			end

			local str = " has police banned " .. (XPA.IsValidSteamID(target) and target or target:Name())
			if IsValid(pl) then
				XPA.ChatLogCompounded(pl:Name() .. str, pl:GetRankTitle() .. str)
			else
				XPA.ChatLogCompounded("Server" .. str, "Server" .. str)
			end
		end,
	},

	--[[
		xpa unpban <steamid/name/userid>
	]]

	["unpban"] = {
		name = "Police UnBan",
		immunity = 1000,
		icon = "icon16/controller_add.png",
		visible = true,
		func = function(pl, args)
			local target = XPA.FindPlayer(args[1])
			if not IsValid(target) then
				if XPA.IsValidSteamID(args[1]) then
					target = args[1]
				else
					return
				end
			end

			if IsValid(pl) then
				if target:GetImmunity() > pl:GetImmunity() then
					return
				end
			end

			if not XPA.IsValidSteamID(target) and IsValid(target) then
				-- Server Network
				target:SetNWBool("XPA Police Ban", false)

				-- Local DB Integration
				local id = target:SteamID()
				if XPA.Restrictions[id] then
					XPA.Restrictions[id].pban = false
				end

				-- DB Integration
				XPA.DB.Write("xpa-restrictions/" .. id, {
					pban = false
				})
			else
				-- Local DB Integration
				if XPA.Restrictions[target] then
					XPA.Restrictions[target].pban = false
				end

				-- DB Integration
				XPA.DB.Write("xpa-restrictions/" .. target, {
					pban = false
				})
			end

			local str = " has police unbanned " .. (XPA.IsValidSteamID(target) and target or target:Name())
			if IsValid(pl) then
				XPA.ChatLogCompounded(pl:Name() .. str, pl:GetRankTitle() .. str)
			else
				XPA.ChatLogCompounded("Server" .. str, "Server" .. str)
			end
		end
	}
}, false
