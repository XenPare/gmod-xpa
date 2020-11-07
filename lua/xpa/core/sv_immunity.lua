local meta = FindMetaTable("Player")

function meta:GetRank()
	for rank, data in pairs(XPA.Ranks) do
		if data.members then
			if table.HasValue(data.members, self:SteamID()) then
				return rank
			end
		end
	end
	return self:GetUserGroup()
end

function meta:GetRankTitle()
	return XPA.Ranks[self:GetRank()].title or self:GetUserGroup()
end

function meta:IsFounder()
	return self:GetRank() == "founder"
end

function meta:IsSupervisor()
	return self:GetRank() == "supervisor"
end

function meta:GetImmunity()
	local ranks = XPA.Ranks
	if ranks[self:GetRank()] then
		return tonumber(ranks[self:GetRank()].immunity)
	end
	return 0
end