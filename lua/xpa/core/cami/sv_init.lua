local inherits_immunity = {
	["user"] = 0,
	["admin"] = 2500,
	["superadmin"] = 7500
}

hook.Add("PostGamemodeLoaded", "XPA CAMI", function()
	for _, group in pairs(CAMI.GetUsergroups()) do
		if not XPA.Config.Ranks[group.Name] then
			XPA.Config.Ranks[group.Name] = inherits_immunity[group.Inherits] or 0
		end
	end
	for name, immunity in pairs(XPA.Config.Ranks) do
		CAMI.RegisterUsergroup({
			Name = name, 
			Inherits = table.KeyFromValue(XPA.Config.Ranks, immunity)
		}, "XPA")
	end
end)

hook.Add("CAMI.OnUsergroupRegistered", "XPA CAMI", function(group, source)
	local name = group.Name
	if source == "XPA" or XPA.Config.Ranks[name] then 
		return 
	end
	XPA.Config.Ranks[name] = 0
end)

hook.Add("CAMI.OnUsergroupUnregistered", "XPA CAMI", function(group, source)
	local name = group.Name
	if source == "XPA" or not XPA.Config.Ranks[name] then 
		return 
	end
	XPA.Config.Ranks[name] = nil
end)

hook.Add("CAMI.PlayerUsergroupChanged", "XPA CAMI", function(pl, old, new, source)
	if source == "XPA" or not IsValid(pl) then 
		return 
	end
	pl:SetUserGroup(new)
end)

hook.Add("CAMI.PlayerHasAccess", "XPA CAMI", function(pl, privilege, callback, target)
	if not IsValid(pl) or not IsValid(target) then
		return
	end
	if pl:GetImmunity() > target:GetImmunity() then
		return true
	end
end)