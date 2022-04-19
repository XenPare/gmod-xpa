local cfg = XPA.Config
local steamlogin_enabled, group, db = cfg.AdminGroupLogin, cfg.AdminGroupID, cfg.Database

hook.Add("PlayerInitialSpawn", "XPA Login", function(pl)
	local ip = string.Explode(":", pl:IPAddress())[1]
	local id = pl:SteamID()
	local name = pl:Name()

	local ids = " [" .. id .. " / " .. ip .. "] "
	if pl:IsBot() then
		ids = " "
	end

	XPA.MsgC(name .. ids .. "has been spawned.")

	local found = false
	if db == "firebase" then
		for rank, data in pairs(XPA.Ranks) do
			local members = data.members
			if members and table.HasValue(members, id) then
				pl:SetSimpleTimer(0.8, function()
					pl:SetUserGroup(rank)
					XPA.MsgC(name .. ids .. "has been logged in with " .. pl:GetUserGroupTitle() .. " rank.")
				end)
				found = true
				break
			end
		end
	elseif db == "sqlite" then
		local rank = XPA.DB.GetMemberRank(id)
		if rank ~= "user" then
			pl:SetSimpleTimer(0.8, function()
				pl:SetUserGroup(rank)
				XPA.MsgC(name .. ids .. "has been logged in with " .. pl:GetUserGroupTitle() .. " rank.")
			end)
			found = true
		end
	elseif db == "mysqloo" then
		pl:SetSimpleTimer(0.8, function()
			XPA.DB.SetMemberRank(id)
			pl:SetSimpleTimer(0.2, function()
				if pl:GetUserGroup() ~= "user" then
					XPA.MsgC(name .. ids .. "has been logged in with " .. pl:GetUserGroupTitle() .. " rank.")
					found = true
				end
			end)
		end)
	end

	pl:SetSimpleTimer(1.2, function()
		if (not found and (group and group ~= "")) and steamlogin_enabled then
			http.Fetch("http://steamcommunity.com/gid/" .. group .. "/memberslistxml/?xml=1", function(body)
				if body:match("<steamID64>" .. pl:SteamID64() .. "</steamID64>") then
					pl:SetUserGroup("admin")
					XPA.MsgC(name .. ids .. "has been logged in with " .. pl:GetUserGroupTitle() .. " rank.")
				end
			end)
		end
	end)
end)

gameevent.Listen("player_connect")
hook.Add("player_connect", "XPA Connect", function(pl)
	local id = pl.networkid
	local ip = pl.address
	local name = pl.name

	local ids = " [" .. id .. " / " .. ip .. "] "
	if id == "BOT" then
		ids = " "
	end

	XPA.MsgC(name .. ids .. "has connected.")
end)