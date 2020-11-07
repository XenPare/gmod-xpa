--[[
	To find player by given info
]]

function XPA.FindPlayer(info)
	if not info or info == "" then 
		return nil 
	end

	local pls = player.GetAll()
	for i = 1, #pls do
        local pl = pls[i]
        if tonumber(info) == pl:UserID() then
            return pl
        end

        if info == pl:SteamID() then
            return pl
        end

        if info == pl:SteamID64() then
            return pl
        end

        if string.find(string.lower(pl:Nick()), string.lower(tostring(info)), 1, true) ~= nil then
            return pl
        end
    end
    return nil
end

--[[
	To find the biggest number
]]

function XPA.FindBiggest(tbl)
	local biggest = 0
	for i = 1, #tbl do
		if tbl[i] > biggest then
			biggest = tbl[i]
		end
	end
	return biggest
end

--[[
	To check if a place is empty
]]

local content_blacklist = {
	CONTENTS_SOLID,
	CONTENTS_MOVEABLE,
	CONTENTS_LADDER,
	CONTENTS_PLAYERCLIP,
	CONTENTS_MONSTERCLIP
}

function XPA.isEmpty(vector, ignore)
	ignore = ignore or {}

	local point, a = util.PointContents(vector), not table.HasValue(content_blacklist, point) 
	if not a then 
		return false 
	end

	local b = true
	for _, pl in ipairs(ents.FindInSphere(vector, 35)) do
		if (pl:IsNPC() or pl:IsPlayer() or pl:GetClass() == "prop_physics" or pl.NotEmptyPos) and not table.HasValue(ignore, pl) then
			b = false
			break
		end
	end

	return a and b
end

--[[
	To find an empty pos by given vector
]]

function XPA.findEmptyPos(pos, ignore, distance, step, area)
	if XPA.isEmpty(pos, ignore) and XPA.isEmpty(pos + area, ignore) then
		return pos
	end
	for j = step, distance, step do
		for i = -1, 1, 2 do
			local k = j * i

			if XPA.isEmpty(pos + Vector(k, 0, 0), ignore) and XPA.isEmpty(pos + Vector(k, 0, 0) + area, ignore) then
				return pos + Vector(k, 0, 0)
			end
			
			if XPA.isEmpty(pos + Vector(0, k, 0), ignore) and XPA.isEmpty(pos + Vector(0, k, 0) + area, ignore) then
				return pos + Vector(0, k, 0)
			end

			if XPA.isEmpty(pos + Vector(0, 0, k), ignore) and XPA.isEmpty(pos + Vector(0, 0, k) + area, ignore) then
				return pos + Vector(0, 0, k)
			end
		end
	end
	return pos
end

--[[
	Sort table by nicks
]]

function XPA.nickSortedPlayers()
	local plys = player.GetAll()
	table.sort(plys, function(a, b) 
		return a:Nick() < b:Nick() 
	end)
	return plys
end