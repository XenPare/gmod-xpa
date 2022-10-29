XPA.Bans = XPA.Bans or {}

local db = XPA.Config.Database

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

	local bannerid = nil
	if banner and banner ~= nil then
		local bannerid = IsValid(banner) and banner:SteamID() or banner
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

		if bannerid then
			XPA.Bans[idv].banner = bannerid
		end

		-- DB Integration
		if db == "firebase" then
			XPA.DB.Write("xpa-bans/" .. idv, {
				time = time,
				reason = reason
			})

			-- Patch the banner
			if bannerid then
				XPA.DB.Write("xpa-bans/" .. idv, {
					banner = bannerid
				})
			end
		elseif db == "sqlite" or db == "mysqloo" then
			XPA.DB.AddBan(idv, reason, time, bannerid)
		end

		pl:Kick("You have just been banned.\nShame.\n\nReason: " .. reason .. "\nRemaining: " .. preview)
		XPA.MsgC(pl:Name() .. " [" .. idv .. " / " .. ip .. "] has just been banned: " .. reason .. ".")
	else
		-- Local DB Integration
		XPA.Bans[id] = {
			time = time,
			reason = reason
		}

		if bannerid then
			XPA.Bans[idv].banner = bannerid
		end

		-- DB Integration
		if db == "firebase" then
			XPA.DB.Write("xpa-bans/" .. id, {
				time = time,
				reason = reason
			})

			-- Patch the banner
			XPA.DB.Write("xpa-bans/" .. id, {
				banner = bannerid
			})
		elseif db == "sqlite" or db == "mysqloo" then
			XPA.DB.AddBan(id, reason, time, bannerid)
		end

		local pl = XPA.FindPlayer(id)
		if not IsValid(pl) then
			XPA.MsgC(id .. " has just been banned: " .. reason .. ".")
			game.KickID(id, reason)
			return
		end

		local preview = "∞"
		if time > 0 then
			preview = XPA.ConvertTime(((time - os.time()) * 60) / 60)
		end

		local ip, idv = string.Explode(":", pl:IPAddress())[1], pl:SteamID()
		pl:Kick("You have just been banned.\nShame.\n\nReason: " .. reason .. "\nRemaining: " .. preview)
		XPA.MsgC(pl:Name() .. " [" .. idv .. " / " .. ip .. "] has just been banned: " .. reason .. ".")
	end
end

--[[
	XPA.Unban (SteamID)
]]

function XPA.Unban(id)
	if XPA.Bans[id] then
		XPA.Bans[id] = nil
	end

	if db == "firebase" then
		XPA.DB.Read("xpa-bans", function(js)
			local bans = util.JSONToTable(js)
			if bans[id] then
				XPA.DB.Delete("xpa-bans/" .. id)
				XPA.MsgC(id .. " has just been unbanned.")
			end
		end)
	elseif db == "sqlite" or db == "mysqloo" then
		XPA.DB.RemoveBan(id)
		XPA.MsgC(id .. " has just been unbanned.")
	end
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
	if db == "firebase" then
		XPA.DB.Read("xpa-bans", function(js)
			local loaded = util.JSONToTable(js)
			for id, data in pairs(loaded) do
				if not found[id] then
					found[id] = data
				end
				local pl = XPA.FindPlayer(id)
				if IsValid(pl) then
					pl:Kick(data.reason)
				end
			end
			XPA.Bans = found
		end)
	elseif db == "sqlite" or db == "mysqloo" then
		XPA.DB.UpdateBans(found)
	end
end)

--[[
	Ban validation hook
]]

hook.Add("CheckPassword", "XPA Bans", function(id64, ip, svp, clp)
	if svp ~= "" and svp ~= clp then
		return false
	end

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
				return false, "You are banned.\nShame.\n\nReason: " .. ban.reason .. "\nRemaining: " .. preview
			end
		else
			return false, "You are banned.\nShame.\n\nReason: " .. ban.reason .. "\nRemaining: ∞"
		end
	else
		return true
	end
end)