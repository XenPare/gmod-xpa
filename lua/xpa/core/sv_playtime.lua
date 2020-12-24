local update = XPA.Config.PlaytimeUpdate
hook.Add("PlayerInitialSpawn", "XPA Playtime", function(pl)
	if pl:IsBot() then
		return
	end

	local id = pl:SteamID()
	pl:SetTimer("XPA Playtime", update, 0, function()
		if XPA.Playtime[id] then
			if XPA.Playtime[id].name ~= pl:Name() then
				XPA.Playtime[id].name = pl:Name()
			end
			XPA.Playtime[id].time = XPA.Playtime[id].time + update
		else
			XPA.Playtime[id] = {
				name = pl:Name(),
				time = update
			}
		end

		XPA.DB.Write("xpa-playtime/" .. id, {
			name = XPA.Playtime[id].name,
			time = XPA.Playtime[id].time
		})
	end)
end)