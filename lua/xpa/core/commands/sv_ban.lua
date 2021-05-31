XPA.Bans = XPA.Bans or {}

--[[
	XPA.Ban (Target ID, Ban Time, Ban reason)
]]

function XPA.Ban(id, time, reason, banner)
	time = time or 0
	if time > 0 then
		time = (time * 60) + os.time()
	end

	if not reason then
		reason = "No reason provided"
	end

	if not XPA.IsValidSteamID(id) then
		local pl = id
		if not IsEntity(id) then
			pl = XPA.FindPlayer(id)
		end

		if not IsValid(pl) then
			return
		end

		local preview = "∞"
		if time > 0 then
			preview = XPA.ConvertTime(((time - os.time()) * 60) / 60)
		end

		local ip, idv = string.Explode(":", pl:IPAddress())[1], pl:SteamID()
		-- Local DB Integration
		XPA.Bans[idv] = {
			time = time,
			reason = reason
		}

		-- DB Integration
		XPA.DB.Write("xpa-bans/" .. idv, {
			time = time,
			reason = reason
		})

		-- Patch the banner
		if banner and banner ~= nil then
			local bannerid = IsValid(banner) and banner:SteamID() or banner
			XPA.Bans[idv].banner = bannerid
			XPA.DB.Write("xpa-bans/" .. idv, {
				banner = bannerid
			})
		end

		pl:Kick("You have been banned.\nShame.\n\nReason: " .. reason .. "\nRemaining: " .. preview)
		XPA.MsgC(pl:Name() .. " [" .. idv .. " / " .. ip .. "] has been banned: " .. reason .. ".")
	else
		-- Local DB Integration
		XPA.Bans[id] = {
			time = time,
			reason = reason
		}
		
		-- DB Integration
		XPA.DB.Write("xpa-bans/" .. id, {
			time = time,
			reason = reason
		})

		-- Patch the banner
		if banner and banner ~= nil then
			local bannerid = IsValid(banner) and banner:SteamID() or banner
			XPA.Bans[id].banner = bannerid
			XPA.DB.Write("xpa-bans/" .. id, {
				banner = bannerid
			})
		end

		local pl = XPA.FindPlayer(id)
		if not IsValid(pl) then
			XPA.MsgC(id .. " has been banned: " .. reason .. ".")
			game.KickID(id, reason)
			return
		end

		local preview = "∞"
		if time > 0 then
			preview = XPA.ConvertTime(((time - os.time()) * 60) / 60)
		end

		local ip, idv = string.Explode(":", pl:IPAddress())[1], pl:SteamID()
		pl:Kick("You have been banned.\nShame.\n\nReason: " .. reason .. "\nRemaining: " .. preview)
		XPA.MsgC(pl:Name() .. " [" .. idv .. " / " .. ip .. "] has been banned: " .. reason .. ".")
	end
end

--[[
	XPA.Unban (Target ID)
]]

function XPA.Unban(id)
	if XPA.Bans[id] then
		XPA.Bans[id] = nil
	end
	XPA.DB.Read("xpa-bans", function(js)
		local bans = util.JSONToTable(js) 
		if bans[id] then
			XPA.DB.Delete("xpa-bans/" .. id)
			XPA.MsgC(id .. " has been unbanned.")
		end
	end)
end

--[[
	XPA.IsBanned (SteamID)
]]

function XPA.IsBanned(id)
	if XPA.Bans[id] then
		return true, XPA.Bans[id]
	end
	return false
end

--[[
	Updates
]]

timer.Create("XPA Bans Update", XPA.Config.BansUpdate, 0, function()
	local found = table.Copy(XPA.Bans)
	XPA.DB.Read("xpa-bans", function(js)
		local loaded = util.JSONToTable(js) 
		for id, data in pairs(loaded) do
			if not found[id] then
				found[id] = data
			end
			local pl = XPA.FindPlayer(id)
			if IsValid(pl) then
				pl:Kick(found[id].reason)
			end
		end
		XPA.Bans = found
	end)
end)

--[[
	Ban validation hook
]]

hook.Add("CheckPassword", "XPA Bans", function(id64)
	local id = util.SteamIDFrom64(id64)
	local banned, ban = XPA.IsBanned(id)
	if banned then
		local time = ban.time
		if time > 0 then
			if os.time() >= time then
				XPA.Unban(id)
			else
				local preview = ((time - os.time()) * 60) / 60
				preview = XPA.ConvertTime(preview)
				return false, "You have been banned.\nShame.\n\nReason: " .. ban.reason .. "\nRemaining: " .. preview
			end
		else
			return false, "You have been banned.\nShame.\n\nReason: " .. ban.reason .. "\nRemaining: ∞"
		end
	else
		return true
	end
end)