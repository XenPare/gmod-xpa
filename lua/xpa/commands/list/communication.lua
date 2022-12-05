local db = XPA.Config.Database
return "Communication", "*", {
	--[[
		xpa gag <steamid/name/userid>
	]]

	["gag"] = {
		name = "Gag",
		immunity = 1000,
		icon = "icon16/sound_delete.png",
		visible = true,
		func = function(pl, args)
			local id = ""
			local target = XPA.FindPlayer(args[1])
			if XPA.IsValidSteamID(args[1]) then
				id = args[1]
			elseif IsValid(target) then
				id = target:SteamID()
			end

			if id == "" then
				return
			end

			if (IsValid(pl) and IsValid(target)) and (target:GetImmunity() > pl:GetImmunity()) then
				return
			end

			if IsValid(target) then
				target:SetNWBool("XPA Gag", true)
			end

			-- Local DB Integration
			if XPA.Restrictions[id] then
				XPA.Restrictions[id].gag = true
			else
				XPA.Restrictions[id] = {
					gag = true,
				}
			end

			-- DB Integration
			if db == "firebase" then
				XPA.DB.Write("xpa-restrictions/" .. id, {
					gag = true
				})
			elseif db == "sqlite" or db == "mysqloo" then
				XPA.DB.SetRestriction(id, nil, true)
			end

			local str = " has gagged " .. (IsValid(target) and target:Name() or id)
			if IsValid(pl) then
				XPA.ChatLogCompounded(pl:Name() .. str, pl:GetRankTitle() .. str)
			else
				XPA.ChatLogCompounded("Server" .. str, "Server" .. str)
			end
		end
	},

	--[[
		xpa ungag <steamid/name/userid>
	]]

	["ungag"] = {
		name = "UnGag",
		immunity = 1000,
		icon = "icon16/sound_add.png",
		visible = true,
		func = function(pl, args)
			local id = ""
			local target = XPA.FindPlayer(args[1])
			if XPA.IsValidSteamID(args[1]) then
				id = args[1]
			elseif IsValid(target) then
				id = target:SteamID()
			end

			if id == "" then
				return
			end

			if (IsValid(pl) and IsValid(target)) and (target:GetImmunity() > pl:GetImmunity()) then
				return
			end

			if IsValid(target) then
				target:SetNWBool("XPA Gag", false)
			end

			-- Local DB Integration
			if XPA.Restrictions[id] then
				XPA.Restrictions[id].gag = false
			end

			-- DB Integration
			if db == "firebase" then
				XPA.DB.Write("xpa-restrictions/" .. id, {
					gag = false
				})
			elseif db == "sqlite" or db == "mysqloo" then
				XPA.DB.SetRestriction(id, nil, false)
			end

			local str = " has ungagged " .. (IsValid(target) and target:Name() or id)
			if IsValid(pl) then
				XPA.ChatLogCompounded(pl:Name() .. str, pl:GetRankTitle() .. str)
			else
				XPA.ChatLogCompounded("Server" .. str, "Server" .. str)
			end
		end
	},

	--[[
		xpa mute <steamid/name/userid>
	]]

	["mute"] = {
		name = "Mute",
		immunity = 1000,
		icon = "icon16/comments_delete.png",
		visible = true,
		func = function(pl, args)
			local id = ""
			local target = XPA.FindPlayer(args[1])
			if XPA.IsValidSteamID(args[1]) then
				id = args[1]
			elseif IsValid(target) then
				id = target:SteamID()
			end

			if id == "" then
				return
			end

			if (IsValid(pl) and IsValid(target)) and (target:GetImmunity() > pl:GetImmunity()) then
				return
			end

			if IsValid(target) then
				target:SetNWBool("XPA Mute", true)
			end

			-- Local DB Integration
			if XPA.Restrictions[id] then
				XPA.Restrictions[id].mute = true
			else
				XPA.Restrictions[id] = {
					mute = true
				}
			end

			-- DB Integration
			if db == "firebase" then
				XPA.DB.Write("xpa-restrictions/" .. id, {
					mute = true
				})
			elseif db == "sqlite" or db == "mysqloo" then
				XPA.DB.SetRestriction(id, true)
			end

			local str = " has muted " .. (IsValid(target) and target:Name() or id)
			if IsValid(pl) then
				XPA.ChatLogCompounded(pl:Name() .. str, pl:GetRankTitle() .. str)
			else
				XPA.ChatLogCompounded("Server" .. str, "Server" .. str)
			end
		end
	},

	--[[
		xpa unmute <steamid/name/userid>
	]]

	["unmute"] = {
		name = "UnMute",
		immunity = 1000,
		icon = "icon16/comments_add.png",
		visible = true,
		func = function(pl, args)
			local id = ""
			local target = XPA.FindPlayer(args[1])
			if XPA.IsValidSteamID(args[1]) then
				id = args[1]
			elseif IsValid(target) then
				id = target:SteamID()
			end

			if id == "" then
				return
			end

			if (IsValid(pl) and IsValid(target)) and (target:GetImmunity() > pl:GetImmunity()) then
				return
			end

			if IsValid(target) then
				target:SetNWBool("XPA Mute", false)
			end

			-- Local DB Integration
			if XPA.Restrictions[id] then
				XPA.Restrictions[id].mute = false
			end

			-- DB Integration
			if db == "firebase" then
				XPA.DB.Write("xpa-restrictions/" .. id, {
					mute = false
				})
			elseif db == "sqlite" or db == "mysqloo" then
				XPA.DB.SetRestriction(id, false)
			end

			local str = " has unmuted " .. (IsValid(target) and target:Name() or id)
			if IsValid(pl) then
				XPA.ChatLogCompounded(pl:Name() .. str, pl:GetRankTitle() .. str)
			else
				XPA.ChatLogCompounded("Server" .. str, "Server" .. str)
			end
		end
	}
}, true