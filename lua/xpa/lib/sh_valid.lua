function XPA.IsValidSteamID(id)
	if IsEntity(id) or not id or #id < 3 then
		return false
	end
	return string.match(id, "STEAM_[01]:[01]:%d+") and true or false
end

function XPA.IsValidSteamID64(id)
	if IsEntity(id) or not id then
		return false
	end
	return #id == 17
end