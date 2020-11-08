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
	for rank, data in pairs(XPA.Ranks) do 
		local members = data.members
		if members and table.HasValue(members, id) then
			pl:SetUserGroup(rank)
			XPA.MsgC(name .. ids .. "has logged with " .. pl:GetUserGroupTitle() .. " rank.")
			found = true
			break
		end
	end

	local group = XPA.Config.AdminGroupID
	if not found and (group and group ~= "") then
		http.Fetch("http://steamcommunity.com/gid/" .. group .. "/memberslistxml/?xml=1", function(body)
			if body:match("<steamID64>" .. pl:SteamID64() .. "</steamID64>") then
				pl:SetUserGroup("admin")
				XPA.MsgC(name .. ids .. "has logged with " .. pl:GetUserGroupTitle() .. " rank.")
			end
		end)
	end
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
