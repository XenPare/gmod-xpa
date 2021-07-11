return "Player", "*", {
	--[[
		xpa hp <steamid/name/userid> <number>
	]]

	["hp"] = {
		name = "Set health",
		immunity = 1000,
		icon = "icon16/heart_add.png",
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
			target:SetHealth(number)
			XPA.AChatLog(pl:Name() .. " has changed " .. target:Name() .. "'s health to " .. number)
		end
	},

	--[[
		xpa gethp <steamid/name/userid>
	]]

	["gethp"] = {
		name = "Get health",
		immunity = 1000,
		icon = "icon16/heart.png",
		visible = true,
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

			XPA.SendMsg(pl, target:Name() .. " has got " .. pl:Health() .. " health.")
		end
	},

	--[[
		xpa ar <steamid/name/userid> <number>
	]]

	["ar"] = {
		name = "Set armor",
		immunity = 1000,
		icon = "icon16/shield_add.png",
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
			if number > 255 then
				number = 255
			end

			target:SetArmor(number)
			XPA.AChatLog(pl:Name() .. " has changed " .. target:Name() .. "'s armor to " .. number)
		end
	},

	--[[
		xpa getar <steamid/name/userid>
	]]

	["getar"] = {
		name = "Get armor",
		immunity = 1000,
		icon = "icon16/shield.png",
		visible = true,
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

			XPA.SendMsg(pl, target:Name() .. " has got " .. pl:Armor() .. " armor.")
		end
	},

	--[[
		xpa god <steamid/name/userid>
	]]

	["god"] = {
		name = "God",
		immunity = 1000,
		icon = "icon16/pill.png",
		visible = true,
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

			target:GodEnable()
			XPA.AChatLog(pl:Name() .. " has enabled god for " .. target:Name())
		end
	},

	--[[
		xpa ungod <steamid/name/userid>
	]]

	["ungod"] = {
		name = "UnGod",
		immunity = 1000,
		icon = "icon16/pill_delete.png",
		visible = true,
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

			target:GodDisable()
			XPA.AChatLog(pl:Name() .. " has disabled god for " .. target:Name())
		end
	},

	--[[
		xpa weapon <steamid/name/userid> <classname>
	]]

	["weapon"] = {
		name = "Give weapon",
		immunity = 1000,
		icon = "icon16/gun.png",
		visible = true,
		string = true,
		func = function(pl, args)
			local target = XPA.FindPlayer(args[1])
			if not IsValid(target) or not target:Alive() or not args[2] then
				return
			end

			local available = {} -- we don't want admins to spawn entities
			for _, wep in pairs(weapons.GetList()) do
				table.insert(available, wep.ClassName)
			end
			if not table.HasValue(available, args[2]) then
				target:Give(args[2])
			end
		end
	},

	--[[
		xpa noclip
	]]

	["noclip"] = {
		name = "Noclip",
		immunity = 1000,
		icon = "icon16/wand.png",
		self = true,
		visible = true,
		func = function(pl, args)
			if not IsValid(pl) then
				return
			end
			local type = pl:GetMoveType() == MOVETYPE_WALK and MOVETYPE_NOCLIP or MOVETYPE_WALK
			pl:SetMoveType(type)
		end
	},

	--[[
		xpa cloak
	]]

	["cloak"] = {
		name = "Cloak",
		immunity = 1000,
		icon = "icon16/contrast.png",
		self = true,
		visible = true,
		func = function(pl, args)
			if not IsValid(pl) then
				return
			end

			local bool, msg = not pl:GetNWBool("XPA Cloaked"), pl:GetNWBool("XPA Cloaked") and "Uncloaked" or "Cloaked"
			pl:SetNWBool("XPA Cloaked", bool)
			pl:SetNoDraw(bool)
		
			for _, v in pairs(pl:GetWeapons()) do
				v:SetNoDraw(bool)
			end

			for _, v in ipairs(ents.FindByClass("physgun_beam")) do
				if v:GetParent() == pl then
					v:SetNoDraw(bool)
				end
			end

			pl:ChatPrint(msg)
		end
	},

	--[[
		xpa fs <steamid/name/userid>
	]]

	["fs"] = {
		name = "Fam. sharing",
		immunity = 1000,
		icon = "icon16/controller.png",
		visible = true,
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

			http.Fetch("http://api.steampowered.com/IPlayerService/IsPlayingSharedGame/v0001/?key=" .. XPA.Config.SteamAPIKey .. "&format=json&steamid=" .. target:SteamID64() .. "&appid_playing=4000",
				function(body)
					body = util.JSONToTable(body)
					if not body or not body.response or not body.response.lender_steamid then
						pl:ChatPrint("Can't connect to the Steam API")
					end
					local lender = body.response.lender_steamid
					if lender ~= "0" then
						XPA.SendMsg(pl, target:Name() .. " is using Family Sharing, lender player's SteamID is " .. util.SteamIDFrom64(lender))
						pl:ChatPrint(target:Name() .. " is using Family Sharing, lender player's SteamID is " .. util.SteamIDFrom64(lender))
					else
						XPA.SendMsg(pl, target:Name() .. " is not using Family Sharing")
					end
				end
			)
		end
	}
}, true
