hook.Add("PhysgunPickup", "XPA PhysgunPickup", function(pl, ent)
	if pl:IsAdmin() and IsValid(ent) and ent:GetClass() == "player" then
		if ent:GetImmunity() > pl:GetImmunity() then
			return
		end
		ent:GodEnable()
		return true
	end
end)

hook.Add("PhysgunDrop", "XPA PhysgunDrop", function(pl, ent)
	if not IsValid(ent) or ent:GetClass() ~= "player" then
		return
	end

	ent:SetMoveType(MOVETYPE_WALK)
	ent:Freeze(false)
	ent:GodDisable()

	if pl:GetImmunity() > ent:GetImmunity() then
		ent:SetVelocity(ent:GetVelocity() * -1)
		ent:SetMoveType(pl:KeyDown(IN_ATTACK2) and MOVETYPE_NOCLIP or MOVETYPE_WALK)
		timer.Simple(0.001, function()
			if pl:KeyDown(IN_ATTACK2) and IsValid(ent) and not ent:IsFrozen() then
				ent:Freeze(true)
			end
		end)
	else
		ent:SetMoveType(MOVETYPE_WALK)
		ent:GodDisable()
	end
end)
