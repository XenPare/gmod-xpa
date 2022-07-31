return "Player", "*", {
	--[[
		xpa hp <steamid/name/userid> <number>
	]]

	["hp"] = {
		name = "Set health",
		aliases = {"health", "sethealth", "sethp"},
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
		aliases = {"gethealth"},
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

			XPA.SendMsg(pl, target:Name() .. " has got " .. target:Health() .. " health.")
		end
	},

	--[[
		xpa ar <steamid/name/userid> <number>
	]]

	["ar"] = {
		name = "Set armor",
		aliases = {"armor", "setarmor", "setar"},
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
		aliases = {"getarmor"},
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

			XPA.SendMsg(pl, target:Name() .. " has got " .. target:Armor() .. " armor.")
		end
	},

	--[[
		xpa god <steamid/name/userid>
	]]

	["god"] = {
		name = "God",
		aliases = {"godmode"},
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

			local change
			if target:HasGodMode() then
				target:GodDisable()
				change = "disabled"
			else
				target:GodEnable()
				change = "enabled"
			end

			XPA.AChatLog(pl:Name() .. " has " .. change .. " god for " .. target:Name())
		end
	},

	--[[
		xpa weapon <steamid/name/userid> <classname>
	]]

	["weapon"] = {
		name = "Give weapon",
		aliases = {"give", "wep", "givewep", "giveweapon"}
		immunity = 1000,
		icon = "icon16/gun.png",
		visible = true,
		string = true,
		init = function()
			XPA.AvailableWeapons = {}  -- we don't want admins to spawn entities
			for _, wep in ipairs(weapons.GetList()) do
				XPA.AvailableWeapons[wep.ClassName] = true
			end
		end,
		autocompletion = function(arg)
			local t = string.Explode(" ", arg)
			local w = t[2]
			local tbl = {}
			for _, pl in ipairs(player.GetAll()) do
				table.insert(tbl, "xpa " .. w .. ' "' .. pl:Name() .. '" "weapon_357"')
			end
			return tbl
		end,
		func = function(pl, args)
			local target = XPA.FindPlayer(args[1])
			local wepcl = args[2]
			if not IsValid(target) or not target:Alive() or not wepcl then
				return
			end
			if XPA.AvailableWeapons[wepcl] then
				target:Give(wepcl)
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

			for _, v in ipairs(pl:GetWeapons()) do
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
		aliases = {"familysharing", "famsharing", "famshar"},
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

			local ownerid =  util.SteamIDFrom64(target:OwnerSteamID64())
			if target:SteamID() ~= ownerid then
				XPA.SendMsg(pl, target:Name() .. " is using Family Sharing, lender player's SteamID is " .. ownerid)
				pl:ChatPrint(target:Name() .. " is using Family Sharing, lender player's SteamID is " .. ownerid)
			else
				XPA.SendMsg(pl, target:Name() .. " is not using Family Sharing")
			end
		end
	}
}, true
