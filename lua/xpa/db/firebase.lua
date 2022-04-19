local db_link, db_key = XPA.Config.FirebaseLink, XPA.Config.FirebaseKey

--[[
	####
	#### DB Initialization
	#### (a functions to initialize a firebase db, make sure you've created xpa-*** tables before running)
	####

	XPA.DB.Write("xpa-playtime/STEAM_0:0:11101", {
		name = "Gabe Newell",
		time = 60
	})

	XPA.DB.Write("xpa-bans/STEAM_0:0:11101", {
		time = 0,
		reason = "you had to be the first"
	})

	XPA.DB.Write("xpa-restrictions/STEAM_0:0:11101", {
		mute = true,
		gag = true
	})

	for name, imm in pairs(XPA.Config.Ranks) do
		XPA.DB.Write("xpa-ranks/" .. name, {
			immunity = imm,
			members = {}
		})
	end

	XPA.DB.Write("xpa-ranks/founder", {
		members = {
			"STEAM_0:0:11101" -- basically your steamid
		}
	})
]]

XPA.DB = {}

XPA.Playtime = {}
XPA.Ranks = {}
XPA.Bans = {}
XPA.Restrictions = {}

--[[
	Database core
]]

timer.Simple(0.5, function()
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

	XPA.DB.Read("xpa-playtime", function(json)
		XPA.Playtime = util.JSONToTable(json) 
	end)

	XPA.DB.Read("xpa-ranks", function(json)
		XPA.Ranks = util.JSONToTable(json) 
	end)

	XPA.DB.Read("xpa-bans", function(json)
		XPA.Bans = util.JSONToTable(json) 
	end)

	XPA.DB.Read("xpa-restrictions", function(json)
		XPA.Restrictions = util.JSONToTable(json) 
	end)
end)