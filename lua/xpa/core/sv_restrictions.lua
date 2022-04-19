local db = XPA.Config.Database
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
			if db == "firebase" then
				XPA.DB.Delete("xpa-restrictions/" .. id)
			elseif db == "sqlite" or db == "mysqloo" then
				XPA.DB.RemoveRestrictions(id)
			end
			return
		end
		pl:SetNWBool("XPA Mute", tbl.mute)
		pl:SetNWBool("XPA Gag", tbl.gag)
	end
end)