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