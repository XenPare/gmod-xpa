local ranks = XPA.Config.Ranks

local inherits_immunity = {}
inherits_immunity["user"] = 0
for name, immunity in pairs(ranks) do 
	inherits_immunity[name] = immunity + 2500
end

hook.Add("PostGamemodeLoaded", "XPA CAMI", function()
	for _, group in pairs(CAMI.GetUsergroups()) do
		if not ranks[group.Name] then
			XPA.Config.Ranks[group.Name] = inherits_immunity[group.Inherits] or 0
		end
	end
	for name, immunity in pairs(ranks) do
		CAMI.RegisterUsergroup({
			Name = name, 
			Inherits = (name == "founder" or name == "supervisor") and "superadmin" or "admin"
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