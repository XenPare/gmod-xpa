--[[
	no additional db initialization required
]]

XPA.DB = {}

XPA.Playtime = {}
XPA.Bans = {}
XPA.Restrictions = {}

XPA.Ranks = table.Copy(XPA.Config.Ranks)

--[[
	Database core
]]

hook.Add("Initialize", "XPA DB", function()
	if not sql.TableExists("xpa_bans") then
		sql.Query("CREATE TABLE xpa_bans (id TEXT, reason TEXT, time INTEGER, banner TEXT)")
		sql.Query('INSERT INTO xpa_bans (id, reason, time, banner) VALUES("STEAM_0:0:11101", "you had to be the first", 0, "Unknown")')
	end

	if not sql.TableExists("xpa_playtime") then
		sql.Query("CREATE TABLE xpa_playtime (id TEXT, name TEXT, time INTEGER)")
		sql.Query('INSERT INTO xpa_playtime (id, name, time) VALUES("STEAM_0:0:11101", "Gabe Newell", 60)')
	end

	if not sql.TableExists("xpa_restrictions") then
		sql.Query("CREATE TABLE xpa_restrictions (id TEXT, mute INTEGER, gag INTEGER)")
		sql.Query('INSERT INTO xpa_restrictions (id, mute, gag, pban) VALUES("STEAM_0:0:11101", 1, 1, 0)')
	end

	sql.Query("CREATE TABLE IF NOT EXISTS xpa_members (id TEXT, rank TEXT)")
end)

XPA.DB.UpdatePlaytime = function(id, name, time)
	if name ~= nil then
		sql.Query("UPDATE xpa_playtime SET name = " .. SQLStr(name) .. " WHERE id = " .. SQLStr(id))
	end
	if time ~= nil then
		sql.Query("UPDATE xpa_playtime SET time = " .. SQLStr(time) .. " WHERE id = " .. SQLStr(id))
	end
end

XPA.DB.AddBan = function(id, reason, time, banner)
	local ex = sql.Query("SELECT * FROM xpa_bans WHERE id = " .. SQLStr(id))
	if ex then
		if reason ~= nil then
			sql.Query("UPDATE xpa_bans SET reason = " .. SQLStr(reason) .. " WHERE id = " .. SQLStr(id))
		end
		if time ~= nil then
			sql.Query("UPDATE xpa_bans SET time = " .. SQLStr(time) .. " WHERE id = " .. SQLStr(id))
		end
		if banner ~= nil then
			sql.Query("UPDATE xpa_bans SET banner = " .. SQLStr(banner) .. " WHERE id = " .. SQLStr(id))
		end
	else
		sql.Query("INSERT INTO xpa_bans (id, reason, time, banner) VALUES(" .. SQLStr(id) .. ", " .. SQLStr(reason) ..", " .. SQLStr(time) .. ", " .. SQLStr(not banner and "Unknown" or banner).. ")")
	end
end

XPA.DB.RemoveBan = function(id)
	local ex = sql.Query("SELECT * FROM xpa_bans WHERE id = " .. SQLStr(id))
	if ex then
		sql.Query("DELETE * FROM xpa_bans WHERE id = " .. SQLStr(id))
	end
end

XPA.DB.SetRestriction = function(id, mute, gag, pban)
	local ex = sql.Query("SELECT * FROM xpa_restrictions WHERE id = " .. SQLStr(id))
	if ex then
		if mute ~= nil then
			local m = mute == true and 1 or 0
			sql.Query("UPDATE xpa_bans SET mute = " .. SQLStr(m) .. " WHERE id = " .. SQLStr(id))
		end
		if gag ~= nil then
			local g = gag == true and 1 or 0
			sql.Query("UPDATE xpa_bans SET gag = " .. SQLStr(g) .. " WHERE id = " .. SQLStr(id))
		end
		if pban ~= nil then
			local p = pban == true and 1 or 0
			sql.Query("UPDATE xpa_bans SET pban = " .. SQLStr(p) .. " WHERE id = " .. SQLStr(id))
		end
	else
		local m = mute ~= nil and (mute and 1 or 0) or 0
		local g = gag ~= nil and (gag and 1 or 0) or 0
		local p = pban ~= nil and (pban and 1 or 0) or 0
		sql.Query("INSERT INTO xpa_restrictions (id, mute, gag, pban) VALUES(" .. SQLStr(id) .. ", " .. SQLStr(m) .. ", " .. SQLStr(g) .. ", " .. SQLStr(p) .. ")")
	end
end

XPA.DB.RemoveRestrictions = function(id)
	local ex = sql.Query("SELECT * FROM xpa_restrictions WHERE id = " .. SQLStr(id))
	if ex then
		sql.Query("DELETE * FROM xpa_restrictions WHERE id = " .. SQLStr(id))
	end
end

XPA.DB.AddMember = function(id, rank)
	local ex = sql.Query("SELECT * FROM xpa_members WHERE id = " .. SQLStr(id))
	if ex then
		if not rank or rank == "user" then
			sql.Query("DELETE * FROM xpa_members WHERE id = " .. SQLStr(id))
		else
			sql.Query("UPDATE xpa_members SET rank = " .. SQLStr(rank) .. " WHERE id = " .. SQLStr(id))
		end
	else
		sql.Query("INSERT INTO xpa_members (id, rank) VALUES(" .. SQLStr(id) .. ", " .. SQLStr(rank) .. ")")
	end
end

XPA.DB.GetMemberRank = function(id)
	local ex = sql.Query("SELECT * FROM xpa_members WHERE id = " .. SQLStr(id))
	return ex and ex[1].rank or "user"
end

timer.Simple(0.5, function()
	local playtime = sql.Query("SELECT * FROM xpa_playtime")
	for _, data in pairs(playtime) do 
		XPA.Playtime[data.id] = {
			name = data.name,
			time = data.time
		}
	end

	local bans = sql.Query("SELECT * FROM xpa_bans")
	for _, data in pairs(bans) do 
		XPA.Bans[data.id] = {
			reason = data.reason,
			time = data.time,
			banner = data.banner
		}
	end

	local restrictions = sql.Query("SELECT * FROM xpa_restrictions")
	for _, data in pairs(bans) do 
		XPA.Restrictions[data.id] = {
			gag = tobool(data.gag),
			mute = tobool(data.mute),
			pban = tobool(data.pban)
		}
	end
end)