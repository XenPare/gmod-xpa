function XPA.MsgC(str)
	MsgC(Color(255, 222, 102), "[XPA] ", color_white, str .. "\n")
end

function XPA.ChatLog(str)
	for _, pl in pairs(player.GetAll()) do
		if pl:GetImmunity() <= 0 then
			pl:ChatPrint(str)
		end
	end
end

function XPA.AChatLog(str)
	for _, pl in pairs(player.GetAll()) do
		if pl:GetImmunity() > 0 then
			pl:ChatPrint(str)
		end
	end
end

function XPA.ChatLogCompounded(astr, ustr)
	XPA.ChatLog(ustr)
	XPA.AChatLog(astr)
end

function XPA.SendMsg(pl, msg)
	if string.find(msg, "'") then
		msg = string.Replace(msg, "'", "`")
	elseif string.find(msg, '"') then
		msg = string.Replace(msg, '"', "`")
	end
	pl:SendLua("Derma_Message('" .. msg .. "', 'XPA Message', 'Got it')")
end