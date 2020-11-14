local ent = FindMetaTable("Entity")

function ent:SetSimpleTimer(delay, func)
	timer.Simple(delay, function()
		if IsValid(self) then
			func()
		end
	end)
end

function ent:SetTimer(identifier, delay, repetitions, func)
	timer.Create(self:EntIndex() .. "[" .. identifier .. "]", delay, repetitions, function()
		if IsValid(self) then
			func()
		end
	end)
end

function ent:RemoveTimer(identifier)
	timer.Remove(self:EntIndex() .. "[" .. identifier .. "]")
end

function ent:TimerExists(identifier)
	local _identifier = self:EntIndex() .. "[" .. identifier .. "]"
	return timer.Exists(_identifier), _identifier
end
