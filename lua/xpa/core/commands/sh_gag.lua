local meta = FindMetaTable("Player")
function meta:IsGagged()
	return self:GetNWBool("XPA Gag")
end

if SERVER then
	hook.Add("PlayerCanHearPlayersVoice", "XPA Gag", function(_, talker)
		if talker:IsGagged() then 
			return false
		end
	end)
end