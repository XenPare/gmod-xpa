local tag = "XPA Jail"
local function isJailed(pl)
	if XPA.Jail[pl:SteamID()] then 
		return false 
	end
end

hook.Add("CanPlayerSuicide", tag, isJailed)
hook.Add("PlayerNoClip", tag, isJailed)
hook.Add("PlayerLoadout", tag, isJailed)
hook.Add("PlayerSpawnObject", tag, isJailed)
hook.Add("PlayerSpawnNPC", tag, isJailed)
hook.Add("PlayerSpawnSENT", tag, isJailed)
hook.Add("PlayerSpawnVehicle", tag, isJailed)
hook.Add("PlayerSpawnSWEP", tag, isJailed)
hook.Add("PlayerGiveSWEP", tag, isJailed)
hook.Add("CanPlayerSuicide", tag, isJailed)