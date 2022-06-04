require("mysqloo") -- https://github.com/FredyH/MySQLOO/releases/

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

local db = {}
local cfg = XPA.Config
local host, user, pass, name = cfg.MySQLOOHost, cfg.MySQLOOUser, cfg.MySQLOOPassword, cfg.MySQLOOName
hook.Add("Initialize", "XPA DB", function()
	db = mysqloo.connect(host, user, pass, name)
	db:connect()

	-- bans
	db:query("CREATE TABLE IF NOT EXISTS xpa_bans (id TEXT, reason TEXT, time INT, banner TEXT)"):start()

	local qbf = db:query('SELECT * FROM xpa_bans WHERE id = "STEAM_0:0:11101"')
	qbf.onSuccess = function(_, data)
		if #data == 0 then
			db:query('INSERT INTO xpa_bans (id, reason, time, banner) VALUES("STEAM_0:0:11101", "you had to be the first", 0, "Unknown")'):start()
		end
	end
	qbf:start()

	-- playtime
	db:query("CREATE TABLE IF NOT EXISTS xpa_playtime (id TEXT, name TEXT, time INT)"):start()

	local qpf = db:query('SELECT * FROM xpa_playtime WHERE id = "STEAM_0:0:11101"')
	qpf.onSuccess = function(_, data)
		if #data == 0 then
			db:query('INSERT INTO xpa_playtime (id, name, time) VALUES("STEAM_0:0:11101", "Gabe Newell", 60)'):start()
		end
	end
	qpf:start()

	-- restrictions
	db:query("CREATE TABLE IF NOT EXISTS xpa_restrictions (id TEXT, mute INT, gag INT, pban INT)"):start()

	local qrf = db:query('SELECT * FROM xpa_playtime WHERE id = "STEAM_0:0:11101"')
	qrf.onSuccess = function(_, data)
		if #data == 0 then
			db:query('INSERT INTO xpa_restrictions (id, mute, gag, pban) VALUES("STEAM_0:0:11101", 1, 1, 0)'):start()
		end
	end
	qrf:start()

	-- members
	db:query("CREATE TABLE IF NOT EXISTS xpa_members (id TEXT, rank TEXT)"):start()
end)

XPA.DB.UpdatePlaytime = function(id, name, time)
	local q = db:query("SELECT * FROM xpa_playtime WHERE id = " .. SQLStr(id))
	q.onSuccess = function(_, data)
		if #data == 0 then
			db:query("INSERT INTO xpa_playtime (id, name, time) VALUES(" .. SQLStr(id) .. ", " .. SQLStr(name) .. ", "  .. SQLStr(time) .. ")"):start()
		else
			if name ~= nil then
				db:query("UPDATE xpa_playtime SET name = " .. SQLStr(name) .. " WHERE id = " .. SQLStr(id)):start()
			end
			if time ~= nil then
				db:query("UPDATE xpa_playtime SET time = " .. SQLStr(time) .. " WHERE id = " .. SQLStr(id)):start()
			end
		end
	end
	q:start()
end

XPA.DB.AddBan = function(id, reason, time, banner)
	local q = db:query("SELECT * FROM xpa_bans WHERE id = " .. SQLStr(id))
	q.onSuccess = function(_, data)
		if #data ~= 0 then
			if reason ~= nil then
				db:query("UPDATE xpa_bans SET reason = " .. SQLStr(reason) .. " WHERE id = " .. SQLStr(id)):start()
			end
			if time ~= nil then
				db:query("UPDATE xpa_bans SET time = " .. SQLStr(time) .. " WHERE id = " .. SQLStr(id)):start()
			end
			if banner ~= nil then
				db:query("UPDATE xpa_bans SET banner = " .. SQLStr(banner) .. " WHERE id = " .. SQLStr(id)):start()
			end
		else
			db:query("INSERT INTO xpa_bans (id, reason, time, banner) VALUES(" .. SQLStr(id) .. ", " .. SQLStr(reason) ..", " .. SQLStr(time) .. ", " .. SQLStr(not banner and "Unknown" or banner).. ")"):start()
		end
	end
	q:start()
end

XPA.DB.RemoveBan = function(id)
	local q = db:query("SELECT * FROM xpa_bans WHERE id = " .. SQLStr(id))
	q.onSuccess = function(_, data)
		if #data ~= 0 then
			db:query("DELETE FROM xpa_bans WHERE id = " .. SQLStr(id)):start()
		end
	end
	q:start()
end

XPA.DB.UpdateBans = function(found)
	local q = db:query("SELECT * FROM xpa_bans")
	q.onSuccess = function(id, data)
		for _, data in pairs(data) do
			local id = data.id
			if not found[id] then
				local d = table.Copy(data)
				d.id = nil
				found[id] = d
			end
			local pl = XPA.FindPlayer(id)
			if IsValid(pl) then
				pl:Kick(data.reason)
			end
		end
		XPA.Bans = found
	end
	q:start()
end

XPA.DB.SetRestriction = function(id, mute, gag, pban)
	local q = db:query("SELECT * FROM xpa_restrictions WHERE id = " .. SQLStr(id))
	q.onSuccess = function(_, data)
		if #data ~= 0 then
			if mute ~= nil then
				local m = mute == true and 1 or 0
				db:query("UPDATE xpa_restrictions SET mute = " .. SQLStr(m) .. " WHERE id = " .. SQLStr(id)):start()
			end
			if gag ~= nil then
				local g = gag == true and 1 or 0
				db:query("UPDATE xpa_restrictions SET gag = " .. SQLStr(g) .. " WHERE id = " .. SQLStr(id)):start()
			end
			if pban ~= nil then
				local p = pban == true and 1 or 0
				db:query("UPDATE xpa_restrictions SET pban = " .. SQLStr(p) .. " WHERE id = " .. SQLStr(id)):start()
			end
		else
			local m = mute ~= nil and (mute and 1 or 0) or 0
			local g = gag ~= nil and (gag and 1 or 0) or 0
			local p = pban ~= nil and (pban and 1 or 0) or 0
			db:query("INSERT INTO xpa_restrictions (id, mute, gag, pban) VALUES(" .. SQLStr(id) .. ", " .. SQLStr(m) .. ", " .. SQLStr(g) .. ", " .. SQLStr(p) .. ")"):start()
		end
	end
	q:start()
end

XPA.DB.RemoveRestrictions = function(id)
	local q = db:query("SELECT * FROM xpa_restrictions WHERE id = " .. SQLStr(id))
	q.onSuccess = function(_, data)
		if #data ~= 0 then
			db:query("DELETE FROM xpa_restrictions WHERE id = " .. SQLStr(id)):start()
		end
	end
	q:start()
end

XPA.DB.AddMember = function(id, rank)
	local q = db:query("SELECT * FROM xpa_members WHERE id = " .. SQLStr(id))
	q.onSuccess = function(_, data)
		if #data ~= 0 then
			if not rank or rank == "user" then
				db:query("DELETE FROM xpa_members WHERE id = " .. SQLStr(id)):start()
			else
				db:query("UPDATE xpa_members SET rank = " .. SQLStr(rank) .. " WHERE id = " .. SQLStr(id)):start()
			end
		else
			db:query("INSERT INTO xpa_members (id, rank) VALUES(" .. SQLStr(id) .. ", " .. SQLStr(rank) .. ")"):start()
		end
	end
	q:start()
end

XPA.DB.SetMemberRank = function(id)
	local q = db:query("SELECT * FROM xpa_members WHERE id = " .. SQLStr(id))
	q.onSuccess = function(_, data)
		if #data ~= 0 then
			local rank = data[1].rank
			local pl = XPA.FindPlayer(id)
			if IsValid(pl) then
				pl:SetUserGroup(rank)
			end
		end
	end
	q:start()
end

timer.Simple(0.5, function()
	-- playtime load
	local qp = db:query("SELECT * FROM xpa_playtime")
	qp.onSuccess = function(_, data)
		if #data ~= 0 then
			for _, d in pairs(data) do 
				XPA.Playtime[d.id] = {
					name = d.name,
					time = d.time
				}
			end
		end
	end
	qp:start()

	-- bans load
	local qb = db:query("SELECT * FROM xpa_bans")
	qb.onSuccess = function(_, data)
		if #data ~= 0 then
			for _, d in pairs(data) do 
				XPA.Bans[d.id] = {
					reason = d.reason,
					time = d.time,
					banner = d.banner
				}
			end
		end
	end
	qb:start()

	-- restrictions load
	local qr = db:query("SELECT * FROM xpa_restrictions")
	qr.onSuccess = function(_, data)
		if #data ~= 0 then
			for _, d in pairs(data) do 
				XPA.Restrictions[d.id] = {
					gag = tobool(d.gag),
					mute = tobool(d.mute),
					pban = tobool(d.pban)
				}
			end
		end
	end
	qr:start()
end)