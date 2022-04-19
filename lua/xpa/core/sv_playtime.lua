local update, db = XPA.Config.PlaytimeUpdate, XPA.Config.Database
hook.Add("PlayerInitialSpawn", "XPA Playtime", function(pl)
	if pl:IsBot() then
		return
	end

	local id = pl:SteamID()
	pl:SetTimer("XPA Playtime", update, 0, function()
		local plname = pl:Name()
		local should_update_name = false
		if XPA.Playtime[id] then
			if XPA.Playtime[id].name ~= plname then
				XPA.Playtime[id].name = plname
				should_update_name = true
			end
			XPA.Playtime[id].time = XPA.Playtime[id].time + update
		else
			XPA.Playtime[id] = {
				name = plname,
				time = update
			}
		end

		if db == "firebase" then
			XPA.DB.Write("xpa-playtime/" .. id, {
				name = plname,
				time = XPA.Playtime[id].time
			})
		elseif db == "sqlite" or db == "mysqloo" then
			XPA.DB.UpdatePlaytime(id, should_update_name and plname or nil, XPA.Playtime[id].time)
		end
	end)
end)