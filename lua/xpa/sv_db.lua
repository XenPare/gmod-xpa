local db_link, db_key = XPA.Config.DBLink, XPA.Config.DBKey

--[[
	####
	#### DB Initialization base
	####

	XPA.DB.Write("xpa-bans/STEAM_0:0:11101", {
		time = 0,
		reason = "you had to be the first"
	})

	XPA.DB.Write("xpa-restrictions/STEAM_0:0:11101", {
		mute = true,
		gag = true
	})

	XPA.DB.Write("xpa-ranks/founder", {
		base = "superadmin",
		immunity = 99999999,
		title = "Founder",
		members = {
			"STEAM_0:0:99753397",
			"STEAM_0:0:53025026"
		}
	})

	XPA.DB.Write("xpa-ranks/supervisor", {
		base = "superadmin",
		immunity = 10000,
		title = "Supervisor",
		members = {
			"STEAM_0:0:168580862"
		}
	})

	XPA.DB.Write("xpa-ranks/admin", {
		base = "admin",
		immunity = 1000,
		title = "Admin"
	})
]]

XPA.DB = {}

XPA.DB.Print = function(str)
	MsgC("[XPA DB] ", color_white, str .. "\n")
end

XPA.DB.Read = function(path, meth)
	if path == nil then
		path = ".json"
	else
		path = "/" .. path .. ".json"
	end

	http.Fetch(db_link .. path, function(html)
		meth(html)
	end, 
	function(err)
		XPA.DB.Print("HTTP: " .. err)
	end)
end

XPA.DB.Write = function(path, json)
	assert(path and json, "Sending request: PATH or TABLE [NULL]")
	path = "/" .. path .. ".json"

	HTTP({
		failed = function(err)
			XPA.DB.Print("HTTP: " .. err)
		end,
		method = "PATCH",
		url = db_link .. path .. "?auth=" .. db_key,
		body = util.TableToJSON(json),
		type = "application/json"
	})
end

XPA.DB.Delete = function(path)
	assert(path, "Sending request: PATH [NULL]")
	path = "/" .. path .. ".json"

	HTTP({
		failed = function(err)
			XPA.DB.Print("HTTP: " .. err)
		end,

		method = "DELETE",
		url = db_link .. path .. "?auth=" .. db_key,
		type = "application/json"
	})
end

--[[
	XPA Stuff
]]

XPA.Ranks = {}
XPA.DB.Read("xpa-ranks", function(json)
	XPA.Ranks = util.JSONToTable(json) 
end)

XPA.Bans = {}
XPA.DB.Read("xpa-bans", function(json)
	XPA.Bans = util.JSONToTable(json) 
end)

XPA.Restrictions = {}
XPA.DB.Read("xpa-restrictions", function(json)
	XPA.Restrictions = util.JSONToTable(json) 
end)

hook.Add("PlayerInitialSpawn", "XPA Restrictions", function(pl)
	local id = pl:SteamID()
	local tbl = XPA.Restrictions[id]
	if tbl then
		local useless = true
		for _, data in pairs(tbl) do
			if data then
				useless = false
			end
		end
		if useless then
			XPA.Restrictions[id] = nil
			XPA.DB.Delete("xpa-restrictions/" .. id)
			return
		end
		pl:SetNWBool("XPA Mute", tbl.mute)
		pl:SetNWBool("XPA Gag", tbl.gag)
	end
end)
