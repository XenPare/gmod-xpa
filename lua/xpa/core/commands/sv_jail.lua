hook.Add("CanPlayerSuicide", "XPA Jail", function(pl)
	if XPA.Jail[pl:SteamID()] then
		return false
	end
end)