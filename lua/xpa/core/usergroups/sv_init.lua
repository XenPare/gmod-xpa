local db = XPA.Config.Database
local meta = FindMetaTable("Player")

meta._SetUserGroup = meta.SetUserGroup
function meta:SetUserGroup(usergroup)
	self:_SetUserGroup(usergroup)
	
	local ranks = XPA.Ranks
	local rank = ranks[usergroup]
	if rank then
		self:SetImmunity(db == "firebase" and rank.immunity or rank)
	else
		self:SetImmunity(0)
	end
end

function meta:SetImmunity(int)
	self:SetNWInt("XPA Immunity", int)
end