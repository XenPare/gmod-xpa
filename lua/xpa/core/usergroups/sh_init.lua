local meta, titles = FindMetaTable("Player"), {
	["founder"] = "Founder",
	["supervisor"] = "Supervisor",
	["superadmin"] = "Superadmin",
	["admin"] = "Admin",
	["user"] = "User"
}

--[[
	Booleans
]]

function meta:IsFounder()
	return self:GetImmunity() >= 100000
end

function meta:IsSupervisor()
	return self:GetImmunity() >= 10000
end

function meta:IsSuperAdmin()
	return self:GetImmunity() >= 5000
end

function meta:IsAdmin()
	return self:GetImmunity() >= 1000
end

--[[
	Values 
]]

function meta:GetUserGroupTitle()
	if titles[self:GetUserGroup()] then
		return titles[self:GetUserGroup()]
	end
	return self:GetUserGroup()
end

function meta:GetImmunity()
	return self:GetNWInt("XPA Immunity")
end

--[[
	Alternatives
	## XPA Builds under 08/11/20 are used to have an old GetRankTitle method
		thats why we add another method to save some time
]]

meta.GetRankTitle = meta.GetUserGroupTitle
