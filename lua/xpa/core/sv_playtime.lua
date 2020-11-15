local update = XPA.Config.PlaytimeUpdate
hook.Add("PlayerInitialSpawn", "XPA Playtime", function(pl)
	if pl:IsBot() then
		return
	end

	local id, nchanged = pl:SteamID(), false
	pl:SetTimer("XPA Playtime", update, 0, function()
		if XPA.Playtime[id] then
			if XPA.Playtime[id].name ~= pl:Name() then
				XPA.Playtime[id].name = pl:Name()
				nchanged = true
			end
			XPA.Playtime[id].time = XPA.Playtime[id].time + update
		else
			XPA.Playtime[id] = {
				name = pl:Name(),
				time = update
			}
		end

		XPA.DB.Write("xpa-playtime/" .. id, nchanged and {
			name = XPA.Playtime[id].name,
			time = XPA.Playtime[id].time
		} or {
			time = XPA.Playtime[id].time
		})

		nchanged = false
	end)
end)