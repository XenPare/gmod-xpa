local meta = FindMetaTable("Player")
function meta:IsMuted()
	return self:GetNWBool("XPA Mute")
end

if SERVER then
	hook.Add("PlayerSay", "XPA Mute", function(pl)
		if pl:IsMuted() then 
			return "" 
		end
	end)
end