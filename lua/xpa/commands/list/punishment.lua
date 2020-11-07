return "Punishment", "*", {
	--[[
		xpa jail <steamid/name/userid> <time>
	]]

	["jail"] = {
		name = "Jail",
		immunity = 1000,
		icon = "icon16/basket_add.png",
		visible = true,
		init = function()
			XPA.Jail = {}
			hook.Add("PlayerInitialSpawn", "XPA Jail", function(pl)
				local id = pl:SteamID()
				if not XPA.Jail[id] then
					return
				end

				pl:Freeze(true)
				pl:ChatPrint("Your jail has been restored for " .. XPA.Jail[id] .. " seconds")
				timer.Create("XPA Jail #" .. id, XPA.Jail[id], 1, function()
					if not IsValid(pl) or not XPA.Jail[pl] then
						return
					end
					pl:Freeze(false)
					XPA.Jail[id] = nil
				end)
			end)
		end,
		func = function(pl, args)
			local target = XPA.FindPlayer(args[1])
			if not IsValid(target) then
				return
			end

			if IsValid(pl) then
				if target:GetImmunity() > pl:GetImmunity() then
					return
				end
			end

			local id = target:SteamID()
			local time = tonumber(args[2]) or 300
			target:Spawn()
			target:Freeze(true)
			XPA.Jail[id] = time

			timer.Create("XPA Jail #" .. id, time, 1, function()
				if not IsValid(target) or not XPA.Jail[id] then
					return
				end
				target:Freeze(false)
				XPA.Jail[id] = nil
			end)

			local str = " has jailed " .. target:Name() .. " for " .. time .. " seconds"
			if IsValid(pl) then
				XPA.ChatLogCompounded(pl:Name() .. str, pl:GetRankTitle() .. str)
			else
				XPA.ChatLogCompounded("Server" .. str, "Server" .. str)
			end
		end
	},

	--[[
		xpa unjail <steamid/name/userid>
	]]

	["unjail"] = {
		name = "UnJail",
		immunity = 1000,
		icon = "icon16/basket_delete.png",
		visible = true,
		func = function(pl, args)
			local target = XPA.FindPlayer(args[1])
			if not IsValid(target) then
				return
			end

			if IsValid(pl) then
				if target:GetImmunity() > pl:GetImmunity() then
					return
				end
			end

			target:Spawn()
			target:Freeze(false)
			XPA.Jail[target:SteamID()] = nil
			timer.Remove("XPA Jail #" .. target:SteamID())

			local str = " has unjailed " .. target:Name()
			if IsValid(pl) then
				XPA.ChatLogCompounded(pl:Name() .. str, pl:GetRankTitle() .. str)
			else
				XPA.ChatLogCompounded("Server" .. str, "Server" .. str)
			end
		end
	},

	--[[
		xpa ignite <steamid/name/userid> <time>
	]]

	["ignite"] = {
		name = "Ignite",
		immunity = 1000,
		icon = "icon16/weather_sun.png",
		visible = true,
		func = function(pl, args)
			local target = XPA.FindPlayer(args[1])
			if not IsValid(target) then
				return
			end

			if IsValid(pl) then
				if target:GetImmunity() > pl:GetImmunity() then
					return
				end
			end

			target:Ignite(tonumber(args[2]) or 60)

			local str = " has ignited " .. target:Name()
			if IsValid(pl) then
				XPA.ChatLogCompounded(pl:Name() .. str, pl:GetRankTitle() .. str)
			else
				XPA.ChatLogCompounded("Server" .. str, "Server" .. str)
			end
		end
	},

	--[[
		xpa unignite <steamid/name/userid>
	]]

	["unignite"] = {
		name = "UnIgnite",
		immunity = 1000,
		icon = "icon16/weather_rain.png",
		visible = true,
		func = function(pl, args)
			local target = XPA.FindPlayer(args[1])
			if not IsValid(target) then
				return
			end

			if IsValid(pl) then
				if target:GetImmunity() > pl:GetImmunity() then
					return
				end
			end

			target:Ignite()

			local str = " has unignited " .. target:Name()
			if IsValid(pl) then
				XPA.ChatLogCompounded(pl:Name() .. str, pl:GetRankTitle() .. str)
			else
				XPA.ChatLogCompounded("Server" .. str, "Server" .. str)
			end
		end
	},

	--[[
		xpa slay <steamid/name/userid>
	]]

	["slay"] = {
		name = "Slay",
		immunity = 1000,
		icon = "icon16/cross.png",
		visible = true,
		func = function(pl, args)
			local target = XPA.FindPlayer(args[1])
			if not IsValid(target) then
				return
			end

			if IsValid(pl) then
				if target:GetImmunity() > pl:GetImmunity() then
					return
				end
			end

			target:KillSilent()

			local str = " has slayed " .. target:Name()
			if IsValid(pl) then
				XPA.ChatLogCompounded(pl:Name() .. str, pl:GetRankTitle() .. str)
			else
				XPA.ChatLogCompounded("Server" .. str, "Server" .. str)
			end
		end
	},

	--[[
		xpa freeze <steamid/name/userid>
	]]

	["freeze"] = {
		name = "Freeze",
		immunity = 1000,
		icon = "icon16/status_away.png",
		visible = true,
		func = function(pl, args)
			local target = XPA.FindPlayer(args[1])
			if not IsValid(target) then
				return
			end

			if IsValid(pl) then
				if target:GetImmunity() > pl:GetImmunity() then
					return
				end
			end

			target:Freeze(true)

			local str = " has frozen " .. target:Name()
			if IsValid(pl) then
				XPA.ChatLogCompounded(pl:Name() .. str, pl:GetRankTitle() .. str)
			else
				XPA.ChatLogCompounded("Server" .. str, "Server" .. str)
			end
		end
	},

	--[[
		xpa unfreeze <steamid/name/userid>
	]]

	["unfreeze"] = {
		name = "UnFreeze",
		immunity = 1000,
		icon = "icon16/status_online.png",
		visible = true,
		func = function(pl, args)
			local target = XPA.FindPlayer(args[1])
			if not IsValid(target) then
				return
			end

			if IsValid(pl) then
				if target:GetImmunity() > pl:GetImmunity() then
					return
				end
			end

			target:Freeze(false)

			local str = " has unfrozen " .. target:Name()
			if IsValid(pl) then
				XPA.ChatLogCompounded(pl:Name() .. str, pl:GetRankTitle() .. str)
			else
				XPA.ChatLogCompounded("Server" .. str, "Server" .. str)
			end
		end
	},
}, true
