hook.Add("PhysgunPickup", "XPA PhysgunPickup", function(pl, ent)
	if pl:IsAdmin() and pl:GetInfoNum("xpa_touchplayers", 1) == 1 and IsValid(ent) and ent:GetClass() == "player" and ent:GetImmunity() < pl:GetImmunity() then
		ent:Freeze(true)
		ent:SetMoveType(MOVETYPE_NOCLIP)
		ent:GodEnable()
		return true
	end
end)

hook.Add("PhysgunDrop", "XPA PhysgunDrop", function(pl, ent)
	if not IsValid(ent) or ent:GetClass() ~= "player" then
		return
	end

	ent:SetMoveType(MOVETYPE_WALK)
	ent:GodDisable()
	ent:Freeze(false)

	if pl:GetImmunity() > ent:GetImmunity() then
		pl:SetSimpleTimer(0.001, function()
			if pl:KeyDown(IN_ATTACK2) and IsValid(ent) and not ent:IsFrozen() then
				ent:SetMoveType(pl:KeyDown(IN_ATTACK2) and MOVETYPE_NOCLIP or MOVETYPE_WALK)
				ent:Freeze(true)
				ent:SetVelocity(ent:GetVelocity() * -1)
			end
		end)
	end
end)