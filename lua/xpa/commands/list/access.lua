return "Server Access", "*", {
	["ban"] = {
		name = "Ban",
		immunity = 1000,
		icon = "icon16/user_delete.png",
		visible = true,
		func = function(pl, args)
			if #args <= 1 then
				return
			end

			local target = args[1]
			local time = tonumber(args[2]) or 1440
			local reason = args[3] or "No reason provided"
			local preview = XPA.ConvertTime(time * 60)

			if IsEntity(target) and IsValid(target) then
				if IsValid(pl) then
					if target:GetImmunity() > pl:GetImmunity() then
						return
					end
				end
			end

			XPA.Ban(target, time, reason)

			if IsEntity(target) and IsValid(target) then
				local str = " has banned " .. target:Name() .. " for: " .. reason
				if IsValid(pl) then
					XPA.ChatLogCompounded(pl:Name() .. str, pl:GetRankTitle() .. str)
				else
					XPA.ChatLogCompounded("Server" .. str, "Server" .. str)
				end
			else
				local str
				if XPA.IsValidSteamID(target) then
					str = " has banned " .. target .. " for: " .. reason
				else
					local _target = XPA.FindPlayer(target)
					if IsValid(_target) then
						str = " has banned " .. _target:Name() .. " for: " .. reason
					end
				end
			end
		end
	},

	["unban"] = {
		name = "UnBan",
		immunity = 10000,
		icon = "icon16/user_add.png",
		self = true,
		visible = true,
		string = true,
		func = function(pl, args)
			local id = args[1] or 0
			if id == 0 then
				return
			end

			XPA.Unban(id)

			local str = " has unbanned " .. id
			if IsValid(pl) then
				XPA.ChatLogCompounded(pl:Name() .. str, pl:GetRankTitle() .. str)
			else
				XPA.ChatLogCompounded("Server" .. str, "Server" .. str)
			end
		end
	},

	["kick"] = {
		name = "Kick",
		immunity = 1000,
		icon = "icon16/user_delete.png",
		visible = true,
		string = true,
		func = function(pl, args)
			local target = XPA.FindPlayer(args[1])
			local reason = args[2] or "No reason provided"

			if not IsValid(target) then
				return
			end

			if IsValid(pl) then
				if target:GetImmunity() > pl:GetImmunity() then
					return
				end
			end

			if reason ~= "No reason provided" then
				_reason = table.Copy(args)
				_reason[1] = nil
				_reason = table.ClearKeys(_reason)
				target:Kick(table.concat(_reason, " "))
			else
				target:Kick(reason)
			end

			local str = " has kicked " .. target:Name() .. " for: " .. reason
			if IsValid(pl) then
				XPA.ChatLogCompounded(pl:Name() .. str, pl:GetRankTitle() .. str)
			else
				XPA.ChatLogCompounded("Server" .. str, "Server" .. str)
			end
		end
	}
}, true