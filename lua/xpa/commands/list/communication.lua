return "Communication", "*", {
	["gag"] = {
		name = "Gag",
		immunity = 1000,
		icon = "icon16/sound_delete.png",
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
				target:SetNWBool("XPA Gag", true)

				-- Local DB Integration
				local id = target:SteamID()
				if XPA.Restrictions[id] then
					XPA.Restrictions[id].gag = true
				else
					XPA.Restrictions[id] = {
						gag = true,
					}
				end

				-- DB Integration
				XPA.DB.Write("xpa-restrictions/" .. id, {
					gag = true
				})
			else
				-- Local DB Integration
				if XPA.Restrictions[target] then
					XPA.Restrictions[target].gag = true
				else
					XPA.Restrictions[target] = {
						gag = true,
					}
				end

				-- DB Integration
				XPA.DB.Write("xpa-restrictions/" .. target, {
					gag = true
				})
			end

			local str = " has gagged " .. (XPA.IsValidSteamID(target) and target or target:Name())
			if IsValid(pl) then
				XPA.ChatLogCompounded(pl:Name() .. str, pl:GetRankTitle() .. str)
			else
				XPA.ChatLogCompounded("Server" .. str, "Server" .. str)
			end
		end
	},

	["ungag"] = {
		name = "UnGag",
		immunity = 1000,
		icon = "icon16/sound_add.png",
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
				target:SetNWBool("XPA Gag", false)

				-- Local DB Integration
				local id = target:SteamID()
				if XPA.Restrictions[id] then
					XPA.Restrictions[id].gag = false
				end

				-- DB Integration
				XPA.DB.Write("xpa-restrictions/" .. id, {
					gag = false
				})
			else
				-- Local DB Integration
				if XPA.Restrictions[target] then
					XPA.Restrictions[target].gag = false
				end

				-- DB Integration
				XPA.DB.Write("xpa-restrictions/" .. target, {
					gag = false
				})
			end

			local str = " has ungagged " .. (XPA.IsValidSteamID(target) and target or target:Name())
			if IsValid(pl) then
				XPA.ChatLogCompounded(pl:Name() .. str, pl:GetRankTitle() .. str)
			else
				XPA.ChatLogCompounded("Server" .. str, "Server" .. str)
			end
		end
	},

	["mute"] = {
		name = "Mute",
		immunity = 1000,
		icon = "icon16/comments_delete.png",
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
				target:SetNWBool("XPA Mute", true)

				-- Local DB Integration
				local id = target:SteamID()
				if XPA.Restrictions[id] then
					XPA.Restrictions[id].mute = true
				else
					XPA.Restrictions[id] = {
						mute = true
					}
				end

				-- DB Integration
				XPA.DB.Write("xpa-restrictions/" .. id, {
					mute = true
				})
			else
				-- Local DB Integration
				if XPA.Restrictions[target] then
					XPA.Restrictions[target].mute = true
				else
					XPA.Restrictions[target] = {
						mute = true
					}
				end

				-- DB Integration
				XPA.DB.Write("xpa-restrictions/" .. target, {
					mute = true
				})
			end

			local str = " has muted " .. (XPA.IsValidSteamID(target) and target or target:Name())
			if IsValid(pl) then
				XPA.ChatLogCompounded(pl:Name() .. str, pl:GetRankTitle() .. str)
			else
				XPA.ChatLogCompounded("Server" .. str, "Server" .. str)
			end
		end
	},

	["unmute"] = {
		name = "UnMute",
		immunity = 1000,
		icon = "icon16/comments_add.png",
		visible = true,
		func = function(pl, args)
			local target = XPA.FindPlayer(args[1])
			if not IsValid(target) then
				if XPA.IsValidSteamID(args[1]) then
					target = args[1]
					if not XPA.Restrictions[target] then
						return
					end
				else
					return
				end
			else
				if not XPA.Restrictions[target:SteamID()] then
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
				target:SetNWBool("XPA Mute", false)

				-- Local DB Integration
				local id = target:SteamID()
				if XPA.Restrictions[id] then
					XPA.Restrictions[id].mute = false
				end

				-- DB Integration
				XPA.DB.Write("xpa-restrictions/" .. id, {
					mute = false
				})
			else
				-- Local DB Integration
				if XPA.Restrictions[target] then
					XPA.Restrictions[target].mute = false
				end

				-- DB Integration
				XPA.DB.Write("xpa-restrictions/" .. target, {
					mute = false
				})
			end

			local str = " has unmuted " .. (XPA.IsValidSteamID(target) and target or target:Name())
			if IsValid(pl) then
				XPA.ChatLogCompounded(pl:Name() .. str, pl:GetRankTitle() .. str)
			else
				XPA.ChatLogCompounded("Server" .. str, "Server" .. str)
			end
		end
	}
}, true